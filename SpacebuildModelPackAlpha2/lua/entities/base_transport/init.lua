AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

util.PrecacheSound( "SB/SteamEngine.wav" )

local function GetJBool(self,sVal)
	if not joystick then return false end
	return joystick.Get(self.CPL, "sbeptpt_"..sVal)
end

local function GetJNum(self,sVal, nMax, nMin)
	if not joystick then return false end
	local nJoyGet = joystick.Get(self.CPL, "sbeptpt_"..sVal)
	if nJoyGet then
		nJoyGet = nJoyGet/127.5-1
		if nJoyGet > 0 then
			nJoyGet = nJoyGet * nMax
		else
			nJoyGet = nJoyGet * nMin
		end
	end
	return nJoyGet
end

function ENT:Think()
	if self.Pod and self.Pod:IsValid() then
		self.CPL = self.Pod:GetPassenger()
		if (self.CPL && self.CPL:IsValid()) then
			local trace = {}
			trace.start = self.CPL:GetShootPos()
			trace.endpos = self.CPL:GetShootPos() + self.CPL:GetAimVector() * 10000
			trace.filter = self.Pod
			self.Pod.Trace = util.TraceLine( trace )
			self.Active = true
			if (self.CPL:KeyDown( IN_FORWARD )) then
				if self.MCC then
					self.VSpeed = self.StrafeSpeed
				else
					self.Pitch = self.TSpeed
				end
			elseif (self.CPL:KeyDown( IN_BACK )) then
				if self.MCC then
					self.VSpeed = -self.StrafeSpeed
				else
					self.Pitch = -self.TSpeed
				end
			else
				self.Pitch = 0
				self.VSpeed = 0
			end
	
			if (self.CPL:KeyDown( IN_MOVERIGHT )) then
				self.Roll = self.TSpeed
			elseif (self.CPL:KeyDown( IN_MOVELEFT )) then
				self.Roll = -self.TSpeed
			else
				self.Roll = 0
			end
	
			if (self.CPL:KeyDown( IN_SPEED )) then
				self.Speed = math.Clamp(self.Speed + self.AccelMax, -self.MinSpeed, self.MaxSpeed)
			elseif (self.CPL:KeyDown( IN_WALK )) then
				self.Speed = math.Clamp(self.Speed - self.DecelMax, -self.MinSpeed, self.MaxSpeed)
			end
			--self.TSpeed = math.Clamp(self.Speed / 10, 20, 200)
			
			if (self.CPL:KeyDown( IN_RELOAD )) then
				if !self.MTog then
					if self.MCC then
						self.MCC = false
						self.CPL:PrintMessage( HUD_PRINTCENTER, "Mouse Control Disabled" )
					else
						self.MCC = true
						self.CPL:PrintMessage( HUD_PRINTCENTER, "Mouse Control Enabled" )
					end
				end
				self.MTog = true
			else
				self.MTog = false
			end
			
			if (self.CPL:KeyDown( IN_JUMP ) || GetJBool(self,"launch")) then
				if !self.LTog then
					if self.Launchy then
						self.Launchy = false
						self.Pod:StopSound( "k_lab.ambient_powergenerators" )
					else
						self.Launchy = true
						self.Pod:EmitSound( "k_lab.ambient_powergenerators" )
						self.Pod:EmitSound( "ambient/machines/thumper_startup1.wav" )
					end
				end
				self.LTog = true
			else
				self.LTog = false
			end
			
			
			if (GetJBool(self,"strafe_up")) then
				self.VSpeed = self.StrafeSpeed
			elseif (GetJBool(self,"strafe_down")) then
				self.VSpeed = -self.StrafeSpeed
			end
		
			if (GetJBool(self,"strafe_right")) then
				self.HSpeed = self.StrafeSpeed
			elseif (GetJBool(self,"strafe_left")) then
				self.HSpeed = -self.StrafeSpeed
			else
				self.HSpeed = 0
			end
		
			--Acceleration, greater than halfway accelerates, less than decelerates
			local nAccel = GetJNum(self,"accelerate",self.AccelMax,self.DecelMax)
			if nAccel then self.Speed = math.Clamp(self.Speed + nAccel, -self.MinSpeed, self.MaxSpeed) end
			
			--Set the speed
			local nTarSpeed = GetJNum(self,"thrust",self.MaxSpeed,self.MinSpeed)
			if nTarSpeed then
				if (nTarSpeed > self.Speed) then
					self.Speed = math.Clamp(self.Speed + self.AccelMax, -self.MinSpeed, self.MaxSpeed)
				elseif (nTarSpeed < self.Speed) then
					self.Speed = math.Clamp(self.Speed - self.DecelMax, -self.MinSpeed, self.MaxSpeed)						
				end
			end
			
			--forward is down on pitch, if you don't like it check the box on joyconfig to invert it
			local nPitch = GetJNum(self,"pitch",self.TSpeed,self.TSpeed)
			if nPitch then self.Pitch = -nPitch end
		
			--The control for inverting yaw and roll
			local sYaw = "yaw"
			local sRoll = "roll"
			if (GetJBool(self,"switch")) then
				sYaw = "roll"
				sRoll = "yaw"
			end
			
			--Yaw is negative because Paradukes says so
			--You could invert it, but the default configuration should be correct
			local nYaw = GetJNum(self,sYaw,self.TSpeed,self.TSpeed)
			if nYaw then self.Yaw = -nYaw end
			
			local nRoll = GetJNum(self,sRoll,self.TSpeed,self.TSpeed)
			if nRoll then self.Roll = nRoll end
			
			if self.MCC then
				local PRel = self.Pod:GetPos() + self.CPL:GetAimVector() * 100
				
				--Believe it or not, the following code came from a set of tank treads. Who'd have thunk it?
				local FDist = PRel:Distance( self.Pod:GetPos() + self.Pod:GetUp() * 500 )
				local BDist = PRel:Distance( self.Pod:GetPos() + self.Pod:GetUp() * -500 )
				self.Pitch = (FDist - BDist) * 0.5
				FDist = PRel:Distance( self.Pod:GetPos() + self.Pod:GetForward() * 500 )
				BDist = PRel:Distance( self.Pod:GetPos() + self.Pod:GetForward() * -500 )
				self.Yaw = (BDist - FDist) * 0.5

				self.CPL:CrosshairEnable()
			end
			
			if (self.Launchy) then
				local PodAng = self.Pod:LocalToWorldAngles(Angle(0,0,0))
				local pitch = self.PMult or 1
				pitch = pitch * self.Pitch
				local yaw = self.YMult or 1
				yaw = yaw * self.Yaw
				local roll = self.RMult or 1
				roll = roll * self.Roll
				if (self.EMount) then
					local physi = self.Entity:GetPhysicsObject()
					physi:SetVelocity( (physi:GetVelocity() * self.DragRate) + ((self.Pod:GetRight() * self.Speed) + (self.Pod:GetUp() * self.VSpeed) + (self.Pod:GetForward() * -self.HSpeed)) )
					physi:AddAngleVelocity((physi:GetAngleVelocity() * -self.DragRate) + Angle(roll,pitch,yaw))
					physi:EnableGravity(false)
					self.Pod:GetPhysicsObject():EnableGravity(false)
				end
				local physi = self.Pod:GetPhysicsObject()
				physi:SetVelocity( (physi:GetVelocity() * self.DragRate) + ((PodAng:Forward() * self.Speed) + (PodAng:Up() * self.VSpeed) + (PodAng:Right() * self.HSpeed)) )
				physi:AddAngleVelocity((physi:GetAngleVelocity() * -self.DragRate) + Angle(roll,pitch,yaw))
				physi:EnableGravity(false)
			else
				if (self.EMount) then
					self.Speed = 0
					self.Yaw = 0
					self.Roll = 0
					self.Pitch = 0
					local physi = self.Entity:GetPhysicsObject()
					physi:EnableGravity(true)
					self.Pod:GetPhysicsObject():EnableGravity(true)
				else
					self.Speed = 0
					self.Yaw = 0
					self.Roll = 0
					self.Pitch = 0
					local physi = self.Pod:GetPhysicsObject()
					physi:EnableGravity(true)
				end
			end
		else
			self.Speed = 0
			self.Yaw = 0
			self.Roll = 0
			self.Pitch = 0
			self.Pod.Trace = nil
		end
	else
		self.Entity:Remove()
	end

	self.Entity:NextThink( CurTime() + 0.01 ) 
	return true
