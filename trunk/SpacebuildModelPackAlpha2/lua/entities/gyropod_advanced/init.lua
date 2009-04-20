AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('entities/base_wire_entity/init.lua')
include( 'shared.lua' )

util.PrecacheSound( "ambient/atmosphere/outdoor2.wav" )
util.PrecacheSound( "ambient/atmosphere/indoor1.wav" )
util.PrecacheSound( "buttons/button1.wav" )
util.PrecacheSound( "buttons/button18.wav" )
util.PrecacheSound( "buttons/button6.wav" )
util.PrecacheSound( "buttons/combine_button3.wav" )
util.PrecacheSound( "buttons/combine_button2.wav" )
util.PrecacheSound( "buttons/lever7.wav" )

function ENT:Initialize()
	self.Entity:SetName("advanced_gyropod")
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:SetMaterial("spacebuild/SBLight5");
	self.Inputs = WireLib.CreateSpecialInputs( self.Entity, {"Activate", "Forward", "Back", "MoveLeft", "MoveRight", "MoveUp", "MoveDown", "RollLeft", "RollRight",
								"PitchUp", "PitchDown", "YawLeft", "YawRight", "PitchMult", "YawMult", "RollMult", "ThrustMult", "MPH Limit", "Level", "Freeze", "AimMode",
								"AimX", "AimY", "AimZ", "AimVec"},{"NORMAL","NORMAL","NORMAL","NORMAL","NORMAL",
								"NORMAL","NORMAL","NORMAL","NORMAL","NORMAL","NORMAL","NORMAL","NORMAL","NORMAL","NORMAL","NORMAL","NORMAL","NORMAL","NORMAL","NORMAL","NORMAL","NORMAL","NORMAL","NORMAL","VECTOR"} )
	self.Outputs = Wire_CreateOutputs(self.Entity, { "On", "Frozen", "Targeting Mode", "MPH", "KmPH", "Leveler", "Total Mass", "Mouse Disabled", "Props Linked", "Debug" })
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	self.LTab = {}
	self.PhysTable = {}
	self.SystemOn = false
	self.FreezeOn = false
	self.AimModeOn = false
	self.PMult = 1
	self.RMult = 1
	self.YaMult = 1
	self.TMult = 1
	self.SpdL = 112
	self.Forw = 0
	self.Back = 0
	self.SLeft = 0
	self.SRight = 0
	self.HUp = 0
	self.HDown = 0
	self.RollLeft = 0
	self.RollRight = 0
	self.RollAdd = 0
	self.GyroPitchUp = 0
	self.GyroPitchDown = 0
	self.GyroYawLeft = 0
	self.GyroYawRight = 0
	self.DisableML = false
	self.GyroLvl = false
	self.TarPos = Vector(0, 0, 0)
	self.ModeOut = 0
	self.spacetrigger = false
	self.GyroMass = 0
	self.GyroLevelerOut = 0
	self.DisableMLOut = 0
	self.Debug = 0
end


local Gyrojcon = {}  --Joystick control stuff
local GyroJoystickControl = function()
	Gyrojcon.pitch = jcon.register{
		uid = "gyro_pitch",
		type = "analog",
		description = "Pitch",
		category = "Gyro-Pod",
	}
	Gyrojcon.yaw = jcon.register{
		uid = "gyro_yaw",
		type = "analog",
		description = "Yaw",
		category = "Gyro-Pod",
	}
	Gyrojcon.roll = jcon.register{
		uid = "gyro_roll",
		type = "analog",
		description = "Roll",
		category = "Gyro-Pod",
	}
	Gyrojcon.thrust = jcon.register{
		uid = "gyro_thrust",
		type = "analog",
		description = "Thrust",
		category = "Gyro-Pod",
	}
	Gyrojcon.accelerate = jcon.register{
		uid = "gyro_accelerate",
		type = "analog",
		description = "Accelerate/Decelerate",
		category = "Gyro-Pod",
	}
	Gyrojcon.up = jcon.register{
		uid = "gyro_strafe_up",
		type = "digital",
		description = "Strafe Up",
		category = "Gyro-Pod",
	}
	Gyrojcon.down = jcon.register{
		uid = "gyro_strafe_down",
		type = "digital",
		description = "Strafe Down",
		category = "Gyro-Pod",
	}
	Gyrojcon.right = jcon.register{
		uid = "gyro_strafe_right",
		type = "digital",
		description = "Strafe Right",
		category = "Gyro-Pod",
	}
	Gyrojcon.left = jcon.register{
		uid = "gyro_strafe_left",
		type = "digital",
		description = "Strafe Left",
		category = "Gyro-Pod",
	}
	Gyrojcon.launch = jcon.register{
		uid = "gyro_launch",
		type = "digital",
		description = "Launch",
		category = "Gyro-Pod",
	}
	Gyrojcon.switch = jcon.register{
		uid = "gyro_switch",
		type = "digital",
		description = "Yaw/Roll Switch",
		category = "Gyro-Pod",
	}
