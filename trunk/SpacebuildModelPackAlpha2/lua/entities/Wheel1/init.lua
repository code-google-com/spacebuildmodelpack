
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )
util.PrecacheSound( "SB/Charging.wav" )

function ENT:Initialize()

	self.Entity:SetModel( "models/props_phx/wheels/trucktire.mdl" ) 
	self.Entity:SetName("Wheel")
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
	end
	self.Entity:SetKeyValue("rendercolor", "255 255 255")
	self.PhysObj = self.Entity:GetPhysicsObject()
	
	self.Mounted = false

end

function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16
	
	local ent = ents.Create( "Wheel1" )
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
				FSpeed = 1000
			elseif (self.CPL:KeyDown( IN_BACK )) then
				FSpeed = -1000
			end
			
			if (self.CPL:KeyDown( IN_MOVERIGHT )) then
				if self.Side == "Left" then
					SSpeed = 1800
				elseif self.Side == "Right" then
					SSpeed = -1800
				end
			elseif (self.CPL:KeyDown( IN_MOVELEFT )) then
				if self.Side == "Left" then
					SSpeed = -800
				elseif self.Side == "Right" then
					SSpeed = 800
				end
			end
			
			local Phys = self.Entity:GetPhysicsObject()
			
			if (self.CPL:KeyDown( IN_JUMP )) then
				FSpeed = 0
				SSpeed = 0	
				if self.Entity:IsOnGround() then
					Phys:SetVelocity( (Phys:GetVelocity() * 0.8) )
				end
				Phys:AddAngleVelocity((Phys:GetAngleVelocity() * -0.8))
			end
			
			if self.Side == "Left" then
				Phys:AddAngleVelocity(Angle(0, 0, (SSpeed + FSpeed)))
			elseif self.Side == "Right" then
				Phys:AddAngleVelocity(Angle(0, 0, (SSpeed + FSpeed) * -1))
			end
				
			if self.Entity:IsOnGround() then
				self.Entity:GetPhysicsObject():ApplyForceCenter( self.Pod:GetForward() * (SSpeed + FSpeed) )
			end
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
			local Offset = {0, 0, 10}
			local AOffset = 0
			local ZVecAngle = Angle(0, 90, 0)
			local PodVec = (Pod:GetForward())
			PodVec:Rotate(ZVecAngle)
			if Cont.Wh[i]["Side"] == "Left" then
				AOffset = 90
				local Ang = (PodVec:Angle())
				Ang:RotateAroundAxis( PodVec, AOffset )
				self.Entity:SetAngles( Ang )
			else
				AOffset = -90
				local Ang = ((PodVec*-1):Angle())
				Ang:RotateAroundAxis( PodVec, AOffset )
				self.Entity:SetAngles( Ang )
			end
			self.Entity:SetPos(Pod:GetPos() + Pod:GetForward() * (Cont.Wh[i]["Pos"].x + Offset[1]) + Pod:GetRight() * (Cont.Wh[i]["Pos"].y + Offset[2]) + Pod:GetUp() * (Cont.Wh[i]["Pos"].z + Offset[3]))
			local LPos = nil
			local Cons = nil
			LPos = Vector(0,0,0)
			Cons = constraint.Ballsocket( Pod, self.Entity, 0, 0, LPos, 0, 0, 1)
			LPos = self.Entity:WorldToLocal(self.Entity:GetPos() + self.Entity:GetUp() * 10)
			Cons = constraint.Ballsocket( Pod, self.Entity, 0, 0, LPos, 0, 0, 1)
			--weap.HPNoc = constraint.NoCollide(pod, weap, 0, 0, 0, true)
			--weap.HPWeld = constraint.Weld(pod, weap, 0, 0, 0, true)
			Cont.Wh[i]["Ent"] = self.Entity
			self.Pod = Pod
			self.Cont = Cont
			self.Side = Cont.Wh[i]["Side"]
			return
		end
	end
end

function ENT:BuildDupeInfo()
	local info = self.BaseClass.BuildDupeInfo(self) or {}
	if (self.Side) then
		info.Side = self.Side
	end
	if (self.Mounted) then
		info.Mounted = self.Mounted
	end
	if (self.Pod) and (self.Pod:IsValid()) then
		info.Pod = self.Pod:EntIndex()
	end
	if (self.Cont) and (self.Cont:IsValid()) then
		info.Cont = self.Cont:EntIndex()
	end
	return info
end

function ENT:ApplyDupeInfo(ply, ent, info, GetEntByID)
	self.BaseClass.ApplyDupeInfo(self, ply, ent, info, GetEntByID)
	if (info.Cont) then
		self.Cont = GetEntByID(info.Cont)
		if (!self.Cont) then
			self.Cont = ents.GetByIndex(info.Cont)
		end
	end
	if (info.Pod) then
		self.Pod = GetEntByID(info.Pod)
		if (!self.Pod) then
			self.Pod = ents.GetByIndex(info.Pod)
		end
	end
	if (info.Mounted) then
		self.Mounted = info.Mounted
	end
	if (info.Side) then
		self.Side = info.Side
	end
	self.SPL = ply
end