AddCSLuaFile( "sbmp_vehicles.lua" )

local Category = "Space Build Model Pack"

local function HandleSBMPVehicleAnimation( vehicle, player )
	return player:SelectWeightedSequence( ACT_DRIVE_AIRBOAT ) 
end

local function HandleSBMPSitAnimation( vehicle, player )
	return player:SelectWeightedSequence( ACT_HL2MP_SIT ) 
end

local V = { 	
				Name = "Captains Chair", 
				Class = "prop_vehicle_prisoner_pod",
				Category = Category,

				Author = "SpaceBuild Model Pack",
				Information = "Captain's Chair",
				Model = "models/Spacebuild/chair.mdl",
				KeyValues = {
								vehiclescript	=	"scripts/vehicles/prisoner_pod.txt",
								limitview		=	"0"
							},
				Members = {
								HandleAnimation = HandleSBMPSitAnimation,
							}
}
list.Set( "Vehicles", "sbmp_chair", V )

local V = { 	
				Name = "Fighter Chair", 
				Class = "prop_vehicle_prisoner_pod",
				Category = Category,

				Author = "SpaceBuild Model Pack",
				Information = "Chair for Fighter Planes",
				Model = "models/Spacebuild/chair2.mdl",
				KeyValues = {
								vehiclescript	=	"scripts/vehicles/prisoner_pod.txt",
								limitview		=	"0"
							},
				Members = {
								HandleAnimation = HandleSBMPSitAnimation,
							}
}
list.Set( "Vehicles", "sbmp_chair2", V )

local V = { 	
				Name = "Military CockPit", 
				Class = "prop_vehicle_prisoner_pod",
				Category = Category,

				Author = "SpaceBuild Model Pack",
				Information = "Military CockPit Style 1",
				Model = "models/Spacebuild/milcock.mdl",
				KeyValues = {
								vehiclescript	=	"scripts/vehicles/prisoner_pod.txt",
								limitview		=	"0"
							},
				Members = {
								HandleAnimation = HandleSBMPVehicleAnimation,
							}
}
list.Set( "Vehicles", "sbmp_milcock", V )

local V = { 	
				Name = "Military CockPit 2", 
				Class = "prop_vehicle_prisoner_pod",
				Category = Category,

				Author = "SpaceBuild Model Pack",
				Information = "Military CockPit Style 2",
				Model = "models/Spacebuild/milcock2.mdl",
				KeyValues = {
								vehiclescript	=	"scripts/vehicles/prisoner_pod.txt",
								limitview		=	"0"
							},
				Members = {
								HandleAnimation = HandleSBMPVehicleAnimation,
							}
}
list.Set( "Vehicles", "sbmp_mcocktwo", V )

local V = { 	
				Name = "Military CockPit 3", 
				Class = "prop_vehicle_prisoner_pod",
				Category = Category,

				Author = "SpaceBuild Model Pack",
				Information = "Military CockPit Style 3",
				Model = "models/Spacebuild/milcock3.mdl",
				KeyValues = {
								vehiclescript	=	"scripts/vehicles/prisoner_pod.txt",
								limitview		=	"0"
							},
				Members = {
								HandleAnimation = HandleSBMPVehicleAnimation,
							}
}
list.Set( "Vehicles", "sbmp_mcockthree", V )

local V = { 	
				Name = "Military CockPit 3B", 
				Class = "prop_vehicle_prisoner_pod",
				Category = Category,

				Author = "SpaceBuild Model Pack",
				Information = "Military CockPit Style 3B",
				Model = "models/Spacebuild/milcock3a.mdl",
				KeyValues = {
								vehiclescript	=	"scripts/vehicles/prisoner_pod.txt",
								limitview		=	"0"
							},
				Members = {
								HandleAnimation = HandleSBMPVehicleAnimation,
							}
}
list.Set( "Vehicles", "sbmp_mcockthreeb", V )

local V = { 	
				Name = "Military CockPit 4", 
				Class = "prop_vehicle_prisoner_pod",
				Category = Category,

				Author = "SpaceBuild Model Pack",
				Information = "Military CockPit Style 4",
				Model = "models/Spacebuild/milcock4a.mdl",
				KeyValues = {
								vehiclescript	=	"scripts/vehicles/prisoner_pod.txt",

								limitview		=	"0"
							},
				Members = {
								HandleAnimation = HandleSBMPVehicleAnimation,
							}
}
list.Set( "Vehicles", "sbmp_mcockfourb", V )

local V = { 	
				Name = "Military CockPit 4B", 
				Class = "prop_vehicle_prisoner_pod",
				Category = Category,

				Author = "SpaceBuild Model Pack",
				Information = "Military CockPit Style 4B",
				Model = "models/Spacebuild/milcock4b.mdl",
				KeyValues = {
								vehiclescript	=	"scripts/vehicles/prisoner_pod.txt",
								limitview		=	"0"
							},
				Members = {
								HandleAnimation = HandleSBMPVehicleAnimation,
							}
}
list.Set( "Vehicles", "sbmp_mcockfoura", V )

