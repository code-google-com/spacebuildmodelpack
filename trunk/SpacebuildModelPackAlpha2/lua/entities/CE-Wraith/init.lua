AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()
	
	self.Entity:SetModel( "models/Spacebuild/medbridge2_doublehull_elevatorclamp.mdl" ) 
	self.Entity:SetName("Wraith")
	self.BaseClass:Initialize(self)

	self.Speed = 0
	self.TSpeed = 90
	self.Active = false
	--self.Skewed = true
	self.HSpeed = 0
	
	self.HPC			= 9
	self.HP				= {}
	self.HP[1]			= {}
	self.HP[1]["Ent"]	= nil
	self.HP[1]["Type"]	= { "Small", "Large", "Medium", "GatLeft" }
	self.HP[1]["Pos"]	= Vector(-20,-260,70)
	self.HP[1]["Angle"] = Angle(0,0,0)
	self.HP[2]			= {}
	self.HP[2]["Ent"]	= nil
	self.HP[2]["Type"]	= { "Small", "Large", "Medium", "GatRight" }
	self.HP[2]["Pos"]	= Vector(-20,260,70)
	self.HP[2]["Angle"] = Angle(0,0,0)
	self.HP[3]			= {}
	self.HP[3]["Ent"]	= nil
	self.HP[3]["Type"]	= { "Small", "Large", "Medium", "GatMid", "GatLeft" }
	self.HP[3]["Pos"]	= Vector(-190,-100,110)
	self.HP[3]["Angle"] = Angle(0,0,0)
	self.HP[4]			= {}
	self.HP[4]["Ent"]	= nil
	self.HP[4]["Type"]	= { "Small", "Large", "Medium", "GatMid", "GatRight" }
	self.HP[4]["Pos"]	= Vector(-190,100,110)
	self.HP[4]["Angle"]	= Angle(0,0,0)
	self.HP[5]			= {}
	self.HP[5]["Ent"]	= nil
	self.HP[5]["Type"]	= { "Medium", "Large", "Vehicle", "GatMid" }
	self.HP[5]["Pos"]	= Vector(110,0,40)
	self.HP[5]["Angle"]	= Angle(0,0,180)
	self.HP[6]			= {}
	self.HP[6]["Ent"]	= nil
	self.HP[6]["Type"]	= { "Medium", "Large", "Vehicle", "GatRight" }
	self.HP[6]["Pos"]	= Vector(80,-270,60)
	self.HP[6]["Angle"] = Angle(0,0,180)
	self.HP[7]			= {}
	self.HP[7]["Ent"]	= nil
	self.HP[7]["Type"]	= { "Medium", "Large", "Vehicle", "GatLeft" }
	self.HP[7]["Pos"]	= Vector(80,270,60)
	self.HP[7]["Angle"] = Angle(0,0,180)
	self.HP[8]			= {}
	self.HP[8]["Ent"]	= nil
	self.HP[8]["Type"]	= { "Medium", "Large", "GatMid", "GatLeft" }
	self.HP[8]["Pos"]	= Vector(-180,-115,60)
	self.HP[8]["Angle"] = Angle(0,0,180)
	self.HP[9]			= {}
	self.HP[9]["Ent"]	= nil
	self.HP[9]["Type"]	= { "Medium", "Large", "GatMid", "GatLeft" }
	self.HP[9]["Pos"]	= Vector(-180,115,60)
	self.HP[9]["Angle"]	= Angle(0,0,180)
	
end

function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	
	
	local ent = ents.Create( "CE-Wraith" )
	ent:SetPos( Vector( 100000,100000,100000 ) )
	ent:Spawn()
	ent:Initialize()
	ent:Activate()
	ent.SPL = ply
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16 + Vector(0,0,50)
	local ent2 = ents.Create( "prop_vehicle_prisoner_pod" )
	ent2:SetModel( "models/Cerus/Fighters/wraith.mdl" ) 
	ent2:SetPos( SpawnPos )
	ent2:SetKeyValue("vehiclescript", "scripts/vehicles/prisoner_pod.txt")
	ent2:SetKeyValue("limitview", 0)
	ent2.HasHardpoints = true
	ent2:Spawn()
	ent2:Activate()
	local TB = ent2:GetTable()
	TB.HandleAnimation = function (vec, ply)
		return ply:SelectWeightedSequence( ACT_HL2MP_SIT ) 
	end 
	ent2:SetTable(TB)
	ent2.SPL = ply
	ent2:SetNetworkedInt( "HPC", ent.HPC )
	--Networked so the client knows these values
	ent2:SetNetworkedEntity("ViewEnt",ent2)
	ent2:SetNetworkedInt( "OffsetOut", 600 )
	
	ent.Pod = ent2
	ent2.Cont = ent
	ent2.Pod = ent2
	--Constrain so they get duped together
	constraint.NoCollide( ent, ent2, 0, 0 )
	
	return ent
end