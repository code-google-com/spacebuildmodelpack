AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

--util.PrecacheSound( "SB/SteamEngine.wav" )

function ENT:Initialize()
	
	self.Entity:SetModel( "models/Spacebuild/medbridge2_doublehull_elevatorclamp.mdl" ) 
	self.Entity:SetName("Rover")
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
	
	self.HPC			= 3
	self.HP				= {}
	self.HP[1]			= {}
	self.HP[1]["Ent"]	= nil
	self.HP[1]["Type"]	= "RRightPanel"
	self.HP[1]["Pos"]	= Vector(-29,33,63)
	self.HP[2]			= {}
	self.HP[2]["Ent"]	= nil
	self.HP[2]["Type"]	= "RLeftPanel"
	self.HP[2]["Pos"]	= Vector(29,33,63)
	self.HP[3]			= {}
	self.HP[3]["Ent"]	= nil
	self.HP[3]["Type"]	= "RBackPanel"
	self.HP[3]["Pos"]	= Vector(0,-29,74)
	
	self.WhC = 4
	self.Wh = {}
	self.Wh[1] = {}
	self.Wh[1]["Ent"]	= nil
	self.Wh[1]["Pos"]	= Vector(34,93,-6)
	self.Wh[1]["Side"]	= "Left"
	self.Wh[2] = {}
	self.Wh[2]["Ent"]	= nil
	self.Wh[2]["Pos"]	= Vector(-34,93,-6)
	self.Wh[2]["Side"]	= "Right"
	self.Wh[3] = {}
	self.Wh[3]["Ent"]	= nil
	self.Wh[3]["Pos"]	= Vector(34,-24,-6)
	self.Wh[3]["Side"]	= "Left"
	self.Wh[4] = {}
	self.Wh[4]["Ent"]	= nil
	self.Wh[4]["Pos"]	= Vector(-34,-24,-6)
	self.Wh[4]["Side"]	= "Right"
end

function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	
	
	local ent = ents.Create( "Rover" )
	ent:SetPos( Vector( 100000,100000,100000 ) )
	ent:Spawn()
	ent:Initialize()
	ent:Activate()
	ent.SPL = ply
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16 + Vector(0,0,50)
	
	local ent2 = ents.Create( "prop_vehicle_prisoner_pod" )
	ent2:SetModel( "models/Slyfo/rover1_chassis.mdl" ) 
	ent2:SetPos( SpawnPos )
	ent2:SetKeyValue("vehiclescript", "scripts/vehicles/prisoner_pod.txt")
	ent2:SetKeyValue("limitview", 0)
	ent2.HasHardpoints = true
	ent2.HasWheels = true
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
					else
						--self.MCC = true
					end
				end
				self.MTog = true
			else
				self.MTog = false
			end
			
			if (self.CPL:KeyDown( IN_JUMP )) then
				if !self.LTog then
					if self.Launchy then
						--self.Launchy = false
						--self.Pod:StopSound( "k_lab.ambient_powergenerators" )
					else
						--self.Launchy = true
						--self.Pod:EmitSound( "k_lab.ambient_powergenerators" )
						--self.Pod:EmitSound( "ambient/machines/thumper_startup1.wav" )
					end
				end
				self.LTog = true
			else
				self.LTog = false
			end
			
			if (self.CPL:KeyDown( IN_ATTACK )) then
				for i = 1, self.HPC do
					local HPC = self.CPL:GetInfo( "SBHP_"..i )
					if self.HP[i]["Ent"] && self.HP[i]["Ent"]:IsValid() && (HPC == "1.00" || HPC == "1" || HPC == 1) then
						self.HP[i]["Ent"].Entity:HPFire()
					end
				end
			end
			
			if (self.CPL:KeyDown( IN_ATTACK2 )) then
				for i = 1, self.HPC do
					local HPC = self.CPL:GetInfo( "SBHP_"..i.."a" )
					if self.HP[i]["Ent"] && self.HP[i]["Ent"]:IsValid() && (HPC == "1.00" || HPC == "1" || HPC == 1) then
						self.HP[i]["Ent"].Entity:HPFire()
					end
				end
			end
			
			if self.MCC then
				local PAng = self.CPL:EyeAngles()
				local VAng = self.Pod:GetAngles()
				local AAng = Angle(0,0,0)
				
				--self.CPL:PrintMessage( HUD_PRINTCENTER, "Player: " .. math.Round(PAng.y) .. ", " .. math.Round(PAng.r) )
				--self.CPL:PrintMessage( HUD_PRINTCENTER, "Player: " .. math.Round(VAng.y) .. ", " .. math.Round(VAng.r) )
				
				AAng.r = VAng.r
				AAng.p = PAng.p - VAng.p
				AAng.z = PAng.y - VAng.y
				
				--self.CPL:PrintMessage( HUD_PRINTCENTER, "Player: " .. math.Round(AAng.y) .. ", " .. math.Round(AAng.r) ) 
				
				CYaw = (AAng.y * math.cos(math.rad(AAng.r))) - (AAng.p * math.sin(math.rad(AAng.r)))
				CPitch = (AAng.y * math.sin(math.rad(AAng.r))) - (AAng.p * math.cos(math.rad(AAng.r)))
				
				self.CPL:PrintMessage( HUD_PRINTCENTER, "Player: " .. math.Round(CYaw) .. ", " .. math.Round(CPitch) ) 
				self.CPL:CrosshairEnable()
			end
			
			if (self.Launchy) then
				local physi = self.Pod:GetPhysicsObject()
				physi:SetVelocity( (physi:GetVelocity() * 0.75) + ((self.Pod:GetRight() * self.Speed) + (self.Pod:GetUp() * self.VSpeed)) )
				physi:AddAngleVelocity((physi:GetAngleVelocity() * -1) + Angle(self.Roll,self.Pitch,self.Yaw))
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