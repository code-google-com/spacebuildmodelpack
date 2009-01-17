
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()

	self.Entity:SetModel( "models/Slyfo/cdeck_doublewide.mdl" )
	self.Entity:SetName("DeckDoubleWide")
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
	self.Bay[1] = {}
	self.Bay[1]["ship"] = nil 
	self.Bay[1]["weld"] = nil
	self.Bay[1]["pos"] = Vector(0,512,150)
	self.Bay[1]["canface"] = {Angle(0,0,0),Angle(0,90,0),Angle(0,180,0),Angle(0,270,0)}
	self.Bay[2] = {}
	self.Bay[2]["ship"] = nil 
	self.Bay[2]["weld"] = nil
	self.Bay[2]["pos"] = Vector(0,-512,150)
	self.Bay[2]["canface"] = {Angle(0,0,0),Angle(0,90,0),Angle(0,180,0),Angle(0,270,0)}
	
	self.LaunchSpeed = 100
	
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
