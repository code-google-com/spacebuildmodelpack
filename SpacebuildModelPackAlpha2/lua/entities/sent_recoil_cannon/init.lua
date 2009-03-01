
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
	
	--[[
	PrintTable(self:GetAttachment(self:LookupAttachment("Cannon_Tip")))
	
	self.Tip = self:GetAttachment(self:LookupAttachment("Cannon_Tip"))]] --not accurate enough. o.O
	
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
	local seq = self:LookupSequence("fire")
	self:ResetSequence(seq)
	self:EmitSound("Weapon_Mortar.Impact")
	local start = self:GetPos() + (self:GetAngles():Right() * 10)
	local trace = {}
	trace.start = start
	trace.endpos = self:GetPos() + (self:GetAngles():Right() * -9000000)
	trace.filter = self
	local tr = util.TraceLine(trace) 
	local efct = EffectData()
	efct:SetStart(start)
	efct:SetOrigin(tr.HitPos)
	efct:SetMagnitude(2.5)
	util.Effect("laser_beamz",efct)
	
	util.BlastDamage(self, self.SPL, tr.HitPos, 250, 5000)
	if (not gcombat) then
		for k,v in pairs(ents.FindInSphere(tr.HitPos, 250)) do
			v:TakeDamage(math.random(4000,5000),self.SPL, self)
		end
	else
		cbt_hcgexplode( tr.HitPos, 250, math.Rand(800,1000), 9)
		if tr.Entity and tr.Entity:IsValid() then
			tr.Entity:GetPhysicsObject():ApplyForceCenter((self:GetAngles():Right()*-1000)*tr.Entity:GetPhysicsObject():GetMass())
			cbt_dealhcghit( tr.Entity, 900, 9, tr.HitPos, tr.HitPos)
		end
	end
	
	local phy = self:GetPhysicsObject()
	
	phy:ApplyForceCenter((self:GetAngles():Right()*200)*phy:GetMass()) --recoilz
	if self:GetParent() and self:GetParent():IsValid() then
		self:GetParent():GetPhysicsObject():ApplyForceCenter((self:GetAngles():Right()*200)*phy:GetMass())
	end
end

function ENT:PhysicsCollide( data, physobj )  

end 

function ENT:TriggerInput(iname, value)		
	if (iname == "Fire") then
		if (value > 0) then
			if (not self.CanFireAgain or self.CanFireAgain <= CurTime()) then
				self.CanFireAgain = CurTime() + 2.5
				self:FireLazor()
			end
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