
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )
util.PrecacheSound( "SB/Gattling2.wav" )

function ENT:Initialize()

	self.Entity:SetModel( "models/Slyfo/smlturrettop.mdl" ) 
	self.Entity:SetName("SmallMachineGun")
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	--self.Inputs = Wire_CreateInputs( self.Entity, { "Fire" } )
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableGravity(true)
		phys:EnableDrag(true)
		phys:EnableCollisions(true)
	end
	self.Entity:SetKeyValue("rendercolor", "255 255 255")
	self.PhysObj = self.Entity:GetPhysicsObject()
	
	--self.val1 = 0
	--RD_AddResource(self.Entity, "Munitions", 0)

	self.HPC			= 1
	self.HP				= {}
	self.HP[1]			= {}
	self.HP[1]["Ent"]	= nil
	self.HP[1]["Type"]	= "Small"
	self.HP[1]["Pos"]	= Vector(0,0,12)
	
	self.Cont = self.Entity
end

function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16 + Vector(0,0,70)
	
	local ent = ents.Create( "SF-SwivelMountS" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	ent.SPL = ply
	
	SpawnPos2 = SpawnPos + Vector(3,-3,-30)
	
	ent2 = ents.Create( "prop_physics" )
	ent2:SetModel( "models/Slyfo/smlturretbase.mdl" ) 
	ent2:SetPos( SpawnPos2 )
	ent2:Spawn()
	ent2:Activate()
	ent.Base = ent2
	
	local LPos = ent:WorldToLocal(ent:GetPos() + ent:GetUp() * 10)
	local Cons = constraint.Ballsocket( ent2, ent, 0, 0, LPos, 0, 0, 1)
	LPos = ent:WorldToLocal(ent:GetPos() + ent:GetUp() * -10)
	Cons = constraint.Ballsocket( ent2, ent, 0, 0, LPos, 0, 0, 1)
	
	return ent
	
end

function ENT:TriggerInput(iname, value)		
	if (iname == "Fire") then
		if (value > 0) then
			self.Active = true
		else
			self.Active = false
		end
			
	end
end

function ENT:PhysicsUpdate()

end

function ENT:Think()
	local Weap = self.HP[1]["Ent"]
	
	if Weap && Weap:IsValid() then
	
		if !Weap.Swivved then
			local LPos = Vector(0,0,0)
			LPos = Weap:WorldToLocal(Weap:GetPos() + (Weap:GetForward() * -Weap.APPos.x) + (Weap:GetRight() * (-Weap.APPos.y + 10)) + (Weap:GetUp() * -Weap.APPos.z ) )
			self.WSock1 = constraint.Ballsocket( self.Entity, Weap, 0, 0, LPos, 0, 0, 1)
			LPos = Weap:WorldToLocal(Weap:GetPos() + (Weap:GetForward() * -Weap.APPos.x) + (Weap:GetRight() * (-Weap.APPos.y + -10)) + (Weap:GetUp() * -Weap.APPos.z ) )
			self.WSock2 = constraint.Ballsocket( self.Entity, Weap, 0, 0, LPos, 0, 0, 1)
			
			constraint.RemoveConstraints( Weap, "Weld" )
			Weap:SetParent()
			Weap.Swivved = true
		end
		
		if self.CPod && self.CPod:IsValid() then
			self.CPL = self.CPod:GetPassenger()
			if (self.CPL && self.CPL:IsValid()) then
							
				if (self.CPL:KeyDown( IN_ATTACK )) then
					--for i = 1, self.HPC do
					--	local HPC = self.CPL:GetInfo( "SBHP_"..i )
					--	if self.HP[i]["Ent"] && self.HP[i]["Ent"]:IsValid() && (HPC == "1.00" || HPC == "1" || HPC == 1) then
							self.HP[1]["Ent"].Entity:HPFire()
					--	end
					--end
				end
				
				self.CPL:CrosshairEnable()
				
				local PRel = self.CPL:GetEyeTrace().HitPos
				local FDist = PRel:Distance( Weap:GetPos() + Weap:GetUp() * 100 )
				local BDist = PRel:Distance( Weap:GetPos() + Weap:GetUp() * -100 )
				local Pitch = math.Clamp((FDist - BDist) * 0.75, -250, 250)
				FDist = PRel:Distance( Weap:GetPos() + Weap:GetRight() * 100 )
				BDist = PRel:Distance( Weap:GetPos() + Weap:GetRight() * -100 )
				local Yaw = math.Clamp((BDist - FDist) * 0.75, -250, 250)
				
				local physi = self.Entity:GetPhysicsObject()
				local physi2 = Weap:GetPhysicsObject()
				
				physi:AddAngleVelocity((physi:GetAngleVelocity() * -1) + Angle(0,0,-Yaw))
				physi2:AddAngleVelocity((physi2:GetAngleVelocity() * -1) + Angle(0,Pitch,0))
				
			end
		end
	end
	
	self.Entity:NextThink( CurTime() + 0.01 ) 
	return true	
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
	if self.HP[1]["Ent"] && self.HP[1]["Ent"]:IsValid() then
		self.HP[1]["Ent"]:HPFire()
	end
end