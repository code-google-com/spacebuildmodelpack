
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

util.PrecacheSound( "warpdrive/warp.wav" )
util.PrecacheSound( "warpdrive/error2.wav" )

function ENT:SpawnFunction( ply, tr )
	local ent = ents.Create("WarpDrive") 		// Create the entity
	ent:SetPos(tr.HitPos + Vector(0, 0, 20)) 	// Set it to spawn 20 units over the spot you aim at when spawning it
	ent:Spawn() 								// Spawn it
	return ent 									// You need to return the entity to make it work
end 

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()
	
	self.Entity:SetModel( "models/props_c17/consolebox03a.mdl" )
	
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	self.Entity:DrawShadow(false)
	
	local phys = self.Entity:GetPhysicsObject()
	
	self.NTime = 0
	
	if ( phys:IsValid() ) then 
		phys:SetMass( 100 )
		phys:EnableGravity( true )
		phys:Wake() 
	end

	self.JumpCoords = Vector(0,0,0)
	self.SearchRadius = 512
	self.Inputs = WireLib.CreateSpecialInputs( self.Entity, { "Radius", "Destination", "Warp" }, { "NORMAL", "VECTOR", "NORMAL" } );
end

function ENT:TriggerInput(iname, value)
	if(iname == "Radius") then
		self.SearchRadius = value
		 if self.SearchRadius > 1000 then self.SearchRadius = 1000 end
	elseif(iname == "Destination") then
		self.JumpCoords = value
	elseif(iname == "Warp" and value > 0) then
		if not util.IsInWorld(self.JumpCoords) then
	--	print(self.NTime..", "..CurTime())
			if(CurTime() >= self.NTime) then
				self.Entity:EmitSound("warpdrive/error2.wav", 100, 100)
				self.NTime = CurTime() + 5
			end
		return end
		local WarpDrivePos = self.Entity:GetPos()
		local ConstrainedEnts = ents.FindInSphere( self.Entity:GetPos() , self.SearchRadius)
		local DoneList = {}
		self.Entity:EmitSound("warpdrive/warp.wav", 450, 70)
		for _, v in pairs(ConstrainedEnts) do
			if v:IsValid() and !DoneList[v] then
				local ToTele = constraint.GetAllConstrainedEntities(v)
				for ent,_ in pairs(ToTele)do
				 if not (ent.BaseClass and ent.BaseClass.ClassName=="stargate_base" and ent:OnGround()) then
					if ent:IsValid() and ( ent:GetMoveType()==6 or ent:IsPlayer() ) then
						if(!ent:IsPlayer()) then
							DoPropSpawnedEffect( ent )
						end
						DoneList[ent]=ent
						ent:SetPos(self.JumpCoords + (ent:GetPos() - WarpDrivePos) + Vector(0,0,10))
						local phys = ent:GetPhysicsObject()
						if(!phys:IsMoveable())then
							phys:EnableMotion(true)
							phys:EnableMotion(false)
						end 
					end
				 end
				end
			end
		end
	end
end