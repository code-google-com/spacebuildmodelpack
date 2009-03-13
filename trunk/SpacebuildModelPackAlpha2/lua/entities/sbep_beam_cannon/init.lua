AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("entities/sbep_beam_cannon/sh_configs.lua")
include('shared.lua')

function ENT:SpawnFunction(ply, tr)
	if not tr.Hit then return end
	
	local ent = ents.Create("sbep_beam_cannon")
	ent:SetPos(tr.HitPos + (tr.HitNormal * 32))
	ent:Spawn()
	ent:Activate()
	
	return ent
end

function ENT:OnInit()
	self.ConfigurationIndex = -1
	
	self:SetNWInt("ConfigIdx", -1)
	
	self.TraceSettings = {}
	self.TraceSettings.mask   = MASK_PLAYERSOLID
	self.TraceSettings.filter = self.Entity
	self.Inputs = Wire_CreateInputs(self.Entity, {"Config","Fire"})
end

function ENT:TriggerInput(iname, value)
	if(iname == "Config") then
		if(--[[value == 1 ||]] value == 2 || value == 3 || value == 4 || value == 5 --[[|| value == 6 || value == 7]]) then
			beam_config_index = value
			self.ConfigurationIndex = value
			self:SetNWInt("ConfigIdx", value)
		else
			beam_config_index = -1
			self.ConfigurationIndex = -1
			self:SetNWInt("ConfigIdx", -1)
		end
	end

	if (iname == "Fire") and (value == 1) then
		return self:StartFiring()
	elseif (iname == "Fire") and (value == 0) and self.IsToggleable then
		return self:StopFiring()
	end
end

function ENT:Setup(beam_config_type)
	self.ConfigurationIndex = beam_config_type
	
	self:SetNWInt("ConfigIdx", beam_config_type)
end

function ENT:OnRemove()
	if Dev_Unlink_All then return Dev_Unlink_All(self.Entity) end
end

function ENT:OnKillEnt(ent)
	if not (ent and ent.IsValid and ent:IsValid()) then return end
	
	local rag
	
	if ent:IsVehicle() then
		local ply = ent:GetDriver()
		
		if ply and ply:IsValid() then
			ply:Kill()
			
			local ragb = ply:GetRagdollEntity()
			
			if ragb and ragb:IsValid() then
				self:OnKillEnt(ragb)
			end
		end
	elseif ent:IsPlayer() then
		ent:Kill()
		
		local ragb = ent:GetRagdollEntity()
		
		if ragb and ragb:IsValid() then
			rag = ragb
		end
	elseif ent:IsNPC() then
		ent:TakeDamage(9001, self:GetOwner(), self.Entity) -- Do fizzics damage
	end
	
	ent = rag or ent
	
	constraint.RemoveAll(ent)
	
	ent:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	
	local phys = ent:GetPhysicsObject()
	
	if phys and phys.IsValid and phys:IsValid() then
		phys:EnableMotion(true)
		phys:ApplyForceOffset(self:GetForward() * -phys:GetMass() * self.Configs[self.ConfigurationIndex].Damage, self.HackHitPos)
	end
	
	local fx = EffectData()
	fx:SetEntity(ent)
	fx:SetScale(6)
	util.Effect("sbmp_disintergrate", fx)
	
	SafeRemoveEntityDelayed(ent, 6)
end

function ENT:FireCannon()
	local StartPos, EndPos, tr = self:GetFiringData()
	
	if tr.HitWorld then return end
	if not tr.Entity then return end
	
	local damage = (tr.Entity:IsPlayer() or tr.Entity:IsNPC()) and 9001 or self.Configs[self.ConfigurationIndex].Damage
	
	self.HackHitPos = tr.HitPos
	--print("Damage: ", damage)
	self:DamageEntity(tr.Entity, damage)
end
