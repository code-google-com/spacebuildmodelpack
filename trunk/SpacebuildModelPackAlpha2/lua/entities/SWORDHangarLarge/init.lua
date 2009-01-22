
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()

	self.Entity:SetModel( "models/Slyfo/hangar2.mdl" )
	self.Entity:SetName("SWORDHangarLarge")
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
	self.Bay["Top Right"] = {ship = nil, weld = nil, pos = Vector(0, 400, -20), canface = {Angle(0,0,0),Angle(0,180,0),Angle(0,0,180),Angle(0,180,180)}, pexit = Vector(0, 200, -100)}
	self.Bay["Top Left"] = {ship = nil, weld = nil, pos = Vector(0,-400, -20), canface = {Angle(0,0,0),Angle(0,180,0),Angle(0,0,180),Angle(0,180,180)}, pexit = Vector(0,-200, -100)}
	self.Bay["Bottom Right"] = {ship = nil, weld = nil, pos = Vector(0, 400, -220), canface = {Angle(0,0,0),Angle(0,180,0),Angle(0,0,180),Angle(0,180,180)}, pexit = Vector(0, 200, -300)}
	self.Bay["Botton Left"] = {ship = nil, weld = nil, pos = Vector(0,-400, -220), canface = {Angle(0,0,0),Angle(0,180,0),Angle(0,0,180),Angle(0,180,180)}, pexit = Vector(0,-200, -300)}
	
	self.LaunchSpeed = 100
	self.Entity:MakeWire()
	
end

function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16 + Vector(0,0,500)
	
	local ent = ents.Create( "SWORDHangarLarge" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Initialize()
	ent:Activate()
	ent.SPL = ply
	
	return ent
	
end