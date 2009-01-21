
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()

	self.Entity:SetModel( "models/Slyfo/doubleclamp_x.mdl" )
	self.Entity:SetName( "DockingClampX" )
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
	self.Bay["Left"] = {ship = nil, weld = nil, pos = Vector(0,-600,-20), canface = {Angle(0,0,0),Angle(0,180,0),Angle(0,0,180),Angle(0,180,180)}, pexit = Vector(0,-300,-85)}
	self.Bay["Right"] = {ship = nil, weld = nil, pos = Vector(0, 600,-20), canface = {Angle(0,0,0),Angle(0,180,0),Angle(0,0,180),Angle(0,180,180)}, pexit = Vector(0, 300,-85)}
	
	self.LaunchSpeed = 100
	self.Entity:MakeWire()
	
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
