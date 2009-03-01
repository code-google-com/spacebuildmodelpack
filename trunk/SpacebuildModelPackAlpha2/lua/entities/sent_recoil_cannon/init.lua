
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('entities/base_wire_entity/init.lua')
include('shared.lua')

function ENT:Initialize()
	
	util.PrecacheModel("models/Levybreak/laser_cannon.mdl")
	self:SetModel("models/Levybreak/laser_cannon.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE) 
	self.Inputs = Wire_CreateInputs( self.Entity, { "Fire" } )
	
	local seq = self:LookupSequence("idle")
	self:ResetSequence(seq)
	
	self.PhysObj = self.Entity:GetPhysicsObject()
	self.CAng = self.Entity:GetAngles()
	
end

function ENT:Think()

end 

function ENT:Use(ply)
	if (not self.CanFireAgain or self.CanFireAgain <= CurTime()) then
		self.CanFireAgain = CurTime() + 2.5
		self:FireLazor()
	end
end

function ENT:FireLazor()
	print("I'm firin mah lazor!")
	local seq = self:LookupSequence("fire")
	self:ResetSequence(seq)
	self:EmitSound("Weapon_Mortar.Impact")
	
	self:GetPhysicsObject():ApplyForceCenter(self:GetAngles():Forward()*-200) --recoilz
end

function ENT:PhysicsCollide( data, physobj )  

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

function ENT:SpawnFunction(ply, tr)
	if (!tr.HitWorld) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16 + Vector(0,0,50)
	
	local ent = ents.Create("sent_recoil_cannon")
	ent:SetPos(SpawnPos)
	ent.Owner = ply
	ent:Spawn()
	ent:DropToFloor()
	ent.SPL = ply
	
	return ent
end 

function ENT:HPFire()
	if (not self.CanFireAgain or self.CanFireAgain <= CurTime()) then
		self.CanFireAgain = CurTime() + 2.5
		self:FireLazor()
	end
end 

function ENT:Touch( ent )
	if ent.HasHardpoints then
		if ent.Cont && ent.Cont:IsValid() then HPLink( ent.Cont, ent.Entity, self.Entity ) end
	end
end 