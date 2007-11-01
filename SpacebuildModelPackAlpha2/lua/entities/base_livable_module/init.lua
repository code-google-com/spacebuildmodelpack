AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
util.PrecacheSound( "apc_engine_start" )
util.PrecacheSound( "apc_engine_stop" )
util.PrecacheSound( "common/warning.wav" )

include('shared.lua')

local Ground = 1 + 0 + 2 + 8 + 32
local Air_Increment = 2
local Energy_Increment = 5
local Coolant_Increment = 2

function ENT:Initialize()
	self.BaseClass.Initialize(self)
	self.Active = 0
	self.damaged = 0
	SB_Add_Environment(self.Entity, nil, 0, 0, 0, 0)
	if not (WireAddon == nil) then
		self.WireDebugName = self.PrintName
		self.Inputs = Wire_CreateInputs(self.Entity, { "On", "Air", "Heat", "Gravity" })
		self.Outputs = Wire_CreateOutputs(self.Entity, { "On", "Air", "Heat" })
	end
	self.giveAir = 1;
	self.giveHeat = 1;
	self.giveGravity = 1;
	self.size = math.Round(self.Entity:BoundingRadius()/48);
	self.IgnoreClasses = {self.Entity:GetClass()}
end

function ENT:TurnOn()
	self.Entity:EmitSound( "apc_engine_start" )
	self.Active = 1
	self.HasAir = true
	self.HasHeat = true
	if not (WireAddon == nil) then Wire_TriggerOutput(self.Entity, "On", self.Active) end
	self:SetOOO(1)
end

function ENT:TurnOff()
	self.Entity:StopSound( "apc_engine_start" )
	self.Entity:EmitSound( "apc_engine_stop" )
	self.Active = 0
	self.HasAir = false
	self.HasHeat = false
	if not (WireAddon == nil) then Wire_TriggerOutput(self.Entity, "On", self.Active) end
	self:SetOOO(0)
end


function ENT:TriggerInput(iname, value)
	if (iname == "On") then
		self:SetActive(value)
	elseif (iname == "Air") then
		if value > 0 then
			self.giveAir = 1
		else
			self.giveAir = 0
		end
	elseif (iname == "Heat") then
		if value > 0 then
			self.giveHeat = 1
		else
			self.giveHeat = 0
		end
	elseif (iname == "Gravity") then
		if value > 0 then
			self.giveGravity = 1
		else
			self.giveGravity = 0
		end
	end
end

function ENT:Damage()
	if (self.damaged == 0) then
		self.damaged = 1
	end
	if ((self.Active == 1) and (math.random(1, 10) <= 3)) then
		self:TurnOff()
	end
end

function ENT:Repair()
	self.health = self.maxhealth
	self.damaged = 0
end

function ENT:Destruct()
	SB_Remove_Environment(self.num)
	LS_Destruct( self.Entity, true )
end

function ENT:OnRemove()
	SB_Remove_Environment(self.num)
	self.BaseClass.OnRemove(self)
	self.Entity:StopSound( "apc_engine_start" )
end

function ENT:Climate_Control()
	local temperature = self.environment.temperature
	local gravity = 0
	if self.planet then
		gravity = self.gravity or 0
	end
	local atmosphere = 0
	if self.presurized == 1 then
		atmosphere = 1
	else
		atmosphere = self.environment.atmosphere
	end
	local habitat = self.environment.habitat
	if self.environment.inwater == 1 then
		habitat = 0
	end
	if habitat == 0 and self.giveAir == 1 then
		self.needair = true
	else
		self.needair = false
	end
	if temperature > FairTemp_Max and self.giveHeat == 1 then
		self.needcoolant = true
	else
		self.needcoolant = false
	end
	if temperature < FairTemp_Min and self.giveHeat == 1 then
		self.needenergy = true
	else
		self.needenergy = false
	end
	if self.Active == 1 then
		self.hasair = false
		self.hasheat = false
		self.presurized = 1
		self.air = RD_GetResourceAmount(self.Entity, "air")
		self.coolant = RD_GetResourceAmount(self.Entity, "coolant")
		self.energy = RD_GetResourceAmount(self.Entity, "energy")
		if self.energy > 0 then
			if self.needair then
				if self.air > 0 then
					RD_ConsumeResource(self.Entity, "air", self.size * Air_Increment)
					self.hasair = true
				else
					self.hasair = false
				end
			end
			if self.needcoolant then
				if self.coolant > 0 then
					RD_ConsumeResource(self.Entity, "coolant", self.size * Coolant_Increment)
					self.hasheat = true
				end
			end
			if self.needenergy then
				if self.energy > 0 then
					RD_ConsumeResource(self.Entity, "energy", self.size * Coolant_Increment)
					self.hasheat = true
				end
			end
			if self.giveGravity == 1 and gravity != 1 then
				RD_ConsumeResource(self.Entity, "energy", self.size * Coolant_Increment)
				gravity = 1
			end	
			RD_ConsumeResource(self.Entity, "energy", self.size * Energy_Increment)	
			if self.hasair then
				habitat = 1
			end
			if self.hasheat then
				temperature = 288
				if self.heat != 0
					self.heat = 0
				end
			end
			if not (WireAddon == nil) then Wire_TriggerOutput(self.Entity, "Air", self.hasair) end
			if not (WireAddon == nil) then Wire_TriggerOutput(self.Entity, "Heat", self.hasheat) end
		else
			self:TurnOff()
		end
	else
		self.presurized = 0			
	end
	SB_Update_Environment(self.num, nil, gravity, habitat, atmosphere, temperature)
	//SB_Update_Environment(self.num, nil, 1, 1, 1, 288)
end

function ENT:Think()
	self.BaseClass.Think(self)
	self:Climate_Control()
	self.Entity:NextThink(CurTime() + 1)
	return true
end

