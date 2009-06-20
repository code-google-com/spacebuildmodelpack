AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" ) 

ENT.WireDebugName = "SBEP Door"

function ENT:MakeWire()
	self.Inputs = Wire_CreateInputs(self.Entity, { "Open" , "Lock" , "Disable Use" })
	self.Outputs = WireLib.CreateOutputs(self.Entity,{"Open","Locked"})
end

function ENT:OnRemove() 

	self.SBdoor:Remove()
	self:Remove()
	
end

function ENT:AddDoorPhysics()
	
	self.SBdoor:PhysicsInit( SOLID_VPHYSICS )
	self.SBdoor:SetMoveType( MOVETYPE_VPHYSICS )
	self.SBdoor:SetSolid( 77 )
	self.SBdoor:SetModel( self.DoorModel )
	self.SBdoor:Spawn()
	self.SBdoor:SetAngles(self:GetAngles() + self.DoorAngleOffset)
	self.SBdoor:SetPos(self:GetPos() + self.DoorOffset)

	constraint.Weld( self.SBdoor, self, 0, 0, 0, true )

	self.SBdoor:SetNoDraw(true)
end

function ENT:Open()

	self:ResetSequence( self.OpenSequence )
		self:SetPlaybackRate( 1 )
		self:OpenDoorSounds()
		timer.Simple(self.UseDelay, function()
							self.OpenStatus = true
							if self.SBdoor and self.SBdoor:IsValid() then
								self.SBdoor:SetNotSolid( true )
							end
							WireLib.TriggerOutput(self.Entity,"Open",1)
						end)
	WireLib.TriggerOutput(self.Entity,"Open",0.5)

end

function ENT:Close()

	self:ResetSequence( self.CloseSequence )
		self:SetPlaybackRate( 1 )
		self:CloseDoorSounds()
		timer.Simple(self.UseDelay, function()
							self.OpenStatus = false
							if self.SBdoor and self.SBdoor:IsValid() then
								self.SBdoor:SetNotSolid( false )
							end
							WireLib.TriggerOutput(self.Entity,"Open",0)
						end)
	WireLib.TriggerOutput(self.Entity,"Open",0.5)

end

function ENT:Use( activator, caller )

	if self:IsValid() and self:GetSequence() == self.CloseSequence and not self.OpenStatus and not self.DisableUse then

		self:Open()

	elseif self:IsValid() and self:GetSequence() == self.OpenSequence and self.OpenStatus and not self.DisableUse then

		self:Close()
	
	end
	
	return
	
end

function ENT:Think()

	if !self.SBdoor or !self.SBdoor:IsValid() then
		self.SBdoor = ents.Create( "prop_physics" )
		self:AddDoorPhysics()
	end
		
	self.Entity:NextThink( CurTime() + 0.01 )
	
	return true
end

function ENT:TriggerInput(k,v)
	
	if (k == "Open" and v > 0) then
	
		if not self.Locked and self:GetSequence() == self.CloseSequence then
			self:Open()
		end

	elseif (k == "Open" and v == 0) then

		if not self.Locked and self:GetSequence() == self.OpenSequence then
			self:Close()
		end
		
	elseif (k == "Lock" and v > 0) then

		if self:GetSequence() == self.OpenSequence then
			self:Close()
		end
		self.Locked = true
		WireLib.TriggerOutput(self.Entity,"Locked",1)
		
	elseif (k == "Lock" and v == 0) then
	
		self.Locked = false
		WireLib.TriggerOutput(self.Entity,"Locked",0)
		if self.OpenStatus then
			self:Open()
		end
		
	elseif (k == "Disable Use" and v > 0) then
	
		self.DisableUse = true
		
	elseif (k == "Disable Use" and v == 0) then
	
		self.DisableUse = false
	
	end
end

function ENT:BuildDupeInfo()
	local info = self.BaseClass.BaseClass.BuildDupeInfo(self) or {}
	if (self.SBdoor) then
		info.SBdoor = self.SBdoor:EntIndex()
	end
	return info
end

function ENT:ApplyDupeInfo(ply, ent, info, GetEntByID)
	self.BaseClass.BaseClass.ApplyDupeInfo(self, ply, ent, info, GetEntByID)
	if (info.SBdoor) then
		GetEntByID(info.SBdoor):Remove()
	end
end