ENT.Type 		= "anim"
ENT.Base 		= "base_rd_entity"
ENT.PrintName 	= "LS Ship module"

list.Set( "LSEntOverlayText" , "base_livable_module", {HasOOO = true, num = 3, strings = {ENT.PrintName.." ","\nAir: ","\nCoolant: ","\nEnergy: "},resnames = {"air","coolant","energy"}} )
