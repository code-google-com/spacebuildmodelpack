AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()

	self.Entity:SetModel( "models/Weapons/w_portalgun.mdl" ) 
	self.Entity:SetName("Turret")
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	--self.Entity:SetMaterial("models/props_wasteland/tugboat02")
	self.Inputs = Wire_CreateInputs( self.Entity, { "Fire" } )

	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableGravity(true)
		phys:EnableDrag(true)
		phys:EnableCollisions(true)
	end
	self.Entity:StartMotionController()
	self.PhysObj = self.Entity:GetPhysicsObject()

	RD_AddResource(self.Entity, "steam", 0)

end

function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16 + Vector(0,0,50)
	
	local ent = ents.Create( "SBM-Turret" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Initialize()
	ent:Activate()
	ent.SPL = ply
	
	ent.Pod = ents.Create( "prop_vehicle_prisoner_pod" )
	if ( !ent.Pod:IsValid() ) then return end
	ent.Pod:SetModel( "models/Spacebuild/Corvette_Chair.mdl" )
	ent.Pod:SetKeyValue("vehiclescript", "scripts/vehicles/prisoner_pod.txt")
	ent.Pod:SetKeyValue("limitview", 0)
	--self.NPod:SetMembers(HandleAnimation, HandleSBMPSitAnimation)
	ent.Pod:SetPos( self.Entity:GetPos() + self.Entity:GetForward() * -20 + self.Entity:GetUp() * -55)
	ent.Pod:SetAngles( self.Entity:GetAngles() )
	ent.Pod:Spawn()
	ent.Pod:Activate()
	ent.Pod:SetSkin(self.Entity:GetSkin())
	local TB = ent.Pod:GetTable()
	TB.HandleAnimation = function (vec, ply)
		return ply:SelectWeightedSequence( ACT_HL2MP_SIT ) 
	end 
	ent.Pod:SetTable(TB)
	local NC = constraint.NoCollide(ent, ent.Pod, 0, 0)
	--self.WD = constraint.Weld(self.Entity, self.NPod, 0, 0, 0)
	ent.Pod.Entity:SetParent(ent)
	
	return ent
	
end

function ENT:TriggerInput(iname, value)
	
	if (iname == "Activate") then
		if (value > 0) then
			self.Active = true
			self.Entity:EmitSound( "PhysicsCannister.ThrusterLoop" )
		else
			self.Active = false
			self.Entity:StopSound( "PhysicsCannister.ThrusterLoop" )
		end
		
	elseif (iname == "Speed") then
		self.Speed = math.Clamp(value,-1000,1000)
		
	elseif (iname == "Link") then
		if (value > 0) then
			self.Linking = true
		else
			self.Linking = false
		end
		
	end
	
end

function ENT:Think()
	if self.Pod and self.Pod:IsValid() then
		self.CPL = self.Pod:GetPassenger()
		if (self.CPL && self.CPL:IsValid()) then
			self.Pod:SetAngles( self.CPL:EyeAngles() )
			self.CPL:
		end
	end
	
	self.Entity:NextThink( CurTime() + 0.1 ) 
	return true	
end

function ENT:PhysicsCollide( data, physobj )

end

function ENT:OnTakeDamage( dmginfo )
	
end

function ENT:Touch( ent )
	if self.Linking && ent:IsValid()then
		self.CCObj = ent
	end
end

function ENT:Use( ply )

end