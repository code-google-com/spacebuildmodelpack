if(SERVER) then AddCSLuaFile("autorun/config.lua") end

local version = "SVN(1.5b)"

local function registerPF()
	if SERVER then
		if SVX_PF then
			function SBMP_isActive()
				return true
			end
			PF_RegisterPlugin("Spacebuild Model Pack", version, SBMP_isActive, nil, nil, "Addon")
		end
	end
end
timer.Simple(5, registerPF)--Needed to make sure the Plugin Framework gets loaded first

local models = {}
local resmodels = {}
local weaponmodels = {}

function getLSShipModels()
	return models
end

function getLSResShipModels()
	return resmodels
end

function getLSWeaponShipModels()
	return weaponmodels
end

function AddLSShipHabModel(modelname, path)
	if not modelname or not path then return end
	table.insert(models, {modelname, path, 'base_livable_module'})
	//models[modelname] = path
end

function AddLSShipDefResModel(modelname, path) //The Default resource module (contains air, coolant, energy based on the size)
	if not modelname or not path then return end
	table.insert(resmodels, {modelname, path, 'base_default_res_module'})
	//resmodels[modelname] = path
end

function AddLSShipWeaponModel(modelname, path)
	if not modelname or not path then return end
	table.insert(weaponmodels, {modelname, path, 'base_weapons_module'})
	//weaponmodels[modelname] = path
end

function AddLSAirLockModel(modelname, path)
	if not modelname or not path then return end
	table.insert(weaponmodels, {modelname, path, 'airlock'})
	//weaponmodels[modelname] = path
end

table.insert(weaponmodels, {"Railgun","models/spacebuild/plasgun.mdl", "railgun"})
table.insert(weaponmodels, {"Bomb Test","models/weapons/w_bugbait.mdl", "explosion_test"})

//testairlocks
AddLSAirLockModel("Test1", "models/spacebuild/TestE.mdl")
AddLSAirLockModel("Test2", "models/spacebuild/Test2E.mdl")
AddLSAirLockModel("Test3", "models/spacebuild/Test3E.mdl")

