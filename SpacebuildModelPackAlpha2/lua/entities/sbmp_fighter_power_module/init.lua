//From Spacetech's BH Cache, and his dubiously implemented shield
//And from my old joystick module, from which this evolved from
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

util.PrecacheSound("coast.siren_citizen")

local MAX_JS_VAL  = 255
local HALF_MAX_JS_VAL = MAX_JS_VAL*.5
local TEMP_REGULATION_ENABLED = true
local ShieldRepairTime		  = 20 //in seconds
local ShieldRepairMulti       = 100 / ShieldRepairTime

ENT.WireDebugName = "All-In-One Fighter Module"
ENT.OverlayDelay  = 0

ENT.JSOutputs	  = {"Axis 1", "Axis 2", "Axis 3", "Axis 4", "Axis 5", "Axis 6", "Button 1", "Button 2", "Button 3", "Button 4", "Button 5", "Button 6", "Button 7", "Button 8", "Button 9", "Button 10"}
ENT.NavInputs	  = {0,0,0,0,0} //pitch,yaw,roll,speed,yaw->roll
ENT.MasterTable	  = {} //to be overriden

ENT.Resources     = {"energy", "air", "coolant", "ammo_basic", "ammo_pierce", "ammo_explosion", "ammo_fuel"}
ENT.ResourceNames = {"Energy", "Air", "Coolant", "Conventional Ammunition", "Piercing Ammunition", "Explosive Ammunition", "Conventional Fuel"}
ENT.OutputTable   = {"Energy", "Air", "Coolant", "Conventional Ammunition", "Piercing Ammunition", "Explosive Ammunition", "Conventional Fuel", "Axis 1", "Axis 2", "Axis 3", "Axis 4", "Axis 5", "Axis 6", "Button 1", "Button 2", "Button 3", "Button 4", "Button 5", "Button 6", "Button 7", "Button 8", "Button 9", "Button 10"}
ENT.MaxAmounts    = {2000, 500, 1500, 1500, 1000, 1000, 2000}
ENT.RechargeRates = {200,  25,  100,  100,  50,   50,   100}

ENT.TimeTo		  = 1
ENT.MaxAng		  = 100000000
ENT.MaxAngDamp	  = 100000000
ENT.MaxSpeed	  = 1000000
ENT.MaxSpeedDamp  = 10000
ENT.TeleDist	  = 0

ENT.MaxTurnRate	  = 45/HALF_MAX_JS_VAL //the maximum change in ang per frame

ENT.ShieldDamaged = false
ENT.ShieldRepairStatus = ShieldRepairTime

local MaxTerminalDamage = 350
ENT.TerminalDamage = 0

local function MergeTbl(tbl,tbl2)
	for k,v in pairs(tbl2) do
		table.insert(tbl,v)
	end
	table.insert(tbl,"Shield Structural Integrity")
	return tbl
end

function ENT:SpawnFunction(ply, tr)
	if(!tr.Hit) then return end
	local ent = ents.Create("sbmp_fighter_power_module")
	ent:SetPos(tr.HitPos + (tr.HitNormal * 32))
	ent:Spawn()
	ent:Activate()
	if not ply.SBMP_JSEnts then
		ply.SBMP_JSEnts = {}
	end
	table.insert(ply.SBMP_JSEnts,ent)
	return ent
end

