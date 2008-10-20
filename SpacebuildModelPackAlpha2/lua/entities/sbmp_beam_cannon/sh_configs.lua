if SERVER then
	AddCSLuaFile("sh_configs.lua")
end

ENT.Configs = {}
--[[
ENT.Configs[1] = {} -- Anti-Fighter beam
ENT.Configs[1].Damage       = 25
ENT.Configs[1].Cooldown     = 10
ENT.Configs[1].SlashCone    = 25
ENT.Configs[1].GlowSize     = 48
ENT.Configs[1].BeamWidth    = 16

ENT.Configs[1].EventData = {}

ENT.Configs[1].EventData.OnInitFire = {}
ENT.Configs[1].EventData.OnInitFire.Sound = Sound("LuaPineapple/SBMP/beam_cannon/Beam_Up.wav")
ENT.Configs[1].EventData.OnInitFire.ProgressionDelay = 3

ENT.Configs[1].EventData.OnFire = {}
ENT.Configs[1].EventData.OnFire.Sound = Sound("LuaPineapple/SBMP/beam_cannon/beam_shot1.wav")
ENT.Configs[1].EventData.OnFire.ProgressionDelay = 1.75

ENT.Configs[1].EventData.OnFireLoop = {}
ENT.Configs[1].EventData.OnFireLoop.Sound = Sound("LuaPineapple/SBMP/beam_cannon/BT_AntiFtr.wav")
ENT.Configs[1].EventData.OnFireLoop.ProgressionDelay = 2

ENT.Configs[1].EventData.OnFireEnd = {}
ENT.Configs[1].EventData.OnFireEnd.Sound = Sound("LuaPineapple/SBMP/beam_cannon/BS_dwn_3.wav")
ENT.Configs[1].EventData.OnFireEnd.ProgressionDelay = 2

if CLIENT then
	ENT.Configs[1].Materials = {}
	
	ENT.Configs[1].Materials.Beam       = {}
	ENT.Configs[1].Materials.Beam.Pre   = Material("LuaPineapple/FS2/anti_fighter_beam/anti_fighter_beam_pre_fire")
	ENT.Configs[1].Materials.Beam.PostA = Material("LuaPineapple/FS2/anti_fighter_beam/anti_fighter_beam_post_fire_1")
	ENT.Configs[1].Materials.Beam.PostB = Material("LuaPineapple/FS2/anti_fighter_beam/anti_fighter_beam_post_fire_2")
	ENT.Configs[1].Materials.Beam.Main  = {}
	
	for i = 0, 5 do
		for j = 0, 9 do
			ENT.Configs[1].Materials.Beam.Main[(i * 10) + j] = Material("LuaPineapple/FS2/looping/blue/anti_fighter_beam_loop_" .. i .. j .. "_00_00")
		end
	end
	
	ENT.Configs[1].Materials.Beam.Main.Count = #ENT.Configs[1].Materials.Beam.Main
	
	ENT.Configs[1].Materials.Glow = {}
	
	for i = 1, 6 do
		ENT.Configs[1].Materials.Glow[i] = Material("LuaPineapple/FS2/anti_fighter_beam/anti_fighter_beam_glow_" .. i)
	end
	
	ENT.Configs[1].Materials.Glow.Count = #ENT.Configs[1].Materials.Glow
	
	ENT.Configs[1].DLight = {}
	ENT.Configs[1].DLight.Brightness = 1
	ENT.Configs[1].DLight.Size = 256
	ENT.Configs[1].DLight.Decay = ENT.Configs[1].DLight.Size * (.1 * ENT.Configs[1].EventData.OnFireEnd.ProgressionDelay)
	ENT.Configs[1].DLight.R = 0
	ENT.Configs[1].DLight.G = 0
	ENT.Configs[1].DLight.B = 255
end
--]]

ENT.Configs[2] = {} -- Green slasher beam
ENT.Configs[2].Damage       = 200
ENT.Configs[2].Cooldown     = 15
ENT.Configs[2].SlashCone    = 250
ENT.Configs[2].GlowSize     = 64
ENT.Configs[2].BeamWidth    = 32

ENT.Configs[2].EventData = {}

