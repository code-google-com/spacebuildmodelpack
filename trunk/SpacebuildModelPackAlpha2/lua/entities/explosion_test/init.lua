AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize( )
	self.Entity:SetModel( "models/weapons/w_bugbait.mdl" )
 	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:SetColor( 255, 255, 255, 100 )
	self.Entity:GetPhysicsObject( ):SetMass( 1 )
	self.Entity:GetPhysicsObject( ):Wake( )
	self.damage = 100
	self.hit = false
	self.armed = false
	self.CDSIgnore = true //change to be able to be destroyed, but ignore heatdamage
end

function ENT:Think()
	
end

function ENT:Use(ply)
	if not self.armed then
		self.armed = true
	elseif not self.exploding then
		self.exploding = true
		if CDS then
			Msg("Using CDS Explosion func\n")
			CDS.Explosion(self, 1024, 100, 10, ply, true)
		else
			for key,found in pairs(ents.FindInSphere(self:GetPos(),1024)) do
				if found and found:IsValid() then
					local pos = found:LocalToWorld(found:OBBCenter())
					//line of sight check
					local angle = pos - self:GetPos()
					angle:Normalize()
					local physobj = found:GetPhysicsObject()
					if physobj and physobj:IsValid() then
						physobj:ApplyForceOffset(angle * (128/self:GetPos():Distance(found:GetPos())) * 100 * self.damage, found:GetPos() + Vector(math.random(-20,20),math.random(-20,20),math.random(20,40)))
					else
						found:SetVelocity(angle* (128/self:GetPos():Distance(found:GetPos())) * 100 * self.damage)
					end
					found:TakeDamage(self.damage * (128/self:GetPos():Distance(found:GetPos())))
				end
			end
		end
		self.hit = true
	end
end

function ENT:PhysicsUpdate(PhysObj)
	if self.hit then
		self.Entity:Remove()
	end
end