end
hook.Add("JoystickInitialize","GyroJoystickControl",GyroJoystickControl)

function ENT:TriggerInput(iname, value)
	if (iname == "Activate") then
		if (value ~= 0) then
			self.SystemOn = true
		else
			self.SystemOn = false
		end
	elseif (iname == "Freeze") then
		if (value ~= 0) then
			self.FreezeOn = true
		else
			self.FreezeOn = false
		end
	elseif (iname == "AimMode") then
		if (value ~= 0) then
			self.AimModeOn = true
		else
			self.AimModeOn = false
		end
	elseif (iname == "Forward") then
		if (value ~= 0) then
			self.Forw = 1
		else
			self.Forw = 0
		end	
	elseif (iname == "Back") then
		if (value ~= 0) then
			self.Back = 1
		else
			self.Back = 0
		end	
	elseif (iname == "MoveLeft") then
		if (value ~= 0) then
			self.SLeft = 1
		else
			self.SLeft = 0
		end	
	elseif (iname == "MoveRight") then
		if (value ~= 0) then
			self.SRight = 1
		else
			self.SRight = 0
		end	
	elseif (iname == "MoveUp") then
		if (value ~= 0) then
			self.HUp = 1
		else
			self.HUp = 0
		end		
	elseif (iname == "MoveDown") then
		if (value ~= 0) then
			self.HDown = 1
		else
			self.HDown = 0
		end	
	elseif (iname == "RollLeft") then
		if (value ~= 0) then
			self.RollLeft = 1
		else
			self.RollLeft = 0
		end	
	elseif (iname == "RollRight") then
		if (value ~= 0) then
			self.RollRight = 1
		else
			self.RollRight = 0
		end	
	elseif (iname == "PitchUp") then
		if (value ~= 0) then
			self.GyroPitchUp = 1
		else
			self.GyroPitchUp = 0
		end	
	elseif (iname == "PitchDown") then
		if (value ~= 0) then
			self.GyroPitchDown = 1
		else
			self.GyroPitchDown = 0
		end	
	elseif (iname == "YawLeft") then
		if (value ~= 0) then
			self.GyroYawLeft = 1
		else
			self.GyroYawLeft = 0
		end	
	elseif (iname == "YawRight") then
		if (value ~= 0) then
			self.GyroYawRight = 1
		else
			self.GyroYawRight = 0
		end			
	elseif (iname == "PitchMult") then
		if value ~= 0 then
			self.PMult = value
		else
			self.PMult = 1
		end	
	elseif (iname == "YawMult") then
		if value ~= 0 then
			self.YaMult = value
		else
			self.YaMult = 1
		end
	elseif (iname == "RollMult") then
		if value ~= 0 then
			self.RMult = value
		else
			self.RMult = 1
		end		
	elseif (iname == "ThrustMult") then
		if value ~= 0 then
			self.TMult = value
		else
			self.TMult = 1
		end	
	elseif (iname == "AimX") then
		self.TarPos.x = value
	elseif (iname == "AimY") then
		self.TarPos.y = value		
	elseif (iname == "AimZ") then
		self.TarPos.z = value
	elseif (iname == "AimVec") then
		self.TarPos = value
	elseif (iname == "No Mouse") then
		if (value ~= 0) then
			self.DisableML = true
			self.DisableMLOut = 1
		else
			self.DisableML = false
			self.DisableMLOut = 0
		end
	elseif (iname == "MPH Limit") then
		if (value ~= 0) then
			self.SpdL = math.Clamp(math.abs(value), 0, 112)
		else
			self.SpdL = 112
		end	
	elseif (iname == "Level") then
		if (value ~= 0) then
			self.GyroLevelerOut = 1
			self.GyroLvl = true
		else
			self.GyroLevelerOut = 0
			self.GyroLvl = false
		end		
	end
