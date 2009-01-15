
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )
util.PrecacheSound( "SB/Gattling2.wav" )

function ENT:Initialize()

	self.Entity:SetModel( "models/Slyfo/rover1_backpanelmount.mdl" ) 
	self.Entity:SetName("SmallMachineGun")
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Inputs = Wire_CreateInputs( self.Entity, { "Fire" } )
	
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
	self.HP[1]["Pos"]	= Vector(14,0,12)
	
	self.Cont = self.Entity
end

function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16 + Vector(0,0,50)
	
	local ent = ents.Create( "SF-RoverBPanelM" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	ent.SPL = ply
	
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
	--self.Entity:SetColor( 0, 0, 255, 255)
	local Weap = self.HP[1]["Ent"]
	
	if Weap && Weap:IsValid() then
	
		if !Weap.Swivved then
			local LPos = Vector(0,0,0)
			constraint.RemoveConstraints( Weap, "Weld" )
			Weap:SetParent()
			Weap:GetPhysicsObject():EnableCollisions(false)
			
			LPos = Weap:WorldToLocal(Weap:GetPos() + (Weap:GetForward() * (-Weap.APPos.x + -10)) + (Weap:GetRight() * (-Weap.APPos.y + 10 )) + (Weap:GetUp() * (-Weap.APPos.z + 5)))
			self.WSock1 = constraint.Ballsocket( self.Entity, Weap, 0, 0, LPos, 0, 0, 1)
			LPos = Weap:WorldToLocal(Weap:GetPos() + (Weap:GetForward() * (-Weap.APPos.x + -10)) + (Weap:GetRight() * (-Weap.APPos.y + -10)) + (Weap:GetUp() * (-Weap.APPos.z + 5)))
			self.WSock2 = constraint.Ballsocket( self.Entity, Weap, 0, 0, LPos, 0, 0, 1)
			
			local Noc = constraint.NoCollide( Weap, self.Entity, 0, 0 )
			Weap:GetPhysicsObject():EnableCollisions(false)
			Weap.Swivved = true
			--Weap:SetColor( 0, 255, 0, 255)
		else
			--Weap:SetColor( 255, 0, 0, 255)
		end
		
		if self.Pod && self.Pod:IsValid() && self.Pod:IsVehicle() then
			Weap.Pod = self.Pod
			self.CPL = self.Pod:GetPassenger()
			if (self.CPL && self.CPL:IsValid()) then
							
				if (self.CPL:KeyDown( IN_ATTACK )) then
					--for i = 1, self.HPC do
					--	local HPC = self.CPL:GetInfo( "SBHP_"..i )
					--	if self.HP[i]["Ent"] && self.HP[i]["Ent"]:IsValid() && (HPC == "1.00" || HPC == "1" || HPC == 1) then
					--		self.HP[1]["Ent"].Entity:HPFire()
					--	end
					--end
				end
				
				self.CPL:CrosshairEnable()
				
				local PRel = Weap:GetPos() + self.CPL:GetAimVector() * 500
				local FDist = PRel:Distance( Weap:GetPos() + Weap:GetUp() * 100 )
				local BDist = PRel:Distance( Weap:GetPos() + Weap:GetUp() * -100 )
				local Pitch = math.Clamp((FDist - BDist) * 0.75, -250, 250)
				
				local physi2 = Weap:GetPhysicsObject()
				
				physi2:AddAngleVelocity((physi2:GetAngleVelocity() * -1) + Angle(0,Pitch,0))
			else
				local PRel = Weap:GetPos() + self.Entity:GetForward() * 500
				local FDist = PRel:Distance( Weap:GetPos() + Weap:GetUp() * 100 )
				local BDist = PRel:Distance( Weap:GetPos() + Weap:GetUp() * -100 )
				local Pitch = math.Clamp((FDist - BDist) * 0.75, -250, 250)
				
				local physi2 = Weap:GetPhysicsObject()
				
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
	if ent.HasHardpoints then
		if ent.Cont && ent.Cont:IsValid() then HPLink( ent.Cont, ent.Entity, self.Entity ) end
		self.Entity:GetPhysicsObject():EnableCollisions(true)
		self.Entity:SetParent()
	end
end

function ENT:HPFire()
	if self.HP[1]["Ent"] && self.HP[1]["Ent"]:IsValid() then
		self.HP[1]["Ent"]:HPFire()
	end
end

function ENT:BuildDupeInfo()
	local info = self.BaseClass.BuildDupeInfo(self) or {}
	if (self.Pod) and (self.Pod:IsValid()) then
	    info.Pod = self.Pod:EntIndex()
	end
	info.guns = {}
	for k,v in pairs(self.HP) do
		if (v["Ent"]) and (v["Ent"]:IsValid()) then
			info.guns[k] = v["Ent"]:EntIndex()
		end
	end
	return info
end

function ENT:ApplyDupeInfo(ply, ent, info, GetEntByID)
	self.BaseClass.ApplyDupeInfo(self, ply, ent, info, GetEntByID)
	if (info.Pod) then
		self.Pod = GetEntByID(info.Pod)
		if (!self.Pod) then
			self.Pod = ents.GetByIndex(info.Pod)
		end
	end
	if (info.guns) then
		for k,v in pairs(info.guns) do
			local gun = GetEntByID(v)
			self.HP[k]["Ent"] = gun
			if (!self.HP[k]["Ent"]) then
				gun = ents.GetByIndex(v)
				self.HP[k]["Ent"] = gun
			end
		end
	end
end