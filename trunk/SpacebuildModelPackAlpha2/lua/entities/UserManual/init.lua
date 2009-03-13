include('shared.lua')

 function ENT:SpawnFunction( ply, tr )
   local ent = ents.Create("UserManual") 		// Create the entity
   ent:SetPos(tr.HitPos + Vector(0, 0, 20)) 	// Set it to spawn 20 units over the spot you aim at when spawning it
   ent:Spawn() 									// Spawn it
   
   return ent 									// You need to return the entity to make it work
  end 

function ENT:Initialize()

self.Entity:SetModel( "models/Spacebuild/sbepmanual.mdl" )
self.Entity:PhysicsInit( SOLID_VPHYSICS )
self.Entity:SetMoveType( MOVETYPE_VPHYSICS )							
self.Entity:SetSolid( SOLID_VPHYSICS )
self.Entity:SetUseType( SIMPLE_USE )


local phys = self.Entity:GetPhysicsObject()
if (phys:IsValid()) then
	phys:Wake()
end
end

function ENT:Think()
end 

function ENT:Use( activator, caller )
	umsg.Start("my_message", activator) 	//putting activator here tells the server to only send the message to this player
	umsg.Entity( activator ) 				//not necessary, you could send a dummy bool
											//you might even try sending nothing at all, I don't know if that works
umsg.End()

end

function ENT:Touch( ent )
	if ent.HasHardpoints then
		if ent.Cont && ent.Cont:IsValid() then HPLink( ent.Cont, ent.Entity, self.Entity ) end
	end
end

function SBEPManualFirstSpawn( ply )
	if not file.Exists("manuals/spawned.txt") then 
		umsg.Start("my_message", ply)
		umsg.End()
	file.Write("manuals/spawned.txt" ,  "Asphid_Jackal iz mah supreem gawd and ah will folla him forevahz!") 
	end	
end
hook.Add( "PlayerInitialSpawn", "superuniquesbepusermanual", SBEPManualFirstSpawn );
