ENT.Type 			= "anim"
ENT.Base 			= "base_sbmp_weapon"

ENT.PrintName		= "FS2 Flak Gun"
ENT.Author			= "Olivier 'LuaPineapple' Hamel"
ENT.Contact			= "evilpineapple@cox.net"
ENT.Purpose			= "Blow your fellow players to bits!"
ENT.Instructions	= "Spawn, fire!"
ENT.Category		= "SBEP - Other"

ENT.Spawnable		= true
ENT.AdminSpawnable	= true

ENT.WireInputsList = {"Fire"}

ENT.Model = "models/Slyfo/SWORDGRENADE.mdl"
ENT.MassOverride = 1250

ENT.IsToggleable = true
ENT.IsAutomatic  = true

ENT.FiringRate    = 5
ENT.ReloadRate    = .75
ENT.CooldownDelay = 0

ENT.MaxFlackSpread = 768
ENT.MinFlackSpread = ENT.MaxFlackSpread * -1

ENT.MinFlackSpeed = 512
ENT.MaxFlackSpeed = ENT.MinFlackSpeed * 3

ENT.MaxAmmo = 50

local FlakDamage = 200
local FlakRadius = FlakDamage * 1.5
ENT.FlakDuration = 1.75

--print(ENT.FlakRadius)

ENT.ImpactEffect = nil--"sbmp_flak_impact"
ENT.TravelEffect = "sbmp_flak_travel"

function ENT:FireFlackShot(data)
	if SERVER then self:CallOnClient("FireFlackShot", data, true) end -- Send it over to the client as well
	
	--[[
	local fx_debugger = EffectData()
	fx_debugger:SetStart(data.StartPos)
	fx_debugger:SetOrigin(data.StartPos + (data.Dir * data.Speed))
	util.Effect("sbmp_trace_debugger", fx_debugger, true, true)
	--]]
	
	if CLIENT then
		local fx_fire = EffectData()
		fx_fire:SetStart(data.StartPos)
		fx_fire:SetNormal(data.Dir)
		fx_fire:SetEntity(self.Entity)
		util.Effect("sbmp_flak_fire", fx_fire, true, true)
	end
	
	local owner = self:GetNWEntity("OwningPlayer")
	
	if not (owner and (owner ~= NULL) and owner.IsValid and owner:IsValid()) then
		owner = self.Entity
	end
	
	return TraceBulletLib.FireShot(owner, data.StartPos, data.Dir, data.Speed, self.FlakDuration, 0, 500, self.Entity, self.TravelEffect, self.ImpactEffect, self.Entity, self.FlackCallback, self.FlackCallback, MASK_PLAYERSOLID)
end

function ENT.FlackCallback(flack_shot, tr)
	--PrintTable(flack_shot)
	--print(flack_shot.Owner)
	--print(flack_shot.TraceTable.filter)
	--print("Server Pos: ", flack_shot.Position)
	--print("Flack update count: ", flack_shot.UpdateCount)
	
	if CLIENT then
		local fx_fire = EffectData()
		fx_fire:SetStart(flack_shot.Position)
		fx_fire:SetMagnitude(3)
		util.Effect("sbmp_flak_impact", fx_fire, true, true)
	else
		local attacker  = (flack_shot.Owner and flack_shot.Owner.IsValid and flack_shot.Owner:IsValid()) and flack_shot.Owner or GetWorldEntity()
		local inflicter = ((flack_shot.TraceTable.filter and flack_shot.TraceTable.filter.IsValid) and flack_shot.TraceTable.filter:IsValid()) and flack_shot.TraceTable.filter or attacker
		
		util.BlastDamage(inflicter, attacker, flack_shot.Position, FlakRadius, FlakDamage)
	end
end