
SWEP.Author			= "Levybreak"
SWEP.Contact		= "Facepunch"
SWEP.Purpose		= "I CAN'T HEAR YOU OVER THE ROAR OF MY ENGINES!"
SWEP.Instructions	= "Enable for (limited) flight in space."

SWEP.Base				= "weapon_base"
SWEP.HoldType			= "gravgun"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true
SWEP.ViewModelFlip	= false

SWEP.ViewModel			= "models/Slyfo_2/mmu_mk_1.mdl"
--SWEP.WorldModel			= "models/Slyfo_2/mmu_mk_1.mdl"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.MaxFuel = 500
SWEP.Fuel = 0
SWEP.Active = false
SWEP.ConsumptionAmt = 100

local SwepThrustSound = "npc/env_headcrabcanister/hiss.wav"
local SwepThrustSoundObj = Sound(SwepThrustSound)
local FuelConsumption = 25
local ThrustForce = 400
local offset = Vector(0,0,25)

function SWEP:Reload()
	if SERVER then
		local ply = self.Owner
		local trace = ply:GetEyeTrace()
		if not CAF then print("CAF Not installed!") return end
		local RD = CAF.GetAddon("Resource Distribution")
		if ply:GetPos():Distance(trace.HitPos) < 250 and trace.Entity and trace.Entity:IsValid() then
			local energy = RD.GetResourceAmount(trace.Entity, "energy")
			if energy and energy > 100 then
				local maxfuel = math.floor(energy/self.ConsumptionAmt)
				local fuelneeded = math.Clamp(math.Clamp(self.MaxFuel - self.Fuel,0,maxfuel),0,self.MaxFuel)
				RD.ConsumeResource(trace.Entity,"energy",fuelneeded*self.ConsumptionAmt)
				self.Fuel = self.Fuel + fuelneeded
			end
		end
	end
end

function SWEP:Initialize()
	self.Fuel = self.MaxFuel
	self.CanBurstAgain = false
	self.LastTime = CurTime()
	if CLIENT then
		hook.Add("Think","LolFuelUpdateThinkz",function()
			self.Fuel = self:GetNWInt("Fuel")
		end)
	end
	if SERVER then
		timer.Simple(1,function()
		local model = "models/Slyfo_2/mmu_mk_1.mdl"
		self.Unit = ents.Create("prop_physics")
		self.Unit:SetModel(model)
		self.Unit:SetPos(self.Owner:GetPos()+offset)
		self.Unit:SetAngles(self.Owner:GetAngles())
		self.Unit:SetParent(self.Owner)
		end)
	end
end

function SWEP:Think()
	if not counter then counter = 0 end
	if counter >= 150 then
		self.Fuel = math.Clamp(self.Fuel+1,0,self.MaxFuel)
		counter = 0
	end
	counter = counter + 1
	if SERVER then
		self:SetNWInt("Fuel",self.Fuel)
	end
end

