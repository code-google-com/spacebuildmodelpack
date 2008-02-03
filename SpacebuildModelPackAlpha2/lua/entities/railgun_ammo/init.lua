AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")


function ENT:Initialize( )
	self.Entity:SetModel( "models/weapons/w_bugbait.mdl" )
 	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:SetColor( 255, 255, 000, 200 )
	self.Entity:GetPhysicsObject( ):SetMass( 1 )
	self.Entity:GetPhysicsObject( ):Wake( )
	self.owner = 0
	self.hit = false
	self.CDSIgnore = true //change to be able to be destroyed, but ignore heatdamage
	self.force = 0
end

function ENT:SetOwner(owner)
	self.owner = owner
end

function ENT:SetForce(amount)
	if not amount or type(amount) != "number" then return false end
	self.force = amount
end

function ENT:PhysicsCollide( data, physobj )
	if data.HitEntity and not self.hit then
		self.hit = true
		local effect, snd
		//if CombatDamageSystem then
			//cds_damagepos(self.Entity:GetPos(), 20, 34, 100, self.owner)
		//else //todo: maybe add GCombat support?
			data.HitEntity:TakeDamage( (self.force/5000) * 75, self.owner)
		//end
		local obj = data.HitEntity:GetPhysicsObject() 
		if obj:IsValid() then
			obj:ApplyForceOffset( self.Entity:GetForward() * -self.force, self.Entity:GetForward() ) 
		end
		effect = EffectData( )
			effect:SetScale( 10 )
			effect:SetMagnitude( 10 )
			effect:SetOrigin( self:GetPos( ) )
		util.Effect( "cds_plasma_distruption", effect )
		snd = math.random( 9 )
		while snd == 4 do
			snd = math.random( 9 )
		end
		WorldSound( Sound( "ambient/energy/zap" .. snd .. ".wav" ), self:GetPos( ), 100, 100 )
	end
end

function ENT:Think()
	if self.hit then
		self.Entity:Remove()
	end
end

function ENT:PhysicsUpdate(PhysObj)
	PhysObj:ApplyForceCenter(self.Entity:GetForward() * -(self.force * 1000))
end
