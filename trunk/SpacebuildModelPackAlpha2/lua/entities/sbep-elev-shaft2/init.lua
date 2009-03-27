AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()
	util.PrecacheModel("models/SmallBridge/Elevators,Small/sbselevs.mdl")

	self.Entity:SetModel( "models/SmallBridge/Elevators,Small/sbselevs.mdl" ) 
	self.Entity:SetName("sbep-elev-shaft2")
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
	
	self.HPC			= 2
	self.HP				= {}
	self.HP[1]			= {}
	self.HP[1]["Ent"]	= nil
	self.HP[1]["Type"]	= {"Level","TLevel"}
	self.HP[1]["Pos"]	= Vector(0,0,65)
	self.HP[1]["Angle"]	= Angle(0,0,0)
	self.HP[2]			= {}
	self.HP[2]["Ent"]	= nil
	self.HP[2]["Type"]	= {"Level","BLevel"}
	self.HP[2]["Pos"]	= Vector(0,0,(-65-130))
	self.HP[2]["Angle"]	= Angle(0,0,0)	
	
	self.Entity:SetNetworkedInt( "HPC", self.HPC )
	
	self.Cont = self.Entity
end

function ENT:SpawnFunction( ply, tr )
	local ent = ents.Create("sbep-elev-shaft2")
	ent:SetPos(tr.HitPos + Vector(0, 0, 20))
	ent:Spawn()
	return ent
end 

function ENT:Touch( ent )
	if ent.HasHardpoints then
		if ent.Cont && ent.Cont:IsValid() then HPLink( ent.Cont, ent.Entity, self.Entity ) end
		self.Entity:GetPhysicsObject():EnableCollisions(true)
		self.Entity:SetParent()
	end
end