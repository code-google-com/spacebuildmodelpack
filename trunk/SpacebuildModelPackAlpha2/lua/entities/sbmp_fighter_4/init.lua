AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

--util.PrecacheSound( "SB/SteamEngine.wav" )

function ENT:Initialize()
	
	self.Entity:SetModel( "models/spacebuild/emount2_milcock4.mdl" ) 
	self.Entity:SetName("SAWBlade")
	self.BaseClass:Initialize(self)
	
	self.EMount = true
	self.HasHardpoints = true
	self.Cont = self.Entity
	
	self.Speed = 0
	self.TSpeed = 90
	self.Active = false
	--self.Skewed = true
	self.HSpeed = 0
	
	self.PMult = 1
	self.YMult = 1
	self.RMult = 1
	
	self.HPC	= 4
	self.HP				= {}
	self.HP[1]			= {}
	self.HP[1]["Ent"]	= nil
	self.HP[1]["Type"]	= { "WingRight","Wing" }
	self.HP[1]["Pos"]	= Vector(-42,32,32)
	self.HP[1]["Angle"] = Angle(0,0,270)
	self.HP[2]			= {}
	self.HP[2]["Ent"]	= nil
	self.HP[2]["Type"]	= { "WingLeft","Wing" }
	self.HP[2]["Pos"]	= Vector(-42,-32,32)
	self.HP[2]["Angle"] = Angle(0,0,90)
	self.HP[3]			= {}
	self.HP[3]["Ent"]	= nil
	self.HP[3]["Type"]	= { "WingLeft","Wing" }
	self.HP[3]["Pos"]	= Vector(-42,56,-32)
	self.HP[3]["Angle"] = Angle(0,0,270)
	self.HP[4]			= {}
	self.HP[4]["Ent"]	= nil
	self.HP[4]["Type"]	= { "WingRight","Wing" }
	self.HP[4]["Pos"]	= Vector(-42,-56,-32)
	self.HP[4]["Angle"] = Angle(0,0,90)
end

function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16 + Vector(0,0,50)
	
	local ent = ents.Create( "sbmp_fighter_4" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Initialize()
	ent:Activate()
	ent.SPL = ply
	
	local ent2 = ents.Create( "prop_vehicle_prisoner_pod" )
	ent2:SetModel( "models/spacebuild/milcock4a.mdl" ) 
	ent2:SetPos( ent:LocalToWorld(Vector(100,0,23)) )
	ent2:SetKeyValue("vehiclescript", "scripts/vehicles/prisoner_pod.txt")
	ent2:SetKeyValue("limitview", 0)
	--ent2.HasHardpoints = true
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
	ent2:SetNetworkedEntity("ViewEnt",ent)
	ent2:SetNetworkedInt( "OffsetOut", 300 )
	local phys = ent2:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableGravity(true)
		phys:EnableDrag(true)
		phys:EnableCollisions(true)
	end
	
	constraint.Weld(ent,ent2,0,0,0,true)
	
	ent.Pod = ent2
	ent2.Cont = ent
	ent2.Pod = ent2
	
	ent2.ExitPoint = ent
	
	return ent
end