function ENT:Initialize()
	self.Entity:SetModel("models/Spacebuild/emount4_fighter.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	
	for k, res in pairs(self.Resources) do
		RD_AddResource(self.Entity, res, self.MaxAmounts[k])
		RD_SupplyResource(self.Entity, res, self.MaxAmounts[k])
	end
	
	local Phys = self.Entity:GetPhysicsObject()
	if(Phys:IsValid()) then
		Phys:Wake()
		Phys:SetMass(3500) // a bit heavyer please
	end
	
	if(WireAddon != nil) then
		self.Outputs = Wire_CreateOutputs(self.Entity, self.OutputTable)
		for k,v in ipairs(self.Resources) do	
			Wire_TriggerOutput(self.Entity, self.ResourceNames[k], self.MaxAmounts[k])
		end
		Wire_TriggerOutput(self.Entity, "Shield Structural Integrity",100)
	end
	
	self.Entity:StartMotionController()
end

function ENT:Think()
	local phys = self:GetPhysicsObject()
	if phys and phys:IsValid() then
		phys:Wake()
	end
	for k, res in ipairs(self.Resources) do
		local diff = (self.MaxAmounts[k] - RD_GetResourceAmount(self.Entity, res))
		if diff > 0 then
			RD_SupplyResource(self.Entity, res, math.Clamp(diff,0,self.MaxAmounts[k]))
		end
	end
	self:ProcessContraption()
	self.Entity:NextThink(CurTime() + 1)
end

function ENT:ProcessContraption()
	local entities = {}
	local consts = {}
	local energy = RD_GetResourceAmount(self.Entity,"energy")
	local coolant = RD_GetResourceAmount(self.Entity,"coolant")
	local heating_cost = 0
	local cooling_cost = 0
	
	if self.entities then
		for k,v in pairs(self.entities) do
			v.Shield = nil
		end
	end
	
	self.entities, consts = self:GetNextPart(self.Entity, entities, consts)
	
	if self.entities then
		for k,ent in pairs(self.entities) do
			local phys = ent:GetPhysicsObject()
			if phys and phys:IsValid() then
				phys:EnableGravity(false)
			end

			local cost = math.abs(ent.heat or 0)/5
			
			if not self.ShieldDamaged then
				ent.Shield = self.Entity
			end
			
			if not ent.heat then ent.heat = 0 end
			
			if ent.heat  < 0 then
				if (energy-cost) > 0 then
					energy_cost = energy_cost + cost
					energy = energy - cost
					ent.heat = ent.heat - ent.heat/10
					if ent.suit and ent.suit.energy < 100 then //HUh? In case somone get's welded to your ship's ass
						ent.suit.energy = 100
					end
				end
			elseif 0 > 0 then
				if (coolant-cost) > 0 then
					coolant_cost = coolant_cost + cost
					coolant = coolant - cost
					ent.heat = ent.heat - ent.heat/10
					if ent.suit and ent.suit.coolant < 100 then
						ent.suit.coolant = 100
					end
				end
			end
		end
	end
	
	RD_ConsumeResource(self, "energy",  heating_cost)
	RD_ConsumeResource(self, "coolant", cooling_cost)
	
	for k,v in ipairs(self.Resources) do	
		Wire_TriggerOutput(self.Entity, self.ResourceNames[k], RD_GetResourceAmount(self.Entity, v))
	end
end

function ENT:GetNextPart(ent,EntTable,ConstraintTable)
    if (!ent:IsValid()) then return end
	EntTable[ ent:EntIndex() ] = ent
    if (!constraint.HasConstraints(ent)) then return end
    for key, ConstraintEntity in pairs(ent.Constraints) do
        if (!ConstraintTable[ ConstraintEntity ]) then
            ConstraintTable[ ConstraintEntity ] = true
            if (ConstraintEntity[ "Ent" ] && ConstraintEntity[ "Ent" ]:IsValid()) then
                self:GetNextPart(ConstraintEntity[ "Ent" ].Entity, EntTable, ConstraintTable)
            else
                for i=1, 10 do
                    if (ConstraintEntity[ "Ent"..i ] && ConstraintEntity[ "Ent"..i ]:IsValid()) then
                        self:GetNextPart(ConstraintEntity[ "Ent"..i ].Entity, EntTable, ConstraintTable)
                    end
                end
            end
		end
    end    
	return EntTable, ConstraintTable
end

function ENT:ShieldDamage(amount)
	if self.ShieldDamaged then //fuck, terminal damage!
		self.TerminalDamage = self.TerminalDamage + amount
		if self.TerminalDamage >= MaxTerminalDamage then
			self:Detonation()
		end
	else
		local power = RD_GetResourceAmount(self.Entity,"energy")
		if power-amount >= 0 then
			RD_ConsumeResource(self, "energy", amount)
		else
			RD_ConsumeResource(self, "energy", power)
			self.ShieldDamaged = true
			self.ShieldRepairStatus = 0
			self:SoundAlarm()
			timer.Simple(1,self.RestoreTimerTick,self)
		end
	end
end

function ENT:Detonate() //"Poor Johny...." -- (Guess from where this came from....)
	local Dir = self:GetVelocity():Normalize()
	local Pos = self:OBBCenter()+self:GetPos()
		
	local fx_Disruption = EffectData()
	local fx_Explode = EffectData()
	local fx_Shockwave = EffectData()
	
	fx_Disruption:SetOrigin(Pos)
	fx_Explode:SetMagnitude(math.random(7,13))
	fx_Explode:SetOrigin(Pos)
	fx_Explode:SetScale(50)
	fx_Shockwave:SetMagnitude(1)
	fx_Shockwave:SetOrigin(Pos)
end

function ENT:SoundAlarm()
	if self.entities then
		for k,v in pairs(self.entities) do
			v.Shield = nil
		end
	end
	self.Entity:EmitSound("coast.siren_citizen",50,50)
	Wire_TriggerOutput(self.Entity, "Shield Structural Integrity", 0)
end

function ENT:EndAlarm()
	self.Entity:StopSound("coast.siren_citizen")
	self.ShieldDamaged = false
	self:ProcessContraption()
end

function ENT:RestoreTimerTick()
	if not (self and self.Entity and self.Entity:IsValid()) then return end
	self.ShieldRepairStatus = self.ShieldRepairStatus+1
	Wire_TriggerOutput(self.Entity, "Shield Structural Integrity", self.ShieldRepairStatus*ShieldRepairMulti)
	if self.ShieldRepairStatus >= ShieldRepairTime then
		self:EndAlarm()
	else
		timer.Simple(1, self.RestoreTimerTick,self)
	end
end

function ENT:PhysicsSimulate(phys, deltatime)
	phys:Wake()
	phys:EnableGravity(false)

	tbl = {}
	tbl.secondstoarrive		= self.TimeTo		// How long it takes to move to pos and rotate accordingly - only if it _could_ move as fast as it want - damping and maxspeed/angular will make this invalid
	tbl.pos					= self:CalcPos()	// Where you want to move to
	tbl.angle				= self:CalcAng()	// Angle you want to move to
	tbl.maxangular 			= self.MaxAng		//What should be the maximal angular force applied
	tbl.maxangulardamp 		= self.MaxAngDamp	// At which force/speed should it start damping the rotation
	tbl.maxspeed 			= self.MaxSpeed		// Maximal linear force applied
	tbl.maxspeeddamp		= self.MaxSpeedDamp // Maximal linear force/speed before  damping
	tbl.dampfactor			= self.DampPercent	// The percentage it should damp the linear/angular force if it reachs it's max ammount
	tbl.teleportdistance	= self.TeleDist		// The distance before it'll teleport to where it wants to be, if it's 0 it never will
	tbl.deltatime			= deltatime			// Irrelevant; Use std. deltatime
	phys:ComputeShadowControl(tbl)
end

function ENT:CalcPos()
	return (self:GetPos()+self:GetForward()*self.NavInputs[4]*-5)
end

function ENT:CalcAng()
	local pitch = self:CalcPitch()
	local yaw   = self:CalcYaw()
	local roll  = self:CalcRoll()

	local ang = self:GetAngles()
	ang:RotateAroundAxis(self:GetRight(),   pitch) //Rotate around the right. Thing about it.
	ang:RotateAroundAxis(self:GetUp(),      yaw)   //Rotate around the up to turn the yaw
	ang:RotateAroundAxis(self:GetForward(), roll)  //Rotate around the forward, this'll make you roll, or rather, it should. :S
	
	return ang
end

function ENT:CalcPitch()
	return self.MaxTurnRate*self.NavInputs[1]
end

function ENT:CalcYaw()
	local val = self.NavInputs[2]
	if self.NavInputs[5] then
		val = 0
	end
	return (self.MaxTurnRate*val*-1)
end

function ENT:CalcRoll()
	local val = self.NavInputs[3]
	if self.NavInputs[5] then
		val = self.NavInputs[2]
	end
	return (self.MaxTurnRate*val)
end

function ENT:OnRemove()
	if self.entities then
		for k,v in pairs(self.entities) do
			v.Shield = nil
		end
	end
	self.Entity:StopSound("coast.siren_citizen")
	Dev_Unlink_All(self.Entity)
	self:StopMotionController()
end

function ENT:Update(args)
	local idx = tonumber(args[1])
	local val = tonumber(args[2])
	if (idx < 4) then
		self.NavInputs[idx] = val - HALF_MAX_JS_VAL //make it 0 centered
	elseif idx == 4 then
		self.NavInputs[idx] = val - MAX_JS_VAL //make it 0 based,
	elseif idx == 5 then
		self.NavInputs[idx] = val //let it as it is
	elseif idx == 7 then
		self.NavInputs[5] = (val == 1) //ITS A BOOLEAN VALUE! RUN!!
	end
	
	Wire_TriggerOutput(self.Entity, self.JSOutputs[idx] or "Button 10", val or 0)
end

function ENT:ShowOutput(value)
	self:SetOverlayText("Fighter Module")
end

function ENT:PostEntityPaste(ply, ent, CreatedEntities)
	if not ply.SBMP_JSEnts then
		ply.SBMP_JSEnts = {}
	end
	table.insert(ply.SBMP_JSEnts,ent)
end

local function SBMP_JSUpdate_CC(pl,cmd,args)
	if not pl.SBMP_JSEnts then
		pl.SBMP_JSEnts = {}
	end
	for k,v in pairs(pl.SBMP_JSEnts) do
		if v and ValidEntity(v) then
			v:Update(args)
		else
			table.remove(pl.SBMP_JSEnts,k)
		end
	end
end
concommand.Add("sbmp_update_fighter_data",SBMP_JSUpdate_CC)