local V = { 	
				Name = "Military CockPit 5", 
				Class = "prop_vehicle_prisoner_pod",
				Category = Category,

				Author = "SpaceBuild Model Pack",
				Information = "Military CockPit Style 5",
				Model = "models/Spacebuild/milcock5a.mdl",
				KeyValues = {
								vehiclescript	=	"scripts/vehicles/prisoner_pod.txt",
								limitview		=	"0"
							},
				Members = {
								HandleAnimation = HandleSBMPVehicleAnimation,
							}
}
list.Set( "Vehicles", "sbmp_mcockfive", V )

local V = { 	
				Name = "Military CockPit 6", 
				Class = "prop_vehicle_prisoner_pod",
				Category = Category,

				Author = "SpaceBuild Model Pack",
				Information = "Military CockPit Style 6",
				Model = "models/Spacebuild/milcock6a.mdl",
				KeyValues = {
								vehiclescript	=	"scripts/vehicles/prisoner_pod.txt",
								limitview		=	"0"
							},
				Members = {
								HandleAnimation = HandleSBMPVehicleAnimation,
							}
}
list.Set( "Vehicles", "sbmp_mcocksix", V )

local V = { 	
				Name = "Closed Pod", 
				Class = "prop_vehicle_prisoner_pod",
				Category = Category,

				Author = "SpaceBuild Model Pack",
				Information = "Closed Escape Pod",
				Model = "models/Spacebuild/neopod.mdl",
				KeyValues = {
								vehiclescript	=	"scripts/vehicles/prisoner_pod.txt",
								limitview		=	"0"
							}
}
list.Set( "Vehicles", "sbmp_pod", V )

local V = { 	
				Name = "Open Pod", 
				Class = "prop_vehicle_prisoner_pod",
				Category = Category,

				Author = "SpaceBuild Model Pack",
				Information = "Open Escape Pod",
				Model = "models/Spacebuild/neopodt.mdl",
				KeyValues = {
								vehiclescript	=	"scripts/vehicles/prisoner_pod.txt",
								limitview		=	"0"
							}
}
list.Set( "Vehicles", "sbmp_podt", V )

local V = { 	
				Name = "Ball Pod", 
				Class = "prop_vehicle_prisoner_pod",
				Category = Category,

				Author = "SpaceBuild Model Pack",
				Information = "Ball Shaped Pod",
				Model = "models/Spacebuild/strange.mdl",
				KeyValues = {
								vehiclescript	=	"scripts/vehicles/prisoner_pod.txt",
								limitview		=	"0"
							},
				Members = {
								HandleAnimation = HandleSBMPSitAnimation,
							}
}
list.Set( "Vehicles", "sbmp_stpod", V )

local V = { 	
				Name = "Light Combat Corvette", 
				Class = "prop_vehicle_prisoner_pod",
				Category = Category,

				Author = "SpaceBuild Model Pack",
				Information = "Light Combat Corvette Pre-Made Ship",
				Model = "models/Spacebuild/Light_Combat_Corvette.mdl",
				KeyValues = {
								vehiclescript	=	"scripts/vehicles/prisoner_pod.txt",
								limitview		=	"0"
							},
				Members = {
								HandleAnimation = HandleSBMPVehicleAnimation,
							}
}
list.Set( "Vehicles", "sbmp_lcomcorv", V )

local V = { 	
				Name = "Mil_Cock_7", 
				Class = "prop_vehicle_prisoner_pod",
				Category = Category,

				Author = "SpaceBuild Model Pack",
				Information = "Military Cockpit 7",
				Model = "models/Spacebuild/Mil_Cock_7.mdl",
				KeyValues = {
								vehiclescript	=	"scripts/vehicles/prisoner_pod.txt",
								limitview		=	"0"
							},
				Members = {
								HandleAnimation = HandleSBMPVehicleAnimation,
							}
}
list.Set( "Vehicles", "sbmp_milcock7", V )

local V = { 	
				Name = "Mil_Cock_8", 
				Class = "prop_vehicle_prisoner_pod",
				Category = Category,

				Author = "SpaceBuild Model Pack",
				Information = "Military Cockpit 8",
				Model = "models/Spacebuild/MilCock8.mdl",
				KeyValues = {
								vehiclescript	=	"scripts/vehicles/prisoner_pod.txt",
								limitview		=	"0"
							},
				Members = {
								HandleAnimation = HandleSBMPVehicleAnimation,
							}
}
list.Set( "Vehicles", "sbmp_milcock8", V )

