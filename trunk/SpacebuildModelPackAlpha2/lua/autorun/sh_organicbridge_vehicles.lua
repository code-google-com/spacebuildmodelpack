AddCSLuaFile( "sbmp_vehicles.lua" )
			  
local Category = "OrganicBridge"

local function HandleSBMPVehicleAnimation( vehicle, player )
	return player:SelectWeightedSequence( ACT_DRIVE_AIRBOAT ) 
end

local function HandleSBMPSitAnimation( vehicle, player )
	return player:SelectWeightedSequence( ACT_HL2MP_SIT ) 
end

local V = { 	
				Name = "Egg Pod", 
				Class = "prop_vehicle_prisoner_pod",
				Category = Category,

				Author = "Cerebrate",
				Information = "Egg Pod vehicle",
				Model = "models/organicbridge/egg_pod.mdl",
				KeyValues = {
								vehiclescript	=	"scripts/vehicles/prisoner_pod.txt",
								limitview		=	"0"
							},
				Members = {
								HandleAnimation = HandleSBMPSitAnimation,
							}
}
list.Set( "Vehicles", "egg_pod", V )