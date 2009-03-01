
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()
	self.BaseClass:Initialize(self)
	self.Entity:SetModel( "models/Slyfo/cdeck_single.mdl" )
	self.Entity:SetName("Deck")
end

function ENT:InitDock()
	self.Bay = {}
	self.Bay["Deck"] = {}
	self.Bay["Deck"]["ship"] = nil 
	self.Bay["Deck"]["weld"] = nil
	self.Bay["Deck"]["pos"] = Vector(0,0,256)
	self.Bay["Deck"]["canface"] = {Angle(0,90,0),Angle(0,270,0),Angle(0,180,0),Angle(0,0,0),
							Angle(0,90,180),Angle(0,270,180),Angle(0,180,180),Angle(0,0,180)}
end

function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16 + Vector(0,0,500)
	
	local ent = ents.Create( "sbmp_hangar_deck" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Initialize()
	ent:Activate()
	ent.SPL = ply
	
	return ent
	
end
