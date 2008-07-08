if not CAF or not CAF.GetAddon("Resource Distribution") then return end
if not GAMEMODE.IsSpacebuildDerived then return end

TOOL.Category			= "SBMP"
TOOL.Name				= "#Habitable Modules"

TOOL.DeviceName			= "Habitable Module"
TOOL.DeviceNamePlural	= "Habitable Modules"
TOOL.ClassName			= "sbmp_hab_mods"

TOOL.DevSelect			= true
TOOL.CCVar_type			= "base_livable_module"
TOOL.CCVar_sub_type		= "test1"
TOOL.CCVar_model		= "models/Spacebuild/s1t1.mdl"

TOOL.Limited			= true
TOOL.LimitName			= "sbmp_hab_mods"
TOOL.Limit				= 30

RD2ToolSetup.SetLang("SBMP Habitable Modules","Create Habitable Modules attached to any surface.","Left-Click: Spawn a Device.  Reload: Repair Device.")


TOOL.ExtraCCVars = {

}

function TOOL.ExtraCCVarsCP( tool, panel )
end

function TOOL:GetExtraCCVars()
	local Extra_Data = {}
	return Extra_Data
end

local function spawn_hab_func(ent,type,sub_type,devinfo,Extra_Data,ent_extras) 
	CAF.GetAddon("Resource Distribution").AddResource(ent, "energy", 0)
	CAF.GetAddon("Resource Distribution").AddResource(ent, "nitrogen", 0)
	CAF.GetAddon("Resource Distribution").AddResource(ent, "water", 0)
	CAF.GetAddon("Resource Distribution").AddResource(ent, "carbon dioxide", 0)
	CAF.GetAddon("Resource Distribution").AddResource(ent, "oxygen", 0)
	local mass = 1000
	local phys = ent:GetPhysicsObject()
	if phys:IsValid() then
		mass = phys:GetMass()
	end
	local maxhealth = mass * 10
	return mass, maxhealth 
end

TOOL.Devices = {
	base_livable_module = {
		Name	= "Habitable Modules",
		type	= "base_livable_module",
		class	= "base_livable_module",
		func 	= spawn_hab_func,
		legacy = false,
		devices = {
			test1 = {
				Name	= "Style 1 Tube x1",
				model	= "models/Spacebuild/s1t1.mdl",
				skin	= 0,
			},
			test2 = {
				Name	= "Style 1 Tube 5 Way",
				model	= "models/Spacebuild/s1t15w.mdl",
				skin	= 0,
			},
		},
	},
}


	
	
	
