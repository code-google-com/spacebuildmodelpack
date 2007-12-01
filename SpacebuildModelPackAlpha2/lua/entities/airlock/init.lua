AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

local Ground = 1 + 0 + 2 + 8 + 32

function ENT:Initialize()
	self.BaseClass.Initialize(self)
	self.open = false
	self.doingsequence = false
	self.model = string.sub( self.Entity:GetModel(), 1, -6 )
end

function ENT:Use()
	if self.doingsequence then return end
	if(self.open) then
		self.doingsequence = true
		local sequence = self.Entity:LookupSequence("idle_closed")
		self.Entity:SetSequence(sequence)
		timer.Simple( 1 , Close2, self.Entity)
	else
		self.doingsequence = true
		local phys = self.Entity:GetPhysicsObject()
		if phys:IsValid() then
			phys:EnableCollisions( false )
			phys:Sleep()
		end
		self.Entity:SetModel(self.model .. ".mdl")
		phys = self.Entity:GetPhysicsObject()
		if phys:IsValid() then
			phys:EnableCollisions( true )
			phys:Wake()
		end
		local sequence = self.Entity:LookupSequence("idle_open") 
		self.Entity:SetSequence(sequence)
		timer.Simple( 1 , Open2, self.Entity)
	end
end

function Close2(ent)
	ent.open = false
	ent.doingsequence = false
	local phys = ent:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableCollisions( false )
		phys:Sleep()
	end
	ent:SetModel(self.model .. "E.mdl")
	phys = ent:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableCollisions( true )
		phys:Wake()
	end
end

function Open2(ent)
	ent.open = true
	ent.doingsequence = false
end

function ENT:TriggerInput(iname, value)
	/*if (iname == "On") then
		self:SetActive(value)*/
end

function ENT:Damage()
end

function ENT:Repair()
end

function ENT:Destruct()
end

function ENT:OnRemove()
end

function ENT:Think()
	self.BaseClass.Think(self)
	self.Entity:NextThink(CurTime() + 1)
	return true
end

