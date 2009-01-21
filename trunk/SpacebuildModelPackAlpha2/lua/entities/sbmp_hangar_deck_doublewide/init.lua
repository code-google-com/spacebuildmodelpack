
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
	self.Bay["Right"] = {}
	self.Bay["Right"]["ship"] = nil 
	self.Bay["Right"]["weld"] = nil
	self.Bay["Right"]["pos"] = Vector(0,512,150)
	self.Bay["Right"]["canface"] = {Angle(0,0,0),Angle(0,90,0),Angle(0,180,0),Angle(0,270,0)}
	self.Bay["Left"] = {}
	self.Bay["Left"]["ship"] = nil 
	self.Bay["Left"]["weld"] = nil
	self.Bay["Left"]["pos"] = Vector(0,-512,150)
	self.Bay["Left"]["canface"] = {Angle(0,0,0),Angle(0,90,0),Angle(0,180,0),Angle(0,270,0)}
	
	self.LaunchSpeed = 100
	self.Entity:MakeWire()
	
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

function ENT:BuildDupeInfo()
	local info = self.BaseClass.BuildDupeInfo(self) or {}
	info["ships"] = {}
	for k, v in pairs(self.Bay) do
		if (v.ship) and (v.ship:IsValid()) then
			info["ships"][k] = v.ship:EntIndex()
		end
	end
	return info
end

function ENT:ApplyDupeInfo(ply, ent, info, GetEntByID)
	self.BaseClass.ApplyDupeInfo(self, ply, ent, info, GetEntByID)
	for k, v in pairs(info.ships) do
		self.Bay[k]["ship"] = GetEntByID(v)
		if (!self.Bay[k]["ship"]) then
			self.Bay[k]["ship"] = ents.GetByIndex(v)
		end
	end
end