local DahUberSecretCreatorzSteamIDz = "?" -- Please don't change this, :( I worked quite a bit on this. :S
local DLightIndexOffset = 42 * 1337 + 9001 -- Shut up. I needed a non-colliding index offset

local MaxParticles   = 25
local ParticleRadius = 64

local Gravity = math.sqrt(ParticleRadius) * .25

local CHARGING_CANNON = 1
local START_FIRE      = 2
local LOOP_FIRE       = 3
local POWERING_DOWN   = 4

local Colour_White = Color(255, 255, 255, 255)

local HitGlow = Material("sprites/light_glow02")
HitGlow:SetMaterialInt("$spriterendermode", 9)
HitGlow:SetMaterialInt("$illumfactor", 8)
HitGlow:SetMaterialInt("$ignorez", 1)

local HackzReloadFastFX = EFFECT

function EFFECT:Init(data)
	self.Ent = data:GetEntity()
	self.TimeOffset = data:GetMagnitude()
	
	if not (self.Ent and self.Ent:IsValid() and (self.Ent.ConfigurationIndex >= 1) and (self.Ent.ConfigurationIndex <= 5)) then
		self.Ent = nil
		
		return
	end
	
	--self.Entity:SetParent(self.Ent)
	
	self.Settings   = {}
	
	self.RenderGlowFrame = 0
	self.RenderBeamFrame = 0
	
	self.UniqueShiftNum = math.random(-9001, 9001)
	
	if false and self.Ent.ConfigurationIndex >= 4 then -- Only for the big suckers
		self.ActivateUberEastaEggMode = (self.Ent:GetOwner():SteamID() == DahUberSecretCreatorzSteamIDz)
	end
	
	local StartPos = self.Ent:GetFiringData()
	
	self.Emitter = ParticleEmitter(StartPos)
	
	self.TimeTillNextStage = -1
	
	self:OnInitFire()
	
	self.CTime = CurTime()
	self.ProgressionPercent = (self.TillNextStageTimestamp - self.CTime) / self.TimeTillNextStage
	
	local ent_idx = self.Ent:EntIndex()
	
	self.Settings.StartPos, self.Settings.EndPos, self.Settings.TraceData = self.Ent:GetFiringData()
	
	self.Settings.Forward  = self.Ent:GetForward() * -1
	self.SphereFrontOffset = self.Settings.Forward - self.Settings.StartPos
	
	self.HitGlowColour = Color(self.Ent.Configs[self.Ent.ConfigurationIndex].DLight.R,
							   self.Ent.Configs[self.Ent.ConfigurationIndex].DLight.G,
							   self.Ent.Configs[self.Ent.ConfigurationIndex].DLight.B)
end

function EFFECT:OnInitFire(stall)
	self.State = CHARGING_CANNON
	
	self.Ent:EmitSound(self.Ent.Configs[self.Ent.ConfigurationIndex].EventData.OnInitFire.Sound, 500, 100)
	
	self.TimeTillNextStage = self.TimeOffset + self.Ent.Configs[self.Ent.ConfigurationIndex].EventData.OnInitFire.ProgressionDelay
	self.TillNextStageTimestamp = self.TimeTillNextStage + CurTime()
	
	return timer.Simple(self.TimeTillNextStage, self.OnFire, self)
end

function EFFECT:OnFire()
	if not (self and self.Entity and self.Entity:IsValid() and self.Ent and self.Ent:IsValid()) then return end
	
	self.State = START_FIRE
	
	self.Ent:EmitSound(self.Ent.Configs[self.Ent.ConfigurationIndex].EventData.OnFire.Sound, 500, 100)
	
	self.TimeTillNextStage = self.Ent.Configs[self.Ent.ConfigurationIndex].EventData.OnFire.ProgressionDelay
	self.TillNextStageTimestamp = self.TimeTillNextStage + CurTime()
	
	return timer.Simple(self.TimeTillNextStage, self.OnFireLoop, self)
end

function EFFECT:OnFireLoop()
	if not (self and self.Entity and self.Entity:IsValid() and self.Ent and self.Ent:IsValid()) then return end
	
	self.State = LOOP_FIRE
	
	self.Ent:EmitSound(self.Ent.Configs[self.Ent.ConfigurationIndex].EventData.OnFireLoop.Sound, 500, 100)
	
	self.TimeTillNextStage = self.Ent.Configs[self.Ent.ConfigurationIndex].EventData.OnFireLoop.ProgressionDelay
	self.TillNextStageTimestamp = self.TimeTillNextStage + CurTime()
	
	return timer.Simple(self.TimeTillNextStage, self.OnFireEnd, self)
end

