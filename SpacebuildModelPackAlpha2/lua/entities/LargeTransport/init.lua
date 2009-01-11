AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

--util.PrecacheSound( "SB/SteamEngine.wav" )

function ENT:Initialize()
	
	self.Entity:SetModel( "models/Spacebuild/medbridge2_doublehull_elevatorclamp.mdl" ) 
	self.Entity:SetName("LargeTransport")
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	--self.Entity:SetMaterial("models/props_wasteland/tugboat02")
	--self.Inputs = Wire_CreateInputs( self.Entity, { "Activate" } )

	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableGravity(false)
		phys:EnableDrag(false)
		phys:EnableCollisions(false)
	end
	self.Entity:StartMotionController()
	self.PhysObj = self.Entity:GetPhysicsObject()


	self.Speed = 0
	self.TSpeed = 150
	self.Active = false
	self.Skewed = true
	self.HSpeed = 0
end

function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	
	
	local ent = ents.Create( "LargeTransport" )
	ent:SetPos( Vector( 100000,100000,100000 ) )
	ent:Spawn()
	ent:Initialize()
	ent:Activate()
	ent.SPL = ply
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16 + Vector(0,0,50)
	
	local ent2 = ents.Create( "prop_vehicle_prisoner_pod" )
	ent2:SetModel( "models/Slyfo/transportlarge.mdl" ) 
	ent2:SetPos( SpawnPos )
	ent2:SetKeyValue("vehiclescript", "scripts/vehicles/prisoner_pod.txt")
	ent2:SetKeyValue("limitview", 0)
	ent2.HasHardpoints = true
	ent2:Spawn()
	ent2:Activate()
	local TB = ent2:GetTable()
	TB.HandleAnimation = function (vec, ply)
		return ply:SelectWeightedSequence( ACT_HL2MP_SIT ) 
	end 
	ent2:SetTable(TB)
	ent2.SPL = ply
	ent2:SetNetworkedInt( "HPC", ent.HPC )
	
	ent.Pod = ent2
	ent2.Cont = ent
	--Constrain so they get duped together
	constraint.NoCollide( ent, ent2, 0, 0 )
	
	return ent
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
					self.VSpeed = 50
				else
					self.Pitch = self.TSpeed
				end
			elseif (self.CPL:KeyDown( IN_BACK )) then
				if self.MCC then
					self.VSpeed = -50
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
				self.Speed = math.Clamp(self.Speed + 5, -40, 2000)
			elseif (self.CPL:KeyDown( IN_WALK )) then
				self.Speed = math.Clamp(self.Speed - 10, -40, 2000)
			end
	
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
					self.VSpeed = 50
				elseif (joystick.Get(self.CPL, "sbeptpt_strafe_down")) then
					self.VSpeed = -50
				end
			
				if (joystick.Get(self.CPL, "sbeptpt_strafe_right")) then
					self.HSpeed = 50
				elseif (joystick.Get(self.CPL, "sbeptpt_strafe_left")) then
					self.HSpeed = -50
				else
					self.HSpeed = 0
				end
			
				--Acceleration, greater than halfway accelerates, less than decelerates
				if (joystick.Get(self.CPL, "sbeptpt_accelerate")) then
					if (joystick.Get(self.CPL, "sbeptpt_accelerate") > 128) then
						self.Speed = math.Clamp(self.Speed + (joystick.Get(self.CPL, "sbeptpt_accelerate")/127.5-1)*5, -40, 2000)
					elseif (joystick.Get(self.CPL, "sbeptpt_accelerate") < 127) then
						self.Speed = math.Clamp(self.Speed + (joystick.Get(self.CPL, "sbeptpt_accelerate")/127.5-1)*10, -40, 2000)
					end
				end
				
				--Set the speed
				if (joystick.Get(self.CPL, "sbeptpt_thrust")) then
					if (joystick.Get(self.CPL, "sbeptpt_thrust") > 128) then
						self.TarSpeed = (joystick.Get(self.CPL, "sbeptpt_thrust")/127.5-1)*2000
					elseif (joystick.Get(self.CPL, "sbeptpt_thrust") < 127) then
						self.TarSpeed = (joystick.Get(self.CPL, "sbeptpt_thrust")/127.5-1)*40
					elseif (joystick.Get(self.CPL, "sbeptpt_thrust") < 128 && joystick.Get(self.CPL, "sbeptpt_thrust") > 127) then
						self.TarSpeed = 0
					end
					if (self.TarSpeed > self.Speed) then
						self.Speed = math.Clamp(self.Speed + 5, -40, 2000)
					elseif (self.TarSpeed < self.Speed) then
						self.Speed = math.Clamp(self.Speed - 10, -40, 2000)						
					end
				end
				
				--forward is down on pitch, if you don't like it check the box on joyconfig to inver it
				if (joystick.Get(self.CPL, "sbeptpt_pitch")) then
					if (joystick.Get(self.CPL, "sbeptpt_pitch") > 128) then
						self.Pitch = -(joystick.Get(self.CPL, "sbeptpt_pitch")/127.5-1)*90
					elseif (joystick.Get(self.CPL, "sbeptpt_pitch") < 127) then
						self.Pitch = -(joystick.Get(self.CPL, "sbeptpt_pitch")/127.5-1)*90
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
						self.Yaw = -(joystick.Get(self.CPL, yaw)/127.5-1)*90
					elseif (joystick.Get(self.CPL, yaw) < 127) then
						self.Yaw = -(joystick.Get(self.CPL, yaw)/127.5-1)*90
					elseif (joystick.Get(self.CPL, yaw) < 128 && joystick.Get(self.CPL, yaw) > 127) then
						self.Yaw = 0
					end
				end
			
				if (joystick.Get(self.CPL, roll)) then
					if (joystick.Get(self.CPL, roll) > 128) then
						self.Roll = (joystick.Get(self.CPL, roll)/127.5-1)*90
					elseif (joystick.Get(self.CPL, roll) < 127) then
						self.Roll = (joystick.Get(self.CPL, roll)/127.5-1)*90
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
				local physi = self.Pod:GetPhysicsObject()
				physi:SetVelocity( (physi:GetVelocity() * 0.75) + ((self.Pod:GetRight() * self.Speed) + (self.Pod:GetUp() * self.VSpeed) + (self.Pod:GetForward() * -self.HSpeed)) )
				physi:AddAngleVelocity((physi:GetAngleVelocity() * -0.75) + Angle(self.Roll,self.Pitch,self.Yaw))
				physi:EnableGravity(false)
			else
				self.Speed = 0
				self.Yaw = 0
				self.Roll = 0
				self.Pitch = 0
				local physi = self.Pod:GetPhysicsObject()
				physi:EnableGravity(true)
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


function ENT:BuildDupeInfo()
	local info = self.BaseClass.BuildDupeInfo(self) or {}
	if (self.Pod) and (self.Pod:IsValid()) then
	    info.Pod = self.Pod:EntIndex()
	end
	return info
end

function ENT:ApplyDupeInfo(ply, ent, info, GetEntByID)
	self.BaseClass.ApplyDupeInfo(self, ply, ent, info, GetEntByID)
	if (info.Pod) then
		self.Pod = GetEntByID(info.Pod)
		if (!self.Pod) then
			self.Pod = ents.GetByIndex(info.Pod)
		end
		self.Pod.Cont = self.Entity
		self.Pod.SPL = ply
		self.Pod:SetNetworkedInt( "HPC", ent.HPC )
		local TB = self.Pod:GetTable()
		TB.HandleAnimation = function (vec, ply)
			return ply:SelectWeightedSequence( ACT_HL2MP_SIT ) 
		end 
		self.Pod:SetTable(TB)
		self.Pod:SetKeyValue("limitview", 0)
	end
	self.SPL = ply
end