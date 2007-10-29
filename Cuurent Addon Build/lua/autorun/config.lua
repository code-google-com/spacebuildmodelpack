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

//Put the models under here
AddLSShipHabModel("Tube part", "models/Spacebuild/s1t1.mdl")
AddLSShipHabModel("Tube part", "models/Spacebuild/s1t1s.mdl")
AddLSShipHabModel("Tube part", "models/Spacebuild/s1t1t.mdl")
AddLSShipHabModel("Tube part", "models/Spacebuild/s1t1x.mdl")
AddLSShipHabModel("Tube part", "models/Spacebuild/s1t15w.mdl")
AddLSShipHabModel("Tube part", "models/Spacebuild/s1t16w.mdl")
AddLSShipHabModel("Tube part", "models/Spacebuild/s1t190.mdl")
AddLSShipHabModel("Tube part", "models/Spacebuild/s1t190b.mdl")
AddLSShipHabModel("Tube part", "models/Spacebuild/s2t1s.mdl")
AddLSShipHabModel("Tube part", "models/Spacebuild/s2t1.mdl")
AddLSShipHabModel("Tube part", "models/Spacebuild/s3t1s.mdl")
AddLSShipHabModel("Tube part", "models/Spacebuild/s3t1.mdl")
AddLSShipHabModel("Tube part", "models/Spacebuild/stube1.mdl")
AddLSShipHabModel("Tube part", "models/Spacebuild/s1t1s.mdl")



