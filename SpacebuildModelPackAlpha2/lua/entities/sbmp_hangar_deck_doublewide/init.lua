
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()
	self.BaseClass:Initialize(self)
	self.Entity:SetModel( "models/Slyfo/cdeck_doublewide.mdl" )
	self.Entity:SetName("DeckDoubleWide")
end

function ENT:InitDock()
	self.Bay = {}
	self.Bay["Right"] = {}
	self.Bay["Right"]["ship"] = nil 
	self.Bay["Right"]["weld"] = nil
	self.Bay["Right"]["pos"] = Vector(0,512,256)
	self.Bay["Right"]["canface"] = {Angle(0,90,0),Angle(0,270,0),Angle(0,180,0),Angle(0,0,0),
							Angle(0,90,180),Angle(0,270,180),Angle(0,180,180),Angle(0,0,180)}
	self.Bay["Left"] = {}
	self.Bay["Left"]["ship"] = nil 
	self.Bay["Left"]["weld"] = nil
	self.Bay["Left"]["pos"] = Vector(0,-512,256)
	self.Bay["Left"]["canface"] = {Angle(0,90,0),Angle(0,270,0),Angle(0,180,0),Angle(0,0,0),
							Angle(0,90,180),Angle(0,270,180),Angle(0,180,180),Angle(0,0,180)}
end

function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16 + Vector(0,0,500)
	
	local ent = ents.Create( "sbmp_hangar_deck_doublewide" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Initialize()
	ent:Activate()
	ent.SPL = ply
	
	return ent
	
end