//Put the models under here
AddLSShipHabModel("Style 1 Tube x1", "models/Spacebuild/s1t1.mdl")
AddLSShipHabModel("Style 1 Tube 5 Way", "models/Spacebuild/s1t15w.mdl")
AddLSShipHabModel("Style 1 Tube 6 Way", "models/Spacebuild/s1t16w.mdl")
AddLSShipHabModel("Style 1 Tube 90 Turn", "models/Spacebuild/s1t190.mdl")
AddLSShipHabModel("Style 1 Tube 90 Other Turn", "models/Spacebuild/s1t190b.mdl")
AddLSShipHabModel("Style 1 Tube 3 Way", "models/Spacebuild/s1t1t.mdl")
AddLSShipHabModel("Style 1 Tube 4 Way", "models/Spacebuild/s1t1x.mdl")
AddLSShipHabModel("Style 1 Tube to Standard", "models/Spacebuild/s1t1s.mdl")
AddLSShipHabModel("Style 2 Tube x1", "models/Spacebuild/s2t1.mdl")
AddLSShipHabModel("Style 2 Tube 3 way", "models/Spacebuild/s2t1t.mdl")
AddLSShipHabModel("Style 2 Tube 4 way", "models/Spacebuild/s2t1x.mdl")
AddLSShipHabModel("Style 2 Tube to standard", "models/Spacebuild/s2t1s.mdl")
AddLSShipHabModel("Style 3 Tube 1x", "models/Spacebuild/s3t1.mdl")
AddLSShipHabModel("Style 3 Tube 90 turn", "models/Spacebuild/s3t190.mdl")
AddLSShipHabModel("Style 3 Tube 4 way", "models/Spacebuild/s3t1x.mdl")
AddLSShipHabModel("Style 3 Tube to standard", "models/Spacebuild/s3t1s.mdl")
AddLSShipHabModel("Standard Tube 4-way, Doublewide","models/Spacebuild/ST4WDW.mdl")
AddLSShipHabModel("Standard Tube 5-way, Doublesize","models/Spacebuild/ST5wDS.mdl")
AddLSShipHabModel("Standard Tube 6-way, Doublesize","models/Spacebuild/ST6wDS.mdl")
AddLSShipHabModel("Standard Tube 6-way, Doublewide","models/Spacebuild/ST6wDW.mdl")
AddLSShipHabModel("Standard Tube 2, Doublewide","models/Spacebuild/st2dw.mdl")
AddLSShipHabModel("Standard Tube 2, Standard to Doublesize","models/Spacebuild/ST2StDS.mdl")
AddLSShipHabModel("Standard Tube 2, Standard to Doublewide","models/Spacebuild/ST2StDW.mdl")
AddLSShipHabModel("Standard Tube 90-degree, Doublewide","models/Spacebuild/ST90DW.mdl")
AddLSShipHabModel("Standard Tube, Standard to Doublelong","models/Spacebuild/STDL.mdl")
AddLSShipHabModel("Standard Tube, Doublelong and doublewide","models/Spacebuild/stdldw.mdl")
AddLSShipHabModel("Standard Tube 90-degree Doublesize","models/Spacebuild/stds90.mdl")
AddLSShipHabModel("Standard Tube Doublesized","models/Spacebuild/STDS.mdl")
AddLSShipHabModel("Standard to Doublewide","models/Spacebuild/stdw.mdl")
AddLSShipHabModel("Standard to Quadlength","models/Spacebuild/stql.mdl")
AddLSShipHabModel("Standard to Quadlength Doublewide","models/Spacebuild/stqldw.mdl")
AddLSShipHabModel("Standard Tube to Doublesize","models/Spacebuild/sttds.mdl")
AddLSShipHabModel("Standard Tube to Doublewide","models/Spacebuild/sttdw.mdl")
AddLSShipHabModel("Standard X Doublesized","models/Spacebuild/stxds.mdl")
AddLSShipHabModel("Standard X Doublewide","models/Spacebuild/stxdw.mdl")
AddLSShipHabModel("Standard Tube", "models/Spacebuild/stube1.mdl")
AddLSShipHabModel("Cargobay", "models/Spacebuild/cbay1.mdl")
AddLSShipHabModel("Medium Bridge 2, Empty","models/Spacebuild/medbridge2_emptyhull.mdl")
AddLSShipHabModel("Medium Bridge 2, Empty 90 degree","models/Spacebuild/medbridge2_emptyhull_90.mdl")
AddLSShipHabModel("Medium Bridge 2, Empty T-Junction","models/Spacebuild/medbridge2_emptyhull_t.mdl")
AddLSShipHabModel("Medium Bridge 2, Empty X-Junction","models/Spacebuild/medbridge2_emptyhull_x.mdl")
AddLSShipHabModel("Medium Bridge 2, Engine 1","models/Spacebuild/medbridge2_enginehull.mdl")
AddLSShipHabModel("Medium Bridge 2, Engine 2","models/Spacebuild/medbridge2_enginehull2.mdl")
AddLSShipHabModel("Medium Bridge 2, Fighterbay 1","models/Spacebuild/medbridge2_fighterbay.mdl")
AddLSShipHabModel("Medium Bridge 2, Fighterbay 2","models/Spacebuild/medbridge2_fighterbay2.mdl")
AddLSShipHabModel("Medium Bridge 2, Fighterbay 2: glassless","models/Spacebuild/medbridge2_fighterbay2_noglass.mdl")
AddLSShipHabModel("Medium Bridge 2, Fighterbay 3","models/Spacebuild/medbridge2_fighterbay3.mdl")
AddLSShipHabModel("Medium Bridge 2, Fighterbay 3 Revision A","models/Spacebuild/medbridge2_fighterbay3a.mdl")
AddLSShipHabModel("Medium Bridge 2, Fighterbay 3 Transfer Cap","models/Spacebuild/medbridge2_FighterBay3TransCap.mdl")
AddLSShipHabModel("Medium Bridge 2, Two Level","models/Spacebuild/medbridge2_twolevel.mdl")
AddLSShipHabModel("Medium Bridge 2, Wide Transfer","models/Spacebuild/medbridge2_widey.mdl")
AddLSShipHabModel("Medium Bridge 2, Bridge","models/Spacebuild/medbridge2.mdl")
AddLSShipHabModel("Medium Bridge 2, Double, Empty","models/Spacebuild/medbridge2_emptydoublehull.mdl")
AddLSShipHabModel("Medium Bridge 2, Double, Ramps","models/Spacebuild/medbridge2_emptydoublehull_decktodeckramp.mdl")
AddLSShipHabModel("Medium Bridge 2, Mid sec. Bridge","models/Spacebuild/medbridge2_midsectionbridge.mdl")
AddLSShipHabModel("Medium Bridge 2, Single to double","models/Spacebuild/medbridge2_singletodoublehull.mdl")

