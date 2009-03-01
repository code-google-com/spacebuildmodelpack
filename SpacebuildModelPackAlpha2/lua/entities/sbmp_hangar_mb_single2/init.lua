
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()
	self.BaseClass:Initialize(self)
	self.Entity:SetModel( "models/Slyfo/shangar.mdl" )
	self.Entity:SetName("mbhangarside2")
end

function ENT:InitDock()
	self.Bay = {}
	self.Bay["Side"] = {ship = nil, weld = nil, pos = Vector(0,214,0),
						canface = {Angle(0,0,0),Angle(0,180,0),Angle(0,0,180),Angle(0,180,180)},
						pexit = Vector(0,100,-100)}
end

function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16 + Vector(0,0,500)
	
	local ent = ents.Create( "sbmp_hangar_mb_single2" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Initialize()
	ent:Activate()
	ent.SPL = ply
	
	return ent
	
end
