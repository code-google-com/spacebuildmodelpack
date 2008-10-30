AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	
	local phys = self.Entity:GetPhysicsObject()
	
	if phys:IsValid() then
		phys:EnableDrag(false)
		phys:EnableGravity(false)
	end
	
	self.Entity:SetColor(255, 255, 255, 200)
	
	self.Entity:SetCollisionGroup(COLLISION_GROUP_WORLD)
	
	return self.Entity:DrawShadow(false)
end

local VecZero = Vector(0, 0, 0)

function ENT:PhysicsUpdate(physobj)
	if not self.Entity:IsPlayerHolding() then
		physobj:Sleep()
	end
end
