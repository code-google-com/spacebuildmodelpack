AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" ) 

local model = { "models/SmallBridge/SEnts/SBADoorDBsmall.mdl" , "models/SmallBridge/Panels/SBdoorDBsmall.mdl" }

function ENT:Initialize()	

		self:SetModel( model[1] )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		
		local phys = self:GetPhysicsObject()  	
		if (phys:IsValid()) then  		
			phys:Wake()  	
		end 
		
		self:ResetSequence( self:LookupSequence( "close" ) )
		self:SetPlaybackRate( 1 )

		self.OpenStatus      	= false
		self.Locked     		= false
		self.DisableUse 		= false
		self.DoorModel 			= model[2]
		self.DoorOffset 		= Vector(0, 0, 0)
		self.DoorAngleOffset 	= Angle(0, 0, 0)
		self.UseDelay		 	= 5
		
		self.OpenSequence 	= self:LookupSequence( "open" )
		self.CloseSequence	= self:LookupSequence( "close" )

		if !self.SBdoor or !self.SBdoor:IsValid() then
			self.SBdoor = ents.Create( "prop_physics" )
		end
		self:AddDoorPhysics()

		self:Close()

		self:MakeWire()

end

function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16 + Vector(0,0,150)
	local RotAng   = Angle(0 , 0 , 0)
	
	local ent = ents.Create( "sbep_smb_door_DBS" )
	ent:SetPos( SpawnPos )
	ent:SetAngles( RotAng )
	ent:Spawn()
	ent:Activate()
	
	return ent
	
end

function ENT:OpenDoorSounds()

	self:EmitSound("Doors.Move14")
	timer.Simple(1.3, function()
									self:EmitSound("Doors.FullOpen8")
								end)
	timer.Simple(2.6, function()
									self:EmitSound("Doors.FullOpen8")
								end)
	timer.Simple(3.9, function()
									self:EmitSound("Doors.FullOpen9")
								end)
	timer.Simple(4.9, function()
									self:EmitSound("Doors.FullOpen8")
								end)

end

function ENT:CloseDoorSounds()

	self:EmitSound("Doors.Move14")
	timer.Simple(2.6, function()
									self:EmitSound("Doors.FullOpen8")
								end)
	timer.Simple(3.95, function()
									self:EmitSound("Doors.FullOpen8")
								end)
	timer.Simple(4.9, function()
									self:EmitSound("Doors.FullOpen9")
								end)

end