ENT.Configs[2].EventData.OnInitFire = {}
ENT.Configs[2].EventData.OnInitFire.Sound = Sound("LuaPineapple/SBMP/beam_cannon/BT_up_1_5.wav")
ENT.Configs[2].EventData.OnInitFire.ProgressionDelay = 3

ENT.Configs[2].EventData.OnFire = {}
ENT.Configs[2].EventData.OnFire.Sound = Sound("LuaPineapple/SBMP/beam_cannon/BT_LTerSlash.wav")
ENT.Configs[2].EventData.OnFire.ProgressionDelay = 2

ENT.Configs[2].EventData.OnFireLoop = {}
ENT.Configs[2].EventData.OnFireLoop.Sound = Sound("LuaPineapple/SBMP/beam_cannon/BT_LTerSlash.wav")
ENT.Configs[2].EventData.OnFireLoop.ProgressionDelay = 2

ENT.Configs[2].EventData.OnFireEnd = {}
ENT.Configs[2].EventData.OnFireEnd.Sound = Sound("LuaPineapple/SBMP/beam_cannon/BT_dwn_2.wav")
ENT.Configs[2].EventData.OnFireEnd.ProgressionDelay = 2

if CLIENT then
	ENT.Configs[2].Materials = {}
	
	ENT.Configs[2].Materials.Beam      = {}
	ENT.Configs[2].Materials.Beam.Beam = Material("LuaPineapple/FS2/beam_cannon/green_beam_cannon_beam")
	ENT.Configs[2].Materials.Beam.Core = Material("LuaPineapple/FS2/beam_cannon/green_beam_cannon_core")
	ENT.Configs[2].Materials.Beam.Glow = Material("LuaPineapple/FS2/beam_cannon/green_beam_cannon_glow")
	ENT.Configs[2].Materials.Beam.Haze = Material("LuaPineapple/FS2/beam_cannon/green_beam_cannon_haze")
	
	ENT.Configs[2].Materials.Glow = {}
	
	for i = 0, 5 do
		for j = 0, 9 do
			ENT.Configs[2].Materials.Glow[(i * 10) + j] = Material("LuaPineapple/FS2/looping/green/green_beam_cannon_loop_" .. i .. j .. "_00_00")
		end
	end
	
	ENT.Configs[2].Materials.Glow.Count = #ENT.Configs[2].Materials.Glow
	
	ENT.Configs[2].DLight = {}
	ENT.Configs[2].DLight.Brightness = 3.25
	ENT.Configs[2].DLight.Size = 512
	ENT.Configs[2].DLight.Decay = ENT.Configs[2].DLight.Size * (.1 * ENT.Configs[2].EventData.OnFireEnd.ProgressionDelay)
	ENT.Configs[2].DLight.R = 0
	ENT.Configs[2].DLight.G = 255
	ENT.Configs[2].DLight.B = 0
end


ENT.Configs[3] = {} -- Gold slasher beam
ENT.Configs[3].Damage       = 200
ENT.Configs[3].Cooldown     = 15
ENT.Configs[3].SlashCone    = 250
ENT.Configs[3].GlowSize     = 64
ENT.Configs[3].BeamWidth    = 32

ENT.Configs[3].EventData = {}

ENT.Configs[3].EventData.OnInitFire = {}
ENT.Configs[3].EventData.OnInitFire.Sound = Sound("LuaPineapple/SBMP/beam_cannon/BT_up_1_5.wav")
ENT.Configs[3].EventData.OnInitFire.ProgressionDelay = 3

ENT.Configs[3].EventData.OnFire = {}
ENT.Configs[3].EventData.OnFire.Sound = Sound("LuaPineapple/SBMP/beam_cannon/BT_TerSlash.wav")
ENT.Configs[3].EventData.OnFire.ProgressionDelay = 2

ENT.Configs[3].EventData.OnFireLoop = {}
ENT.Configs[3].EventData.OnFireLoop.Sound = Sound("LuaPineapple/SBMP/beam_cannon/BT_TerSlash.wav")
ENT.Configs[3].EventData.OnFireLoop.ProgressionDelay = 2

