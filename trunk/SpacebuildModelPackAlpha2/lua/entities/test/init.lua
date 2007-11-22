AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

local Ground = 1 + 0 + 2 + 8 + 32

function ENT:Initialize()
	self.BaseClass.Initialize(self)
	self.open = false;
end

function ENT:Use()
	Msg("Using\n")
	if(self.open) then
		local sequence = self.Entity:LookupSequence("test_close") 
		Msg("Sequence closing: "..tostring(sequence).."\n")
		self.Entity:SetSequence(sequence)
		self.Entity:LookupSequence("idle_closed")
		Msg("Sequence closing: "..tostring(sequence).."\n")
		self.Entity:SetSequence(sequence) 
		self.open = false
	else
		local sequence = self.Entity:LookupSequence("test_open") 
		Msg("Sequence opening: "..tostring(sequence).."\n")
		self.Entity:SetSequence(sequence)
		self.Entity:LookupSequence("idle_open") 
		Msg("Sequence opening: "..tostring(sequence).."\n")
		self.Entity:SetSequence(sequence)
		self.open = true
	end
end

/*function ENT:TurnOn()
	local sequence = self.Entity:LookupSequence("test_open") 
	self.Entity:SetSequence(sequence)
	self.Entity:LookupSequence("idle_open") 
	self.Entity:SetSequence(sequence) 
end

function ENT:TurnOff()
	local sequence = self.Entity:LookupSequence("test_close") 
	self.Entity:SetSequence(sequence)
	self.Entity:LookupSequence("idle_closed") 
	self.Entity:SetSequence(sequence)
end*/


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

