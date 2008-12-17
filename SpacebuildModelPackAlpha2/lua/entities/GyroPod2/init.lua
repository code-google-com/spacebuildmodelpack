
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

util.PrecacheSound( "k_lab.ambient_powergenerators" )
util.PrecacheSound( "ambient/machines/thumper_startup1.wav" )

function ENT:Initialize()

	self.Entity:SetModel( "models/props_combine/headcrabcannister01a.mdl" ) 
	self.Entity:SetName("GenericAircraft")
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:SetMaterial("models/props_combine/combinethumper002");

	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableGravity(true)
		phys:EnableDrag(true)
		phys:EnableCollisions(true)
	end
	self.Entity:StartMotionController()
    self.Entity:SetKeyValue("rendercolor", "255 255 255")
	self.PhysObj = self.Entity:GetPhysicsObject()
	self.LTab = {}
end

/*
function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16
	
	local ent = ents.Create( "GyroPod2" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	ent.SPL = ply
	
	return ent
	
end
*/

function ENT:TriggerInput(iname, value)
	
	if (iname == "Link") then
		if (value > 0) then
			self.Linking = true
		else
			self.Linking = false
		end
		
	elseif (iname == "TSpeed") then
		self.TSpeed = value
		
	end
	
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
			
			/*
			if (self.CPL:KeyDown( IN_RIGHT )) then
				self.Yaw = self.TSpeed
			elseif (self.CPL:KeyDown( IN_LEFT )) then
				self.Yaw = -self.TSpeed
			else
				self.Yaw = 0
			end
			*/
	
			if (self.CPL:KeyDown( IN_SPEED )) then
				self.Speed = math.Clamp(self.Speed + 2, -40, 2000)
			elseif (self.CPL:KeyDown( IN_WALK )) then
				self.Speed = math.Clamp(self.Speed - 5, -40, 2000)
			end
	
			if (self.CPL:KeyDown( IN_RELOAD )) then
				if !self.MTog then
					if self.MCC then
						self.MCC = false
					else
						self.MCC = true
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
						self.Entity:StopSound( "k_lab.ambient_powergenerators" )
					else
						self.Launchy = true
						self.Entity:EmitSound( "k_lab.ambient_powergenerators" )
						self.Entity:EmitSound( "ambient/machines/thumper_startup1.wav" )
					end
				end
				self.LTog = true
			else
				self.LTog = false
			end
			
			if self.MCC then
				self.Pitch = self.CPL.SBEPPitch * self.TSpeed
				self.Yaw = self.CPL.SBEPYaw * -self.TSpeed
			end
			
			if (self.Launchy) then
				for x, c in pairs(self.LTab) do
					if (c:IsValid()) then
						local physi = c:GetPhysicsObject()
						physi:SetVelocity( (physi:GetVelocity() * 0.75) + ((self.Entity:GetForward() * self.Speed) + (self.Entity:GetUp() * self.VSpeed)) )
						physi:AddAngleVelocity((physi:GetAngleVelocity() * -1) + Angle(self.Roll,self.Pitch,self.Yaw))
						physi:EnableGravity(false)
					end
				end
			else
				self.Speed = 0
				self.Yaw = 0
				self.Roll = 0
				self.Pitch = 0
				for x, c in pairs(self.LTab) do
					if (c:IsValid()) then
						local physi = c:GetPhysicsObject()
						physi:EnableGravity(true)
					end
				end			
			end
			
			if (self.Launchy) then
				self.Entity:GetPhysicsObject():EnableGravity(false)
			else
				self.Entity:GetPhysicsObject():EnableGravity(true)
			end
		else
			self.Speed = 0
			self.Yaw = 0
			self.Roll = 0
			self.Pitch = 0
			self.Entity:GetPhysicsObject():EnableGravity(false)
		end
	end

	self.Entity:NextThink( CurTime() + 0.01 ) 
	return true
end

function ENT:PhysicsCollide( data, physobj )
	
end

function ENT:OnTakeDamage( dmginfo )
	
end

function ENT:Link( hitEnt )
	if (hitEnt:IsVehicle()) then
		self.Pod = hitEnt
	end
	
	local LCount = 0
	local AddBreak = false
	for x, c in pairs(self.LTab) do
		if (c == hitEnt) then
			AddBreak = true
		end
		if (c:IsValid()) then
			LCount = LCount + 1
		end
	end
	if (!AddBreak) then
		self.LTab[LCount] = hitEnt
	end		
end

function ENT:OnRemove()
	self.Entity:StopSound( "k_lab.ambient_powergenerators" )
end