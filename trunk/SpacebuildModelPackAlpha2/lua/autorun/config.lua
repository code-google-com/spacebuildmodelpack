SecureActive = true //change this to false to disable the stool!

if(SERVER) then AddCSLuaFile("autorun/config.lua") end
local models = {}

function getLSShipModels()
	return models
end

function AddLSShipHabModel(modelname, path)
	if not modelname or not path then return end
	table.insert(models, {modelname, path, 'base_livable_module'})
	models[modelname] = path
end

function AddLSShipDefResModel(modelname, path) //The Default resource module (contains air, coolant, energy based on the size)
	if not modelname or not path then return end
	table.insert(models, {modelname, path, 'base_default_res_module'})
	models[modelname] = path
end

//Put the models under here
AddLSShipHabModel("Style 1 Tube x1", "models//Spacebuild/s1t1.mdl")
AddLSShipHabModel("Style 1 Tube 5 Way", "models//Spacebuild/s1t15w.mdl")
AddLSShipHabModel("Style 1 Tube 6 Way", "models//Spacebuild/s1t16w.mdl")
AddLSShipHabModel("Style 1 Tube 90 Turn", "models//Spacebuild/s1t190.mdl")
AddLSShipHabModel("Style 1 Tube 90 Other Turn", "models//Spacebuild/s1t190b.mdl")
AddLSShipHabModel("Style 1 Tube 3 Way", "models//Spacebuild/s1t1t.mdl")
AddLSShipHabModel("Style 1 Tube 4 Way", "models//Spacebuild/s1t1x.mdl")
AddLSShipHabModel("Style 1 Tube to Standard", "models//Spacebuild/s1t1s.mdl")
AddLSShipHabModel("Style 2 Tube x1", "models//Spacebuild/s2t1.mdl")
AddLSShipHabModel("Style 2 Tube 3 way", "models//Spacebuild/s2t1t.mdl")
AddLSShipHabModel("Style 2 Tube 4 way", "models//Spacebuild/s2t1x.mdl")
AddLSShipHabModel("Style 2 Tube to standard", "models//Spacebuild/s2t1s.mdl")
AddLSShipHabModel("Style 3 Tube 1x", "models//Spacebuild/s3t1.mdl")
AddLSShipHabModel("Style 3 Tube 90 turn", "models//Spacebuild/s3t190.mdl")
AddLSShipHabModel("Style 3 Tube 4 way", "models//Spacebuild/s3t1x.mdl")
AddLSShipHabModel("Style 3 Tube to standard", "models//Spacebuild/s3t1s.mdl")
AddLSShipHabModel("Standard Tube", "models//Spacebuild/stube1.mdl")
AddLSShipDefResModel("test", "models/props_lab/powerbox01a.mdl")
AddLSShipDefResModel("Cargobay", "models//Spacebuild/cbay1.mdl")
AddLSShipDefResModel("CargoCrate", "models//Spacebuild/cargo1.mdl")