function EFFECT:OnFireEnd()
	if not (self and self.Entity and self.Entity:IsValid() and self.Ent and self.Ent:IsValid()) then return end
	
	self.FiringBeam = false
	self.State = POWERING_DOWN
	
	self.Ent:EmitSound(self.Ent.Configs[self.Ent.ConfigurationIndex].EventData.OnFireEnd.Sound, 500, 100)
	
	self.TimeTillNextStage = (self.Ent.ConfigurationIndex == 1) and .5 or self.Ent.Configs[self.Ent.ConfigurationIndex].EventData.OnFireEnd.ProgressionDelay
	self.TillNextStageTimestamp = self.TimeTillNextStage + CurTime()
	
	return timer.Simple(self.TimeTillNextStage, self.KillSelf, self)
end

function EFFECT:KillSelf()
	if not (self and self.Entity and self.Entity:IsValid()) then return end
	
	return self:Remove()
end

function EFFECT:RndPos() -- Fuck it mahalis, you make everything look easy
	--local rndV = Vector(math.random()*2 - 1,math.random()*2 - 1,math.random()*2 - 1):GetNormal() * ParticleRadius
	local rndV = VectorRand():GetNormal() * ParticleRadius
	
	--if rndV:Dot(self.SphereFrontOffset) < 0 then rndV = rndV * -1 end
	
	return rndV
end

function EFFECT:Think()
	if not (self and self.Ent and self.Ent:IsValid() and self.Ent.Firing) then
		if self.Emitter then
			--print("die on think.")
			self.Emitter:Finish()
		end
		
		return 
	end
	
	self.CTime = CurTime()
	self.ProgressionPercent = (self.TillNextStageTimestamp - self.CTime) / self.TimeTillNextStage
	
	local ent_idx = self.Ent:EntIndex()
	
	self.Settings.StartPos, self.Settings.EndPos, self.Settings.TraceData = self.Ent:GetFiringData()
	
	self.Settings.Forward  = self.Ent:GetForward() * -1
	self.SphereFrontOffset = self.Settings.Forward - self.Settings.StartPos
	
	if self.FiringBeam then
		self.ProgressionPercent = 1
	end
	
	-- DLights
	---[[
	local DLight      = DynamicLight(ent_idx)
	DLight.Pos        = self.Settings.StartPos
	DLight.R          = self.Ent.Configs[self.Ent.ConfigurationIndex].DLight.R
	DLight.G          = self.Ent.Configs[self.Ent.ConfigurationIndex].DLight.G
	DLight.B          = self.Ent.Configs[self.Ent.ConfigurationIndex].DLight.B
	DLight.Size       = self.Ent.Configs[self.Ent.ConfigurationIndex].DLight.Size
	DLight.Decay      = self.Ent.Configs[self.Ent.ConfigurationIndex].DLight.Decay
	DLight.Brightness = self.Ent.Configs[self.Ent.ConfigurationIndex].DLight.Brightness * self.ProgressionPercent
	DLight.DieTime    = self.CTime + self.Ent.Configs[self.Ent.ConfigurationIndex].EventData.OnFireEnd.ProgressionDelay
	
	if self.FiringBeam then
		local DLight2      = DynamicLight(ent_idx + DLightIndexOffset)
		DLight2.Pos        = self.Settings.EndPos
		DLight2.R          = self.Ent.Configs[self.Ent.ConfigurationIndex].DLight.R
		DLight2.G          = self.Ent.Configs[self.Ent.ConfigurationIndex].DLight.G
		DLight2.B          = self.Ent.Configs[self.Ent.ConfigurationIndex].DLight.B
		DLight2.Size       = self.Ent.Configs[self.Ent.ConfigurationIndex].DLight.Size * 1.5
		DLight2.Decay      = self.Ent.Configs[self.Ent.ConfigurationIndex].DLight.Decay * 3
		DLight2.Brightness = self.Ent.Configs[self.Ent.ConfigurationIndex].DLight.Brightness * 1.5 * self.ProgressionPercent
		DLight2.DieTime    = self.CTime + .1
	end
	--]]
	
	if (self.State == CHARGING_CANNON) and (self.Ent.ConfigurationIndex ~= 1) then
		local num_particles = math.floor(MaxParticles * self.ProgressionPercent)
		local alpha = 255 * self.ProgressionPercent
		local size = (self.Ent.ConfigurationIndex < 4) and 20 or 30
		
		for i = 1, num_particles do
			local pos = self:RndPos()
			local particle = self.Emitter:Add("sprites/orangecore2", pos + self.Settings.StartPos)
			particle:SetStartLength(math.random(0, .2))
			particle:SetDieTime(1)
			particle:SetStartAlpha(0)
			particle:SetEndAlpha(alpha)
			particle:SetStartSize(size)
			particle:SetEndSize(0)
			particle:SetGravity(pos * -Gravity)
			particle:SetColor(self.Ent.Configs[self.Ent.ConfigurationIndex].DLight.R,
							  self.Ent.Configs[self.Ent.ConfigurationIndex].DLight.G,
							  self.Ent.Configs[self.Ent.ConfigurationIndex].DLight.B)
		end
	end
	
	self.Entity:SetRenderBoundsWS(self.Settings.StartPos, self.Settings.EndPos)
	
	return true
