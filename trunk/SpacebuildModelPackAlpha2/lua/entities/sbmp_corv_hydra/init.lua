AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

--util.PrecacheSound( "SB/SteamEngine.wav" )

function ENT:Initialize()
	self.Entity:SetModel( "models/smallbridge/ships/matthew0623_hydra.mdl" ) 
	self.Entity:SetName("Hydra")
	self.BaseClass:Initialize(self)
	
	self.EMount = true
	self.HasHardpoints = true
	self.Cont = self.Entity
	self.Speed = 0
	self.Active = false
	--self.Skewed = true
	self.HSpeed = 0
	self.PMult = 1
	self.YMult = 1
	self.RMult = 1
	self.TSpeed				= 45
	self.StrafeSpeed		= 150
	self.AccelMax			= 7.5
	self.DecelMax			= 15
	self.MinSpeed			= 22
	self.MaxSpeed			= 2200
	self.DragRate			= 0.75
	
	self.HPC = 2
	self.HP = {}
	self.HP[1]			= {}
	self.HP[1]["Ent"]	= nil
	self.HP[1]["Type"]	= {"Medium","Large"}
	self.HP[1]["Pos"]	= Vector(0,-220,65)
	self.HP[1]["Angle"] = Angle(0,0,0)
	self.HP[2]			= {}
	self.HP[2]["Ent"]	= nil
	self.HP[2]["Type"]	= {"Medium","Large"}
	self.HP[2]["Pos"]	= Vector(0, 220,65)
	self.HP[2]["Angle"] = Angle(0,0,0)

end

function ENT:SpawnFunction( ply, tr )
	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16 + Vector(0,0,50)
	
	local ent = ents.Create( "sbmp_corv_hydra" )
	ent:SetPos( SpawnPos )
	
	local ent2 = ents.Create( "prop_vehicle_prisoner_pod" )
	gamemode.Call("PlayerSpawnedVehicle",ply,ent2)
	ent2:SetModel( "models/smallbridge/sbchair/sbchair.mdl" )
	ent2:SetPos( ent:LocalToWorld( Vector(300,0,75) ) )
	ent2:SetAngles( ent:LocalToWorldAngles( Angle(0,0,0)) )
	
	--Networked so the client knows these values
	ent2:SetNetworkedEntity("ViewEnt",ent)
	ent2:SetNetworkedInt( "OffsetOut", 1500 )
	
	--Common Block--
	ent:Spawn()
	ent:Initialize()
	ent:Activate()
	ent.SPL = ply
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
	ent2.ViewOverride = {}
	local phys = ent2:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableGravity(true)
		phys:EnableDrag(true)
		phys:EnableCollisions(true)
	end
	ent.Pod = ent2
	ent2.Cont = ent
	ent2.Pod = ent2
	--End of common Block--
	
	constraint.Weld(ent,ent2,0,0,0,true)
	
	
	return ent
end
