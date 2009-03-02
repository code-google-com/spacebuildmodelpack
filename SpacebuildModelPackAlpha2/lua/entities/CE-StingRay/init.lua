AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()
	
	self.Entity:SetModel( "models/cerus/fighters/stingray.mdl" ) 
	self.Entity:SetName("StingRay")
	self.BaseClass:Initialize(self)
	
	self.EMount = true
	self.HasHardpoints = true
	self.Cont = self.Entity
	
	self.Speed = 0
	self.TSpeed = 90
	self.Active = false
	--self.Skewed = true
	self.HSpeed = 0
	
	self.HPC			= 3
	self.HP				= {}
	self.HP[1]			= {}
	self.HP[1]["Ent"]	= nil
	self.HP[1]["Type"]	= { "Small","Medium"  }
	self.HP[1]["Pos"]	= Vector(-50,-60,32)
	self.HP[1]["Angle"] = Angle(0,0,0)
	self.HP[2]			= {}
	self.HP[2]["Ent"]	= nil
	self.HP[2]["Type"]	= { "Small","Medium"  }
	self.HP[2]["Pos"]	= Vector(-50, 60,32)
	self.HP[2]["Angle"] = Angle(0,0,0)
	self.HP[3]			= {}
	self.HP[3]["Ent"]	= nil
	self.HP[3]["Type"]	= { "Small","Medium" }
	self.HP[3]["Pos"]	= Vector(72,0,24)
	self.HP[3]["Angle"] = Angle(0,0,180)
	
	local sequence = self.Entity:LookupSequence("canopy_idle_open")
	self.Entity:SetSequence(sequence)
end

function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16 + Vector(0,0,50)
	
	local ent = ents.Create( "CE-StingRay" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Initialize()
	ent:Activate()
	ent.SPL = ply
	ent.HasHardpoints = true
	
	local ent2 = ents.Create( "prop_vehicle_prisoner_pod" )
	ent2:SetModel( "models/smallbridge/sbchair/sbchair.mdl" ) 
	ent2:SetPos( ent:LocalToWorld(Vector(40,0,20)) )
	ent2:SetColor(255,255,255,31)
	ent2:SetKeyValue("vehiclescript", "scripts/vehicles/prisoner_pod.txt")
	ent2:SetKeyValue("limitview", 0)
	ent2:Spawn()
	ent2:Activate()
	ent2.ExitPoint = ent
	local TB = ent2:GetTable()
	TB.HandleAnimation = function (vec, ply)
		return ply:SelectWeightedSequence( ACT_HL2MP_SIT ) 
	end 
	ent2:SetTable(TB)
	ent2.SPL = ply
	ent2:SetNetworkedInt( "HPC", ent.HPC )
	--Networked so the client knows these values
	ent2:SetNetworkedEntity("ViewEnt",ent)
	ent2:SetNetworkedInt( "OffsetOut", 600 )
	
	ent.Pod = ent2
	ent2.Cont = ent
	ent2.Pod = ent2
	--Constrain so they get duped together
	constraint.Weld( ent, ent2, 0, 0, 0, true )
	
	return ent
end

function ENT:Use(activator,caller)
	if ( activator:IsPlayer() ) then
		local sequence = self.Entity:LookupSequence("BIO_RIO")
		activator:EnterVehicle( self.Pod )
		self.Entity:SetSequence(sequence)
	end
end

function ENT:ExitFighter(player,vehicle)
	sequence = self.Entity:LookupSequence("canopy_idle_open")
	self.Entity:SetSequence(sequence)
end