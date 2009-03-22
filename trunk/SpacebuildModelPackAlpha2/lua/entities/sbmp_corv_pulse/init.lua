AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

--util.PrecacheSound( "SB/SteamEngine.wav" )

function ENT:Initialize()
	self.Entity:SetModel( "models/Spacebuild/Higar/pulsecorvett.mdl" ) 
	self.Entity:SetName("Pulsar")
	self.BaseClass:Initialize(self)
	--fix for those without GCombat suggested by jdm12989
	if gcombat then
		gcombat.registerent( self.Entity, 6000, 10 )
	end
	
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
	self.TSpeed				= 15
	self.StrafeSpeed		= 150
	self.AccelMax			= 2.5
	self.DecelMax			= 1.75
	self.MinSpeed			= 20
	self.MaxSpeed			= 2000
	self.DragRate			= 0.5
	self.TSAInc				= 10
	self.TSADec				= 10
	
	self.HPC	= 6
	self.HP				= {}
	self.HP[1]			= {}
	self.HP[1]["Ent"]	= nil
	self.HP[1]["Type"]	= {"Heavy","Huge","SwivelMountC"}
	self.HP[1]["Pos"]	= Vector(-115,0,100)
	self.HP[1]["Angle"] = Angle(0,0,0)
	self.HP[2]			= {}
	self.HP[2]["Ent"]	= nil
	self.HP[2]["Type"]	= {"Heavy","Huge","SwivelMountC"}
	self.HP[2]["Pos"]	= Vector(-115,0,-125)
	self.HP[2]["Angle"] = Angle(0,0,180)
	self.HP[3]			= {}
	self.HP[3]["Ent"]	= nil
	self.HP[3]["Type"]	= {"Medium","Large","Wing","WingLeft"}
	self.HP[3]["Pos"]	= Vector(-500,225,40)
	self.HP[3]["Angle"] = Angle(0,0,-60)
	self.HP[4]			= {}
	self.HP[4]["Ent"]	= nil
	self.HP[4]["Type"]	= {"Medium","Large"}
	self.HP[4]["Pos"]	= Vector(-115,215,-45)
	self.HP[4]["Angle"] = Angle(0,0,180)
	self.HP[5]			= {}
	self.HP[5]["Ent"]	= nil
	self.HP[5]["Type"]	= {"Medium","Large","Wing","WingRight"}
	self.HP[5]["Pos"]	= Vector(-500,-225,40)
	self.HP[5]["Angle"] = Angle(0,0,60)
	self.HP[6]			= {}
	self.HP[6]["Ent"]	= nil
	self.HP[6]["Type"]	= {"Medium","Large"}
	self.HP[6]["Pos"]	= Vector(-115,-215,-45)
	self.HP[6]["Angle"] = Angle(0,0,180)
end

function ENT:SpawnFunction( ply, tr )
	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16 + Vector(0,0,100)
	
	local ent = ents.Create( "sbmp_corv_pulse" )
	ent:SetPos( SpawnPos )
	
	local ent2 = ents.Create( "prop_vehicle_prisoner_pod" )
	--gamemode.Call("PlayerSpawnedVehicle",ply,ent2)
	ent2:SetModel( "models/spacebuild/corvette_chair.mdl" )
	ent2:SetPos( ent:LocalToWorld( Vector( 525, 0, -20) ) )
	ent2:SetAngles( ent:LocalToWorldAngles( Angle(0,0,0)) )
	
	--Networked so the client knows these values
	ent2:SetNetworkedEntity("ViewEnt",ent)
	ent2:SetNetworkedInt( "OffsetOut", 2000 )
	ent2.ExitPoint = ent
	
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
