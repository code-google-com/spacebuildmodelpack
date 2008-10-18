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

function ENT:OnKillEnt(ent, amount, was_player_or_npc)
	if was_player_or_npc then
		local fx = EffectData()
		fx:SetOrigin(ent:GetPos() + ent:OBBCenter())
		util.Effect("sbmp_flak_gibbify", fx, true, true)
	end
	
	SafeRemoveEntity(ent)
end