end

function ENT:Think()

	local abs, round, clamp, sqrt = math.abs, math.Round, math.Clamp, math.sqrt  --speed up math
 	
	if (self.Pod and self.Pod:IsValid()) then  --Determins whether stuff comes from vehicle or entity
		self.GyroDriver, self.entorpod  = self.Pod:GetPassenger(), self.Pod	
	else
		self.entorpod = self.Entity	
	end 
	if self.Entity:GetParent():IsValid() then  --Determines whether to get local velocity from the Gyropod, or the entity it is parented to, if it exists
		entorpar = self.Entity:GetParent()
	else
		entorpar = self.Entity
	end
	local entpos, entorparvel = self.Entity:GetPos(), entorpar:GetVelocity()
	local localentorparvel = self.Entity:WorldToLocal(entorparvel + entpos)--most of the features rely on these numbers
	local speedmph = round(localentorparvel:Length() / 17.6) 

	if self.FreezeOn then  --convert toggled to non-toggled for freezing
		if !self.freezetrigger then
			self.entorpod:EmitSound( "buttons/lever7.wav" )
			self:FreezeMotion()
		end
		self.GyroSpeed, self.VSpeed, self.HSpeed = 0, 0, 0
		self.FreezeOut = 1
	else
		if self.freezetrigger then
			self.entorpod:EmitSound( "buttons/button6.wav" )
			self:FreezeMotion()
		end
		self.FreezeOut = 0
	end	
	
	if self.AimModeOn then  
		self.ModeOut = 1
		if !self.AimSound then
			self.entorpod:EmitSound( "buttons/combine_button3.wav" )
			self.AimSound = true
		end
		if self.SystemOn || (joystick && joystick.Get(self.CPL, "gyro_launch")) then
			self:AimByTarPos()
		end	
	else 
		if speedmph > 75 then --increase pitch yaw during high speeds
			NTC = speedmph / 75
		else
			NTC = 1
		end	
		self.ModeOut = 0
		if self.AimSound then
			self.entorpod:EmitSound( "buttons/combine_button2.wav" )
			self.AimSound = false
		end
		if self.SystemOn || (joystick && joystick.Get(self.CPL, "gyro_launch")) then
			if (self.GyroDriver && self.GyroDriver:IsValid()) then  
				if (joystick) then
					self:UseJoystick()
				else 
					self:AimByMouse()				
				end
			else
				self.GyroPitch =  (self.GyroPitchDown - self.GyroPitchUp) * 2
				self.GyroYaw = self.GyroYawLeft - self.GyroYawRight
				self.ViewDelay = true
			end
		end	
	end 
	
	if self.SystemOn || (joystick && joystick.Get(self.CPL, "gyro_launch")) then
		self.OnOut = 1
		if !self.gravtrigger || ( !self.spacetrigger and GAMEMODE.IsSpacebuildDerived and self.environment and not self.environment:IsSpace() ) then  --run gravity function when turning system on  or planet re-entry
			if !self.gravtrigger then
				if self.HighEngineSound || self.LowDroneSound then
					self.HighEngineSound:Stop()
					self.LowDroneSound:Stop()
				end 
				self.HighEngineSound = CreateSound(self.entorpod, Sound("ambient/atmosphere/outdoor2.wav"))
				self.LowDroneSound = CreateSound(self.entorpod, Sound("ambient/atmosphere/indoor1.wav"))
				self.HighEngineSound:Play()
				self.LowDroneSound:Play()
				self.entorpod:EmitSound( "buttons/button1.wav" )
			end	
			self:Gravity()
		else
			if GAMEMODE.IsSpacebuildDerived and self.environment and self.environment:IsSpace() then
				self.spacetrigger = false
			end	
		end
		
		if !self.weighttrigger then
			self:GyroWeight()
		end	
		
		if speedmph > 80 then  --changing sounds based on speed
			self.HighEngineVolume = clamp(((speedmph * 0.035)-2.6), 0, 1)
		else
			self.HighEngineVolume = speedmph * 0.0025
		end
		self.HighEnginePitch = (speedmph * 1.2) + 60
		self.LowDronePitch = 35+(speedmph * 0.2)
		self.HighEngineSound.ChangeVolume(self.HighEngineSound, self.HighEngineVolume)
		self.HighEngineSound.ChangePitch(self.HighEngineSound, self.HighEnginePitch)
		self.LowDroneSound.ChangePitch(self.LowDroneSound, self.LowDronePitch)
		
		--Roll Calculations.  Stops the ship from changing its roll angle when you turn or pitch.
		if self.GyroLvl then
			gyroshipangles = self.Entity:GetAngles()  
		end
		local speedx, speedy, speedz = abs(localentorparvel.x) / 17.6, abs(localentorparvel.y) / 17.6, abs(localentorparvel.z) / 17.6
		local SMult, HMult, VMult, GyroRoll = self.Forw - self.Back, self.SRight - self.SLeft, self.HUp - self.HDown, self.RollRight - self.RollLeft		
		if abs(speedx) >= self.SpdL then  --Speed Limit modifiers
			self.XMult = 0 
		else
			self.XMult = 1
		end
		if abs(speedy) >= self.SpdL then
			self.YMult = 0 
		else
			self.YMult = 1
		end		
		if abs(speedz) >= self.SpdL then
			self.ZMult = 0 
		else
			self.ZMult = 1
		end

		if (SMult > 0) and (self.GyroSpeed >= 0) then  --pressing forward and moving forwards
			self.GyroSpeed = self.GyroSpeed + (7 * self.XMult * (abs(sqrt(speedx)-10.583) * 0.2))
		elseif (SMult < 0) and (self.GyroSpeed <= 0) then --pressing reverse moving backwards
			self.GyroSpeed = self.GyroSpeed - (7 * self.XMult * (abs(sqrt(speedx)-10.583) * 0.2))
		elseif (SMult > 0) and (self.GyroSpeed < 0) then --pressing forward and moving backwards, increase speed faster until moving forwards again
			self.GyroSpeed = clamp(self.GyroSpeed + 20, -2000, 0)
		elseif (SMult < 0) and (self.GyroSpeed > 0) then  --pressing reverse and moving forwards, reverse speed faster until moving backwards again
			self.GyroSpeed = clamp(self.GyroSpeed - 20, 0, 2000)
		elseif (SMult == 0) and (self.GyroSpeed > 0) then  --not pressing for or back and moving forwards, slow movement faster until stopped
			self.GyroSpeed = clamp(self.GyroSpeed - 10, 0, 2000)
		elseif (SMult == 0) and (self.GyroSpeed < 0) then  --not pressing forw or back and moving backwards slow movement faster until stopped
			self.GyroSpeed = clamp(self.GyroSpeed + 10, -2000, 0)
		end		
		if (HMult > 0) and (self.HSpeed >= 0) then  --Strafe movement
			self.HSpeed = self.HSpeed + (7 * self.YMult * (abs(sqrt(speedy)-10.583) * 0.1))
		elseif (HMult < 0) and (self.HSpeed <= 0) then
			self.HSpeed = self.HSpeed - (7 * self.YMult * (abs(sqrt(speedy)-10.583) * 0.1))
		elseif (HMult > 0) and (self.HSpeed < 0) then
			self.HSpeed = clamp(self.HSpeed + 20, -2000, 0)
		elseif (HMult < 0) and (self.HSpeed > 0) then
			self.HSpeed = clamp(self.HSpeed - 20, 0, 2000)
		elseif (HMult == 0) and (self.HSpeed > 0) then
			self.HSpeed = clamp(self.HSpeed - 10, 0, 2000)
		elseif (HMult == 0) and (self.HSpeed < 0) then
			self.HSpeed = clamp(self.HSpeed + 10, -2000, 0)
		end
		if (VMult > 0) and (self.VSpeed >= 0) then  --Height Movement
			self.VSpeed = self.VSpeed + (7 * self.ZMult * (abs(sqrt(speedz)-10.583) * 0.3))
		elseif (VMult < 0) and (self.VSpeed <= 0) then
			self.VSpeed = self.VSpeed - (7 * self.ZMult * (abs(sqrt(speedz)-10.583) * 0.3))
		elseif (VMult > 0) and (self.VSpeed < 0) then
			self.VSpeed = clamp(self.VSpeed + 20, -2000, 0)
		elseif (VMult < 0) and (self.VSpeed > 0) then
			self.VSpeed = clamp(self.VSpeed - 20, 0, 2000)
		elseif (VMult == 0) and (self.VSpeed > 0) then
			self.VSpeed = clamp(self.VSpeed - 10, 0, 2000)
		elseif (VMult == 0) and (self.VSpeed < 0) then
			self.VSpeed = clamp(self.VSpeed + 10, -2000, 0)
		end

		--Force Application
		for x, c in pairs(self.PhysTable) do
			if (c:IsValid()) then
				local physobj = c:GetPhysicsObject()
				local mass, physvel, physangvel = self.GyroMass * 0.1, physobj:GetVelocity(), physobj:GetAngleVelocity()
				local entfor, entright, entup = self.Entity:GetForward(), self.Entity:GetRight(), self.Entity:GetUp() 
				physobj:SetVelocity( (((entfor * self.GyroSpeed) + (entup * self.VSpeed) + (entright * self.HSpeed)) * self.TMult) )
				physobj:AddAngleVelocity(physangvel * -0.5)
				if self.GyroLvl then
					physobj:ApplyForceOffset( entup * math.NormalizeAngle(gyroshipangles.p * 0.2) * self.PMult * mass, entpos + entfor * 1000 )
					physobj:ApplyForceOffset( entup * math.NormalizeAngle(-gyroshipangles.p * 0.2) * self.PMult * mass, entpos + entfor * -1000 )
					physobj:ApplyForceOffset( entup * math.NormalizeAngle(gyroshipangles.r * 0.2)  * self.RMult * mass, entpos + entright * 1000 )
					physobj:ApplyForceOffset( entup * math.NormalizeAngle(-gyroshipangles.r * 0.2)  * self.RMult * mass, entpos + entright * -1000 )						
				else
					physobj:ApplyForceOffset( entup * -self.GyroPitch * self.PMult * mass * NTC, entpos + entfor * 1000 )
					physobj:ApplyForceOffset( entup * self.GyroPitch * self.PMult * mass * NTC, entpos + entfor * -1000 )
					physobj:ApplyForceOffset( entup * -GyroRoll * self.RMult * mass, entpos + entright * 1000 )
					physobj:ApplyForceOffset( entup * GyroRoll * self.RMult * mass, entpos + entright * -1000 )				
				end	
				physobj:ApplyForceOffset( entright * -self.GyroYaw * self.YaMult * mass * NTC, entpos + entfor * 1000 )
				physobj:ApplyForceOffset( entright * self.GyroYaw * self.YaMult * mass * NTC, entpos + entfor * -1000 )
			end
		end

	else
		if self.gravtrigger then
			self.entorpod:EmitSound( "buttons/button18.wav" )
			self:Gravity()
		end
		
		if self.weighttrigger then
			self:GyroWeight()
		end	
		
		local shipangles = self.Entity:GetAngles()
		self.RollAdd = shipangles.r
		self.OnOut, self.GyroSpeed, self.VSpeed, self.HSpeed, self.GyroYaw, GyroRoll, self.GyroPitch = 0, 0, 0, 0, 0, 0, 0

		if self.HighEngineSound || self.LowDroneSound then  --Wind down engine sound when turned off
			self.HighEnginePitch = clamp(self.HighEnginePitch - 0.7, 0, 300)
			self.LowDronePitch = clamp(self.LowDronePitch - 0.3, 0, 300)
			self.HighEngineVolume = clamp(self.HighEngineVolume - 0.005, 0, 2)
			self.HighEngineSound.ChangeVolume(self.HighEngineSound, self.HighEngineVolume)
			self.HighEngineSound.ChangePitch(self.HighEngineSound, self.HighEnginePitch)
			self.LowDroneSound.ChangePitch(self.LowDroneSound, self.LowDronePitch)
			if self.LowDronePitch < 1 then
				self.LowDroneSound:Stop()
				self.HighEngineSound:Stop()
			end
		end
	end

	Wire_TriggerOutput(self.Entity, "On", self.OnOut)
	Wire_TriggerOutput(self.Entity, "Frozen", self.FreezeOut)
	Wire_TriggerOutput(self.Entity, "Targeting Mode", self.ModeOut)
	Wire_TriggerOutput(self.Entity, "MPH", speedmph)
	Wire_TriggerOutput(self.Entity, "KmPH", round(localentorparvel:Length() / 10.93613297222))
	Wire_TriggerOutput(self.Entity, "Leveler", self.GyroLevelerOut)
	Wire_TriggerOutput(self.Entity, "Total Mass", self.GyroMass)
	Wire_TriggerOutput(self.Entity, "Mouse Disabled", self.DisableMLOut)
	Wire_TriggerOutput(self.Entity, "Props Linked", table.Count(self.PhysTable))
	Wire_TriggerOutput(self.Entity, "Debug", self.GyroYaw * self.YaMult * self.GyroMass)
	
	self.Entity:NextThink( CurTime() + 0.01 )
	return true
