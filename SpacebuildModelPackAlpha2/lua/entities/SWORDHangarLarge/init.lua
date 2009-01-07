
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )
local Fighters = list.Get("sbepfighters")
--PrintTable(Fighters)

function ENT:Initialize()

	self.Entity:SetModel( "models/Slyfo/hangar2.mdl" )
	self.Entity:SetName("SWORDHangarLarge")
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableGravity(true)
		phys:EnableDrag(true)
		phys:EnableCollisions(true)
	end
	
    self.Entity:SetKeyValue("rendercolor", "255 255 255")
	
end

function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16 + Vector(0,0,500)
	
	local ent = ents.Create( "SWORDHangarLarge" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Initialize()
	ent:Activate()
	ent.SPL = ply
	
	return ent
	
end

function ENT:Think()
	if ( !self.SWORD1 || !self.SWORD1:IsValid() ) then
		self.Bay1Cons = nil
		self.SWORD1 = nil
	end
	if ( self.SWORD1 && self.SWORD1.Cont.Launchy ) then
		self.Bay1Cons:Remove()
		self.Bay1Cons = nil
		self.SWORD1.Cont.Speed =1000
		self.SWORD1 = nil
	end
	if ( !self.SWORD2 || !self.SWORD2:IsValid() ) then
		self.Bay2Cons = nil
		self.SWORD2 = nil
	end
	if ( self.SWORD2 && self.SWORD2.Cont.Launchy ) then
		self.Bay2Cons:Remove()
		self.Bay2Cons = nil
		self.SWORD2.Cont.Speed =1000
		self.SWORD2 = nil
	end
	if ( !self.SWORD3 || !self.SWORD3:IsValid() ) then
		self.Bay3Cons = nil
		self.SWORD3 = nil
	end
	if ( self.SWORD3 && self.SWORD3.Cont.Launchy ) then
		self.Bay3Cons:Remove()
		self.Bay3Cons = nil
		self.SWORD3.Cont.Speed =1000
		self.SWORD3 = nil
	end
	if ( !self.SWORD4 || !self.SWORD4:IsValid() ) then
		self.Bay4Cons = nil
		self.SWORD4 = nil
	end
	if ( self.SWORD4 && self.SWORD4.Cont.Launchy ) then
		self.Bay4Cons:Remove()
		self.Bay4Cons = nil
		self.SWORD4.Cont.Speed =1000
		self.SWORD4 = nil
	end
end

function ENT:Touch( ent )
	if ( ent:IsValid() && ent:IsVehicle() && self.Entity:IsInBoth(ent) && (ent.Cont != nil) && !ent.Cont.Launchy ) then
		local fighter = string.lower(ent.Cont:GetName())
		if ( (self.SWORD1 == nil) && (ent != self.SWORD2) && (ent != self.SWORD3) && (ent != self.SWORD4) ) then
			self.SWORD1 = ent
			self.SWORD1:SetPos( self.Entity:LocalToWorld(Vector(-50, 400, -100)+Fighters[fighter]["VecOff"]) )
			self.SWORD1:SetAngles( self.Entity:GetAngles()+Fighters[fighter]["AngOff"] )
			self.Bay1Cons = constraint.Weld(self.Entity, self.SWORD1, 0, 0, 0, true)
			if (self.SWORD1:GetPassenger():IsPlayer()) then
				local pilot = self.SWORD1:GetPassenger()
				local savedcolgroup = pilot:GetCollisionGroup()
				pilot:SetCollisionGroup( COLLISION_GROUP_NONE )
				pilot:ExitVehicle()
				pilot:SetPos( self.Entity:LocalToWorld(Vector(-50, 200, -100)) )
				pilot:SetCollisionGroup( savedcolgroup )
			end
		elseif ( (self.SWORD2 == nil) && (ent != self.SWORD1) && (ent != self.SWORD3) && (ent != self.SWORD4) ) then
			self.SWORD2 = ent
			self.SWORD2:SetPos( self.Entity:LocalToWorld(Vector(-50, -400, -100)+Fighters[fighter]["VecOff"]) )
			self.SWORD2:SetAngles( self.Entity:GetAngles()+Fighters[fighter]["AngOff"] )
			self.Bay2Cons = constraint.Weld(self.Entity, self.SWORD2, 0, 0, 0, true)
			if (self.SWORD2:GetPassenger():IsPlayer()) then
				local pilot = self.SWORD2:GetPassenger()
				local savedcolgroup = pilot:GetCollisionGroup()
				pilot:SetCollisionGroup( COLLISION_GROUP_NONE )
				pilot:ExitVehicle()
				pilot:SetPos( self.Entity:LocalToWorld(Vector(-50, -200, -100)) )
				pilot:SetCollisionGroup( savedcolgroup )
			end
		elseif ( (self.SWORD3 == nil) && (ent != self.SWORD1) && (ent != self.SWORD2) && (ent != self.SWORD4) ) then
			self.SWORD3 = ent
			self.SWORD3:SetPos( self.Entity:LocalToWorld(Vector(-50, 400, -300)+Fighters[fighter]["VecOff"]) )
			self.SWORD3:SetAngles( self.Entity:GetAngles()+Fighters[fighter]["AngOff"] )
			self.Bay3Cons = constraint.Weld(self.Entity, self.SWORD3, 0, 0, 0, true)
			if (self.SWORD3:GetPassenger():IsPlayer()) then
				local pilot = self.SWORD3:GetPassenger()
				local savedcolgroup = pilot:GetCollisionGroup()
				pilot:SetCollisionGroup( COLLISION_GROUP_NONE )
				pilot:ExitVehicle()
				pilot:SetPos( self.Entity:LocalToWorld(Vector(-50, 200, -300)) )
				pilot:SetCollisionGroup( savedcolgroup )
			end
		elseif ( (self.SWORD4 == nil) && (ent != self.SWORD1) && (ent != self.SWORD2) && (ent != self.SWORD3) ) then
			self.SWORD4 = ent
			self.SWORD4:SetPos( self.Entity:LocalToWorld(Vector(-50, -400, -300)+Fighters[fighter]["VecOff"]) )
			self.SWORD4:SetAngles( self.Entity:GetAngles()+Fighters[fighter]["AngOff"] )
			self.Bay4Cons = constraint.Weld(self.Entity, self.SWORD4, 0, 0, 0, true)
			if (self.SWORD4:GetPassenger():IsPlayer()) then
				local pilot = self.SWORD4:GetPassenger()
				local savedcolgroup = pilot:GetCollisionGroup()
				pilot:SetCollisionGroup( COLLISION_GROUP_NONE )
				pilot:ExitVehicle()
				pilot:SetPos( self.Entity:LocalToWorld(Vector(-50, -200, -300)) )
				pilot:SetCollisionGroup( savedcolgroup )
			end
		end
	end
end

function ENT:IsInBoth(ent)
	local fighter = string.lower(ent.Cont:GetName())
	--print(fighter)
	if (!Fighters[fighter]) then return false end
	local docklist = Fighters[fighter]["Docklist"]
	--PrintTable(docklist)
	return (Fighters[fighter] && table.HasValue(docklist, "swordhangarlarge"))
end

function ENT:Use(activator)
/*	self.Bay1Cons:Remove()
	self.Bay1Cons = nil
	self.SWORD1 = nil
	self.Bay2Cons:Remove()
	self.Bay2Cons = nil
	self.SWORD2 = nil*/
end