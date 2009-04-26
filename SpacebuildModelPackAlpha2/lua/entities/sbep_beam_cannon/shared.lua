-- THIS IS A HACKZED WEAPON! DO NOT USE IT FOR LEARNING!!!
include("entities/sbep_beam_cannon/sh_configs.lua")

ENT.Type 			= "anim"
ENT.Base 			= "base_sbmp_weapon"

ENT.PrintName		= "Beam Cannon"
ENT.Author			= "Olivier 'LuaPineapple' Hamel, Asphid_Jackal"
ENT.Contact			= "evilpineapple@cox.net"
ENT.Purpose			= "Blow your fellow players to bits!"
ENT.Instructions	= "Spawn, fire!"

-- This gun can crash servers, spawning disabled
ENT.Spawnable       = false
ENT.AdminSpawnable  = false

ENT.Category		= "SBEP-Weapons"

ENT.Model        = "models/Spacebuild/emount4_fighter.mdl"
ENT.MassOverride = 750

ENT.IsCoherentBeamWeapon = true
ENT.IsToggleable = false

ENT.UsesAmmoRounds = false

ENT.ResList = {}
--[[
ENT.ResList.energy = {}
ENT.ResList.energy.Default     = 0
ENT.ResList.energy.Capacity    = 0
ENT.ResList.energy.CostPerShot = ??
--]]

function ENT:OnStartFiring(timing_offset) -- To allow compensation for network latency
	if self.ConfigurationIndex == -1 then return Error("No configuration given.\n") end -- WTF?
	--print("firing")
	if SERVER then
		-- Do an inital range check so we can make the slash scale nicely
		-- Not so elegant
		
		local tr = util.QuickTrace(self:GetPos(), self:GetForward() * -99999, self.Entity)
		--[[print(type(VectorRand()))]]
		local VecRnd = VectorRand() * self.Configs[self.ConfigurationIndex].SlashCone
		
		if tr.HitPos:Distance(self:GetPos()) < 512 then
			tr.HitPos = self:GetPos() + self:GetForward() * -512 -- Hackz
		end
		
		self.SlashStart = self:WorldToLocal(tr.HitPos + VecRnd):Normalize()
		self.SlashEnd   = self:WorldToLocal(tr.HitPos + (VecRnd * -1)):Normalize()
		--print("Setting NW timestamp")
		self:SetNWInt("Firing", CurTime())
		--print("GetNWInt, Firing: ", self:GetNWInt("Firing"))
		self:SetNWVector("SlashStart", self.SlashStart) -- Use the NW stuff because the system/entity might have shifted by the time we get the "OMGZ! W3 h@v3 FI@HD!" message
		self:SetNWVector("SlashEnd",   self.SlashEnd)
		--print("moving to on init fire")
		return self:OnInitFire()
	else
		return self:OnInitFire(timing_offset)
	end
end

function ENT:OnInitFire(timing_offset)
	timing_offset = timing_offset or 0
	
	if CLIENT then
		self.ConfigurationIndex = self:GetNWInt("ConfigIdx")
		
		if self.ConfigurationIndex == -1 then return Error("Received invalid networked configuration index.\n") end -- WTF?
		
		--print("Configuration Index: ", self.ConfigurationIndex)
		
		self.SlashStart = self:GetNWVector("SlashStart")
		self.SlashEnd   = self:GetNWVector("SlashEnd")
		
		local fx = EffectData()
		fx:SetEntity(self.Entity)
		fx:SetMagnitude(timing_offset)
		util.Effect("sbmp_fs2_beam", fx)
	
		self.PredictedFireStart = self.FireTimestamp + self.Configs[self.ConfigurationIndex].EventData.OnInitFire.ProgressionDelay
	else
		self.PredictedFireStart = CurTime() + self.Configs[self.ConfigurationIndex].EventData.OnInitFire.ProgressionDelay
	end
	
	self.PredictedFireEnd = self.PredictedFireStart + self.Configs[self.ConfigurationIndex].EventData.OnFire.ProgressionDelay + self.Configs[self.ConfigurationIndex].EventData.OnFireLoop.ProgressionDelay
	
	return timer.Simple(timing_offset + self.Configs[self.ConfigurationIndex].EventData.OnInitFire.ProgressionDelay, self.OnFire, self)
