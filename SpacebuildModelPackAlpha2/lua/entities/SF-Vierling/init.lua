--models/Slyfo/flakvierling_base.mdl - models/Slyfo/flakvierling_blasternorm.mdl - models/Slyfo/flakvierling_gunmount.mdl - models/Slyfo/flakvierling_spinner.mdl
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('entities/base_wire_entity/init.lua')
include( 'shared.lua' )
util.PrecacheSound( "SB/Gattling2.wav" )

function ENT:Initialize()

	--self.Entity:SetModel( "models/Slyfo/smlturrettop.mdl" ) 
	self.Entity:SetName("SmallMachineGun")
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Inputs = Wire_CreateInputs( self.Entity, { "Active", "Fire", "X", "Y", "Z" } )
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableGravity(false)
		phys:EnableDrag(true)
		phys:EnableCollisions(true)
	end
	self.Entity:SetKeyValue("rendercolor", "255 255 255")
	self.PhysObj = self.Entity:GetPhysicsObject()
	
	--self.val1 = 0
	--RD_AddResource(self.Entity, "Munitions", 0)
	
	self.Cont = self.Entity
	self.Firing = false
	self.Active = false
	
	self.XCo = 0
	self.YCo = 0
	self.ZCo = 0
	
	self.NST = 0
	self.CHP = 1
end

function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16 + Vector(0,0,70)
	
	local ent = ents.Create( "SF-Vierling" )
	ent:SetPos( SpawnPos )
	ent:SetModel( "models/Slyfo/flakvierling_gunmount.mdl" ) 
	ent:Spawn()
	ent:Initialize()
	ent:Activate()
	ent.SPL = ply
	
	ent.HPC				= 4
	ent.HP				= {}
	ent.HP[1]			= {}
	ent.HP[1]["Ent"]	= nil
	ent.HP[1]["Type"]	= "Small"
	ent.HP[1]["Pos"]	= Vector(20,-20,53)
	ent.HP[2]			= {}
	ent.HP[2]["Ent"]	= nil
	ent.HP[2]["Type"]	= "Small"
	ent.HP[2]["Pos"]	= Vector(20,-20,23)
	ent.HP[3]			= {}
	ent.HP[3]["Ent"]	= nil
	ent.HP[3]["Type"]	= "Small"
	ent.HP[3]["Pos"]	= Vector(20,20,53)
	ent.HP[4]			= {}
	ent.HP[4]["Ent"]	= nil
	ent.HP[4]["Type"]	= "Small"
	ent.HP[4]["Pos"]	= Vector(20,20,23)
	
	local LPos = nil
	local Cons = nil
	
	SpawnPos2 = SpawnPos + (ent:GetForward() * 32) + Vector(0,0,-20)
	
	ent2 = ents.Create( "prop_physics" )
	ent2:SetModel( "models/Slyfo/flakvierling_spinner.mdl" ) 
	ent2:SetPos( SpawnPos2 )
	ent2:Spawn()
	ent2:Activate()
	ent.Base = ent2
	
	LPos = ent:WorldToLocal(ent:GetPos() + ent:GetRight() * 10 + ent:GetUp() * 40)
	Cons = constraint.Ballsocket( ent2, ent, 0, 0, LPos, 0, 0, 1)
	LPos = ent:WorldToLocal(ent:GetPos() + ent:GetRight() * -10 + ent:GetUp() * 40)
	Cons = constraint.Ballsocket( ent2, ent, 0, 0, LPos, 0, 0, 1)
	
	SpawnPos3 = SpawnPos + Vector(0,0,-38)
	
	ent3 = ents.Create( "prop_physics" )
	ent3:SetModel( "models/Slyfo/flakvierling_base.mdl" ) 
	ent3:SetPos( SpawnPos3 )
	ent3:Spawn()
	ent3:Activate()
	ent.Base2 = ent3
	
	LPos = ent2:WorldToLocal(ent2:GetPos() + ent2:GetForward() * -32 + ent2:GetUp() * 10)
	Cons = constraint.Ballsocket( ent3, ent2, 0, 0, LPos, 0, 0, 1)
	LPos = ent2:WorldToLocal(ent2:GetPos() + ent2:GetForward() * -32 + ent2:GetUp() * -10)
	Cons = constraint.Ballsocket( ent3, ent2, 0, 0, LPos, 0, 0, 1)
	
	return ent
	
end

function ENT:TriggerInput(iname, value)		
	if (iname == "Active") then
		if (value > 0) then
			self.Active = true
		else
			self.Active = false
		end
		
	elseif (iname == "Fire") then
		if (value > 0) then
			self.Firing = true
		else
			self.Firing = false
		end
		
	elseif (iname == "X") then
		self.XCo = value
	
	elseif (iname == "Y") then
		self.YCo = value
	
	elseif (iname == "Z") then
		self.ZCo = value
				
	end
end

function ENT:PhysicsUpdate()

end

function ENT:Think()
		
	local TargPos = nil
	if self.CPod && self.CPod:IsValid() then
		self.CPL = self.CPod:GetPassenger()
		if (self.CPL && self.CPL:IsValid()) then
						
			if (self.CPL:KeyDown( IN_ATTACK )) then
				self.Entity:HPFire()
			end
			
			self.CPL:CrosshairEnable()
			
			TargPos = self.CPL:GetEyeTrace().HitPos				
		end
	end
	if self.Active then
		TargPos = Vector(self.XCo,self.YCo,self.ZCo)
	end
	if TargPos then
		local FDist = TargPos:Distance( self.Entity:GetPos() + self.Entity:GetUp() * 100 )
		local BDist = TargPos:Distance( self.Entity:GetPos() + self.Entity:GetUp() * -100 )
		local Pitch = math.Clamp((FDist - BDist) * 1.75, -450, 450)
		FDist = TargPos:Distance( self.Entity:GetPos() + self.Entity:GetRight() * 100 )
		BDist = TargPos:Distance( self.Entity:GetPos() + self.Entity:GetRight() * -100 )
		local Yaw = math.Clamp((BDist - FDist) * 1.75, -450, 450)
		
		local physi = self.Base:GetPhysicsObject()
		local physi2 = self.Entity:GetPhysicsObject()
		
		physi:AddAngleVelocity((physi:GetAngleVelocity() * -1) + Angle(0,0,-Yaw))
		physi2:AddAngleVelocity((physi2:GetAngleVelocity() * -1) + Angle(0,Pitch,0))
	end
	
	if CurTime() >= self.NST then
		self.NST = CurTime() + 0.125
		self.CHP = self.CHP + 1
		if self.CHP > 4 then
			self.CHP = 1
		end
	end
	
	if self.Firing then
		self.Entity:HPFire()
	end

	self.Entity:NextThink( CurTime() + 0.01 ) 
	return true	
end

function ENT:OnRemove( ) 
	if self.Base && self.Base:IsValid() then
		self.Base:Remove()
	end
	if self.Base2 && self.Base2:IsValid() then
		self.Base2:Remove()
	end
end

function ENT:PhysicsCollide( data, physobj )
	
end

function ENT:OnTakeDamage( dmginfo )
	
end

function ENT:Use( activator, caller )

end

function ENT:Touch( ent )
	if ent && ent:IsValid() && ent:IsVehicle() then
		self.CPod = ent
	end
end

function ENT:HPFire()
	if self.HP[self.CHP]["Ent"] && self.HP[self.CHP]["Ent"]:IsValid() then
		self.HP[self.CHP]["Ent"]:HPFire()
	end
end