ENT.Configs[3].EventData.OnFireEnd = {}
ENT.Configs[3].EventData.OnFireEnd.Sound = Sound("LuaPineapple/SBMP/beam_cannon/BT_dwn_2.wav")
ENT.Configs[3].EventData.OnFireEnd.ProgressionDelay = 2

if CLIENT then
	ENT.Configs[3].Materials = {}
	
	ENT.Configs[3].Materials.Beam      = {}
	ENT.Configs[3].Materials.Beam.Beam = Material("LuaPineapple/FS2/beam_cannon/gold_beam_cannon_beam")
	ENT.Configs[3].Materials.Beam.Core = Material("LuaPineapple/FS2/beam_cannon/gold_beam_cannon_core")
	ENT.Configs[3].Materials.Beam.Glow = Material("LuaPineapple/FS2/beam_cannon/gold_beam_cannon_glow")
	ENT.Configs[3].Materials.Beam.Haze = Material("LuaPineapple/FS2/beam_cannon/gold_beam_cannon_haze")
	
	ENT.Configs[3].Materials.Glow = {}
	
	for i = 0, 5 do
		for j = 0, 9 do
			ENT.Configs[3].Materials.Glow[(i * 10) + j] = Material("LuaPineapple/FS2/looping/gold/gold_beam_cannon_loop_" .. i .. j .. "_00_00")
		end
	end
	
	ENT.Configs[3].Materials.Glow.Count = #ENT.Configs[3].Materials.Glow
	
	ENT.Configs[3].DLight = {}
	ENT.Configs[3].DLight.Brightness = 3.25
	ENT.Configs[3].DLight.Size = 512
	ENT.Configs[3].DLight.Decay = ENT.Configs[3].DLight.Size * (.1 * ENT.Configs[3].EventData.OnFireEnd.ProgressionDelay)
	ENT.Configs[3].DLight.R = 255
	ENT.Configs[3].DLight.G = 225
	ENT.Configs[3].DLight.B = 90
end


ENT.Configs[4] = {} -- Green beam cannon
ENT.Configs[4].Damage       = 500
ENT.Configs[4].Cooldown     = 25
ENT.Configs[4].SlashCone    = 100
ENT.Configs[4].GlowSize     = 128
ENT.Configs[4].BeamWidth    = 64

ENT.Configs[4].EventData = {}

ENT.Configs[4].EventData.OnInitFire = {}
ENT.Configs[4].EventData.OnInitFire.Sound = Sound("LuaPineapple/SBMP/beam_cannon/BT_up_5.wav")
ENT.Configs[4].EventData.OnInitFire.ProgressionDelay = 5

ENT.Configs[4].EventData.OnFire = {}
ENT.Configs[4].EventData.OnFire.Sound = Sound("LuaPineapple/SBMP/beam_cannon/BT_BGreen.wav")
ENT.Configs[4].EventData.OnFire.ProgressionDelay = 2

ENT.Configs[4].EventData.OnFireLoop = {}
ENT.Configs[4].EventData.OnFireLoop.Sound = Sound("LuaPineapple/SBMP/beam_cannon/BT_BGreen.wav")
ENT.Configs[4].EventData.OnFireLoop.ProgressionDelay = 2

ENT.Configs[4].EventData.OnFireEnd = {}
ENT.Configs[4].EventData.OnFireEnd.Sound = Sound("LuaPineapple/SBMP/beam_cannon/BT_dwn_1.wav")
ENT.Configs[4].EventData.OnFireEnd.ProgressionDelay = 3

