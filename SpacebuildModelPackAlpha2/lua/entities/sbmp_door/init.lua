AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

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

		Delay = true
		Locked = false

		self:AddDoorPhysics()
		
		self.Inputs = Wire_CreateInputs(self.Entity, { "Open" , "Lock" , "Disable Use" })

end

function ENT:OnRemove() 

	ent:Remove()
	self:Remove()
	
end

function ENT:AddDoorPhysics()

	ent = ents.Create( "prop_physics" )
		ent:PhysicsInit( SOLID_VPHYSICS )
		ent:SetMoveType( MOVETYPE_VPHYSICS )
		ent:SetSolid( SOLID_VPHYSICS )
		ent:SetModel( model[2] )
		ent:Spawn()
		ent:SetAngles(self:GetAngles() + Angle( 0 , 90 , 0 ))
		ent:SetPos(self:GetPos())

		constraint.Weld( ent, self, 0, 0, 0, true )
				
		ent:SetNoDraw(true)
		
end

function ENT:Open()

	self:SetSequence( self:LookupSequence( "open" ) )
		self:ResetSequence( self:LookupSequence( "open" ) )
		self:SetPlaybackRate( 1 )
		timer.Simple(2, function()
							Delay = false
							if ent and ent:IsValid() then
								ent:SetNotSolid( true )
							end
						end)

end

function ENT:Close()

	self:SetSequence( self:LookupSequence( "close" ) )
		self:ResetSequence( self:LookupSequence( "close" ) )
		self:SetPlaybackRate( 1 )
		timer.Simple(2, function()
							Delay = true
							if ent and ent:IsValid() then
								ent:SetNotSolid( false )
							end
						end)

end

function ENT:Use( activator, caller )

	if self:IsValid() and (self:GetSequence() == self:LookupSequence( "close" )) and Delay and not Locked then

		self:Open()

	elseif self:IsValid() and (self:GetSequence() == self:LookupSequence( "open" )) and not Delay and not Locked then

		self:Close()
	
	end
	
	return
	
end

function ENT:TriggerInput(k,v)
	if (k == "Open" and v >= 1) then
	
		if not Locked then
			self:Open()
		end

	elseif (k == "Open" and v == 0) then

		if not Locked then
			self:Close()
		end

	elseif (k == "Lock" and v >= 1) then

		self:Close()
		Locked = true
		
	elseif ((k == "Lock" and v == 0) or (k == "Disable Use" and v == 0)) then
	
		Locked = false
	
	elseif (k == "Disable Use" and v >= 1) then
	
		Locked = true
	
	end
end