return
if not ( RES_DISTRIB == 2 ) then Error("Please Install Resource Distribution 2 Addon.'" ) return end

TOOL.Category = 'Spacebuild Tools'
TOOL.Name = '#LS Ship REsource Modules'
TOOL.Command = nil
TOOL.ConfigName = ''
if (CLIENT and GetConVarNumber("RD_UseLSTab") == 1) then TOOL.Tab = "Life Support" end

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

local ls_res_mod = {}
if (SERVER) then
	ls_res_mod.base_default_res_module = function( ply, ent, system_type, system_class, model )
		local hash = {}
		local angles = ent:GetAngles()
		ent:SetAngles(Vector(0, 0, 0))
		local min, max = ent:WorldSpaceAABB()
		local size = max-min
		local square = (max.x - min.x) * (max.y - min.y)
		local volume = square * (max.z - min.z);
		ent:SetAngles(angles)
		Msg("Volume: "..tostring(volume).."\n")
		hash.size = volume/7.59; //math.Round(ent:BoundingRadius()/32)
		local maxhealth = math.Round(hash.size/6)
		local mass = math.Round(hash.size/40)
		RD_AddResource(ent, "energy", math.Round(hash.size))
		RD_AddResource(ent, "coolant", math.Round(hash.size))
		RD_AddResource(ent, "air", math.Round(hash.size))
		hash.size = math.Round(hash.size)
		LS_RegisterEnt(ent, "Resource Module")
		return hash, maxhealth, mass
	end
end

RD2_ToolRegister( TOOL, getLSResShipModels(), nil, "ls_res_mod", 30, ls_res_mod )
