local SpiralParticleCount     = 10
local SpiralParticleSize      = 15
local SpiralParticleRollDelta = 30
local SpiralTrailVelocity     = 33 -- You'll have cylons raining down on you every half hour.
local SpiralTrailDuration     = .33
local SpiralAlphaMulti        = 255 / SpiralParticleCount

local CoreParticleCount = 3
local CoreFlashDuration = .2
local CoreFlashAlpha    = 150
local CoreParticleSize  = 30

local SoundFX = Sound("LuaPineapple/SBMP/beam_cannon/FlakLaunch.wav")

function EFFECT:Init(data)
	local pos = data:GetStart()
	local dir = data:GetNormal() * 3 -- Affects the velocity but more importantly it removes a calculation from the for loop. It's this sort of small thing that makes a difference (minor) to your system after a better algorithm (colossal)
	local ent = data:GetEntity()
	
	local vel = dir * SmokeTrailVelocity
	
	local emttr = ParticleEmitter(pos)
	
	for i = 1, CoreParticleCount do
		local particle = emttr:Add("effects/muzzleflash4", pos)
		
		if particle then
			particle:SetDieTime(CoreFlashDuration)
			
			particle:SetStartAlpha(CoreFlashAlpha)
			particle:SetEndAlpha(0)
			
			particle:SetStartSize(CoreParticleSize)
			particle:SetEndSize(CoreParticleSize)
			
			particle:SetRollDelta(SpiralParticleRollDelta * math.random(-1, 1))
			--particle:SetRollDelta()
		end
	end
	
	-- Pseudo spirally trail effect I created by accident yesterday. Looks reasonably like 3D spiral without the overhead. :)
	for i = 1, SpiralParticleCount do
		local particle = emttr:Add("effects/muzzleflash4", pos + (dir * i))
		
		if particle then
			particle:SetDieTime(SpiralTrailDuration)
			
			particle:SetVelocity(vel)
			
			particle:SetStartAlpha(SpiralAlphaMulti * i)
			particle:SetEndAlpha(0)
			
			particle:SetStartSize(SpiralParticleSize)
			particle:SetEndSize(SpiralParticleSize)
			
			particle:SetRollDelta(SpiralParticleRollDelta)
		end
	end
	
	emttr:Finish()
	
	local DLight      = DynamicLight(ent:EntIndex())
	DLight.Pos        = pos
	DLight.R          = 220
	DLight.G          = 255
	DLight.B          = 0
	DLight.Size       = 768
	DLight.Decay      = 1024
	DLight.Brightness = 3
	DLight.DieTime    = CurTime() + .2
	
	WorldSound(SoundFX, pos, 500, 100)
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end