AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('entities/base_wire_entity/init.lua')
include('shared.lua')

local STATE_IDLE       = 1
local STATE_GOING_UP   = 2
local STATE_GOING_DOWN = 3

ENT.WireDebugName = "Lift"
ENT.OverlayDelay  = 0

ENT.TimeTo		  = .0001
ENT.MaxAng		  = 100000000
ENT.MaxAngDamp	  = 100000000
ENT.MaxSpeed	  = 100000000
ENT.MaxSpeedDamp  = 100000000
ENT.TeleDist	  = 0

ENT.MaxTurnRate	  = 100000000

ENT.InputTable    = {"Lift Duration (Def. 5)", "Up", "Down", "Toggle", "Auto", "Lock"}
ENT.OutputTable   = {"ETA", "Going Up", "Going Down"}

function ENT:Initialize()
	--self.Entity:SetModel("models/SmallBridge/SBpanelelev2s/sbpanelelev2s.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	
	local Phys = self.Entity:GetPhysicsObject()
	
	if Phys:IsValid() then
		Phys:Wake()
		Phys:SetMass(90001)
	end
	
	self.StopTimestamp  = self.StopTimestamp or 0
	
	self.Speed = self.Speed or 5
	self.Perc  = self.Perc  or 1
	
	self.State     = self.State     or STATE_IDLE
	self.PrevState = self.PrevState or STATE_GOING_DOWN
	
	self.AutoTrigger = true
	
	if Wire_CreateInputs and Wire_CreateOutputs then
		self.Inputs  = Wire_CreateInputs( self.Entity, self.InputTable)
		self.Outputs = Wire_CreateOutputs(self.Entity, self.OutputTable)
	end
	
	self.PhysSimTbl = {}
	self.PhysSimTbl.secondstoarrive		= self.TimeTo		// How long it takes to move to pos and rotate accordingly - only if it _could_ move as fast as it want - damping and maxspeed/angular will make this invalid
	self.PhysSimTbl.maxangular 			= self.MaxAng		// What should be the maximal angular force applied
	self.PhysSimTbl.maxangulardamp 		= self.MaxAngDamp	// At which force/speed should it start damping the rotation
	self.PhysSimTbl.maxspeed 			= self.MaxSpeed		// Maximal linear force applied
	self.PhysSimTbl.maxspeeddamp		= self.MaxSpeedDamp // Maximal linear force/speed before  damping
	self.PhysSimTbl.dampfactor			= self.DampPercent	// The percentage it should damp the linear/angular force if it reachs it's max ammount
	self.PhysSimTbl.teleportdistance	= self.TeleDist		// The distance before it'll teleport to where it wants to be, if it's 0 it never will
	
	self.TouchingPlayers = {}
	
	timer.Simple(.1, self.SetupControlPoints, self)
end

function ENT:TriggerInput(iname, value)
	if not (iname and value) then return end
	
	if not self.Locked then
		if (iname == "Lift Duration (Def. 5)") and (value >= 1) then
			self:SetSpeed(value)
		elseif (iname == "Up")     and (value == 1) then
			self:GoUp()
		elseif (iname == "Down")   and (value == 1) then
			self:GoDown()
		elseif (iname == "Toggle") and (value == 1) then
			self:Toggle()
		elseif (iname == "Auto") then
			self.AutoTrigger = (value == 1)
		end
	end
	
	if iname == "Lock" then
		self.Locked = (value == 1)
	end
end

function ENT:OnTakeDamage(dmg)
	local phys = self:GetPhysicsObject()
	
	if phys and phys:IsValid() then
		phys:Wake()
	end
	
	return self:TakePhysicsDamage(dmg)
end

function ENT:SetSpeed(speed)
	self.StopTimestamp = CurTime() + (speed * (1 - self.Perc))
	
	self.Speed = speed
end

function ENT:GoUp()
	if (self.State == STATE_GOING_UP) or ((self.State == STATE_IDLE) and (self.PrevState == STATE_GOING_UP)) then return end
	
	self.StopTimestamp = CurTime() + (self.Speed * self.Perc)
	
	self.PrevState = self.State
	self.State = STATE_GOING_UP
	
	--print("State: Going up.")
end

function ENT:GoDown()
	if (self.State == STATE_GOING_DOWN) or ((self.State == STATE_IDLE) and (self.PrevState == STATE_GOING_DOWN)) then return end
	
	self.StopTimestamp = CurTime() + (self.Speed * self.Perc)
	
	self.PrevState = self.State
	self.State = STATE_GOING_DOWN
	
	--print("State: Going down.")
end

function ENT:Toggle()
	if (self.State == STATE_IDLE) and (self.PrevState == STATE_GOING_DOWN) then
		return self:GoUp()
	elseif self.State == STATE_GOING_UP then
		return self:GoDown()
	elseif self.State == STATE_GOING_DOWN then
		return self:GoUp()
	else
		return self:GoDown()
	end
end

function ENT:Think()
	local CTime = CurTime()
	local phys  = self:GetPhysicsObject()
	
	if phys and phys:IsValid() then
		phys:Wake()
	end
	
	if Wire_TriggerOutput and (self.State ~= STATE_IDLE) then
		Wire_TriggerOutput(self.Entity, "ETA", self.StopTimestamp - CTime)
	end
	
	return self:NextThink(CTime + .1)
end

function ENT:Touch(ent)
	local CTime = CurTime()
	
	self.TouchingPlayers[ent] = self.TouchingPlayers[ent] or 0
	
	if not (self.AutoTrigger and (self.State == STATE_IDLE) and ent and ent:IsPlayer() and (self.TouchingPlayers[ent] < CTime)) then return end
	
	self.TouchingPlayers[ent] = CTime + self.Speed + 3
	
	return self:Toggle()
end

function ENT:PhysicsSimulate(phys, deltatime)
	if self.Entity:IsPlayerHolding() then return SIM_NOTHING end
	
	self.Perc = 1
	
	if self.State ~= STATE_IDLE then
		self.Perc = 1 - ((self.StopTimestamp - CurTime()) / self.Speed)
		
		--print(self.Perc)
	end
	
	if self.Perc > 1 then
		self.PrevState = self.State
		self.State = STATE_IDLE
		
		self.Perc = 1
		
		--print("Now Idle.")
	end
	
	phys:EnableGravity(false)
	
	self.PhysSimTbl.pos       = self:CalcPos() // Where you want to move to
	self.PhysSimTbl.angle     = self:CalcAng() // Angle you want to move to
	self.PhysSimTbl.deltatime = deltatime      // Irrelevant; Use std. deltatime
	
	return phys:ComputeShadowControl(self.PhysSimTbl)
end

function ENT:CalcPos()
	if self.State == STATE_GOING_DOWN then
		return LerpVector(self.Perc, self.TopCntrlPnt:GetPos(), self.BottomCntrlPnt:GetPos())
	elseif self.State == STATE_GOING_UP then
		return LerpVector(self.Perc, self.BottomCntrlPnt:GetPos(), self.TopCntrlPnt:GetPos())
	elseif self.PrevState == STATE_GOING_UP then
		return LerpVector(self.Perc, self.BottomCntrlPnt:GetPos(), self.TopCntrlPnt:GetPos())
	else
		return LerpVector(self.Perc, self.TopCntrlPnt:GetPos(), self.BottomCntrlPnt:GetPos())
	end
end

function ENT:CalcAng(perc)
	if self.State == STATE_GOING_DOWN then
		return LerpAngle(self.Perc, self.TopCntrlPnt:GetAngles(), self.BottomCntrlPnt:GetAngles())
	elseif self.State == STATE_GOING_UP then
		return LerpAngle(self.Perc, self.BottomCntrlPnt:GetAngles(), self.TopCntrlPnt:GetAngles())
	elseif self.PrevState == STATE_GOING_UP then
		return LerpAngle(self.Perc, self.BottomCntrlPnt:GetAngles(), self.TopCntrlPnt:GetAngles())
	else
		return LerpAngle(self.Perc, self.TopCntrlPnt:GetAngles(), self.BottomCntrlPnt:GetAngles())
	end
end

function ENT:OnRemove()
	return self:StopMotionController()
end

function ENT:SetupControlPoints(TopCntrlPnt, BottomCntrlPnt)
	if (not (self and self:IsValid())) or self.HasEmitters then return print("invalid or have emitters.") end
	
	self.HasEmitters = true
	
	self.Entity:StartMotionController()
	
	--self:GetPhysicsObject():EnableMotion(false)
	
	if not TopCntrlPnt then
		TopCntrlPnt = ents.Create("sbmp_lift_ghost")
		TopCntrlPnt:SetModel(self:GetModel())
		TopCntrlPnt:SetPos(self:GetPos())
		TopCntrlPnt:SetAngles(self:GetAngles())
		TopCntrlPnt:Spawn()
		TopCntrlPnt:GetPhysicsObject():EnableMotion(false)
		
		BottomCntrlPnt = ents.Create("sbmp_lift_ghost")
		BottomCntrlPnt:SetModel(self:GetModel())
		BottomCntrlPnt:SetPos(self:GetPos())
		BottomCntrlPnt:SetAngles(self:GetAngles())
		BottomCntrlPnt:Spawn()
		BottomCntrlPnt:GetPhysicsObject():EnableMotion(false)
	end
	
	local const1 = constraint.NoCollide(self.Entity, TopCntrlPnt,    0, 0)
	local const2 = constraint.NoCollide(self.Entity, BottomCntrlPnt, 0, 0)
	local const3 = constraint.NoCollide(TopCntrlPnt, BottomCntrlPnt, 0, 0)
	
	self.Entity:DeleteOnRemove(TopCntrlPnt)
	self.Entity:DeleteOnRemove(BottomCntrlPnt)
	
	self.Entity:DeleteOnRemove(const1)
	self.Entity:DeleteOnRemove(const2)
	self.Entity:DeleteOnRemove(const3)
	
	TopCntrlPnt:DeleteOnRemove(self.Entity)
	BottomCntrlPnt:DeleteOnRemove(self.Entity)
	
	self.TopCntrlPnt    = TopCntrlPnt
	self.BottomCntrlPnt = BottomCntrlPnt
end

function ENT:PreEntityCopy() -- build the DupeInfo table and save it as an entity mod
	local SBMPLift = {}
	
	SBMPLift.TopCntrlPnt    = self.TopCntrlPnt:EntIndex()
	SBMPLift.BottomCntrlPnt = self.BottomCntrlPnt:EntIndex()
	
	SBMPLift.State     = self.State
	SBMPLift.PrevState = self.PrevState
	
	SBMPLift.Speed = self.Speed 
	SBMPLift.Perc  = self.Perc
	
	return duplicator.StoreEntityModifier(self.Entity, "SBMPLift", SBMPLift)
end

function ENT:PostEntityPaste(Player, Ent, CreatedEntities)
	if Ent.EntityMods and Ent.EntityMods.SBMPLift then
		if Ent.EntityMods.SBMPLift then
			local TopCntrlPnt = CreatedEntities[Ent.EntityMods.SBMPLift.TopCntrlPnt]
			
			if not (TopCntrlPnt and TopCntrlPnt:IsValid()) then
				if not (CreatedEntities.EntityList and CreatedEntities.EntityList[Ent.EntityMods.SBMPLift.TopCntrlPnt]) then
					TopCntrlPnt = ents.GetByIndex(Ent.EntityMods.SBMPLift.TopCntrlPnt)
				end
			end
			
			if TopCntrlPnt and TopCntrlPnt:IsValid() then
				self:SetNWEntity("TopCntrlPnt", TopCntrlPnt)
			else
				Error("ApplyDupeInfo: Error, Could not find the top Lift control point.\n")
			end
			
			local BottomCntrlPnt = CreatedEntities[Ent.EntityMods.SBMPLift.BottomCntrlPnt]
			
			if not (BottomCntrlPnt and BottomCntrlPnt:IsValid()) then
				if not (CreatedEntities.EntityList and CreatedEntities.EntityList[Ent.EntityMods.SBMPLift.BottomCntrlPnt]) then
					BottomCntrlPnt = ents.GetByIndex(Ent.EntityMods.SBMPLift.BottomCntrlPnt)
				end
			end
			
			if BottomCntrlPnt and BottomCntrlPnt:IsValid() then
				self:SetNWEntity("BottomCntrlPnt", BottomCntrlPnt)
			else
				Error("ApplyDupeInfo: Error, Could not find the bottom Lift control point.\n")
			end
			
			self:SetupControlPoints(TopCntrlPnt, BottomCntrlPnt)
			
			self.State     = Ent.EntityMods.SBMPLift.State
			self.PrevState = Ent.EntityMods.SBMPLift.PrevState
			
			self.Speed = Ent.EntityMods.SBMPLift.Speed
			self.Perc  = Ent.EntityMods.SBMPLift.Perc
			
			self.StopTimestamp = CurTime() + (self.Speed * (1 - self.Perc))
		end
	end
end

function ENT:BuildDupeInfo()
end

function ENT:ApplyDupeInfo(ply, ent, data, CreatedEntities)
end

function ENT.AfterPasteMods(ply, Ent, DupeInfo)
end
duplicator.RegisterEntityModifier("SBMPLift", ENT.AfterPasteMods)