AddLSShipHabModel("SmallBridge, Empty 1","models/SmallBridge/SBcorridorE1/sbcorridore1.mdl")
AddLSShipHabModel("SmallBridge, Empty 2","models/SmallBridge/SBcorridorE2/sbcorridore2.mdl")
AddLSShipHabModel("SmallBridge, Empty 3","models/SmallBridge/SBcorridorE3/sbcorridore3.mdl")
AddLSShipHabModel("SmallBridge, Empty 4","models/SmallBridge/SBcorridorE4/sbcorridore4.mdl")
AddLSShipHabModel("SmallBridge, R-Junction","models/SmallBridge/SBcorridorR/sbcorridorr.mdl")
AddLSShipHabModel("SmallBridge, T-Junction","models/SmallBridge/SBcorridorT/sbcorridort.mdl")
AddLSShipHabModel("SmallBridge, X-Junction","models/SmallBridge/SBcorridorX/sbcorridorx.mdl")
AddLSShipHabModel("SmallBridge, Empty Doublewidth","models/SmallBridge/SBcorridorEdw/sbcorridoredw.mdl")
AddLSShipHabModel("SmallBridge, Empty Doublewidth 2","models/SmallBridge/SBcorridorEdw2/sbcorridoredw2.mdl")
AddLSShipHabModel("SmallBridge, Empty End","models/SmallBridge/SBcorridorEnd/sbcorridorend.mdl")
AddLSShipHabModel("SmallBridge, Empty Curve Small","models/SmallBridge/SBcorridorCurveS/sbcorridorcurves.mdl")
AddLSShipHabModel("SmallBridge, NAME","models/SmallBridge/SBcorridorFlip/sbcorridorflip.mdl")
AddLSShipHabModel("SmallBridge, Single to Double Width","models/SmallBridge/SBcorridorEStoDW/sbcorridorestodw.mdl")
AddLSShipHabModel("SmallBridge, Double to 2 Single Width","models/SmallBridge/SBcorridorEDto2SW/sbcorridoredto2sw.mdl")
AddLSShipHabModel("SmallBridge, V-Junction","models/SmallBridge/SBcorridorV/sbcorridorv.mdl")
AddLSShipHabModel("SmallBridge, Cockpit","models/SmallBridge/SBbridge1/sbbridge1.mdl")
AddLSShipHabModel("SmallBridge, Empty Hull (doors)","models/SmallBridge/SBcorridorEdoors/sbcorridoredoors.mdl")
AddLSShipHabModel("SmallBridge, Engine 1","models/SmallBridge/SBengine1/sbengine1.mdl")
AddLSShipHabModel("SmallBridge, Doublewidth Engine 1","models/SmallBridge/SBenginedw1/sbenginedw1.mdl")
AddLSShipHabModel("SmallBridge, Engine SW Left","models/SmallBridge/SBenginesw1L/sbenginesw1L.mdl")
AddLSShipHabModel("SmallBridge, Engine SW Middle","models/SmallBridge/SBenginesw1M/sbenginesw1M.mdl")
AddLSShipHabModel("SmallBridge, Engine SW Right","models/SmallBridge/SBenginesw1R/sbenginesw1R.mdl")



AddLSShipHabModel("PuddleJumper B","models/puddle/pjbr.mdl")
AddLSShipHabModel("PuddleJumper C","models/puddle/pjd.mdl")
AddLSShipHabModel("PuddleJumper Wide","models/puddle/pjw.mdl")
AddLSShipHabModel("PuddleJumper Doublewide","models/puddle/pjdw.mdl")
AddLSShipHabModel("Bay A","models/Spacebuild/probay.mdl")

AddLSShipDefResModel("test", "models/props_lab/powerbox01a.mdl")
AddLSShipDefResModel("Cargobay", "models/Spacebuild/cbay1.mdl")
AddLSShipDefResModel("CargoCrate", "models/Spacebuild/cargo1.mdl")
AddLSShipDefResModel("tiney Cache", "models/Spacebuild/resourcecachetiny.mdl")
AddLSShipDefResModel("small cache", "models/Spacebuild/resourcecachesmall.mdl")
AddLSShipDefResModel("medium cache", "models/Spacebuild/resourcecachemedium.mdl")
AddLSShipDefResModel("large cache", "models/Spacebuild/resourcecachelarge.mdl")
AddLSShipDefResModel("huge cache", "models/Spacebuild/resourcecachehuge.mdl")
AddLSShipDefResModel("massive Cache", "models/Spacebuild/resourcecachemassive.mdl")
AddLSShipDefResModel("Modular Unit X-01", "models/Spacebuild/milcock4_multipod1.mdl")

AddLSShipWeaponModel("Plasma Cannon", "models/spacebuild/plasgun.mdl")