
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()
	util.PrecacheModel("models/SmallBridge/Elevators,Small/sbselevbx.mdl" )
	util.PrecacheModel("models/SmallBridge/Elevators,Small/sbselevbt.mdl" ) 
	util.PrecacheModel("models/SmallBridge/Elevators,Small/sbselevbr.mdl" )
	util.PrecacheModel("models/SmallBridge/Elevators,Small/sbselevbe.mdl" )
	util.PrecacheModel("models/SmallBridge/Elevators,Small/sbselevb.mdl"  )
	
	self.Entity:SetModel( "models/SmallBridge/Elevators,Small/sbselevbx.mdl" ) 
	self.Entity:SetName("sbep-elev-bottom")
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Inputs = WireLib.CreateSpecialInputs( self.Entity, { "Model Type" }, { "STRING" } )
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableGravity(true)
		phys:EnableDrag(true)
		phys:EnableCollisions(true)
	end

	self.HPC			= 2
	self.HP				= {}
	self.HP[1]			= {}
	self.HP[1]["Ent"]	= nil
	self.HP[1]["Type"]	= {"Shaft"}
	self.HP[1]["Pos"]	= Vector(0,0,65)
	self.HP[1]["Angle"]	= Angle(0,0,0)
	self.HP[2]			= {}
	self.HP[2]["Ent"]	= nil
	self.HP[2]["Type"]	= {"Shaft"}
	self.HP[2]["Pos"]	= Vector(0,0,-65)
	self.HP[2]["Angle"]	= Angle(0,0,0)	
	
	self.Entity:SetNetworkedInt( "HPC", self.HPC )
	
	self.Cont = self.Entity
end

function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16 + Vector(0,0,50)
	
	local ent = ents.Create( "sbep-elev-bottom" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	ent.SPL = ply
	return ent
	
end

function ENT:TriggerInput(iname, value)		
	if (iname == "Model Type") then
		if (value == "X") then
			self.Entity:SetModel( "models/SmallBridge/Elevators,Small/sbselevbx.mdl" ) 
			constraint.RemoveAll(self.Entity)
			self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
			self.Entity:SetSolid( SOLID_VPHYSICS )
			self.Entity:PhysicsInit( SOLID_VPHYSICS )
			self.Entity:GetPhysicsObject():Wake()
		elseif (value == "T") then
			self.Entity:SetModel( "models/SmallBridge/Elevators,Small/sbselevbt.mdl" ) 
			constraint.RemoveAll(self.Entity)
			self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
			self.Entity:SetSolid( SOLID_VPHYSICS )
			self.Entity:PhysicsInit( SOLID_VPHYSICS )
			self.Entity:GetPhysicsObject():Wake()
		elseif (value == "R") then
			self.Entity:SetModel( "models/SmallBridge/Elevators,Small/sbselevbr.mdl" )
			constraint.RemoveAll(self.Entity)
			self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
			self.Entity:SetSolid( SOLID_VPHYSICS )
			self.Entity:PhysicsInit( SOLID_VPHYSICS )
			self.Entity:GetPhysicsObject():Wake()
		elseif (value == "Corridor") then
			self.Entity:SetModel( "models/SmallBridge/Elevators,Small/sbselevbe.mdl" ) 
			constraint.RemoveAll(self.Entity)
			self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
			self.Entity:SetSolid( SOLID_VPHYSICS )
			self.Entity:PhysicsInit( SOLID_VPHYSICS )
			self.Entity:GetPhysicsObject():Wake()
		elseif (value == "Cap") then
			self.Entity:SetModel( "models/SmallBridge/Elevators,Small/sbselevb.mdl"  )
			constraint.RemoveAll(self.Entity)
			self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
			self.Entity:SetSolid( SOLID_VPHYSICS )
			self.Entity:PhysicsInit( SOLID_VPHYSICS )
			self.Entity:GetPhysicsObject():Wake()
		else
			self.Entity:SetModel( "models/SmallBridge/Elevators,Small/sbselevbx.mdl" )
			constraint.RemoveAll(self.Entity)
			self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
			self.Entity:SetSolid( SOLID_VPHYSICS )
			self.Entity:PhysicsInit( SOLID_VPHYSICS )
			self.Entity:GetPhysicsObject():Wake()
		end
	end
end

function ENT:PhysicsUpdate()

end

function ENT:Think()
end

function ENT:PhysicsCollide( data, physobj )
	
end

function ENT:OnTakeDamage( dmginfo )
	
end

function ENT:Use( activator, caller )

end

function ENT:Touch( ent )
	if ent.HasHardpoints then
		if ent.Cont && ent.Cont:IsValid() then HPLink( ent.Cont, ent.Entity, self.Entity ) end
		self.Entity:GetPhysicsObject():EnableCollisions(true)
		self.Entity:SetParent()
	end
end