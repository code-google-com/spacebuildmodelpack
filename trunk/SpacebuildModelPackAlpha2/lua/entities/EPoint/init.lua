AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('entities/base_wire_entity/init.lua')
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
	self.Inputs = Wire_CreateInputs( self.Entity, { "Priority" } )
	self.CDown = 0
end

function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16 + Vector(0,0,10)
	
	local ent = ents.Create( "EPoint" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Initialize()
	ent:Activate()
	ent.SPL = ply
	
	return ent
	
end

function ENT:TriggerInput(iname, value)
	
	if (iname == "Priority") then
		if (value >= 0) then
			self.EPriority = value
		end
		
	end
	
end

function ENT:Think()
	
end

function ENT:PhysicsCollide( data, physobj )
	
end

function ENT:OnTakeDamage( dmginfo )
	
end

function ENT:Touch( ent )
	if (ent:IsVehicle()) then
		ent.ExitPoint = self.Entity
		self.Vec = ent
	end
end

function ENT:Use( ply )
	if self.Vec && self.Vec:IsValid() then
		if (CurTime() >= self.CDown) then
			ply:EnterVehicle( self.Vec )
		end
	end
end

function ENT:BuildDupeInfo()
	local info = self.BaseClass.BuildDupeInfo(self) or {}
	if (self.Vec) and (self.Vec:IsValid()) then
	    info.Vec = self.Vec:EntIndex()
	end
	if (self.CDown) then
	    info.CDown = self.CDown
	end
	return info
end

function ENT:ApplyDupeInfo(ply, ent, info, GetEntByID)
	self.BaseClass.ApplyDupeInfo(self, ply, ent, info, GetEntByID)
	if (info.Vec) then
		self.Vec = GetEntByID(info.Vec)
		if (!self.Vec) then
			self.Vec = ents.GetByIndex(info.Vec)
		end
		self.Vec.ExitPoint = self.Entity
	end
	self.CDown = info.CDown
end
