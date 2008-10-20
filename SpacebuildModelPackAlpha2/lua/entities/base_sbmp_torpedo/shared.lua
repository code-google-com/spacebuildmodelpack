--[[
	BE SURE TO CHECK OUT BASE_SBMP_ENTITY! IT ALSO HAS LOADS OF USEFUL OPTIONS THAT YOU CAN USE FOR YOUR WEAPON!
	
	DO NOT! I REPEAT! DO NOT ADD AN EXPLOSION DAMANGE CAUSING STATMENT ON YOUR ON ENTITY KILL OR ONDAMAGE CALLBACKS!
	ONLY ADD AN EXPLOSION DAMAGE STATMENT IN YOUR ON FIRE CALLBACK!
--]]

ENT.Type            = "anim"
ENT.Base            = "base_sbmp_entity"

ENT.PrintName       = "Base SBMP Torpedo"
ENT.Author          = "Olivier 'LuaPineapple' Hamel"
ENT.Contact         = "evilpineapple@cox.net"
ENT.Purpose         = "Insta-ban justifier."
ENT.Instructions    = "There's a manual you know."
ENT.Category        = "Spacebuild Enhancement Project" -- Who changed the title?

ENT.Spawnable		= false
ENT.AdminSpawnable	= false

ENT.IsSBMPWeapon    = true -- DO, NOT, CHANGE, THIS!
ENT.StandAlone      = false -- Is this a stand alone missile? Or is it a seeking weapon fired by a launcher

ENT.IsDumbFire      = false -- No seeking, constant acceleration in a straight line
ENT.IsSeeking       = true  -- Is this weapon seeking?

ENT.FuelCache       = 4096 -- Can travel this many inchs, make it -1 to disable fuel need

