
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()
	self.BaseClass:Initialize(self)
	self.Entity:SetModel( "models/Slyfo/capturehull1.mdl" )
	self.Entity:SetName("DockingClamp")
end

function ENT:InitDock()
	self.Bay = {}
	self.Bay["Clamp"] = {}
	self.Bay["Clamp"]["ship"] = nil
	self.Bay["Clamp"]["weld"] = nil
	self.Bay["Clamp"]["pos"] = Vector(425,0,80)
	self.Bay["Clamp"]["canface"] = {Angle(0,90,0),Angle(0,270,0),Angle(0,90,180),Angle(0,270,180)}
	self.Bay["Clamp"]["pexit"] = Vector(150,0,10)
end

function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16 + Vector(0,0,200)
	
	local ent = ents.Create( "DockingClamp" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Initialize()
	ent:Activate()
	ent.SPL = ply
	
	return ent
	
end
