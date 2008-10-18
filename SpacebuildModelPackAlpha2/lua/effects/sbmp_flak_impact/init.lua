local MaterialSprite = "LuaPineapple/FS2/flak/explode_core_anim"
local ExplodeSound   = Sound("LuaPineapple/SBMP/beam_cannon/flack_explode.wav")

local CoreParticleSize  = 45
local CoreFlashAlpha    = 255
local CoreFlashDuration = 1
local GlobalEmitter = ParticleEmitter(Vector(0, 0, 0)) -- Seems to work fine, even in different PVSs. *shrugs*

function EFFECT:Init(data)
	local pos = data:GetStart()
	local ent = data:GetEntity()
	
	if data:GetMagnitude() ~= 3 then
		print(ent)
		print("Client Pos: ", pos)
	end
	
	--local emttr = ParticleEmitter(pos)
	
	local particle = GlobalEmitter:Add(MaterialSprite, pos)
	
	if particle then
		particle:SetDieTime(CoreFlashDuration)
		
		particle:SetStartAlpha(CoreFlashAlpha)
		particle:SetEndAlpha(50)
		
		particle:SetStartSize(CoreParticleSize)
		particle:SetEndSize(CoreParticleSize)
		
		particle:SetRollDelta(0)
		particle:SetRoll(math.random(-1, 1))
	end
	
	for i = 1, 25 do
		local particle = GlobalEmitter:Add("effects/fire_cloud2", pos)
		
		if particle then
			particle:SetVelocity(VectorRand():Normalize() * 128)
			particle:SetDieTime(.5)
			
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
	DLight.Pos        = pos
	DLight.R          = 255
	DLight.G          = 200
	DLight.B          = 0
	DLight.Size       = 512
	DLight.Decay      = 1024
	DLight.Brightness = 2
	DLight.DieTime    = CurTime() + .2
	
	--emttr:Finish()
	
	WorldSound(ExplodeSound, pos, 500, 100)
end

function EFFECT:Think()
end

function EFFECT:Render()
end
