
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:InitDock()
	self.Bay = {}
	self.Bay["Bay"] = {}
	self.Bay["Bay"]["ship"] = nil
	self.Bay["Bay"]["weld"] = nil
	self.Bay["Bay"]["pos"] = Vector(0,0,0)
	self.Bay["Bay"]["canface"] = {Angle(0,0,0),Angle(0,180,0),Angle(90,90,0),Angle(90,180,0),Angle(90,270,0),Angle(90,360,0)}
	self.Bay["Bay"]["pexit"] = Vector(-250,0,10)
end

function ENT:Initialize()
	self.BaseClass:Initialize(self)
	self.Entity:SetModel( "models/SmallBridge/SBdropbaycomplete1S/sbdropbaycomplete1s.mdl" )
	self.Entity:SetName("sbHangar")
end

function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16 + Vector(0,0,500)
	
	local ent = ents.Create( "sbmp_hangar_sb" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Initialize()
	ent:Activate()
	ent.SPL = ply
	
	return ent
	
end
