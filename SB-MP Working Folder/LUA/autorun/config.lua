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
AddLSShipHabModel("Tube part", "models/Spacebuild/tube.mdl")