end

function EFFECT:Render()
	if self.TimeTillNextStage == -1 then return end
	self.RenderAlpha = 255
	
	self.CTime      = CurTime()
	self.CTimeShift = self.CTime + self.UniqueShiftNum
	
	self.TextureCoord = self.UniqueShiftNum - self.CTime * 3
	
	self.BeamLength = self.Settings.StartPos:Distance(self.Settings.EndPos)
	self.BeamWidth  = self.Ent.Configs[self.Ent.ConfigurationIndex].BeamWidth * (255 / self.RenderAlpha)
	
	if self.State == CHARGING_CANNON then
		self.RenderAlpha = self.RenderAlpha * self.ProgressionPercent
		self.RenderGlowSize = self.Ent.Configs[self.Ent.ConfigurationIndex].GlowSize * (1 - self.ProgressionPercent)
	elseif self.State == POWERING_DOWN then
		self.RenderAlpha = self.RenderAlpha - (self.RenderAlpha * self.ProgressionPercent)
		self.RenderGlowSize = self.Ent.Configs[self.Ent.ConfigurationIndex].GlowSize * self.ProgressionPercent
	else
		self.RenderGlowSize = self.Ent.Configs[self.Ent.ConfigurationIndex].GlowSize
		
		self.FiringBeam = true
	end
	
	---[[
	if self.FiringBeam then
		local BeamFluxed  = self.BeamWidth + (self.BeamWidth * math.cos(self.CTimeShift + UnPredictedCurTime())) * .35 -- ???
		local BeamFluxed2 = BeamFluxed * .7 -- ???
		local BeamFluxed3 = BeamFluxed * .4 -- ???
		local BeamFluxed4 = BeamFluxed * .2 -- ???
		---[[
		render.SetMaterial(self.Ent.Configs[self.Ent.ConfigurationIndex].Materials.Beam.Haze)
		render.DrawBeam(self.Settings.StartPos, self.Settings.EndPos, BeamFluxed, self.TextureCoord, self.TextureCoord + (self.BeamLength / 512), Colour_White)
		
		render.SetMaterial(self.Ent.Configs[self.Ent.ConfigurationIndex].Materials.Beam.Glow)
		render.DrawBeam(self.Settings.StartPos, self.Settings.EndPos, BeamFluxed2, self.TextureCoord, self.TextureCoord + (self.BeamLength / 512), Colour_White)
		
		render.SetMaterial(self.Ent.Configs[self.Ent.ConfigurationIndex].Materials.Beam.Core)
		render.DrawBeam(self.Settings.StartPos, self.Settings.EndPos, BeamFluxed3, self.TextureCoord, self.TextureCoord + self.BeamLength / 100, Colour_White)
		
		render.SetMaterial(self.Ent.Configs[self.Ent.ConfigurationIndex].Materials.Beam.Beam)
		render.DrawBeam(self.Settings.StartPos, self.Settings.EndPos, BeamFluxed4, self.TextureCoord, self.TextureCoord + self.BeamLength / 100, Colour_White)
		--]]
		
		render.SetMaterial(HitGlow)
		render.DrawSprite(self.Settings.EndPos, BeamFluxed * 10, BeamFluxed * 10, self.HitGlowColour)
	end
	--]]
	
	--print("Raw: ", self.RenderGlowFrame + 1)
	--print("Modulused: ", self.RenderGlowFrame + 1 % self.Ent.Configs[self.Ent.ConfigurationIndex].Materials.Glow.Count)	
	self.RenderGlowFrame = math.Round((self.RenderGlowFrame + 1) % self.Ent.Configs[self.Ent.ConfigurationIndex].Materials.Glow.Count)
	
	Colour_White.a = self.RenderAlpha
	
	--self.RenderGlowFrame = 58
	--print("Frame Glow: ", self.RenderGlowFrame)
	local glow = self.RenderGlowSize
	
	if (self.Ent.ConfigurationIndex == 2) or (self.Ent.ConfigurationIndex == 4) then
		glow = glow * 3
	end
	
	---[[
	render.SetMaterial(self.Ent.Configs[self.Ent.ConfigurationIndex].Materials.Glow[self.RenderGlowFrame])
	render.DrawSprite(self.Settings.StartPos, glow, glow, Colour_White)
	--]]
end
