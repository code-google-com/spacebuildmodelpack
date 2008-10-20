AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:DamageEntity(ent, amount, reported_position)
	if ent:GetDataField("SBMP", "Dying") then return end
	
	local health      = ent:Health()
	local sbmp_health = ent:GetDataField("SBMP", "Health")
	
	if not sbmp_health then
		print("Init SBMP health")
		if health == 0 then
			sbmp_health = ent:GetPhysicsObject():GetMass() * ent:BoundingRadius() * .01
			print("setup prop ", ent, " with health ", sbmp_health)
			ent:SetDataField("SBMP", "Health", sbmp_health)
		else
			print("Nvm, ", ent, " isn't a prop")
			sbmp_health = -1
			ent:SetDataField("SBMP", "Health", -1)
		end
	end
	
	if ent:IsVehicle() then
		local ply = ent:GetDriver()
		
		if ply and ply:IsValid() then
			ply:Kill() -- Hey, if we're talking about weapons fired from spaceships I think a human has no chance
			
			local rag = ply:GetRagdollEntity()
			
			if rag and rag:IsValid() then
				self:OnKillEnt(rag, amount, reported_position, true)
			end
		end
	elseif ent:IsPlayer() then
		ent:Kill()
		
		local rag = ent:GetRagdollEntity()
		
		if rag and rag:IsValid() then
			return self:OnKillEnt(rag, amount, reported_position, true)
		end
	elseif ent:IsNPC() then
		ent:SetHealth(0)
		return self:OnKillEnt(ent, amount, reported_position, true)
	end
	
	if health <= amount then
		if (health == 0) and (sbmp_health ~= -1) then -- A prop/vehicle
			if sbmp_health <= amount then
				ent:SetDataField("SBMP", "Dying", true)
				
				return self:OnKillEnt(ent, amount, reported_position)
			else
				sbmp_health = sbmp_health - amount
				print("health now: ", sbmp_health)
				ent:SetDataField("SBMP", "Health", sbmp_health)
				ent:TakeDamage(amount, self:GetOwner(), self.Entity) -- Do fizzics damage
			end
		else
			ent:SetDataField("SBMP", "Dying", true)
			
			return self:OnKillEnt(ent, amount, reported_position)
		end
	else
		ent:SetDataField("SBMP", "Dying", true)
		ent:TakeDamage(amount, self:GetOwner(), self.Entity) -- Do fizzics damage
		
		return self:OnKillEnt(ent, amount, reported_position)
	end
end

function ENT:OnKillEnt(ent, damage, reported_position, was_player_or_npc)
	local diefx = EffectData()
	diefx:SetMagnitude(10)
	diefx:SetEntity(ent)
	util.Effect("sbmp_die_generic", diefx, true, true)
	
	constraint.RemoveAll(ent)
	
	ent:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE_DEBRIS) 
	
	local dir = ((ent:GetPos() + ent:OBBCenter()) - reported_position):Normalize()
	local phys = ent:GetPhysicsObject()
	
	if phys and phys.IsValid and phys:IsValid() then
		phys:EnableMotion(true)
		phys:ApplyForceOffset(dir * phys:GetMass() * damage * .25, reported_position)
	end
	
	return SafeRemoveEntityDelayed(ent, 10)
end