AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" ) 

local model = { "models/SmallBridge/SEnts/SBAhullDsE.mdl" , "models/SmallBridge/Ship Parts/SBhullDsPd.mdl" }

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

		self.Opened       		= false
		self.Delay      		= true
		self.Locked     		= false
		self.DisableUse 		= false
		self.DoorModel 			= model[2]
		self.DoorOffset 		= Vector(0, 0, 0)
		self.DoorAngleOffset 	= Angle(0, 0, 0)
		self.OpenTime		 	= 1.5
		self.CloseTime			= 1.5

		if !self.SBdoor or !self.SBdoor:IsValid() then
			self.SBdoor = ents.Create( "prop_physics" )
		end
		self:AddDoorPhysics()

		self:MakeWire()

end

function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16 + Vector(0,0,65.1)
	local RotAng   = Angle(0 , 0 , 0)
	
	local ent = ents.Create( "sbep_smb_door_hull2" )
	ent:SetPos( SpawnPos )
	ent:SetAngles( RotAng )
	ent:Spawn()
	ent:Activate()
	
	return ent
	
end