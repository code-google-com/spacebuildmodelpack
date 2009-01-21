
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()

	self.Entity:SetModel( "models/SmallBridge/SBhangardhdw1D/sbhangardhdw1d.mdl" )
	self.Entity:SetName("sbfighterbay3")
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
	
	self.LaunchSpeed = 100
	self.Entity:MakeWire()
	
end

function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16 + Vector(0,0,500)
	
	local ent = ents.Create( "sbmp_hangar_sb_fb3" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Initialize()
	ent:Activate()
	ent.SPL = ply
	
	return ent
	
end
