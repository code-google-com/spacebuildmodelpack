
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()
	self.BaseClass:Initialize(self)
	self.Entity:SetModel( "models/Slyfo/doubleclamp_x.mdl" )
	self.Entity:SetName( "DockingClampX" )
end

function ENT:InitDock()
	self.Bay = {}
	self.Bay["Left"] = {ship = nil, weld = nil, pos = Vector(0,-600,-20), canface = {Angle(0,0,0),Angle(0,180,0),Angle(0,0,180),Angle(0,180,180)}, pexit = Vector(0,-300,-85)}
	self.Bay["Right"] = {ship = nil, weld = nil, pos = Vector(0, 600,-20), canface = {Angle(0,0,0),Angle(0,180,0),Angle(0,0,180),Angle(0,180,180)}, pexit = Vector(0, 300,-85)}
end

function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16 + Vector(0,0,200)
	
	local ent = ents.Create( "DockingClampX" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Initialize()
	ent:Activate()
	ent.SPL = ply
	
	return ent
	
end
