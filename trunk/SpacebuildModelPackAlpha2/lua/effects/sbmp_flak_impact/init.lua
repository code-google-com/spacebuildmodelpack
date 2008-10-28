local MaterialSprite = {}

for i = 0, 17 do
	MaterialSprite[i] = Material("LuaPineapple/FS2/flak/explode_core_anim_" .. i)
end

local ExplodeSound   = Sound("LuaPineapple/SBMP/beam_cannon/flack_explode.wav")

local CoreParticleSize  = 45
local CoreFlashAlpha    = 255
local CoreFlashDuration = .75

SBMPGlobalEmitter = SBMPGlobalEmitter or ParticleEmitter(Vector(0, 0, 0)) -- Seems to work fine, even in different PVSs. *shrugs*

function EFFECT:Init(data)
	self.Pos = data:GetStart()
	local ent = data:GetEntity()
	
	--local emttr = ParticleEmitter(pos)
	
	for i = 1, 5 do
		local particle = SBMPGlobalEmitter:Add("effects/fire_cloud2", self.Pos)
		
		if particle then
			particle:SetVelocity(VectorRand():Normalize() * 128)
			particle:SetDieTime(.33)
			
			particle:SetStartAlpha(175)
			particle:SetEndAlpha(0)
			
			particle:SetStartSize(7)
			particle:SetEndSize(7)
			
			particle:SetStartLength(0)
			particle:SetEndLength(15)
			
			particle:SetColor(255, 200, 0)
			
			particle:SetRoll(math.random(-1, 1))
		end
	end
	
	local DLight      = DynamicLight(0)
	DLight.Pos        = self.Pos
	DLight.R          = 255
	DLight.G          = 200
	DLight.B          = 0
	DLight.Size       = 512
	DLight.Decay      = 1024
	DLight.Brightness = 2
	DLight.DieTime    = CurTime() + .2
	
	--emttr:Finish()
	
	self.Timestamp = CurTime() + CoreFlashDuration
	
	WorldSound(ExplodeSound, self.Pos, 500, 100)
	
	self.RndAng = math.random(0, 359)
end

function EFFECT:Think()
	return (self.Timestamp > CurTime())
end

local size = 64

function EFFECT:Render()
	local idx = math.Round(Lerp(1 - ((self.Timestamp - CurTime()) / CoreFlashDuration), 0, 17))
	local EyeDir = self.Pos - EyePos()
	
	--print(idx)
	render.SetMaterial(MaterialSprite[idx])
	
	render.DrawQuadEasy(self.Pos, EyeDir,      size, size, color_white, self.RndAng)
	render.DrawQuadEasy(self.Pos, EyeDir * -1, size, size, color_white, self.RndAng)
end
