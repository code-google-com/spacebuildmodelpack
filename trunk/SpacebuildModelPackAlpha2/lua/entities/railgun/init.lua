AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
util.PrecacheSound( "ambient.steam01" )

include('shared.lua')

local Ground = 1 + 0 + 2 + 8 + 32

function ENT:Initialize()
	self.BaseClass.Initialize(self)
	self.damaged = 0
	self.lastfire = 0
	self.delay = 0.5
	self.force = 5000
	self.type = 0
	if not (WireAddon == nil) then
		self.WireDebugName = self.PrintName
		self.Inputs = Wire_CreateInputs(self.Entity, { "Force type", "fire"})
		self.Outputs = Wire_CreateOutputs(self.Entity, { "Energy", "Coolant", "Type"})
	end
end

function ENT:FireRail(ply)
	Msg("Firing fire\n")
	//local ent = ents.Create( "railgun_ammo" )
	local ent = ents.Create( "cds_physical_bullet" )
			ent:SetPos( self.Entity:GetPos() + (self.Entity:GetForward() * -80))
			ent:SetAngles( self.Entity:GetAngles( ) )
			ent:SetOwner( ply )
		ent:Spawn( )
		ent:SetForce(self.force)
		local obj = self.Entity:GetPhysicsObject() 
		if obj:IsValid() then
			obj:ApplyForceCenter( self.Entity:GetForward() * self.force ) 
		end
		ent.Force = self.force
		constraint.NoCollide(self.Entity, ent, 0, 0)
		self.lastfire = CurTime()
end

function ENT:TriggerInput(iname, value)
	if iname == "Force type" then
		if value >= 0 then
			/*if value == 0 then
				self.force = 5000
				self.type = 0
			elseif value == 1 then
				self.force = 10000
				self.type = 1
			elseif value == 2 then
				self.force = 40000
				self.type = 2
			elseif value == 3 then
				self.force = 100000
				self.type = 3
			end*/
			self.force = value
		end
	elseif iname == "fire" then
		if(CurTime() > self.lastfire + (self.delay * (self.type+1))) then
			self:FireRail()
		end
	end
end

function ENT:Damage()
	if (self.damaged == 0) then
		self.damaged = 1
	end
end

function ENT:Repair()
	self.Entity:SetColor(255, 255, 255, 255)
	self.health = self.maxhealth
	self.damaged = 0
end

function ENT:Destruct()
	LS_Destruct( self.Entity, true )
end

function ENT:Use( pl)
	if(CurTime() > self.lastfire + (self.delay * (self.type+1))) then
		self:FireRail(pl)
		Msg("Firing use\n")
	end
end

function ENT:OnRemove()
	self.BaseClass.OnRemove(self)
end

function ENT:Think()
	self.BaseClass.Think(self)
	if not (WireAddon == nil) then 
		self:UpdateWireOutput()
	end
	
	self.Entity:NextThink(CurTime() + 1)
	return true
end

function ENT:UpdateWireOutput()
	local energy = RD_GetResourceAmount(self, "energy")
	local coolant = RD_GetResourceAmount(self, "coolant")
	
	Wire_TriggerOutput(self.Entity, "Type", self.type)
	Wire_TriggerOutput(self.Entity, "Energy", energy)
	Wire_TriggerOutput(self.Entity, "Coolant", coolant)
end
