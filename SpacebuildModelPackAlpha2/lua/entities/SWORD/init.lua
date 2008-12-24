AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

util.PrecacheSound( "SB/SteamEngine.wav" )

function ENT:Initialize()
	
	self.Entity:SetModel( "models/Spacebuild/medbridge2_doublehull_elevatorclamp.mdl" ) 
	self.Entity:SetName("SWORD")
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
	self.TSpeed = 90
	self.Active = false
	self.Skewed = true
	
	self.HPC			= 5
	self.HP				= {}
	self.HP[1]			= {}
	self.HP[1]["Ent"]	= nil
	self.HP[1]["Type"]	= "Large"
	self.HP[1]["Pos"]	= Vector(-140,60,35)
	self.HP[2]			= {}
	self.HP[2]["Ent"]	= nil
	self.HP[2]["Type"]	= "Large"
	self.HP[2]["Pos"]	= Vector(140,60,35)
	self.HP[3]			= {}
	self.HP[3]["Ent"]	= nil
	self.HP[3]["Type"]	= "Medium"
	self.HP[3]["Pos"]	= Vector(0,130,25)
	self.HP[4]			= {}
	self.HP[4]["Ent"]	= nil
	self.HP[4]["Type"]	= "Small"
	self.HP[4]["Pos"]	= Vector(50,215,40)
	self.HP[5]			= {}
	self.HP[5]["Ent"]	= nil
	self.HP[5]["Type"]	= "Small"
	self.HP[5]["Pos"]	= Vector(-50,215,40)
	
	
end

function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	
	
	local ent = ents.Create( "SWORD" )
	ent:SetPos( Vector( 100000,100000,100000 ) )
	ent:Spawn()
	ent:Initialize()
	ent:Activate()
	ent.SPL = ply
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16 + Vector(0,0,50)
	
	local ent2 = ents.Create( "prop_vehicle_prisoner_pod" )
	ent2:SetModel( "models/Slyfo/sword.mdl" ) 
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
	
	return ent
	
end

function ENT:Think()
	if self.Pod and self.Pod:IsValid() then
		self.CPL = self.Pod:GetPassenger()
		if (self.CPL && self.CPL:IsValid()) then
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
			
			if (self.CPL:KeyDown( IN_JUMP )) then
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
			
			if (self.CPL:KeyDown( IN_ATTACK )) then
				for i = 1, self.HPC do
					local HPC = self.CPL:GetInfo( "SBHP_"..i )
					if self.HP[i]["Ent"] && self.HP[i]["Ent"]:IsValid() && (HPC == "1.00" || HPC == "1" || HPC == 1) then
						if self.HP[i]["Ent"].Cont && self.HP[i]["Ent"].Cont:IsValid() then
							self.HP[i]["Ent"].Cont:HPFire()
						else
							self.HP[i]["Ent"].Entity:HPFire()
						end
					end
				end
			end
			
			if (self.CPL:KeyDown( IN_ATTACK2 )) then
				for i = 1, self.HPC do
					local HPC = self.CPL:GetInfo( "SBHP_"..i.."a" )
					if self.HP[i]["Ent"] && self.HP[i]["Ent"]:IsValid() && (HPC == "1.00" || HPC == "1" || HPC == 1) then
						if self.HP[i]["Ent"].Cont && self.HP[i]["Ent"].Cont:IsValid() then
							self.HP[i]["Ent"].Cont:HPFire()
						else
							self.HP[i]["Ent"].Entity:HPFire()
						end
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
						
				--CYaw = (AAng.y * math.cos(math.rad(AAng.r))) - (AAng.p * math.sin(math.rad(AAng.r)))
				--CPitch = (AAng.y * math.sin(math.rad(AAng.r))) - (AAng.p * math.cos(math.rad(AAng.r)))
				
				--self.CPL:PrintMessage( HUD_PRINTCENTER, "Bearing: " .. math.Round(Yaw) .. ", Elevation: " .. math.Round(Pitch) ) 
				self.CPL:CrosshairEnable()
			end
			
			if (self.Launchy) then
				local physi = self.Pod:GetPhysicsObject()
				physi:SetVelocity( (physi:GetVelocity() * 0.75) + ((self.Pod:GetRight() * self.Speed) + (self.Pod:GetUp() * self.VSpeed)) )
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
	if self.Pod:IsValid() then
		self.Pod:Remove()
	end
end