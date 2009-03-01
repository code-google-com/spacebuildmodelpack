
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
	
	util.PrecacheModel("models/Levybreak/laser_cannon.mdl")
	self:SetModel("models/Levybreak/laser_cannon.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE) 
	
	local seq = self:LookupSequence("idle")
	self:ResetSequence(seq)
	
end

function ENT:Think()
	self:NextThink(CurTime()+0.0000000000001)
end 

function ENT:Use(ply)
	local seq = self:LookupSequence("fire")
	self:ResetSequence(seq)
end

function ENT:PhysicsCollide( data, physobj )  

end 

function ENT:SpawnFunction(ply, tr)
	if (!tr.HitWorld) then return end

	local ent = ents.Create("sent_recoil_cannon")
	ent:SetPos(tr.HitPos + Vector(0, 0, 50))
	ent.Owner = ply
	ent:Spawn()
	ent:DropToFloor()
	
	return ent
end 