end

function ENT:OnFire()
	if not (self and self:IsValid()) then return end
	
	self.FireTime = self.Configs[self.ConfigurationIndex].EventData.OnFire.ProgressionDelay + self.Configs[self.ConfigurationIndex].EventData.OnFireLoop.ProgressionDelay
	self.PredictedFireEnd = CurTime() + self.FireTime
	
	self.FiringActive = true
	
	if SERVER then
		self:DoFire()
	end
	
	return timer.Simple(self.Configs[self.ConfigurationIndex].EventData.OnFire.ProgressionDelay + self.Configs[self.ConfigurationIndex].EventData.OnFireLoop.ProgressionDelay, self.OnEndFire, self)
end

function ENT:OnEndFire()
	if not (self and self:IsValid()) then return end
	
	self.FiringActive = false
	
	timer.Simple(self.Configs[self.ConfigurationIndex].Cooldown + self.Configs[self.ConfigurationIndex].EventData.OnFireEnd.ProgressionDelay, self.ResetFiring, self)
end

function ENT:ResetFiring()
	if not (self and self:IsValid()) then return end
	
	self.Firing = false -- This is more elegent then using a timestamp
end

function ENT:DoFire()
	if not (self and self:IsValid()) then return end
	
	if self.FiringActive then
		self:FireCannon()
		
		return timer.Simple(.2, self.DoFire, self)
	end
end

if CLIENT then
	function ENT:Think()
		local firing_timestamp = self:GetNWInt("Firing")
		
		if firing_timestamp == 0 then return end
		
		if firing_timestamp ~= self.FireTimestamp then
			--print("Timestamp differential, received ", firing_timestamp, " at ", CurTime())
			self.FireTimestamp = firing_timestamp
			self.Firing = true
			
			return self:OnStartFiring(firing_timestamp - CurTime()) -- Offsets it back to when the server fired
		end
	end
end

function ENT:GetFiringData()
	local CTime = CurTime()
	
	local selfpos  = self:GetPos()
	local tr_data  = nil
	
	local StartPos = selfpos + self:GetForward() * -45
	local EndPos   = nil
	
	--print("slash start: ", self.SlashStart)
	--print("slash end: ", self.SlashEnd)
	
	if self.FiringActive then
		local perc = (self.PredictedFireEnd - CTime) / self.FireTime
		--print(perc)
		
		self.TraceSettings.start  = StartPos
		self.TraceSettings.endpos = StartPos + self:LocalToWorld(LerpVector(perc, self.SlashStart, self.SlashEnd) * 99999)
		--self.TraceSettings.mask = MASK_PLAYERSOLID
		self.TraceSettings.filter = self.Entity
		
		if SERVER then -- Jitter the beam so it seems 'fuller' and not just a thin line
			local jitter_vec = VectorRand() * 4
			self.TraceSettings.start  = self.TraceSettings.start + jitter_vec * .2
			self.TraceSettings.endpos = self.TraceSettings.endpos + jitter_vec
		end
		
		--print(self.TraceSettings.endpos.x, self.TraceSettings.endpos.y, self.TraceSettings.endpos.z)
		tr_data = util.TraceLine(self.TraceSettings)
		
		EndPos  = tr_data.HitPos
		
		if CLIENT then
			util.Decal("Scorch", EndPos + tr_data.HitNormal, EndPos - tr_data.HitNormal) 
		end
	else
		self.TraceSettings.start  = StartPos
		self.TraceSettings.endpos = StartPos + self:GetForward() * -9999
		
		tr_data = util.TraceLine(self.TraceSettings)
		
		EndPos = tr_data.HitPos
	end
	
	--[[
	local fx_debugger = EffectData()
	fx_debugger:SetStart(StartPos)
	fx_debugger:SetOrigin(EndPos)
	util.Effect("sbmp_trace_debugger", fx_debugger, true, true)
	--]]
	
	return StartPos, EndPos, tr_data
end