if CLIENT then
	ENT.Configs[4].Materials = {}
	
	ENT.Configs[4].Materials.Beam      = {}
	ENT.Configs[4].Materials.Beam.Beam = Material("LuaPineapple/FS2/beam_cannon/green_beam_cannon_beam")
	ENT.Configs[4].Materials.Beam.Core = Material("LuaPineapple/FS2/beam_cannon/green_beam_cannon_core")
	ENT.Configs[4].Materials.Beam.Glow = Material("LuaPineapple/FS2/beam_cannon/green_beam_cannon_glow")
	ENT.Configs[4].Materials.Beam.Haze = Material("LuaPineapple/FS2/beam_cannon/green_beam_cannon_haze")
	
	ENT.Configs[4].Materials.Glow = {}
	
	for i = 0, 5 do
		for j = 0, 9 do
			ENT.Configs[4].Materials.Glow[(i * 10) + j] = Material("LuaPineapple/FS2/looping/green/green_beam_cannon_loop_" .. i .. j .. "_00_00")
		end
	end
	
	ENT.Configs[4].Materials.Glow.Count = #ENT.Configs[4].Materials.Glow
	
	ENT.Configs[4].DLight = {}
	ENT.Configs[4].DLight.Brightness = 4
	ENT.Configs[4].DLight.Size = 768
	ENT.Configs[4].DLight.Decay = ENT.Configs[4].DLight.Size * (.1 * ENT.Configs[4].EventData.OnFireEnd.ProgressionDelay)
	ENT.Configs[4].DLight.R = 0
	ENT.Configs[4].DLight.G = 255
	ENT.Configs[4].DLight.B = 0
end


ENT.Configs[5] = {} -- Gold beam cannon
ENT.Configs[5].Damage       = 500
ENT.Configs[5].Cooldown     = 25
ENT.Configs[5].SlashCone    = 100
ENT.Configs[5].GlowSize     = 128
ENT.Configs[5].BeamWidth    = 64

ENT.Configs[5].EventData = {}

ENT.Configs[5].EventData.OnInitFire = {}
ENT.Configs[5].EventData.OnInitFire.Sound = Sound("LuaPineapple/SBMP/beam_cannon/BT_up_5.wav")
ENT.Configs[5].EventData.OnInitFire.ProgressionDelay = 5

ENT.Configs[5].EventData.OnFire = {}
ENT.Configs[5].EventData.OnFire.Sound = Sound("LuaPineapple/SBMP/beam_cannon/BT_BFGreen.wav")
ENT.Configs[5].EventData.OnFire.ProgressionDelay = 2

ENT.Configs[5].EventData.OnFireLoop = {}
ENT.Configs[5].EventData.OnFireLoop.Sound = Sound("LuaPineapple/SBMP/beam_cannon/BT_BFGreen.wav")
ENT.Configs[5].EventData.OnFireLoop.ProgressionDelay = 2

ENT.Configs[5].EventData.OnFireEnd = {}
ENT.Configs[5].EventData.OnFireEnd.Sound = Sound("LuaPineapple/SBMP/beam_cannon/BT_dwn_1.wav")
ENT.Configs[5].EventData.OnFireEnd.ProgressionDelay = 3

if CLIENT then
	ENT.Configs[5].Materials = {}
	
	ENT.Configs[5].Materials.Beam      = {}
	ENT.Configs[5].Materials.Beam.Beam = Material("LuaPineapple/FS2/beam_cannon/gold_beam_cannon_beam")
	ENT.Configs[5].Materials.Beam.Core = Material("LuaPineapple/FS2/beam_cannon/gold_beam_cannon_core")
	ENT.Configs[5].Materials.Beam.Glow = Material("LuaPineapple/FS2/beam_cannon/gold_beam_cannon_glow")
	ENT.Configs[5].Materials.Beam.Haze = Material("LuaPineapple/FS2/beam_cannon/gold_beam_cannon_haze")
	
	ENT.Configs[5].Materials.Glow = {}
	
	for i = 0, 5 do
		for j = 0, 9 do
			ENT.Configs[5].Materials.Glow[(i * 10) + j] = Material("LuaPineapple/FS2/looping/gold/gold_beam_cannon_loop_" .. i .. j .. "_00_00")
		end
	end
	
	ENT.Configs[5].Materials.Glow.Count = #ENT.Configs[5].Materials.Glow
	
	ENT.Configs[5].DLight = {}
	ENT.Configs[5].DLight.Brightness = 4
	ENT.Configs[5].DLight.Size = 768
	ENT.Configs[5].DLight.Decay = ENT.Configs[5].DLight.Size * (.1 * ENT.Configs[5].EventData.OnFireEnd.ProgressionDelay)
	ENT.Configs[5].DLight.R = 255
	ENT.Configs[5].DLight.G = 225
	ENT.Configs[5].DLight.B = 90
end