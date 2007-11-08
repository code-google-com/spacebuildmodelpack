
TOOL.Category = '(Life Support)'
TOOL.Name = '#LS Ship REsource Modules'
TOOL.Command = nil
TOOL.ConfigName = ''
if (CLIENT and LocalPlayer():GetInfo("RD_UseLSTab") == "1") then TOOL.Tab = "Life Support" end

TOOL.ClientConVar['type'] = 'base_default_res_module'
TOOL.ClientConVar['model'] = 'models/props_wasteland/laundry_washer003.mdl'

cleanup.Register('ls_res_mod')

if ( CLIENT ) then
	language.Add( 'Tool_ls_res_mod_name', 'Life Support Resource modules' )
	language.Add( 'Tool_ls_res_mod_desc', 'Create Life Support Resource modules attached to any surface.' )
	language.Add( 'Tool_ls_res_mod_0', 'Left-Click: Spawn a Device.  Right-Click: Repair Device.' )

	language.Add( 'Undone_ls_res_mod', 'Resource Module Undone' )
	language.Add( 'Cleanup_ls_res_mod', 'LS: Resource Modules' )
	language.Add( 'Cleaned_ls_res_mod', 'Cleaned up all Life Support Resource Modules' )
	language.Add( 'SBoxLimit_ls_res_mod', 'Maximum Life Support Resource Modules Reached' )
end

if not ( RES_DISTRIB == 2 ) then Error("Please Install Resource Distribution 2 Addon.'" ) return end
include("autorun/config.lua")
local ls_res_mod = {}
if (SERVER) then
	ls_res_mod.base_default_res_module = function( ply, ent, system_type, system_class, model )
		local hash = {}
		hash.size = math.Round(ent:BoundingRadius()/32)
		local maxhealth = hash.size * 1000
		local mass = hash.size * 150
		RD_AddResource(ent, "energy", math.Round((hash.size/3) * 18000))
		RD_AddResource(ent, "coolant", math.Round((hash.size/3) * 16000))
		RD_AddResource(ent, "air", math.Round((hash.size/3) * 17000))
		LS_RegisterEnt(ent, "Resource Module")
		return hash, maxhealth, mass
	end
end

RD2_ToolRegister( TOOL, getLSResShipModels(), nil, "ls_res_mod", 30, ls_res_mod )
