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
	self.arming = false
	self.CDSIgnore = true //change to be able to be destroyed, but ignore heatdamage
end

function ENT:Think()
	if self.hit then self.Entity:Remove() return false end
	if not self.armed then return false end
	local enttable = ents.FindInSphere(self:GetPos() ,100)
	if table.Count(enttable) > 1 then
		if CDS then
			CDS.Explosion(self, 128, 200, 10, ply, true)
		else
			for key,found in pairs(ents.FindInSphere(self:GetPos(),128)) do
				if found and found:IsValid() then
					local pos = found:LocalToWorld(found:OBBCenter())
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

function ENT:SetArmed(val)
	if self.armed != val then
		self.armed = val
		self.arming = false
	end
end

function ENT:Use(ply)
	if not self.arming then
		timer.Simple(3, self.SetArmed, self, !self.armed)
		self.arming = true
	end
end

function ENT:PhysicsUpdate(PhysObj)
	if self.hit then
		self.Entity:Remove()
	end
end
