
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()

	self.Entity:SetModel( "models/Spacebuild/Nova/flak1.mdl" ) 
	self.Entity:SetName("ArtilleryCannon")
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Inputs = Wire_CreateInputs( self.Entity, { "Fire1", "Fire2" } )
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableGravity(true)
		phys:EnableDrag(true)
		phys:EnableCollisions(true)
	end
	self.Entity:SetKeyValue("rendercolor", "255 255 255")
	self.PhysObj = self.Entity:GetPhysicsObject()
	
	--self.val1 = 0
	--RD_AddResource(self.Entity, "Munitions", 0)


end

function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16
	
	local ent = ents.Create( "SF-FlakCannon" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	ent.SPL = ply
	
	return ent
	
end

function ENT:TriggerInput(iname, value)		
	if (iname == "Fire1") then
		
		if (value > 0) then
			if (CurTime() >= self.CDown1) then
				--if (self.val1 >= 1000) then
					self.Entity:FFire1()
				--end
			end
		end
		
	elseif (iname == "Fire2") then
		
		if (value > 0) then
			if (CurTime() >= self.CDown2) then
				--if (self.val1 >= 1000) then
					self.Entity:FFire2()
				--end
			end
		end
		
	end
end

function ENT:PhysicsUpdate()

end

function ENT:Think()
	--self.val1 = RD_GetResourceAmount(self.Entity, "Munitions")

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
	end
end

function ENT:HPFire()
	if (CurTime() >= self.MCDown) then
		if (CurTime() >= self.CDown1) then
			self.Entity:FFire1()
		else
			if (CurTime() >= self.CDown2) then
				self.Entity:FFire2()
			end
		end
	end
end

function ENT:FFire1()
	local NewShell = ents.Create( "SF-FlakShell" )
	if ( !NewShell:IsValid() ) then return end
	NewShell:SetPos( self.Entity:GetPos() + (self.Entity:GetUp() * 14) )
	NewShell:SetAngles( self.Entity:GetAngles() )
	NewShell.SPL = self.SPL
	NewShell:Spawn()
	NewShell:Initialize()
	NewShell:Activate()
	local NC = constraint.NoCollide(self.Entity, NewShell, 0, 0)
	NewShell.PhysObj:SetVelocity(self.Entity:GetForward() * 1000)
	NewShell:Fire("kill", "", 30)
	NewShell.ParL = self.Entity
	--RD_ConsumeResource(self, "Munitions", 1000)
	self.CDown1 = CurTime() + 5
	self.MCDown = CurTime() + 0.4
	local phys = self.Entity:GetPhysicsObject()  	
	if (phys:IsValid()) then  		
		phys:ApplyForceCenter( self.Entity:GetForward() * -1000 ) 
	end 
	
	local effectdata = EffectData()
	effectdata:SetOrigin(self.Entity:GetPos() +  self.Entity:GetUp() * 14)
	effectdata:SetStart(self.Entity:GetPos() +  self.Entity:GetUp() * 14)
	util.Effect( "Explosion", effectdata )
end

function ENT:FFire2()
	local NewShell = ents.Create( "SF-FlakShell" )
	if ( !NewShell:IsValid() ) then return end
	NewShell:SetPos( self.Entity:GetPos() + (self.Entity:GetUp() * -14) )
	NewShell:SetAngles( self.Entity:GetAngles() )
	NewShell.SPL = self.SPL
	NewShell:Spawn()
	NewShell:Initialize()
	NewShell:Activate()
	local NC = constraint.NoCollide(self.Entity, NewShell, 0, 0)
	NewShell.PhysObj:SetVelocity(self.Entity:GetForward() * 1000)
	NewShell:Fire("kill", "", 30)
	NewShell.ParL = self.Entity
	--RD_ConsumeResource(self, "Munitions", 1000)
	self.CDown2 = CurTime() + 5
	self.MCDown = CurTime() + 0.4
	local phys = self.Entity:GetPhysicsObject()  	
	if (phys:IsValid()) then  		
		phys:ApplyForceCenter( self.Entity:GetForward() * -1000 ) 
	end 
	
	local effectdata = EffectData()
	effectdata:SetOrigin(self.Entity:GetPos() +  self.Entity:GetUp() * -14)
	effectdata:SetStart(self.Entity:GetPos() +  self.Entity:GetUp() * -14)
	util.Effect( "Explosion", effectdata )
end