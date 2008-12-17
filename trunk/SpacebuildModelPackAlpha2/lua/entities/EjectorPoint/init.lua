AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()

	self.Entity:SetModel( "models/jaanus/wiretool/wiretool_range.mdl" ) 
	self.Entity:SetName("NCController")
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )

	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableGravity(false)
		phys:EnableDrag(false)
		phys:EnableCollisions(true)
	end
	self.Entity:StartMotionController()
	self.PhysObj = self.Entity:GetPhysicsObject()
	self.Inputs = Wire_CreateInputs( self.Entity, { "Launch", "Velocity" } )
	
	self.Velocity = 2000
	
end

function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16 + Vector(0,0,10)
	
	local ent = ents.Create( "EjectorPoint" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Initialize()
	ent:Activate()
	ent.SPL = ply
	
	return ent
	
end

function ENT:TriggerInput(iname, value)
	
	if (iname == "Launch") then
		if (value >= 0) then
			self.Entity:Launch()
		end
	elseif (iname == "Velocity") then
		self.Velocity = value
	end
	
end

function ENT:Think()
	if self.Vec && self.Vec:IsValid() then
		local Ply = self.Vec:GetPassenger()
		if Ply && Ply:IsValid() then
			if (Ply:KeyDown( IN_RELOAD ) && Ply:KeyDown( IN_DUCK )) then
				self.Entity:Launch()
			end
		end
	end
end

function ENT:PhysicsCollide( data, physobj )
	
end

function ENT:OnTakeDamage( dmginfo )
	
end

function ENT:Touch( ent )
	if (ent:IsVehicle()) then
		self.Vec = ent
	end
end

function ENT:Use( ply )
	if self.Vec && self.Vec:IsValid() then
		ply:EnterVehicle( self.Vec )
	end
end

function ENT:Launch( )
	if self.Vec && self.Vec:IsValid() then
		local EPP = self.Entity:GetPos()
		local VP = self.Vec:GetPos()
		local Dist = EPP:Distance(VP)
		if Dist <= 3500 then
			local Ply = self.Vec:GetPassenger()
			if Ply && Ply:IsValid() then
				local NPod = ents.Create( "prop_vehicle_prisoner_pod" )
				if ( !NPod:IsValid() ) then return end
				NPod:SetModel( "models/SmallBridge/SBdroppod1/SBdroppod1.mdl" )
				NPod:SetKeyValue("vehiclescript", "scripts/vehicles/prisoner_pod.txt")
				NPod:SetKeyValue("limitview", 0)
				--NPod:SetMembers(HandleAnimation, HandleSBMPSitAnimation)
				NPod:SetPos( self.Entity:GetPos() + self.Entity:GetUp() * 50 )
				NPod:SetAngles( self.Entity:GetAngles() )
				NPod:Spawn()
				NPod:Activate()
				
				local RockTrail = ents.Create("env_rockettrail")
				RockTrail:SetAngles( NPod:GetUp():Angle()  )
				RockTrail:SetPos( NPod:GetPos() )
				RockTrail:SetParent(NPod.Entity)
				RockTrail:Spawn()
				RockTrail:Activate()
				local RTT = self.Velocity * 0.001
				RockTrail:Fire("kill", "", RTT)
				
				NPod:SetSkin(self.Entity:GetSkin())
				
				local TB = NPod:GetTable()
				TB.HandleAnimation = function (vec, ply)
					return ply:SelectWeightedSequence( ACT_HL2MP_SIT ) 
				end 
				NPod:SetTable(TB)
				
				local NC = constraint.NoCollide(self.Entity, NPod, 0, 0)
				NC = constraint.NoCollide(self.Vec, NPod, 0, 0)
				
				Ply:ExitVehicle()
				Ply:EnterVehicle( NPod )
				local phy = NPod:GetPhysicsObject()
				phy:SetVelocity(self.Entity:GetUp() * self.Velocity)
				NPod:Fire("kill", "", 15)
				
			end
		end
	end
end