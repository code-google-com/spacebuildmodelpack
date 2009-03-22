
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()
	self.BaseClass:Initialize(self)
	self.Entity:SetModel( "models/SmallBridge/SBdock1/SBdock1.mdl" )
	self.Entity:SetName("sbclamp")
end

function ENT:InitDock()
	self.Bay = {}
	self.Bay["Clamp"] = {}
	self.Bay["Clamp"]["ship"] = nil
	self.Bay["Clamp"]["weld"] = nil
	self.Bay["Clamp"]["pos"] = Vector(-128,0,0)
	self.Bay["Clamp"]["canface"] = {Angle(0,90,0),Angle(0,270,0),Angle(0,90,180),Angle(0,270,180)}
	self.Bay["Clamp"]["pexit"] = Vector(0,0,0)
end

function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16 + Vector(0,0,100)
	
	local ent = ents.Create( "sbmp_hangar_sb_clamp" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Initialize()
	ent:Activate()
	ent.SPL = ply
	
	return ent
	
end
