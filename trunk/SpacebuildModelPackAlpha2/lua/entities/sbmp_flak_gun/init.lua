AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:SpawnFunction(ply, tr)
	if not tr.Hit then return end
	
	local ent = ents.Create("sbmp_flak_gun")
	ent:SetPos(tr.HitPos + (tr.HitNormal * 32))
	ent:Spawn()
	ent:Activate()
	
	ent:SetNWEntity("OwningPlayer", ply) -- Hackz, SetOwner seems to be breaking something <_<
	
	return ent
end


function ENT:OnInit()
	self.FlackAmmo = self.MaxAmmo
	self.FlackData = {}
	self.ReloadTimestamp = 0
end

function ENT:OnThink()
	if not self.Firing then
		local CTime = CurTime()
		
		if self.ReloadTimestamp < CTime then
			self.FlackAmmo = math.Clamp(self.FlackAmmo, 0, self.MaxAmmo)
			self.ReloadTimestamp = CTime + selfReloadRate
		end
	end
end

function ENT:OnFireShot()
	self.FlackData.StartPos = self:GetPos() + self:GetForward() * 95 + self:GetUp() * -14
	
	self.FlackData.Dir   = (self:GetForward() * 1337 + self:GetRight() * math.random(self.MinFlackSpread, self.MaxFlackSpread) + self:GetUp() * math.random(self.MinFlackSpread, self.MaxFlackSpread)):Normalize()
	self.FlackData.Speed = math.random(self.MinFlackSpeed, self.MaxFlackSpeed)
	
	self:FireFlackShot(self.FlackData)
end

function ENT:OnKillEnt(ent, damage, reported_position, was_player_or_npc)
	local dir = ((ent:GetPos() + ent:OBBCenter()) - reported_position):Normalize()
	
	if was_player_or_npc then
		local fx = EffectData()
		fx:SetOrigin(ent:GetPos() + ent:OBBCenter())
		fx:SetStart(ent:GetVelocity() * 2)
		fx:SetNormal(dir * 3)
		
		if ent and ent:IsValid() then
			ent:Remove()
		end
		
		return util.Effect("sbmp_flak_gibbify", fx, true, true)
	end
	
	local diefx = EffectData()
	diefx:SetMagnitude(7)
	diefx:SetEntity(ent)
	util.Effect("sbmp_die_generic", diefx, true, true)
	
	constraint.RemoveAll(ent)
	
	ent:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE_DEBRIS) 
	
	local phys = ent:GetPhysicsObject()
	
	if phys and phys.IsValid and phys:IsValid() then
		phys:EnableMotion(true)
		phys:ApplyForceOffset(dir * phys:GetMass() * damage * 5, reported_position)
	end
	
	return SafeRemoveEntityDelayed(ent, 7)
end
