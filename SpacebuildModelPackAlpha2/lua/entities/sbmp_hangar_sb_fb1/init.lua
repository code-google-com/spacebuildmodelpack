
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()
	self.BaseClass:Initialize(self)
	self.Entity:SetModel( "models/SmallBridge/Station Parts/SBhangarLu.mdl" )
	self.Entity:SetName("sbfighterbay1")
end

function ENT:InitDock()
	self.Bay = {}
	self.Bay["Right"] = {}
	self.Bay["Right"]["ship"] = nil
	self.Bay["Right"]["weld"] = nil
	self.Bay["Right"]["pos"] = Vector(0,320,80)
	self.Bay["Right"]["canface"] = {Angle(0,0,0),Angle(0,180,0)}
	self.Bay["Right"]["pexit"] = Vector(0,256,0)
	self.Bay["Left"] = {}
	self.Bay["Left"]["ship"] = nil
	self.Bay["Left"]["weld"] = nil
	self.Bay["Left"]["pos"] = Vector(0,-320,80)
	self.Bay["Left"]["canface"] = {Angle(0,0,0),Angle(0,180,0)}
	self.Bay["Left"]["pexit"] = Vector(0,-256,0)
end

function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16 + Vector(0,0,150)
	
	local ent = ents.Create( "sbmp_hangar_sb_fb1" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Initialize()
	ent:Activate()
	ent.SPL = ply
	
	return ent
	
end
