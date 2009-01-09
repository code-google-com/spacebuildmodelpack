
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )
local Fighters = list.Get("sbepfighters")

function ENT:Initialize()

	self.Entity:SetModel( "models/Slyfo/doubleclamp_x.mdl" )
	self.Entity:SetName("DockingClampX")
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableGravity(true)
		phys:EnableDrag(true)
		phys:EnableCollisions(true)
	end
	
    self.Entity:SetKeyValue("rendercolor", "255 255 255")
	self.Bay = {}
	self.Bay[1] = {ship = nil, weld = nil, pos = Vector(0,-600,-100), ang = Angle(0,0,0), pexit = Vector(0,-300,-85)}
	self.Bay[2] = {ship = nil, weld = nil, pos = Vector(0, 600,-100), ang = Angle(0,0,0), pexit = Vector(0, 300,-85)}
	
end

function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16 + Vector(0,0,500)
	
	local ent = ents.Create( "DockingClampX" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Initialize()
	ent:Activate()
	ent.SPL = ply
	
	return ent
	
end

function ENT:Think()
	local bay = self.Bay
	for k, v in pairs(bay) do
		if ( !v.ship || !v.ship:IsValid() || !v.weld || !v.weld:IsValid() ) then
			v.weld = nil
			v.ship = nil
		end
		if ( v.ship && v.ship.Cont.Launchy ) then
			v.weld:Remove()
			v.weld = nil
			v.ship.Cont.Speed =1000
			v.ship = nil
		end
	end
end

function ENT:Touch( ent )
	if ( ent:IsValid() && ent:IsVehicle() && self.Entity:IsInBoth(ent) && (ent.Cont != nil) && !ent.Cont.Launchy ) then
		local fighter = string.lower(ent.Cont:GetName())
		local dock = self.Entity:findNearestDock(ent)
		if (dock == false) then return end
		if ( !dock.ship && !self.Entity:alreadyDocked(ent) ) then
			dock.ship = ent
			dock.ship:SetPos( self.Entity:LocalToWorld(dock.pos + Fighters[fighter]["VecOff"]) )
			dock.ship:SetAngles( self.Entity:getFacing(ent,(self.Entity:GetAngles() + dock.ang + Fighters[fighter]["AngOff"])) )
			dock.weld = constraint.Weld(self.Entity, dock.ship, 0, 0, 0, true)
			if (dock.ship:GetPassenger():IsPlayer()) then
				local pilot = dock.ship:GetPassenger()
				local colgroup = pilot:GetCollisionGroup()
				pilot:SetCollisionGroup( COLLISION_GROUP_NONE )
				pilot:ExitVehicle()
				pilot:SetPos( self.Entity:LocalToWorld(dock.pexit) )
				pilot:SetCollisionGroup( colgroup )
			end
		end
	end
end

function ENT:findNearestDock(ent)
	local pos = self.Entity:WorldToLocal(ent:GetPos())
	local dis, closest
	for k, v in pairs(self.Bay) do
		if (v.ship == nil) then
			local tdis = pos:Distance(v.pos)
			local tclosest = v
			if (dis == null || tdis < dis) then
				dis = tdis
				closest = tclosest
			end
		end
	end
	return closest or false
end

function ENT:getFacing(ent, ang)
	local pfw = ent:GetRight()
	local forward = ang:Forward()
	local back = forward * -1
	if (pfw:DotProduct(forward) >= pfw:DotProduct(back)) then
		return forward:Angle()
	else
		return back:Angle()
	end
end

function ENT:alreadyDocked(ent)
	for k, v in pairs(self.Bay) do
		if (ent == v.ship) then
			return true	
		end
	end
	return false
end

function ENT:IsInBoth(ent)
	local fighter = string.lower(ent.Cont:GetName())
	if (!Fighters[fighter]) then return false end
	local docklist = Fighters[fighter]["Docklist"]
	return (Fighters[fighter] && table.HasValue(docklist, string.lower(self.Entity:GetName())))
end

function ENT:Use(activator)
end