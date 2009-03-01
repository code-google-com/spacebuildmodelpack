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
	local inNames = {"Active", "Fire", "X", "Y", "Z","Vector"}
	local inTypes = {"NORMAL","NORMAL","NORMAL","NORMAL","NORMAL","VECTOR"}
	self.Inputs = WireLib.CreateSpecialInputs( self.Entity,inNames,inTypes)
	
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
		
	elseif (iname == "Vector") then
		self.XCo = value.x
		self.YCo = value.y
		self.ZCo = value.z
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
		local FDist = TargPos:Distance( self.Entity:GetPos() + self.Entity:GetUp() * 120 ) --100 with compensation
		local BDist = TargPos:Distance( self.Entity:GetPos() + self.Entity:GetUp() * -80 )
		local Pitch = math.Clamp((FDist - BDist) * 7.75, -1050, 1050)
		FDist = TargPos:Distance( self.Entity:GetPos() + self.Entity:GetRight() * 100 )
		BDist = TargPos:Distance( self.Entity:GetPos() + self.Entity:GetRight() * -100 )
		local Yaw = math.Clamp((BDist - FDist) * 7.75, -1050, 1050)
		
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


function ENT:BuildDupeInfo()
	local info = self.BaseClass.BuildDupeInfo(self) or {}
	if (self.CPod) and (self.CPod:IsValid()) then
	    info.cpod = self.CPod:EntIndex()
	end
	info.guns = {}
	for k,v in pairs(self.HP) do
		if (v["Ent"]) and (v["Ent"]:IsValid()) then
			info.guns[k] = v["Ent"]:EntIndex()
		end
	end
	if (self.Base) and (self.Base:IsValid()) then
		info.Base = self.Base:EntIndex()
	end
	return info
end

function ENT:ApplyDupeInfo(ply, ent, info, GetEntByID)
	self.HPC				= 4
	self.HP				= {}
	for k=1,4 do
		self.HP[k]			= {}
		self.HP[k]["Ent"]	= nil
		self.HP[k]["Type"]	= "Small"
	end
	self.HP[1]["Pos"]	= Vector(20,-20,53)
	self.HP[2]["Pos"]	= Vector(20,-20,23)
	self.HP[3]["Pos"]	= Vector(20,20,53)
	self.HP[4]["Pos"]	= Vector(20,20,23)
	self.BaseClass.ApplyDupeInfo(self, ply, ent, info, GetEntByID)
	if (info.cpod) then
		self.CPod = GetEntByID(info.cpod)
		if (!self.CPod) then
			self.CPod = ents.GetByIndex(info.cpod)
		end
	end
	if (info.Base) then
		self.Base = GetEntByID(info.Base)
		if (!self.Base) then
			self.Base = ents.GetByIndex(info.Base)
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