end

function ENT:AimByTarPos()    --Aiming mode Calculations
	self:PodModelFix()
	local PodPos, PodUp = self.entorpod:GetPos(), self.entorpod:GetUp()
	local TarMod = PodPos + ((self.TarPos - PodPos):Normalize()) * 100
	local FDistP = TarMod:Distance( PodPos + PodUp * 500 )
	local BDistP = TarMod:Distance( PodPos + PodUp * -500 )
	self.GyroPitch = (FDistP - BDistP) * 0.1
	local FDistY = TarMod:Distance( PodPos + self.T90 * -self.Tmod )
	local BDistY = TarMod:Distance( PodPos + self.T90 * self.Tmod )
	self.GyroYaw = (BDistY - FDistY) * 0.1
end		

function ENT:AimByMouse()  --Mouselook Calculations (whoever figured this out is my personal hero)
	local clamp = math.Clamp
	if self.ViewDelay then --small delay beofre mouse look is enabled
		self.ViewDelayOut = 0
		timer.Simple(1.5,function()
			self.ViewDelay = false
			end)
	else
		self.GyroDriver:CrosshairEnable()
		self.ViewDelayOut = 1
	end	
	self:PodModelFix()
	local PodPos, PodUp = self.Pod:GetPos(), self.Pod:GetUp()	  	
	local PodAim = self.GyroDriver:GetAimVector()
	local PRel = PodPos + PodAim * 100
	local FDistP = PRel:Distance( PodPos + PodUp * 500 )
	local BDistP = PRel:Distance( PodPos + PodUp * -500 )
	local PitchA = clamp((FDistP - BDistP) * 0.05, -7, 7)
	if (PitchA > 0.5) then
		self.GyroPitch = (PitchA - 0.5) * self.ViewDelayOut
	elseif (PitchA < -0.5) then
		self.GyroPitch = (PitchA + 0.5) * self.ViewDelayOut
	else self.GyroPitch = 0
	end
	local FDistY = PRel:Distance( PodPos + self.T90 * -self.Tmod )
	local BDistY = PRel:Distance( PodPos + self.T90 * self.Tmod )
	local YawA = clamp((BDistY - FDistY) * 0.05, -7, 7)
	if (YawA > 0.5) then
		self.GyroYaw = (YawA - 0.5) * self.ViewDelayOut
	elseif (YawA < -0.5) then
		self.GyroYaw = (YawA + 0.5) * self.ViewDelayOut
	else self.GyroYaw = 0
	end	
