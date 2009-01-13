AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('entities/base_wire_entity/init.lua')
include( "shared.lua" ) 

ENT.WireDebugName = "SBMP Door"

local model = { "models/SmallBridge/SBdooranim1/SBdooranim1.mdl" , "models/SmallBridge/SBdoor/SBdoor.mdl" }

function ENT:Initialize()	

		self:SetModel( model[1] )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		
		local phys = self:GetPhysicsObject()  	
		if (phys:IsValid()) then  		
			phys:Wake()  	
		end 
		
		self:SetSequence( self:LookupSequence( "close" ) )
		self:SetPlaybackRate( 1 )

		self.Opened       = false
		self.Delay      = true
		self.Locked     = false
		self.DisableUse = false

		self:AddDoorPhysics()
		
		self.Inputs = Wire_CreateInputs(self.Entity, { "Open" , "Lock" , "Disable Use" })

end

function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16 + Vector(0,0,65.1)
	local RotAng   = Angle(180 , 0 , 0)
	
	local ent = ents.Create( "sbmp_door" )
	ent:SetPos( SpawnPos )
	ent:SetAngles( RotAng )
	ent:Spawn()
	ent:Activate()
	
	return ent
	
end

function ENT:OnRemove() 

	self.SBdoor:Remove()
	self:Remove()
	
end

function ENT:AddDoorPhysics()

	self.SBdoor = ents.Create( "prop_physics" )
		self.SBdoor:PhysicsInit( SOLID_VPHYSICS )
		self.SBdoor:SetMoveType( MOVETYPE_VPHYSICS )
		self.SBdoor:SetSolid( SOLID_VPHYSICS )
		self.SBdoor:SetModel( model[2] )
		self.SBdoor:Spawn()
		self.SBdoor:SetAngles(self:GetAngles() + Angle( 0 , 90 , 0 ))
		self.SBdoor:SetPos(self:GetPos())

		constraint.Weld( self.SBdoor, self, 0, 0, 0, true )
				
		self.SBdoor:SetNoDraw(true)
		
end

function ENT:Open()

	self:SetSequence( self:LookupSequence( "open" ) )
		self:ResetSequence( self:LookupSequence( "open" ) )
		self:SetPlaybackRate( 1 )
		timer.Simple(2, function()
							self.Delay = false
							if self.SBdoor and self.SBdoor:IsValid() then
								self.SBdoor:SetNotSolid( true )
							end
						end)

end

function ENT:Close()

	self:SetSequence( self:LookupSequence( "close" ) )
		self:ResetSequence( self:LookupSequence( "close" ) )
		self:SetPlaybackRate( 1 )
		timer.Simple(2, function()
							self.Delay = true
							if self.SBdoor and self.SBdoor:IsValid() then
								self.SBdoor:SetNotSolid( false )
							end
						end)

end

function ENT:Use( activator, caller )

	if self:IsValid() and (self:GetSequence() == self:LookupSequence( "close" )) and self.Delay and not self.DisableUse then

		self:Open()

	elseif self:IsValid() and (self:GetSequence() == self:LookupSequence( "open" )) and not self.Delay and not self.DisableUse then

		self:Close()
	
	end
	
	return
	
end

function ENT:TriggerInput(k,v)
	
	if (k == "Open" and v > 0) then
	
		if not self.Locked and (self:GetSequence() == self:LookupSequence( "close" )) then
			self:Open()
		end
		self.Opened = true

	elseif (k == "Open" and v == 0) then

		if not self.Locked and (self:GetSequence() == self:LookupSequence( "open" )) then
			self:Close()
		end
		self.Opened = false
		
	elseif (k == "Lock" and v > 0) then

		if self:GetSequence() == self:LookupSequence( "open" ) then
			self:Close()
		end
		self.Locked = true
		
	elseif (k == "Lock" and v == 0) then
	
		self.Locked = false
		if self.Opened then
			self:Open()
		end
		
	elseif (k == "Disable Use" and v > 0) then
	
		self.DisableUse = true
		
	elseif (k == "Disable Use" and v == 0) then
	
		self.DisableUse = false
	
	end
end