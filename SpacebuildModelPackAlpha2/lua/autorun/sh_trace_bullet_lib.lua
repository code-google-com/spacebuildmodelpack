--[[
	Planetfall Trace Bullet Library
	by Olivier 'LuaPineapple' Hamel
	Based on the code EmpirePhonix sent me (almost total rewrite)
	
	It is YOUR responsibility to make sure FireShot is called both on the client
	and server using the same values. (INCLUDING SPREAD! BE SURE TO CALCULATE THAT
	AFOREHAND, USE THE AUX FUNC PROVIDED IF YOU SO WISH.)
--]]

local DEV_MODE = true
local InternalVersion = 1.89

if PLANETFALL_TRACE_BULLET_LIBRARY then
	if PLANETFALL_TRACE_BULLET_LIBRARY > InternalVersion then
		return Msg("A more recent instance of the Planetfall Trace Bullet Library has been detected, aborting initialization.\n")
	elseif PLANETFALL_TRACE_BULLET_LIBRARY < InternalVersion then
		Msg("A less recent instance of the Planetfall Trace Bullet Library has been detected, overriding instance.\n")
		
		hook.Remove("Think", "TraceBulletLib.ThinkDriver")
	elseif DEV_MODE then
		Msg("The same instance of the Planetfall Trace Bullet Library has been detected, overriding instance.\n")
		
		hook.Remove("Think", "TraceBulletLib.ThinkDriver")
	else
		return Msg("The same instance of the Planetfall Trace Bullet Library has been detected, aborting initialization.\n")
	end
else
	Msg("No instance of the Planetfall Trace Bullet Library has been detected, initializing.\n")
end

if SERVER then
	AddCSLuaFile("sh_trace_bullet_lib.lua")
end

_G["PLANETFALL_TRACE_BULLET_LIBRARY"] = InternalVersion -- Explicit to reinforce the point

TraceBulletLib = {}

local TraceShotObj = {}
TraceBulletLib.ShotsList = {}

function TraceShotObj:New(owner, origin, dir, speed, duration, damage, force, attacker, render_effect_name, impact_effect_name, trace_filter, impact_callback, die_callback, trace_mask)
	local obj         = {}
	obj.__index       = TraceShotObj
	setmetatable(obj, obj)
	
	obj.Owner         = owner
	
	obj.Direction     = dir
	
	obj.Origin        = origin
	obj.Position      = origin
	
	obj.Speed         = speed
	obj.Velocity      = dir * speed -- If you change one be sure to update this!!
	obj.ProjectedEndV = origin + (obj.Velocity * duration) -- and this too
	
	obj.Duration      = duration
	
	obj.Damage        = damage
	obj.ImpactForce   = force
	
	obj.Attacker      = attacker
	
	obj.RenderFX_Name = render_effect_name
	obj.ImpactFX_Name = impact_effect_name
	
	obj.TraceTable        = {}
	obj.TraceTable.filter = trace_filter
	obj.TraceTable.mask   = trace_mask or MASK_SHOT
	
	obj.StartTimestamp  = CurTime()
	obj.DieTimestamp    = duration + obj.StartTimestamp
	-- print("Start at: ", obj.StartTimestamp, "; Die at: ", obj.DieTimestamp)
	obj.OnImpactCallback = impact_callback
	obj.OnDieCallback    = die_callback
	
	return obj, table.insert(TraceBulletLib.ShotsList, obj)
end

local UpdateRate = .2

local GenericBulletTable = {}
GenericBulletTable.Num    = 1
GenericBulletTable.Tracer = 0

