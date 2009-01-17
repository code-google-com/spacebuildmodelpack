
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
	self.Bay[1] = {ship = nil, weld = nil, pos = Vector(0, 400, -100), canface = {"forward","backward"}, pexit = Vector(0, 200, -100)}
	self.Bay[2] = {ship = nil, weld = nil, pos = Vector(0,-400, -100), canface = {"forward","backward"}, pexit = Vector(0,-200, -100)}
	self.Bay[3] = {ship = nil, weld = nil, pos = Vector(0, 400, -300), canface = {"forward","backward"}, pexit = Vector(0, 200, -300)}
	self.Bay[4] = {ship = nil, weld = nil, pos = Vector(0,-400, -300), canface = {"forward","backward"}, pexit = Vector(0,-200, -300)}
	
	self.LaunchSpeed = 100
	
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
