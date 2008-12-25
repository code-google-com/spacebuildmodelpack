
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )
util.PrecacheSound( "SB/Charging.wav" )

function ENT:Initialize()

	self.Entity:SetModel( "models/Slyfo/jetenginemed.mdl" ) 
	self.Entity:SetName("JetEngine")
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	--self.Inputs = Wire_CreateInputs( self.Entity, { "Fire" } )
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableGravity(true)
		phys:EnableDrag(true)
		phys:EnableCollisions(true)
		phys:SetMass( 1000 )
	end
	
	self.Entity:StartMotionController()
	
	self.Entity:SetKeyValue("rendercolor", "255 255 255")
	self.PhysObj = self.Entity:GetPhysicsObject()
	
	self.TargetZ = 0
	self.ZVelocity = 5
	self.HSpeed = 3
	self.Hovering = false

end

function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16
	
	local ent = ents.Create( "HoverJetS" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	ent.SPL = ply
	
	return ent
	
end

function ENT:TriggerInput(iname, value)		
	if (iname == "Fire") then
		if (value > 0) then
			self.Entity:HPFire()
		end

	end
end

function ENT:PhysicsUpdate()

end

function ENT:Think()
	if self.Pod && self.Pod:IsValid() then
		self.CPL = self.Pod:GetPassenger()
		if (self.CPL && self.CPL:IsValid()) then
		
			local FSpeed = 0
			local SSpeed = 0
			if (self.CPL:KeyDown( IN_FORWARD )) then
				FSpeed = 400
			elseif (self.CPL:KeyDown( IN_BACK )) then
				FSpeed = -400
			end
			
			local HOffset = 0
			
			if (self.CPL:KeyDown( IN_MOVERIGHT )) then
				if self.Side == "Left" then
					SSpeed = 400
					HOffset = 10
				elseif self.Side == "Right" then
					SSpeed = -400
					HOffset = -10
				end
			elseif (self.CPL:KeyDown( IN_MOVELEFT )) then
				if self.Side == "Left" then
					SSpeed = -400
					HOffset = -10
				elseif self.Side == "Right" then
					SSpeed = 400
					HOffset = 10
				end
			end
			
			if (self.CPL:KeyDown( IN_JUMP )) then
				HOffset = 200
			end
			
			local trace = {}
			trace.start = self.Entity:GetPos() + self.Entity:GetUp() * 20
			trace.endpos = self.Entity:GetPos() + (self.Entity:GetUp() * -600)
			trace.filter = self.Entity
			local tr = util.TraceLine( trace )
			if tr.Hit then
				local HVPos = tr.HitPos + (tr.HitNormal * 100)
				if HVPos.z > tr.HitPos.z + 70 then
					self.Hovering = true
					self.TargetZ = tr.HitPos.z + 200 + HOffset
					
					FSpeed = FSpeed * self.Entity:GetPhysicsObject():GetMass()
					SSpeed = SSpeed * self.Entity:GetPhysicsObject():GetMass()
					
					local physi = self.Pod:GetPhysicsObject()
					
					physi:ApplyForceCenter( self.Pod:GetRight() * (FSpeed) )
					physi:ApplyForceCenter( self.Pod:GetForward() * (SSpeed) )
					physi:SetVelocity( physi:GetVelocity() * 0.75 )
					physi:AddAngleVelocity(physi:GetAngleVelocity() * -0.75)
				end
			else
				self.Hovering = false
			end
			
		else
			self.Hovering = false
		end
	end
end

function ENT:PhysicsCollide( data, physobj )
	
end

function ENT:OnTakeDamage( dmginfo )
	
end

function ENT:Use( activator, caller )

end

function ENT:Touch( ent )
	if ent.HasWheels && !self.Mounted then
		if ent.Cont && ent.Cont:IsValid() then self.Entity:WLink( ent.Cont, ent.Entity ) end
	end
end

function ENT:WLink( Cont, Pod )
	for i = 1, Cont.WhC do
		if !Cont.Wh[i]["Ent"] || !Cont.Wh[i]["Ent"]:IsValid() then
			local Offset = 0
			if Cont.Wh[i]["Side"] == "Left" then
				Offset = 10
			elseif Cont.Wh[i]["Side"] == "Right" then
				Offset = -10
			end
			self.Entity:SetAngles(Pod:GetAngles())
			self.Entity:SetPos(Pod:GetPos() + Pod:GetForward() * (Cont.Wh[i]["Pos"].x + Offset) + (Pod:GetRight() * Cont.Wh[i]["Pos"].y ) + (Pod:GetUp() * (Cont.Wh[i]["Pos"].z - 10 )) )
			--weap.HPNoc = constraint.NoCollide(pod, weap, 0, 0, 0, true)
			self.WhWeld = constraint.Weld(Pod, self.Entity, 0, 0, 0, true)
			Cont.Wh[i]["Ent"] = self.Entity
			self.Pod = Pod
			self.Cont = Cont
			self.Side = Cont.Wh[i]["Side"]
			self.Mounted = true
			return
		end
	end
end

function ENT:PhysicsSimulate( phys, deltatime )

	if !self.Hovering then return SIM_NOTHING end

	if ( self.ZVelocity != 0 ) then
	
		self.TargetZ = self.TargetZ + (self.ZVelocity * deltatime * self.HSpeed)
		self.Entity:GetPhysicsObject():Wake()
	
	end
	
	phys:Wake()
	
	local Pos = phys:GetPos()
	local Vel = phys:GetVelocity()
	local Distance = self.TargetZ - Pos.z
	
	if ( Distance == 0 ) then return end
	
	local Exponent = Distance^2
	
	if ( Distance < 0 ) then
		Exponent = Exponent * -1
	end
	
	Exponent = Exponent * deltatime * 300
	
	local physVel = phys:GetVelocity()
	local zVel = physVel.z
	
	Exponent = Exponent - ( zVel * deltatime * 600 )
	// The higher you make this 300 the less it will flop about
	// I'm thinking it should actually be relative to any objects we're connected to
	// Since it seems to flop more and more the heavier the object
	
	Exponent = math.Clamp( Exponent, -5000, 5000 )
	
	local Linear = Vector(0,0,0)
	local Angular = Vector(0,0,0)
	
	Linear.z = Exponent
	
	return Angular, Linear, SIM_GLOBAL_ACCELERATION
	
end