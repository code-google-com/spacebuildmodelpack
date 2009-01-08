
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
	self.Bay[1] = {ship = nil, weld = nil, pos = Vector(50,-600,-100), ang = Angle(0,0,0), pexit = Vector(0,-300,-85)}
	self.Bay[2] = {ship = nil, weld = nil, pos = Vector(50,600,-100), ang = Angle(0,0,0), pexit = Vector(0,300,-85)}
	
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
		for k, v in pairs(self.Bay) do
			if ( !v.ship && !self.Entity:alreadyDocked(ent) ) then
				v.ship = ent
				v.ship:SetPos( self.Entity:LocalToWorld(v.pos + Fighters[fighter]["VecOff"]) )
				v.ship:SetAngles( self.Entity:GetAngles() + v.ang + Fighters[fighter]["AngOff"] )
				v.weld = constraint.Weld(self.Entity, v.ship, 0, 0, 0, true)
				if (v.ship:GetPassenger():IsPlayer()) then
					local pilot = v.ship:GetPassenger()
					local colgroup = pilot:GetCollisionGroup()
					pilot:SetCollisionGroup( COLLISION_GROUP_NONE )
					pilot:ExitVehicle()
					pilot:SetPos( self.Entity:LocalToWorld(v.pexit) )
					pilot:SetCollisionGroup( colgroup )
				end
			end
		end
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