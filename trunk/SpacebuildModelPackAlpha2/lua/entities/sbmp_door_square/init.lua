AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" ) 

ENT.WireDebugName = "SBMP Door"

local model = { "models/SmallBridge/SBdooranim2/SBdooranim2.mdl" , "models/SmallBridge/SBdoorsquare/SBdoorsquare.mdl" }

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
	
	local ent = ents.Create( "sbmp_door_square" )
	ent:SetPos( SpawnPos )
	ent:SetAngles( RotAng )
	ent:Spawn()
	ent:Activate()
	
	return ent
	
end

function ENT:OnRemove() 

	self.SBdoorsquare:Remove()
	self:Remove()
	
end

function ENT:AddDoorPhysics()

	self.SBdoorsquare = ents.Create( "prop_physics" )
		self.SBdoorsquare:PhysicsInit( SOLID_VPHYSICS )
		self.SBdoorsquare:SetMoveType( MOVETYPE_VPHYSICS )
		self.SBdoorsquare:SetSolid( SOLID_VPHYSICS )
		self.SBdoorsquare:SetModel( model[2] )
		self.SBdoorsquare:Spawn()
		self.SBdoorsquare:SetAngles(self:GetAngles() + Angle( 0 , 0 , 0 ))
		self.SBdoorsquare:SetPos(self:GetPos())

		constraint.Weld( self.SBdoorsquare, self, 0, 0, 0, true )
				
		self.SBdoorsquare:SetNoDraw(true)
		
end

function ENT:Open()

	self:SetSequence( self:LookupSequence( "open" ) )
		self:ResetSequence( self:LookupSequence( "open" ) )
		self:SetPlaybackRate( 1 )
		timer.Simple(2, function()
							self.Delay = false
							if self.SBdoorsquare and self.SBdoorsquare:IsValid() then
								self.SBdoorsquare:SetNotSolid( true )
							end
						end)

end

function ENT:Close()

	self:SetSequence( self:LookupSequence( "close" ) )
		self:ResetSequence( self:LookupSequence( "close" ) )
		self:SetPlaybackRate( 1 )
		timer.Simple(2, function()
							self.Delay = true
							if self.SBdoorsquare and self.SBdoorsquare:IsValid() then
								self.SBdoorsquare:SetNotSolid( false )
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