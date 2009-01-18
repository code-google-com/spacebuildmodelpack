AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('entities/base_wire_entity/init.lua')
include( 'shared.lua' )

function ENT:Initialize()
	
	self.Entity:SetModel( "models/Slyfo/torpedoship1.mdl" ) 
	self.Entity:SetName("TorpedoLauncher")
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	--self.Entity:SetMaterial("models/props_wasteland/tugboat02")
	self.Inputs = Wire_CreateInputs( self.Entity, { "Fire" } ) --, "Reload" } )

	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableGravity(true)
		phys:EnableDrag(true)
		phys:EnableCollisions(true)
	end
	self.Entity:StartMotionController()
	self.PhysObj = self.Entity:GetPhysicsObject()

	
end

function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	
	local ent = ents.Create( "SF-TorpTubeL" )
	ent:SetPos( tr.HitPos + tr.HitNormal * 16 + Vector(0,0,50) )
	ent:Spawn()
	ent:Initialize()
	ent:Activate()
	ent.SPL = ply
	
	return ent
	
end

function ENT:TriggerInput(iname, value)		
	
	if (iname == "Fire") then
		if (value > 0) then
			if self.Torp && self.Torp:IsValid() then
				self.Torp:Arm()
				self.Torp:SetParent()
				self.Torp.PFire2 = true
				if self.BWeld && self.BWeld:IsValid() then self.BWeld:Remove() end
				self.Torp:SetPos( self.Entity:GetPos() + self.Entity:GetRight() * -102 + self.Entity:GetUp() * 63 + self.Entity:GetForward() * -200 )
				self.Torp.PhysObj:EnableCollisions(true)
				self.Torp.PhysObj:EnableGravity(false)
				self.Torp = nil
			end
		end
		
	elseif (iname == "Reload") then	
		if (value > 0) && !self.Loading then
			self.LTime = CurTime() + 15
			self.Loading = true
		end
	end
	
end

function ENT:Think()
	if CurTime() >= self.LTime && self.Loading && !self.Torp then
		local Torp = ents.Create( "SF-TorpBig" )
		Torp:SetPos( self.Entity:GetPos() + self.Entity:GetRight() * -102 + self.Entity:GetUp() * 63 + self.Entity:GetForward() * -50)
		Torp:SetAngles( self.Entity:GetAngles() )
		Torp:Spawn()
		Torp:Initialize()
		Torp:Activate()
		self.BWeld = constraint.Weld(Torp, self.Entity, 0, 0, 0, true)
		--Torp:SetParent( self.Entity )
		self.Torp = Torp
		
		self.Loading = false
	end
end

function ENT:PhysicsCollide( data, physobj )

end

function ENT:OnTakeDamage( dmginfo )
	
end

function ENT:Touch( ent )
	if (!self.Torp || !self.Torp:IsValid()) && ent:IsValid() && ent.BigTorp && !ent.Armed then
		self.Torp = ent
		ent:SetPos( self.Entity:GetPos() + self.Entity:GetRight() * -102 + self.Entity:GetUp() * 63 + self.Entity:GetForward() * -50)
		ent:SetAngles( self.Entity:GetAngles() )
		constraint.RemoveConstraints( self.Torp, "Weld" )
		self.BWeld = constraint.Weld(Torp, self.Entity, 0, 0, 0, true)
		ent:SetParent( self.Entity )
				
		self.Loading = false
	end
end

function ENT:OnRemove()
	if self.Torp && self.Torp:IsValid() then
		self.Torp:Remove()
	end
end