AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

--util.PrecacheSound( "SB/SteamEngine.wav" )
function ENT:IsHangar()
	return true
end
ENT.LaunchSpeed = 0
function ENT:Initialize()
	self.Entity:SetModel( "models/smallbridge/ships/steakknife.mdl" ) 
	self.Entity:SetName("SteakKnife")
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
	self.AccelMax			= 5
	self.DecelMax			= 10
	self.MinSpeed			= 20
	self.MaxSpeed			= 2000
	self.DragRate			= 0.75
	
	self.HPC = 2
	self.HP = {}
	self.HP[1]			= {}
	self.HP[1]["Ent"]	= nil
	self.HP[1]["Type"]	= {"SwivelMountC"}
	self.HP[1]["Pos"]	= Vector(50,-335,195)
	self.HP[1]["Angle"] = Angle(0,0,0)
	self.HP[2]			= {}
	self.HP[2]["Ent"]	= nil
	self.HP[2]["Type"]	= {"SwivelMountC"}
	self.HP[2]["Pos"]	= Vector(50, 335,195)
	self.HP[2]["Angle"] = Angle(0,0,0)
	self.Entity:InitDock()
	if WireAddon then
		SBEP.Hangar.MakeWire(self)
	end
	
end

function ENT:InitDock()
	self.Bay = {}
	self.Bay["Left"] = {}
	self.Bay["Left"]["ship"] =nil
	self.Bay["Left"]["weld"] = nil
	self.Bay["Left"]["pos"] = Vector(0,326,70)
	self.Bay["Left"]["canface"] = {Angle(0,0,0)}
	self.Bay["Left"]["pexit"] = Vector(-100,168,75)
	self.Bay["Right"] = {}
	self.Bay["Right"]["ship"] =nil
	self.Bay["Right"]["weld"] = nil
	self.Bay["Right"]["pos"] = Vector(0,-326,70)
	self.Bay["Right"]["canface"] = {Angle(0,0,0)}
	self.Bay["Right"]["pexit"] = Vector(-100,-168,75)
	
end

function ENT:SpawnFunction( ply, tr )
	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16 + Vector(0,0,50)
	
	local ent = ents.Create( "sbmp_carr_steakknife" )
	ent:SetPos( SpawnPos )
	
	local ent2 = ents.Create( "prop_vehicle_prisoner_pod" )
	--gamemode.Call("PlayerSpawnedVehicle",ply,ent2)
	ent2:SetModel( "models/SmallBridge/Vehicles/SBVPchair.mdl" )
	ent2:SetPos( ent:LocalToWorld( Vector(70,0,205) ) )
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
function ENT:TriggerInput(iname, value)
	if (self.BaseClass.TriggerInput) then
		self.BaseClass:TriggerInput(iname,value)
	end
	SBEP.Hangar.TriggerInput(self,iname,value)
end

function ENT:SetLaunchSpeed(value)
	self.LaunchSpeed = value
end

function ENT:SetDisabled(bay,value)
	if (value != 0) then
		bay.disabled = true
	else
		bay.disabled = false
	end
end

function ENT:Eject(bay,value)
	if (value != 0) then
		if bay.ship then
			bay.ship.Cont.Launchy = true
		end
	end
end

--[[function ENT:Think()
	self.BaseClass:Think()
	SBEP.Hangar.Think(self)
end]]

function ENT:Touch( ent )
	self.BaseClass:Touch()
	SBEP.Hangar.Touch(self,ent)
end

function ENT:PreEntityCopy()
	self.BaseClass:PreEntityCopy()
	local DupeInfo = {}
	DupeInfo["ships"] = {}
	DupeInfo["EPs"] = {}
	for k, v in pairs(self.Bay) do
		if (v.ship) and (v.ship:IsValid()) then
			DupeInfo["ships"][k] = v.ship:EntIndex()
		end
		if (v.EP) and (v.EP:IsValid()) then
			DupeInfo["EPs"][k] = v.EP:EntIndex()
		end
	end
	duplicator.StoreEntityModifier(self.Entity,"HangarDupeInfo",DupeInfo)
end


function ENT:PostEntityPaste(Player,Ent,CreatedEntities)
	self.BaseClass:PostEntityPaste(Player,Ent,CreatedEntities)
	if (Ent.EntityMods.HangarDupeInfo) then
		for k, v in pairs(Ent.EntityMods.HangarDupeInfo.ships) do
			self.Bay[k]["ship"] = CreatedEntities[v]
			if (!self.Bay[k]["ship"]) then
				self.Bay[k]["ship"] = ents.GetByIndex(v)
			end
		end
		for k, v in pairs(Ent.EntityMods.HangarDupeInfo.EPs) do
			self.Bay[k]["EP"] = CreatedEntities[v]
			if (!self.Bay[k]["EP"]) then
				self.Bay[k]["EP"] = ents.GetByIndex(v)
			end
		end
	end
end