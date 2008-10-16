--[[
	Planetfall Trace Bullet Library
	by Olivier 'LuaPineapple' Hamel
	Based on the code EmpirePhonix sent me (almost total rewrite)
	
	It is YOUR responsibility to make sure FireShot is called both on the client
	and server using the same values. (INCLUDING SPREAD! BE SURE TO CALCULATE THAT
	AFOREHAND, USE THE AUX FUNC PROVIDED IF YOU SO WISH.)
--]]

local DEV_MODE = true
local InternalVersion = 1.8

if PLANETFALL_TRACE_BULLET_LIBRARY then
	if PLANETFALL_TRACE_BULLET_LIBRARY > InternalVersion then
		return Msg("A more recent instance of the Planetfall Trace Bullet Library has been detected, aborting initialization.\n")
	elseif PLANETFALL_TRACE_BULLET_LIBRARY < InternalVersion then
		Msg("A less recent instance of the Planetfall Trace Bullet Library has been detected, overriding instance.\n")
		
		hook.Remove("Tick", "TraceBulletLib.TickDriver")
		
		if CLIENT then
			hook.Remove("Think", "TraceBulletLib.ThinkDriver")
		end
	elseif DEV_MODE then
		Msg("The same instance of the Planetfall Trace Bullet Library has been detected, overriding instance.\n")
		
		hook.Remove("Tick", "TraceBulletLib.TickDriver")
		
		if CLIENT then
			hook.Remove("Think", "TraceBulletLib.ThinkDriver")
		end
	else
		return Msg("The same instance of the Planetfall Trace Bullet Library has been detected, aborting initialization.\n")
	end
else
	Msg("No instance of the Planetfall Trace Bullet Library has been detected, initializing.\n")
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
	
	obj.Duration      = duration
	obj.DieTimestamp  = duration + CurTime()
	
	obj.Damage        = damage
	obj.ImpactForce   = force
	
	obj.Attacker      = attacker
	
	obj.RenderFX_Name = render_effect_name
	obj.ImpactFX_Name = impact_effect_name
	
	obj.TraceTable    = {}
	obj.TraceTable.filter = trace_filter
	obj.TraceTable.mask   = trace_mask or MASK_SHOT
	
	obj.OnImpactCallback = impact_callback
	obj.OnDieCallback    = die_callback
	
	return obj, table.insert(TraceBulletLib.ShotsList, obj)
end

local GenericBulletTable = {}
GenericBulletTable.Num    = 1
GenericBulletTable.Tracer = 0

function TraceShotObj:TickUpdate(CTime, index, frametime)
	self.TraceTable.start  = self.Position
	self.TraceTable.endpos = self.Position + (self.Velocity * frametime)
	
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
			self:OnImpactCallback(tr) -- This is the same as self.OnImpactCallback(self, tr)
		end
		
		ShotsList[index] = nil
	end
	
	if self.DieTimestamp < CTime then
		ShotsList[index] = nil
		
		if self.OnDieCallback then
			self:OnDieCallback() -- This is the same as self.OnDieCallback(self)
		end
	end
end

function TraceShotObj:ThinkUpdate(CTime, index, frametime)
	if self.RenderFX_Name then
		local fx = EffectData()
		
		fx:SetOrigin(self.Position)
		fx:SetStart(self.Position + (self.Velocity * frametime))
		
		fx:SetMagnitude(index)
		
		util.Effect(self.RenderFX_Name, fx, true, true)
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

function TraceBulletLib.TickDriver()
	local CTime = CurTime()
	local FTime = FrameTime()
	
	for k, v in pairs(TraceBulletLib.ShotsList) do
		v:TickUpdate(CTime, k, FTime)
	end
end

function TraceBulletLib.ThinkDriver()
	if SERVER then return end -- This shouldn't be in use for the server
	
	local CTime = CurTime()
	local FTime = FrameTime()
	
	for k, v in pairs(TraceBulletLib.ShotsList) do
		v:ThinkUpdate(CTime, k, FTime)
	end
end

hook.Add("Tick", "TraceBulletLib.TickDriver", TraceBulletLib.TickDriver)

if CLIENT then
	hook.Add("Think", "TraceBulletLib.ThinkDriver", TraceBulletLib.ThinkDriver)
end