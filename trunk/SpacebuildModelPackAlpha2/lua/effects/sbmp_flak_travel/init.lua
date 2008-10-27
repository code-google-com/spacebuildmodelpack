
local Mat = "sprites/orangecore1"--"effects/laser_tracer"
local MAX_SEGMENTS = 10

SBMPGlobalEmitter = SBMPGlobalEmitter or ParticleEmitter(Vector(0, 0, 0)) -- Seems to work fine, even in different PVSs. *shrugs*

function EFFECT:Init(data)
	local bullet = TraceBulletLib.ShotsList[data:GetMagnitude()]
	if not bullet then return end
	
	local OldPos = data:GetOrigin()
	
	local Emitter = SBMPGlobalEmitter--ParticleEmitter(bullet.Position) -- Seems to work fine, even in different PVSs. *shrugs*
	
	for i = 1, MAX_SEGMENTS do
		local perc = i / MAX_SEGMENTS
		local particle = Emitter:Add(Mat, LerpVector(perc, OldPos, bullet.Position))
		
		if particle then
			particle:SetVelocity(bullet.Direction)
			particle:SetDieTime(.33)
			
			particle:SetStartAlpha(255 * perc)
			particle:SetEndAlpha(0)
			
			particle:SetStartSize(7)
			particle:SetEndSize(7 * perc)
			
			particle:SetStartLength(15)
			particle:SetEndLength(15)
			
			particle:SetColor(255, 200, 0)
		end
	end
	
	Emitter:Finish()
end

function EFFECT:Think()
end

function EFFECT:Render()
end
