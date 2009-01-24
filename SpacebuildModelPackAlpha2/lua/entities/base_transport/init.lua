AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

util.PrecacheSound( "SB/SteamEngine.wav" )

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
			
			if (self.CPL:KeyDown( IN_JUMP ) || (joystick && joystick.Get(self.CPL, "sbeptpt_launch"))) then
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
			
			if (joystick) then
				if (joystick.Get(self.CPL, "sbeptpt_strafe_up")) then
					self.VSpeed = self.StrafeSpeed
				elseif (joystick.Get(self.CPL, "sbeptpt_strafe_down")) then
					self.VSpeed = -self.StrafeSpeed
				end
			
				if (joystick.Get(self.CPL, "sbeptpt_strafe_right")) then
					self.HSpeed = self.StrafeSpeed
				elseif (joystick.Get(self.CPL, "sbeptpt_strafe_left")) then
					self.HSpeed = -self.StrafeSpeed
				else
					self.HSpeed = 0
				end
			
				--Acceleration, greater than halfway accelerates, less than decelerates
				if (joystick.Get(self.CPL, "sbeptpt_accelerate")) then
					if (joystick.Get(self.CPL, "sbeptpt_accelerate") > 128) then
						self.Speed = math.Clamp(self.Speed + (joystick.Get(self.CPL, "sbeptpt_accelerate")/127.5-1)*self.AccelMax, -self.MinSpeed, self.MaxSpeed)
					elseif (joystick.Get(self.CPL, "sbeptpt_accelerate") < 127) then
						self.Speed = math.Clamp(self.Speed + (joystick.Get(self.CPL, "sbeptpt_accelerate")/127.5-1)*self.DecelMax, -self.MinSpeed, self.MaxSpeed)
					end
				end
				
				--Set the speed
				if (joystick.Get(self.CPL, "sbeptpt_thrust")) then
					if (joystick.Get(self.CPL, "sbeptpt_thrust") > 128) then
						self.TarSpeed = (joystick.Get(self.CPL, "sbeptpt_thrust")/127.5-1)*self.MaxSpeed
					elseif (joystick.Get(self.CPL, "sbeptpt_thrust") < 127) then
						self.TarSpeed = (joystick.Get(self.CPL, "sbeptpt_thrust")/127.5-1)*self.MinSpeed
					elseif (joystick.Get(self.CPL, "sbeptpt_thrust") < 128 && joystick.Get(self.CPL, "sbeptpt_thrust") > 127) then
						self.TarSpeed = 0
					end
					if (self.TarSpeed > self.Speed) then
						self.Speed = math.Clamp(self.Speed + self.AccelMax, -self.MinSpeed, self.MaxSpeed)
					elseif (self.TarSpeed < self.Speed) then
						self.Speed = math.Clamp(self.Speed - self.DecelMax, -self.MinSpeed, self.MaxSpeed)						
					end
				end
				
				--forward is down on pitch, if you don't like it check the box on joyconfig to inver it
				if (joystick.Get(self.CPL, "sbeptpt_pitch")) then
					if (joystick.Get(self.CPL, "sbeptpt_pitch") > 128) then
						self.Pitch = -(joystick.Get(self.CPL, "sbeptpt_pitch")/127.5-1)*self.TSpeed
					elseif (joystick.Get(self.CPL, "sbeptpt_pitch") < 127) then
						self.Pitch = -(joystick.Get(self.CPL, "sbeptpt_pitch")/127.5-1)*self.TSpeed
					elseif (joystick.Get(self.CPL, "sbeptpt_pitch") < 128 && joystick.Get(self.CPL, "sbeptpt_pitch") > 127) then
						self.Pitch = 0
					end
				end
			
				--The control for inverting yaw and roll
				local yaw = ""
				local roll = ""
				if (joystick.Get(self.CPL, "sbeptpt_switch")) then
					yaw = "sbeptpt_roll"
					roll = "sbeptpt_yaw"
				else
					yaw = "sbeptpt_yaw"
					roll = "sbeptpt_roll"
				end
				
				--Yaw is negative because Paradukes says so
				--You could invert it, but the default configuration should be correct
				if (joystick.Get(self.CPL, yaw)) then
					if (joystick.Get(self.CPL, yaw) > 128) then
						self.Yaw = -(joystick.Get(self.CPL, yaw)/127.5-1)*self.TSpeed
					elseif (joystick.Get(self.CPL, yaw) < 127) then
						self.Yaw = -(joystick.Get(self.CPL, yaw)/127.5-1)*self.TSpeed
					elseif (joystick.Get(self.CPL, yaw) < 128 && joystick.Get(self.CPL, yaw) > 127) then
						self.Yaw = 0
					end
				end
			
				if (joystick.Get(self.CPL, roll)) then
					if (joystick.Get(self.CPL, roll) > 128) then
						self.Roll = (joystick.Get(self.CPL, roll)/127.5-1)*self.TSpeed
					elseif (joystick.Get(self.CPL, roll) < 127) then
						self.Roll = (joystick.Get(self.CPL, roll)/127.5-1)*self.TSpeed
					elseif (joystick.Get(self.CPL, roll) < 128 && joystick.Get(self.CPL, roll) > 127) then
						self.Roll = 0
					end
				end
			end
			
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
				if (self.EMount) then
					local physi = self.Entity:GetPhysicsObject()
					physi:SetVelocity( (physi:GetVelocity() * self.DragRate) + ((self.Pod:GetRight() * self.Speed) + (self.Pod:GetUp() * self.VSpeed) + (self.Pod:GetForward() * -self.HSpeed)) )
					physi:AddAngleVelocity((physi:GetAngleVelocity() * -self.DragRate) + Angle(self.Roll,self.Pitch,self.Yaw))
					physi:EnableGravity(false)
					self.Pod:GetPhysicsObject():EnableGravity(false)
				else
					local physi = self.Pod:GetPhysicsObject()
					physi:SetVelocity( (physi:GetVelocity() * self.DragRate) + ((self.Pod:GetRight() * self.Speed) + (self.Pod:GetUp() * self.VSpeed) + (self.Pod:GetForward() * -self.HSpeed)) )
					physi:AddAngleVelocity((physi:GetAngleVelocity() * -self.DragRate) + Angle(self.Roll,self.Pitch,self.Yaw))
					physi:EnableGravity(false)
				end
			else
				if (self.EMount) then
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