ENT.HasAGIS         = true -- Has Advanced Guidance and Instruments Systems, (IE: It'll acquire a lockon by self after being fired if it's in it's firing cone)
ENT.AGISFiringCone  = .25  -- Uses DotProd so 1 is 1*pi radian (or 180 degrees) and two is 2*pi (or 360 degrees)

ENT.Speed           = 1024
ENT.TurnSpeed       = 128

ENT.LaunchSpeed     = 128 -- this * mass is applied on launch before ignition
ENT.PostLaunchIgnitionDelay = 0 -- (In seconds)

ENT.DisableDefaultDetonateOnCollide = false

ENT.GlobalIgnoreList = {} -- Do NOT define this in your SENT
ENT.IgnoreClassnames = {} -- Define this with strings as index in your own SENT, DON'T ADD THEM HERE.

function ENT:GetFwdDir() -- Incase your seeking weapon's model's forward direction isn't GetForward()
	return self:GetForward()
end

function ENT:OnBaseInit()
	if self.OnInit then
		self.OnInit()
	end
	
	if not self.StandAlone then
		return self:Launch()
	end
end

function ENT:Launch()
	self.IgnoreList = {}
	
	self.DetonatingNextFrame = false
	
	self.TargetVec = nil
	self.TargetEnt = nil
	
	self.LaunchTimestamp = CurTime()
	
	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then
		phys:ApplyForceCenter(self:GetFwdDir() * phys:GetMass() * self.LaunchSpeed)
	end
	
	if SERVER then
		if not self.IsDumbFire then
			self:StartMotionController()
		end
		
		if self.StandAlone and Wire_CreateInputs then
			self.Inputs = Wire_CreateInputs(self.Entity, {"Fire", "Self Destruct"})
		end
		
		self.Entity:SetUseType(USE_TOGGLE)
	end
	
	timer.Simple(self.PostLaunchIgnitionDelay, self.Ignition, self)
	
	if self.OnLaunch then
		self:OnLaunch()
	end
end

function ENT:OnDetonate(collisiondata, hitphysobj, selfdestructed)
	util.BlastDamage(self:GetPos(), self, self, 512, 512) -- Huh?
	
	return true
end

function ENT:ValidTarget(ent)
	if not (ent and ent.IsValid and ent:IsValid()) then return end
	if self.GlobalIgnoreList[ent] or self.IgnoreList[ent] then return end
	
	local phys = ent:GetPhysicsObject()
	
	if (not ((phys and phys:IsValid()) or ent:IsPlayer() or ent:IsVehicle() or ent:IsNPC())) then
		if self.IgnoreClassnames[ent:GetClass()] then
			return
		else
			self.IgnoreList[ent] = ent
		end
	else
		self.GlobalIgnoreList[ent] = ent
	end
end

function ENT:SetTargetEnt(ent, do_not_check)
	if (not do_not_check) and (not self:ValidTarget(ent)) then return end
	
	-- so you can filter out some entities, it'll never try to reaquire them though, so be careful.
	if self.OnAcquireTargetEnt and (not self:OnAcquireTargetEnt(ent)) then
		self.IgnoreList[ent] = ent
	end
	
	self.TargetEnt = ent
end

function ENT:SetTargetVec(vec)
	if not (vec and vec.Dot and vec.Length) then return end -- Quick test to see if it's a vector
	
	self.TargetVec = vec
end

-- TODO: Add code to make AGIS enabled seeking weapons to circle around to try and pick up a new target.
function ENT:DoDumbFireAcceleration()
	-- If we're ignited and either we're a dumb fire or we don't have a lock on then accelerate forward
	if self.Ignited and (self.IsDumbFire or ((not self.TargetEnt) and (not self.TargetVec))) then
		self:SetVelocityInstantaneous(self:GetFwdDir() * phys:GetMass() * self.LaunchSpeed)
		
		return true
	end
end

function ENT:OnBaseThink()
	self:DoDumbFireAcceleration()
	
	if self.DetonatingNextFrame then
		if self:OnDetonate(unpack(self.DetonatingNextFrame)) then -- if you return false then we consider we've failed detonation and continue as normal
			return self:Remove()
		else
			self.DetonatingNextFrame = false
		end
	end
	
	if self.OnThink then
		return self:OnThink()
	end
end

function ENT:OnBaseWireInput(iname, value)
	if not self.StandAlone then return end
	
	if self.OnWireInput then
		return self:OnWireInput(iname, value)
	elseif (iname == "Fire") and (value == 1) then
		return self:Ignition()
	elseif (iname == "Self Destruct") and (value == 1) then
		return self:SelfDestruct()
	end
end

function ENT:Ignition()
	if not (self and self.IsValid and self:IsValid()) then return end
	
	self.Ignited = true
	
	if self.IgnitionFX then
		local fx = EffectData()
		fx:SetEntity(self.Entity)
		util.Effect(self.IgnitionFX, fx, true, true)
	end
	
	if self.OnIgnition then
		return self:OnIgnition()
	end
end

function ENT:SelfDestruct(delay)
	if delay then
		return timer.Simple(delay, self.SelfDestruct, self)
	end
	
	if not self.SelfDestructData then
		self.SelfDestructData = {}
		self.SelfDestructData.HitEntity      = self.Entity
		self.SelfDestructData.HitObject      = self:GetPhysicsObject()
		self.SelfDestructData.Delta          = 0
	end
	
	self.SelfDestructData.HitPos         = self:GetPos() + self:OBBCenter()
	self.SelfDestructData.OurOldVelocity = self:GetVelocity()
	self.SelfDestructData.Speed          = self.SelfDestructData.OurOldVelocity:Length()
	self.SelfDestructData.HitNormal      = self:GetFwdDir()
	
	self.DetonatingNextFrame = {self.SelfDestructData, self.SelfDestructData.HitObject, true}
end

function ENT:OnTakeDamage(dmginfo)
	self:TakePhysicsDamage(dmginfo)
	
	if self.OnDamage then
		return self:OnDamage(dmginfo)
	end
end

function ENT:PhysicsCollide(data, physobj)
	if self.DetonatingNextFrame then return end
	
	if not self.DisableDefaultDetonateOnCollide then
		self.DetonatingNextFrame = {data, physobj}
	end
end
