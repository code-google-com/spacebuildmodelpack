AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:OnBaseInit()
	self.Firing = false
	self.CooldownTimestamp = 0
	
	self.Entity:SetUseType(USE_TOGGLE)
	
	if Wire_CreateInputs then
		self.Inputs = Wire_CreateInputs(self.Entity, {"Fire"})
	end
	
	if self.OnInit then
		return self:OnInit()
	end
end

function ENT:OnBaseUse()
	if self.OnUse then
		return self:OnUse()
	end
	
	if self.IsToggleable and self.Firing then
		return self:StopFiring()
	end
	
	return self:StartFiring()
end

function ENT:OnBaseWireInput(iname, value)
	if self.OnWireInput then
		return self:OnBaseWireInput()
	elseif (iname == "Fire") and (value == 1) then
		return self:StartFiring()
	elseif (iname == "Fire") and (value == 0) and self.IsToggleable then
		return self:StopFiring()
	end
end

function ENT:OnBaseThink()
	if self.IsCoherentBeamWeapon and self.Firing then
		self:FireShot()
	end
	
	if self.OnThink then
		self:OnThink()
	end
end

function ENT:CanFire()
	local CTime = CurTime()
	
	if self.UseRD and (not SBMP.MasterResourcesRequiredOverrideVar) then
		if self.UseRD == 3 then
			-- Someone else do this
		else
			for k, v in pairs(self.ResList) do
				if k ~= "BaseClass" then -- WTF was with that one anyways?
					local amount_available = RD_GetResourceAmount(self.Entity, k)
					
					if amount_available < v.CostPerShot then
						return self:StopFiring() -- Bail
					end
					
					RD_ConsumeResource(self.Entity, k, v.CostPerShot)
				end
			end
		end
	end
	
	return self.CooldownTimestamp < CTime
end

function ENT:StartFiring()
	if self.Firing then return end
	if self.CooldownTimestamp > CurTime() then return print("cooling down: ", self.CooldownTimestamp - CurTime()) end
	
	self.Firing = true
	
	if self.OnStartFiring then
		self:OnStartFiring()
	end
	
	return self:FireShot()
end

function ENT:StopFiring()
	if not self.Firing then return end
	
	local CTime = CurTime()
	
	self.Firing = false
	self.CooldownTimestamp = CTime + self.CooldownDelay
	
	if self.OnStopFiring then
		self:OnStopFiring()
	end
end

function ENT:FireShot()
	if not (self and self.Firing and self:IsValid() and self:CanFire()) then return end -- CanFire will also consume your ammo for you, you can disable this automatic resource management by specifying ENT.ResourcesManagedByUser = true, in that cause it's your job to do the res stuff (it'll initiate everthing for you though)
	
	if self.OnFireShot then
		self:OnFireShot()
	end
	
	if self.IsAutomatic and (not self.IsCoherentBeamWeapon) then
		return timer.Simple(1 / self.FiringRate, self.FireShot, self)
	end
end

function ENT:DamageEntity(ent, amount)
	local health      = ent:Health()
	local sbmp_health = ent:GetDataField("SBMP", "Health")
	
	if not sbmp_health then
		if health == 0 then
			health = ent:BoundingRadius()
			ent:SetDataField("SBMP", "Health", health)
		else
			ent:SetDataField("SBMP", "Health", -1)
		end
	end
	
	if ent:IsVehicle() then
		local ply = ent:GetDriver()
		
		if ply and ply:IsValid() then
			ply:Kill() -- Hey, if we're talking about weapons fired from spaceships I think a human has no chance
			
			local rag = ply:GetRagdollEntity()
			
			if rag and rag:IsValid() and self.OnKillEnt then
				self:OnKillEnt(rag, amount, true)
			end
		end
	elseif ent:IsPlayer() then
		ent:Kill()
		
		local rag = ent:GetRagdollEntity()
		
		if rag and rag:IsValid() and self.OnKillEnt then
			return self:OnKillEnt(rag, amount, true)
		end
	elseif ent:IsNPC() then
		ent:Kill()
		return self:OnKillEnt(ent, amount, true)
	end
	
	if health <= amount then
		if (health == 0) and (sbmp_health ~= -1) then -- A prop/vehicle
			if (sbmp_health <= amount) then
				return self:OnKillEnt(ent, amount)
			else
				sbmp_health = sbmp_health - amount
				-- print("health now: ", sbmp_health)
				
				ent:TakeDamage(amount, self:GetOwner(), self.Entity) -- Do fizzics damage
			end
		else
			return self:OnKillEnt(ent, amount)
		end
	else
		ent:TakeDamage(amount, self:GetOwner(), self.Entity) -- Do fizzics damage
		
		return self:OnKillEnt(ent, amount)
	end
end

function ENT:OnKillEnt(ent, damage, was_player_or_npc)
	return SafeRemoveEntity(ent) -- ???
end