local ZeroVec = Vector(0,0,0)
function MMUThink(swep)
	local ply = swep.Owner
	if not ply:Alive() then 
		swep:ToggleMMUActivation(ply,false) 
		swep.Unit:SetParent() 
		swep.Unit:Remove() 
		if swep.SoundFileThing then swep.SoundFileThing:Stop() end
		return 
	end
	if not ply.MMV then ply.MMV = false end
	if (swep.LastTime + 2.5) <= CurTime() then swep.LastTime = CurTime(); swep.CanBurstAgain = true end
	if swep.CanBurstAgain != true then return end
	if ply.MMV == true and (SERVER) and (swep.Fuel >= FuelConsumption) then
		if ply:KeyDown(IN_FORWARD) then
			if swep.SoundFileThing then swep.SoundFileThing:Stop() end
			ply:SetLocalVelocity((ply:GetAimVector()*ThrustForce))
			swep.CanBurstAgain = false
			swep.SoundFileThing = CreateSound(ply,SwepThrustSoundObj)
			swep.SoundFileThing:Play()
			swep.Fuel = math.Clamp(swep.Fuel-FuelConsumption,0,swep.MaxFuel)
		elseif ply:KeyDown(IN_BACK) then
			if swep.SoundFileThing then swep.SoundFileThing:Stop() end
			ply:SetLocalVelocity((ply:GetAimVector()*-ThrustForce))
			swep.CanBurstAgain = false
			swep.SoundFileThing = CreateSound(ply,SwepThrustSoundObj)
			swep.SoundFileThing:Play()
			swep.Fuel = math.Clamp(swep.Fuel-FuelConsumption,0,swep.MaxFuel)
		elseif ply:KeyDown(IN_MOVELEFT) then
			if swep.SoundFileThing then swep.SoundFileThing:Stop() end
			ply:SetLocalVelocity((ply:GetAngles():Right()*-ThrustForce))
			swep.CanBurstAgain = false
			swep.SoundFileThing = CreateSound(ply,SwepThrustSoundObj)
			swep.SoundFileThing:Play()
			swep.Fuel = math.Clamp(swep.Fuel-FuelConsumption,0,swep.MaxFuel)
		elseif ply:KeyDown(IN_MOVERIGHT) then
			if swep.SoundFileThing then swep.SoundFileThing:Stop() end
			ply:SetLocalVelocity((ply:GetAngles():Right()*ThrustForce))
			swep.CanBurstAgain = false
			swep.SoundFileThing = CreateSound(ply,SwepThrustSoundObj)
			swep.SoundFileThing:Play()
			swep.Fuel = math.Clamp(swep.Fuel-FuelConsumption,0,swep.MaxFuel)
		elseif ply:KeyDown(IN_JUMP) then
			if swep.SoundFileThing then swep.SoundFileThing:Stop() end
			ply:SetLocalVelocity((ply:GetAngles():Up()*ThrustForce))
			swep.CanBurstAgain = false
			swep.SoundFileThing = CreateSound(ply,SwepThrustSoundObj)
			swep.SoundFileThing:Play()
			swep.Fuel = math.Clamp(swep.Fuel-FuelConsumption,0,swep.MaxFuel)
		elseif ply:KeyDown(IN_DUCK) then
			if swep.SoundFileThing then swep.SoundFileThing:Stop() end
			ply:SetLocalVelocity((ply:GetAngles():Up()*-ThrustForce))
			swep.CanBurstAgain = false
			swep.SoundFileThing = CreateSound(ply,SwepThrustSoundObj)
			swep.SoundFileThing:Play()
			swep.Fuel = math.Clamp(swep.Fuel-FuelConsumption,0,swep.MaxFuel)
		elseif ply:KeyDown(IN_WALK) then
			if swep.SoundFileThing then swep.SoundFileThing:Stop() end
			ply:PrintMessage(HUD_PRINTTALK,"MMU Halting Movement...")
			ply:SetLocalVelocity(ZeroVec)
			swep.CanBurstAgain = false
			swep.SoundFileThing = CreateSound(ply,SwepThrustSoundObj)
			swep.SoundFileThing:Play()
			swep.Fuel = math.Clamp(swep.Fuel-FuelConsumption,0,swep.MaxFuel)
		end
		timer.Simple(0.2,function() if swep.SoundFileThing then swep.SoundFileThing:Stop() end end)
	end
	swep:SetNWInt("Fuel",swep.Fuel)
end

function SWEP:ToggleMMUActivation(ply,override)
	ply.MMV = !ply.MMV
	self.Active = !self.Active
	if override then
	ply.MMV = override
	self.Active = override
	end
	if self.Active == true then
		ply:PrintMessage(HUD_PRINTTALK,"Your MMU is now active!")
		hook.Add("Think",ply:SteamID().."MMUThink",function() MMUThink(self) end)
	else
		ply:PrintMessage(HUD_PRINTTALK,"Your MMU is now inactive!")
		hook.Remove("Think",ply:SteamID().."MMUThink")
	end
end


/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()
	
	local ply = self.Owner
	self:ToggleMMUActivation(ply)
	
	
	if CLIENT then return end
	self:SetNextPrimaryFire( CurTime() + 1 )
	return true
end



/*---------------------------------------------------------
	SecondaryAttack
---------------------------------------------------------*/
function SWEP:SecondaryAttack()
end

function SWEP:CustomAmmoDisplay()
	self.AmmoDisplay = self.AmmoDisplay or {}


	self.AmmoDisplay.Draw = true

	self.AmmoDisplay.PrimaryClip = self.Fuel
	self.AmmoDisplay.PrimaryAmmo = self.MaxFuel

	return self.AmmoDisplay 
end 


/*---------------------------------------------------------
   Name: ShouldDropOnDie
   Desc: Should this weapon be dropped when its owner dies?
---------------------------------------------------------*/
function SWEP:ShouldDropOnDie()
	return false
end 