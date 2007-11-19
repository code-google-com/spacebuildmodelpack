
TOOL.Category = 'Spacebuild Tools'
TOOL.Name = '#LS Ship Modules'
TOOL.Command = nil
TOOL.ConfigName = ''
if (CLIENT and LocalPlayer():GetInfo("RD_UseLSTab") == "1") then TOOL.Tab = "Life Support" end

TOOL.ClientConVar['type'] = 'base_livable_module'
TOOL.ClientConVar['model'] = 'models/props_wasteland/laundry_washer003.mdl'

cleanup.Register('ls_liv_mod')

if ( CLIENT ) then
	language.Add( 'Tool_ls_liv_mod_name', 'Life Support modules' )
	language.Add( 'Tool_ls_liv_mod_desc', 'Create Life Support modules attached to any surface.' )
	language.Add( 'Tool_ls_liv_mod_0', 'Left-Click: Spawn a Device.  Right-Click: Repair Device.' )

	language.Add( 'Undone_ls_liv_mod', 'Module Undone' )
	language.Add( 'Cleanup_ls_liv_mod', 'LS: Modules' )
	language.Add( 'Cleaned_ls_liv_mod', 'Cleaned up all Life Support Modules' )
	language.Add( 'SBoxLimit_ls_liv_mod', 'Maximum Life Support Modules Reached' )
end

if not ( RES_DISTRIB == 2 ) then Error("Please Install Resource Distribution 2 Addon.'" ) return end
if not GAMEMODE.IsSpaceBuildDerived then return end
include("autorun/config.lua")
local ls_liv_mod = {}
if (SERVER) then
	ls_liv_mod.base_livable_module = function( ply, ent, system_type, system_class, model )
		local maxhealth = 600 //make it based on the ent
		local mass = 1000 //make it get the ents mass
		RD_AddResource(ent, "energy", 0)
		RD_AddResource(ent, "coolant", 0)
		RD_AddResource(ent, "air", 0)
		LS_RegisterEnt(ent, "Module")
		return {}, maxhealth, mass
	end
end

RD2_ToolRegister( TOOL, getLSShipModels(), nil, "ls_liv_mod", 30, ls_liv_mod )