end	
	
function ENT:PodModelFix() --fixing the strange bug where some vehicles are rotated 90 degrees
	if (self.Pod and self.Pod:IsValid()) then  
		local podmodel = self.Pod:GetModel()
		if (string.find(podmodel, "carseat") || string.find(podmodel, "nova") || string.find(podmodel, "prisoner_pod_inner")) then
			local podright = self.Pod:GetRight()
			self.T90, self.Tmod = podright, 500
		else
			local podfor = self.Pod:GetForward()	
			self.T90, self.Tmod = podfor, -500
		end	
	else
		local entright = self.Entity:GetRight()	
		self.T90, self.Tmod = entright, 500
	end	
end

function ENT:GyroWeight()
	if self.SystemOn then
		for _, ents in pairs( constraint.GetAllConstrainedEntities( self.Entity ) ) do
			if (!ents:IsValid()) then return end
				local linkphys = ents:GetPhysicsObject()
				self.GyroMass = (self.GyroMass + linkphys:GetMass())
		end		
		self.weighttrigger= true
	else
		self.GyroMass = 0
		self.weighttrigger= false	
	end
end				

function ENT:Gravity()  --Turns on/off gravity for all constrained entities
	local constrainedents = constraint.GetAllConstrainedEntities( self.Entity )
	for _, ents in pairs( constrainedents ) do
		if (!ents:IsValid()) then return end
		if self.SystemOn then
			local linkphys = ents:GetPhysicsObject()
			--self.GyroMass = (self.GyroMass + linkphys:GetMass())
			if (linkphys:GetMass() > 20) and (not string.find(ents:GetClass(),"wire")) then
				table.insert(self.PhysTable, ents.Entity)
			end
			linkphys:EnableGravity(false)
			self.gravtrigger, self.spacetrigger = true, true
			
		else 
			--self.GyroMass = 0
			table.Empty(self.PhysTable)
			if GAMEMODE.IsSpacebuildDerived and self.environment and ( self.environment:IsSpace() or self.environment:IsStar() ) then
				self.gravtrigger = false  --don't turn on gravity if in space
			else	
				local linkphys = ents:GetPhysicsObject()
				linkphys:EnableGravity(true)
				self.gravtrigger = false
			end	
		end
	end
