if(SERVER) then

function ENT:SpawnFunction( ply, tr )
	local ent = ents.Create("CupNoodle") 			// Create the entity
		ent:SetPos(tr.HitPos + Vector(0, 0, 20)) 	// Set it to spawn 20 units over the spot you aim at when spawning it
		ent:Spawn()									// Spawn it
		return ent 									// You need to return the entity to make it work
end --SpawnFunction end
	
function ENT:Initialize()

	self.Entity:SetModel( "models/slyfo/cup_noodle.mdl" )
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:SetUseType( SIMPLE_USE )

local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end -- if end
end -- Initialize end

function ENT:Use( activator, caller )
	self.Entity:Remove()
	if ( activator:IsPlayer() ) then
		local health = activator:Health()
		activator:SetHealth( health + 25 )
	end -- if end
end -- Use end
end -- Server end

if(CLIENT) then

function ENT:Draw()
	// self.BaseClass.Draw(self)
	self:DrawEntityOutline( 0.0 ) 			
	self.Entity:DrawModel() 				
end -- Draw end

end -- client end

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Cup Noodles"
ENT.Author = "Asphid_Jackal, SLYFo"
ENT.Contact = "nullonentry"
ENT.Purpose = "Get some health."
ENT.Instructions = "Eat up!" 
ENT.Category = "SBEP - Other"
ENT.Spawnable = true
ENT.AdminSpawnable = true 