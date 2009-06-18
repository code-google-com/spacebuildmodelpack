AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize(self)
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Inputs = Wire_CreateInputs( self.Entity, { "Dock" } )
	self.Outputs = Wire_CreateOutputs( self.Entity, { "Status" })
	self.Entity:SetNWInt( "DMode", self.DMode )
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableGravity(true)
		phys:EnableDrag(true)
		phys:EnableCollisions(true)
	end
	self.Entity:StartMotionController()
	self.PhysObj = self.Entity:GetPhysicsObject()
	self.Entity:SetNetworkedEntity( "LinkLock", nil )
		
	self.LinkLock = nil
end

function ENT:TriggerInput(iname, value)		
	if (iname == "Dock") then
		if (value > 0) then
			self.DMode = 2		
			self.Entity:EmitSound("Buttons.snd1")
		else
			self.Entity:EmitSound("Buttons.snd19")
			self.DMode = 1
			if self.LinkLock && self.LinkLock:IsValid() then
				if self.LinkLock.DMode == 3 || self.LinkLock.DMode == 4 then 
					self.LinkLock.DMode = 2
				end
				self.LinkLock.LinkLock = nil
				self.LinkLock:SetNetworkedEntity( "LinkLock", nil )
				self.Entity:SetNetworkedEntity( "LinkLock", nil )
			end
			self.LinkLock = nil
			if self.AWeld then
				if self.AWeld:IsValid() then
					self.AWeld:Remove()
				end
			end
		end		
	end
end