end

function ENT:PhysicsCollide( data, physobj )

end

function ENT:OnTakeDamage( dmginfo )
	
end

function ENT:Touch( ent )
	if self.Linking && ent:IsValid()then
		self.CCObj = ent
	end
end

function ENT:OnRemove()
	if self.Pod && self.Pod:IsValid() then
		self.Pod:Remove()
	end
end

--[[function ENT:Use( activator, caller )
	if ( activator:IsPlayer() ) and not (self.Pod:GetPassenger() == activator) then
		activator:EnterVehicle( self.Pod )
	else
		activator:ExitVehicle()
	end
end]]

function ENT:BuildDupeInfo()
	local info = self.BaseClass.BaseClass.BuildDupeInfo(self) or {}
	if (self.Pod) and (self.Pod:IsValid()) then
	    info.Pod = self.Pod:EntIndex()
	end
	return info
end

function ENT:ApplyDupeInfo(ply, ent, info, GetEntByID)
	self.BaseClass.BaseClass.ApplyDupeInfo(self, ply, ent, info, GetEntByID)
	if (info.Pod) then
		self.Pod = GetEntByID(info.Pod)
		if (!self.Pod) then
			self.Pod = ents.GetByIndex(info.Pod)
		end
		local ent2 = self.Pod
		ent2.Cont = ent
		ent2:SetKeyValue("limitview", 0)
		ent2.HasHardpoints = true
		local TB = ent2:GetTable()
		TB.HandleAnimation = function (vec, ply)
			return ply:SelectWeightedSequence( ACT_HL2MP_SIT ) 
		end 
		ent2:SetTable(TB)
		ent2.SPL = ply
		ent2:SetNetworkedInt( "HPC", ent.HPC )
	end
	self.SPL = ply
end