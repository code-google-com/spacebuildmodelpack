
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:InitDock()
	self.Bay = {}
	self.Bay["Bay"] = {}
	self.Bay["Bay"]["ship"] = nil
	self.Bay["Bay"]["weld"] = nil
	self.Bay["Bay"]["pos"] = Vector(0,0,0)
	self.Bay["Bay"]["canface"] = {Angle(0,0,0),Angle(0,180,0)}
	self.Bay["Bay"]["pexit"] = Vector(-250,0,10)
end

function ENT:Initialize()
	self.BaseClass:Initialize(self)
	self.Entity:SetModel( "models/SmallBridge/Hangars/SBDBcomp1.mdl" )
	self.Entity:SetName("sbHangar")
end

function ENT:Think()
	if self.FighterPush then
		self.FighterPush:GetPhysicsObject():SetVelocity(self.FighterPush:LocalToWorld(Vector(0,0,-1000)))
	end
	for k, v in pairs(self.Bay) do
		if not ( v.weld and v.weld:IsValid() ) then
			for l,w in pairs(constraint.FindConstraints( self.Entity, "Weld" )) do
				if (w.Ent1 == v.ship || w.Ent2 == v.ship) then
					v.weld = w.Constraint
				end
			end
			if not (v.weld and v.weld:IsValid()) then v.ship = nil end
		end
		if ( v.ship && v.ship.Cont && v.ship.Cont.Launchy ) then
			if (v.weld and v.weld:IsValid()) then
				v.weld:Remove()
			end
			for _,nocol in pairs(v.nocol) do
				nocol:Remove()
			end
			v.weld = nil
			if (v.EP == v.ship.ExitPoint) then
				v.ship.ExitPoint = nil
			end
			v.ship.Cont.Speed = self.LaunchSpeed
			self.FighterPush = v.ship
			timer.Simple(1,function() self.FighterPush = nil end)
			v.ship.docked = false
			v.ship = nil
			Wire_TriggerOutput(self.Entity, "Ship "..tostring(k), "")
		end
	end
end

function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16 + Vector(0,0,150)
	
	local ent = ents.Create( "sbmp_hangar_sb" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Initialize()
	ent:Activate()
	ent.SPL = ply
	
	return ent
	
end