end

function ENT:FreezeMotion()  --Freezes all constrained entities
	local constrainedents = constraint.GetAllConstrainedEntities( self.Entity )
	for _, ents in pairs( constrainedents ) do
		if (!ents:IsValid()) then return end
		if self.FreezeOn then
			local physobj = ents:GetPhysicsObject()
			physobj:EnableMotion(false)
			physobj:Wake()	
			self.freezetrigger = true
		else
			local physobj = ents:GetPhysicsObject()
			physobj:EnableMotion(true)
			physobj:Wake()	
			self.freezetrigger = false
		end
	end
end

function ENT:UseJoystick()  --Joystick Controls (I've never tested this)
	if (joystick.Get(self.GyroDriver, "gyro_strafe_up")) then
		self.VSpeed = 50
	elseif (joystick.Get(self.GyroDriver, "gyro_strafe_down")) then
		self.VSpeed = -50
	end
	if (joystick.Get(self.GyroDriver, "gyro_strafe_right")) then
		self.HSpeed = 50
	elseif (joystick.Get(self.GyroDriver, "gyro_strafe_left")) then
		self.HSpeed = -50
	else
		self.HSpeed = 0
	end
	--Acceleration, greater than halfway accelerates, less than decelerates
	if (joystick.Get(self.GyroDriver, "gyro_accelerate")) then
		if (joystick.Get(self.GyroDriver, "gyro_accelerate") > 128) then
			self.GyroSpeed = math.Clamp(self.GyroSpeed + (joystick.Get(self.GyroDriver, "gyro_accelerate")/127.5-1)*5, -40, 2000)
		elseif (joystick.Get(self.GyroDriver, "gyro_accelerate") < 127) then
			self.GyroSpeed = math.Clamp(self.GyroSpeed + (joystick.Get(self.GyroDriver, "gyro_accelerate")/127.5-1)*10, -40, 2000)
		end
	end
	--Set the speed
	if (joystick.Get(self.GyroDriver, "gyro_thrust")) then
		if (joystick.Get(self.GyroDriver, "gyro_thrust") > 128) then
			self.TarSpeed = (joystick.Get(self.GyroDriver, "gyro_thrust")/127.5-1)*2000
		elseif (joystick.Get(self.GyroDriver, "gyro_thrust") < 127) then
			self.TarSpeed = (joystick.Get(self.GyroDriver, "gyro_thrust")/127.5-1)*40
		elseif (joystick.Get(self.GyroDriver, "gyro_thrust") < 128 && joystick.Get(self.GyroDriver, "gyro_thrust") > 127) then
			self.TarSpeed = 0
		end
		if (self.TarSpeed > self.GyroSpeed) then
			self.GyroSpeed = math.Clamp(self.GyroSpeed + 5, -40, 2000)
		elseif (self.TarSpeed < self.GyroSpeed) then
			self.GyroSpeed = math.Clamp(self.GyroSpeed - 10, -40, 2000)
		end
	end
	--forward is down on pitch, if you don't like it check the box on joyconfig to invert it
	if (joystick.Get(self.GyroDriver, "gyro_pitch")) then
		if (joystick.Get(self.GyroDriver, "gyro_pitch") > 128) then
			self.GyroPitch = -(joystick.Get(self.GyroDriver, "gyro_pitch")/127.5-1)*90
		elseif (joystick.Get(self.GyroDriver, "gyro_pitch") < 127) then
			self.GyroPitch = -(joystick.Get(self.GyroDriver, "gyro_pitch")/127.5-1)*90
		elseif (joystick.Get(self.GyroDriver, "gyro_pitch") < 128 && joystick.Get(self.GyroDriver, "gyro_pitch") > 127) then
			self.GyroPitch = 0
		end
	end
	--The control for inverting yaw and roll
	local yaw = ""
	local roll = ""
	if (joystick.Get(self.GyroDriver, "gyro_switch")) then
		yaw = "gyro_roll"
		roll = "gyro_yaw"
	else
		yaw = "gyro_yaw"
		roll = "gyro_roll"
	end
	--Yaw is negative because Paradukes says so
	--You could invert it, but the default configuration should be correct
	if (joystick.Get(self.GyroDriver, yaw)) then
		if (joystick.Get(self.GyroDriver, yaw) > 128) then
			self.GyroYaw = -(joystick.Get(self.GyroDriver, yaw)/127.5-1)*90
		elseif (joystick.Get(self.GyroDriver, yaw) < 127) then
			self.GyroYaw = -(joystick.Get(self.GyroDriver, yaw)/127.5-1)*90
		elseif (joystick.Get(self.GyroDriver, yaw) < 128 && joystick.Get(self.GyroDriver, yaw) > 127) then
			self.GyroYaw = 0
		end
	end
	if (joystick.Get(self.GyroDriver, roll)) then
		if (joystick.Get(self.GyroDriver, roll) > 128) then
			self.GyroRoll = (joystick.Get(self.GyroDriver, roll)/127.5-1)*90
		elseif (joystick.Get(self.GyroDriver, roll) < 127) then
			self.GyroRoll = (joystick.Get(self.GyroDriver, roll)/127.5-1)*90
		elseif (joystick.Get(self.GyroDriver, roll) < 128 && joystick.Get(self.GyroDriver, roll) > 127) then
			self.GyroRoll = 0
		end
	end
end

function ENT:Link(pod)
	if !pod then return false end
	self.Pod = pod
	return true
end

function ENT:OnRemove()
	if self.sound then
		self.HighEngineSound:Stop()
		self.LowDroneSound:Stop()
	end	
end

function ENT:BuildDupeInfo()
	PrintTable(self.LTab)
	local info = self.BaseClass.BuildDupeInfo(self) or {}
	info.LTab = {}
	for k,v in pairs(self.LTab) do
		info.LTab[k] = v:EntIndex()
	end
	if (self.Pod and self.Pod:IsValid()) then
		info.Pod = self.Pod:EntIndex()
	end
	return info
end

function ENT:ApplyDupeInfo(ply, ent, info, GetEntByID)
	PrintTable(info.LTab)
	if (info.Pod) then
		self.Pod = GetEntByID(info.Pod)
		if (!self.Pod) then
			self.Pod = ents.GetByIndex(info.Pod)
		end
	end
	self.LTab = self.LTab or {}
	for k,v in pairs(info.LTab) do
		self.LTab[k] = GetEntByID(v)
		if (!self.LTab[k]) then
			self.LTab[k] = ents.GetByIndex(v)
		end
	end
	PrintTable(self.LTab)
	self.BaseClass.ApplyDupeInfo(self, ply, ent, info, GetEntByID)
end