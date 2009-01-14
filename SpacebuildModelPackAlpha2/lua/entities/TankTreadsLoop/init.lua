
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()

	self.Entity:SetModel( "models/props_phx/construct/metal_plate1.mdl" )
	self.Entity:SetName("TankTread")
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	--self.Entity:SetMaterial("models/props_combine/combinethumper002")
	self.Inputs = Wire_CreateInputs( self.Entity, { "TrackLength", "MoveSpeed", "SegSize", "Radius", "Link", "Spacing" } )
	self.Outputs = Wire_CreateOutputs( self.Entity, { "Scroll" })
    
    self.Entity:SetLength( 300 )
    self.Entity:SetSegSize( 1 )
    --self.Entity:SetCurved( false )
    self.Entity:SetRadius( 50 )
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableGravity(true)
		phys:EnableDrag(false)
		phys:EnableCollisions(true)
	end
	
    --self.Entity:SetKeyValue("rendercolor", "0 0 0")
	self.PhysObj = self.Entity:GetPhysicsObject()
	self.CAng = self.Entity:GetAngles()
	
	self.IsTankTrack = true
	self.PrevPos = self.Entity:GetPos()
	self.Linking = false
end

function ENT:TriggerInput(iname, value)		
	
	if (iname == "TrackLength") then
		if ( value > 0 && value < 1000 ) then
			self.Entity:SetLength( value )
		end
		
	elseif (iname == "MoveSpeed") then	
		if ( value > -1000 && value < 1000 ) then
			
		end
	
	elseif (iname == "SegSize") then	
		if ( value > 0 && value < 10 ) then
			self.Entity:SetSegSize( value )
		end

	elseif (iname == "Radius") then	
		if ( value > 0 ) then
			self.Entity:SetRadius( value )
		end
		
	elseif (iname == "Spacing") then	
		if ( value > 0 ) then
			self.Entity:SetSpacing( value )
		end
		
	elseif (iname == "Link") then	
		if ( value > 0 ) then
			self.Linking = true
		else
			self.Linking = false
		end
		
	end
end

function ENT:Think()
	/*
	local FDist = self.PrevPos:Distance( self.Entity:GetPos() + self.Entity:GetForward() * 50 )
	local BDist = self.PrevPos:Distance( self.Entity:GetPos() + self.Entity:GetForward() * -50 )
	self.Scroll = FDist - BDist
	
	Wire_TriggerOutput(self.Entity, "Scroll", self.Scroll)
	self.PrevPos = self.Entity:GetPos()
	
	self.Entity:NextThink( CurTime() + 0.1 ) 
	return true
	*/
end

function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16 + Vector(0,0,50)
	
	local ent = ents.Create( "TankTreadsLoop" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Initialize()
	ent:Activate()
	ent.SPL = ply
	
	return ent
	
end

function ENT:Use( activator, caller )

end

function ENT:Touch( ent )
	if self.Linking && ent:IsValid() && ent.IsTankTrack then
		ent:SetCont( self.Entity )
	end
end