function TraceShotObj:ThinkUpdate(CTime, index, updatetime)
	self.UpdateTimestamp = self.UpdateTimestamp or 0
	
	local OldPos = self.Position
	local percent = math.Clamp((1 - (self.StartTimestamp - CTime)) / self.Duration, 0, 1)
	--print("Percent: ", percent)
	if self.UpdateTimestamp < CTime then
		self.TraceTable.start  = self.Position
		self.TraceTable.endpos = LerpVector(percent, self.Origin, self.ProjectedEndV)
		
		local tr = util.TraceLine(self.TraceTable)
		
		self.Position = tr.HitPos -- Update this right away so we have the proper attributes when we get passed to the callbacks
		
		if tr.Hit then
			if SERVER then
				local class = tr.Entity:GetClass()
				
				if self.BulletType ~= "" then
					if self.Owner and self.Owner.IsValid and self.Owner:IsValid() then
						tr.Entity:TakeDamage(self.Damage, self.Owner, self.Attacker)
					else
						tr.Entity:TakeDamage(self.Damage, self.Owner)
					end
				else--(class ~= "prop_physics") and 
					if (class ~= "prop_physics_multiplayer") and (class ~= "player") and (not string.find(class, "npc_")) then
						if self.Owner and self.Owner.IsValid and self.Owner:IsValid() then
							tr.Entity:TakeDamage(self.Damage, self.Owner, self.Attacker)
						else
							tr.Entity:TakeDamage(self.Damage, self.Owner)
						end
					else
						GenericBulletTable.Src    = self.Position
						GenericBulletTable.Dir    = self.Direction
						
						GenericBulletTable.Force  = self.ImpactForce or 0
						GenericBulletTable.Damage = self.Damage or 0
						
						if self.Owner and self.Owner.IsValid and self.Owner:IsValid() then
							self.Owner:FireBullets(GenericBulletTable)
						else
							tr.Entity:FireBullets(GenericBulletTable)
						end
					end
				end
			else -- Don't bother the server with this
				if self.ImpactFX_Name then
					local fx = EffectData()
					
					fx:SetOrigin(tr.HitPos)
					fx:SetNormal(tr.Normal)
					
					fx:SetEntity(tr.Entity)
					
					util.Effect(self.ImpactFX_Name, fx, true, true)
				end
			end
			
			if self.OnImpactCallback then
				local ok, err = pcall(self.OnImpactCallback, self) -- This is the same as self.OnDieCallback(self)
				if not ok then ErrorNoHalt(err, "\n") end
			end
			--print("die by hit")
			TraceBulletLib.ShotsList[index] = nil
		end
		
		
		self.UpdateTimestamp = updatetime
	end
	
	--[[
	local fx_debugger = EffectData()
	fx_debugger:SetStart(OldPos)
	fx_debugger:SetOrigin(self.Position)
	util.Effect("sbmp_trace_debugger", fx_debugger, true, true)
	--]]
	
	if CLIENT and self.RenderFX_Name then
		local fx = EffectData()
		
		fx:SetMagnitude(index)
		fx:SetOrigin(OldPos)
		
		util.Effect(self.RenderFX_Name, fx, true, true)
	end
	
	if percent == 1 then
		--print("die by time")
		if self.OnDieCallback then
			local ok, err = pcall(self.OnDieCallback, self) -- This is the same as self.OnDieCallback(self)
			
			if not ok then ErrorNoHalt(err, "\n") end
		end
		
		TraceBulletLib.ShotsList[index] = nil
	end
end

function TraceBulletLib.FireShot(owner, origin, dir, speed, duration, damage, force, attacker, render_effect_name, impact_effect_name, trace_filter, impact_callback, die_callback, trace_mask)
	return TraceShotObj:New(owner, origin, dir, speed, duration, damage, force, attacker, render_effect_name, impact_effect_name, trace_filter, impact_callback, die_callback, trace_mask)
end

function TraceBulletLib.CalcSpreadVector(dir, spread)
	return Vector(dir.x + math.Rand(-spread.x, spread.x), dir.y + math.Rand(-spread.y, spread.y), dir.z + math.Rand(-spread.z, spread.z))
end

function TraceBulletLib.CalcSpreadVecScalar(dir, spread)
	return (dir + (VectorRand():Normalize() * spread))
end

function TraceBulletLib.ThinkDriver()
	local CTime = CurTime()
	local updatetime = CTime + .1--UpdateRate
	
	for k, v in pairs(TraceBulletLib.ShotsList) do
		v:ThinkUpdate(CTime, k, updatetime)
	end
end

hook.Add("Think", "TraceBulletLib.ThinkDriver", TraceBulletLib.ThinkDriver)
