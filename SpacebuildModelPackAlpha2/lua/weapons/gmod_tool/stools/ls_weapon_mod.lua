
TOOL.Category = 'Spacebuild Tools'
TOOL.Name = '#LS Ship Weapon Modules'
TOOL.Command = nil
TOOL.ConfigName = ''
if (CLIENT and GetConVarNumber("RD_UseLSTab") == 1) then TOOL.Tab = "Life Support" end

TOOL.ClientConVar['type'] = 'base_default_weapon_module'
TOOL.ClientConVar['model'] = 'models/props_wasteland/laundry_washer003.mdl'

cleanup.Register('ls_weapon_mod')

if ( CLIENT ) then
	language.Add( 'Tool_ls_weapon_mod_name', 'Life Support Resource modules' )
	language.Add( 'Tool_ls_weapon_mod_desc', 'Create Life Support Resource modules attached to any surface.' )
	language.Add( 'Tool_ls_weapon_mod_0', 'Left-Click: Spawn a Device.  Right-Click: Repair Device.' )

	language.Add( 'Undone_ls_weapon_mod', 'Resource Module Undone' )
	language.Add( 'Cleanup_ls_weapon_mod', 'LS: Resource Modules' )
	language.Add( 'Cleaned_ls_weapon_mod', 'Cleaned up all Life Support Resource Modules' )
	language.Add( 'SBoxLimit_ls_weapon_mod', 'Maximum Life Support Resource Modules Reached' )
end

if not ( RES_DISTRIB == 2 ) then Error("Please Install Resource Distribution 2 Addon.'" ) return end
include("autorun/config.lua")
local ls_weapon_mod = {}
if (SERVER) then
	ls_weapon_mod.base_weapons_module = function( ply, ent, system_type, system_class, model)
		local hash = {}
		hash.size = math.Round(ent:BoundingRadius()/32)
		local maxhealth = hash.size * 1000
		local mass = hash.size * 150
		if ply.extra then
			Msg(tonumber(ply.extra['test']).."||"..tonumber(ply.extra['test2']))
			ply.extra = nil
		end
		RD_AddResource(ent, "energy", math.Round((hash.size/3) * 18000))
		RD_AddResource(ent, "coolant", math.Round((hash.size/3) * 16000))
		RD_AddResource(ent, "air", math.Round((hash.size/3) * 17000))
		LS_RegisterEnt(ent, "Resource Module")
		return hash, maxhealth, mass
	end

	ls_weapon_mod.test = function( ply, ent, system_type, system_class, model)
		local hash = {}
		local maxhealth = 100
		local mass = 100
		return hash, maxhealth, mass
	end
end

local tab = {}
tab['test'] = {}
tab['test']['type'] = "slider"
tab['test']['min'] = 10
tab['test']['max'] = 100
tab['test2'] = {}
tab['test2']['type'] = "checkbox"

RD2_ToolRegister( TOOL, getLSWeaponShipModels(), nil, "ls_weapon_mod", 30, ls_weapon_mod, tab )