function ENT:Think()
	if self.DMode == 2 then
	
		--local mn, mx = self.Entity:WorldSpaceAABB()
		--mn = mn - Vector(20, 20, 20)
		--mx = mx + Vector(20, 20, 20)
		--local T = ents.FindInBox(mn, mx)
		local T = ents.FindInSphere( self.Entity:GetPos(), self.ScanDist)
		
		for _,i in pairs( T ) do
			if( i.Entity && i.Entity:IsValid() && i.Entity != self.Entity && i.IsAirLock && table.HasValue( self.CompatibleLocks, i.ALType ) && i.DMode == 2) then
				--print(math.fmod((i.Entity:GetAngles().y + self.AYaw), 360).." <= "..math.fmod((self.Entity:GetAngles().y + (self.MYaw * 3)), 360))
				--print(math.fmod((i.Entity:GetAngles().y + self.AYaw), 360).." >= "..math.fmod((self.Entity:GetAngles().y - (self.MYaw * 3)), 360))
				--print("Entity Found")
				--if math.fmod((i.Entity:GetAngles().r + self.ARoll), 360) <= math.fmod((self.Entity:GetAngles().r + (self.MRoll * 3)), 360) && math.fmod((i.Entity:GetAngles().r + self.ARoll), 360) >= math.fmod((self.Entity:GetAngles().r - (self.MRoll * 3)), 360) then
				if math.AngleDifference(math.fmod((i.Entity:GetAngles().r + self.ARoll), 360),self.Entity:GetAngles().r) <= self.MRoll * 3 && math.AngleDifference(math.fmod((i.Entity:GetAngles().r + self.ARoll), 360),self.Entity:GetAngles().r) >= self.MRoll * -3 then
					--print("Roll Match")
					--if math.fmod((i.Entity:GetAngles().p + self.APitch), 360) <= math.fmod((self.Entity:GetAngles().p + (self.MPitch * 3)), 360) && math.fmod((i.Entity:GetAngles().p + self.APitch), 360) >= math.fmod((self.Entity:GetAngles().p - (self.MPitch * 3)), 360) then
					if math.AngleDifference(math.fmod((i.Entity:GetAngles().p + self.APitch), 360),self.Entity:GetAngles().p) <= self.MPitch * 3 && math.AngleDifference(math.fmod((i.Entity:GetAngles().p + self.APitch), 360),self.Entity:GetAngles().p) >= self.MPitch * -3 then
						--print("Pitch Match")
						--if math.fmod((i.Entity:GetAngles().y + self.AYaw), 360) <= math.fmod((self.Entity:GetAngles().y + (self.MYaw * 3)), 360) && math.fmod((i.Entity:GetAngles().y + self.AYaw), 360) >= math.fmod((self.Entity:GetAngles().y - (self.MYaw * 3)), 360) then
						if math.AngleDifference(math.fmod((i.Entity:GetAngles().y + self.AYaw), 360),self.Entity:GetAngles().y) <= self.MYaw * 3 && math.AngleDifference(math.fmod((i.Entity:GetAngles().y + self.AYaw), 360),self.Entity:GetAngles().y) >= self.MYaw * -3 then
							--print("Yaw Match")
							--if i.Entity:GetPos():Distance(self.Entity:GetPos()) <= self.MDist * 100 then
								self.LinkLock = i
								i.LinkLock = self.Entity
								self.Entity:SetNetworkedEntity( "LinkLock", self.LinkLock )
								self.LinkLock:SetNetworkedEntity( "LinkLock", self.Entity )
								self.DMode = 3
								i.DMode = 3
								self.Entity:EmitSound("Building_Teleporter.Send")
								return
							--end
						end
					end
				end
			end
		end
	end
	if self.DMode == 3 && self.LinkLock && self.LinkLock:IsValid() then
		--print("Entity Found")
		if math.AngleDifference(math.fmod((self.LinkLock:GetAngles().r + self.ARoll), 360),self.Entity:GetAngles().r) <= self.MRoll * 1 && math.AngleDifference(math.fmod((self.LinkLock:GetAngles().r + self.ARoll), 360),self.Entity:GetAngles().r) >= self.MRoll * -1 then
			--print("Roll Match")
			if math.AngleDifference(math.fmod((self.LinkLock:GetAngles().p + self.APitch), 360),self.Entity:GetAngles().p) <= self.MPitch * 1 && math.AngleDifference(math.fmod((self.LinkLock:GetAngles().p + self.APitch), 360),self.Entity:GetAngles().p) >= self.MPitch * -1 then
				--print("Pitch Match")
				if math.AngleDifference(math.fmod((self.LinkLock:GetAngles().y + self.AYaw), 360),self.Entity:GetAngles().y) <= self.MYaw * 1 && math.AngleDifference(math.fmod((self.LinkLock:GetAngles().y + self.AYaw), 360),self.Entity:GetAngles().y) >= self.MYaw * -1 then
					--print("Yaw Match")
					if self.LinkLock.Entity:GetPos():Distance(self.Entity:GetPos()) <= self.MDist then
						self.LinkLock.Entity:SetAngles(self.Entity:LocalToWorldAngles(Angle(self.LinkLock.APitch,self.LinkLock.AYaw,self.LinkLock.ARoll)))
						self.LinkLock.Entity:SetPos( self.Entity:GetPos() + (self.Entity:GetForward() * self.LinkLock.AF) + (self.Entity:GetRight() * self.LinkLock.AR) + (self.Entity:GetUp() * self.LinkLock.AU) )
						self.AWeld = constraint.Weld(self.LinkLock.Entity, self.Entity, 0, 0, 0, true)
						self.LinkLock.AWeld = self.AWeld
						self.DMode = 4
						self.LinkLock.DMode = 4
						self.Entity:EmitSound("Building_Teleporter.Ready")
					end
				end
			end
		end
	end
	
	if self.DMode == 3 then
		if self.LinkLock && self.LinkLock:IsValid() then
			local Physy = self.Entity:GetPhysicsObject()
			
			Physy:Wake()		
			
			local Pos = self.Entity:GetPos()
			local Pos2 = self.LinkLock:GetPos()
			local Vel = Physy:GetVelocity()
			
			local Distance = self.LinkLock:GetPos():Distance(self.Entity:GetPos())
			
			if Distance > self.ScanDist then 
				self.LinkLock.DMode = 2
				self.LinkLock.LinkLock = nil
				self.LinkLock:SetNetworkedEntity( "LinkLock", nil )
				self.Entity:SetNetworkedEntity( "LinkLock", nil )
				self.LinkLock = nil
				self.DMode = 2
				self.Entity:EmitSound("Building_Teleporter.Receive")
				return
			end
			
			if self.LinkLock.DMode != 3 then
				self.Entity:SetNetworkedEntity( "LinkLock", nil )
				self.LinkLock = nil
				self.DMode = 2
				self.Entity:EmitSound("Building_Teleporter.Receive")
				return
			end
			
			TVec = (self.LinkLock:GetPos() + self.LinkLock:GetForward() * self.AF + self.LinkLock:GetRight() * self.AR + self.LinkLock:GetUp() * self.AU ) - self.Entity:GetPos()
			
			--OVec = Vel * -1
			
			--MVec = OVec + TVec
			
			local Linear = TVec:GetNormal() * math.Clamp(Distance * 10, 0, 100)
			
			
			Physy:SetVelocity( Linear )
			
			local Roll = math.AngleDifference(self.LinkLock:GetAngles().r, math.fmod(self.Entity:GetAngles().r + self.ARoll,360))
			local Pitch = math.AngleDifference(self.LinkLock:GetAngles().p, math.fmod(self.Entity:GetAngles().p + self.APitch,360))
			local Yaw = math.AngleDifference(self.LinkLock:GetAngles().y, math.fmod(self.Entity:GetAngles().y + self.AYaw,360))
			
			Physy:AddAngleVelocity((Physy:GetAngleVelocity() * -1) + Angle(Roll,Pitch,Yaw))
		else
			self.Entity:EmitSound("Building_Teleporter.Receive")
			self.DMode = 2
		end
	end
	
	Wire_TriggerOutput( self.Entity, "Status", self.DMode )
	if self.ClDMode != self.DMode then
		self.Entity:SetNWInt( "DMode", self.DMode )
		self.ClDMode = self.DMode
		print("Changing DMode to "..self.DMode)
	end
end

function ENT:PhysicsCollide( data, physobj )

end

function ENT:OnTakeDamage( dmginfo )
	
end

function ENT:Touch( ent )

end

function ENT:OnRemove()

end