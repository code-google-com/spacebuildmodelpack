AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()

self.CDown = 0
self.TSwap = 1

self.Entity:SetModel( "models/Stat_Turrets/st_turretdualani.mdl" )
self.Entity:PhysicsInit( SOLID_VPHYSICS )
self.Entity:SetMoveType( MOVETYPE_VPHYSICS ) 
self.Entity:SetSolid( SOLID_VPHYSICS )

local phys = self.Entity:GetPhysicsObject()
 if (phys:IsValid()) then
 phys:Wake()
 end
end

function ENT:Use( activator, caller )
	if ( !activator:IsPlayer() ) then return end 
		if CurTime() > self.CDown then
			
			if self.TSwap == 1 then
				local sequence = self.Entity:LookupSequence("fire_left")
				self.Entity:ResetSequence(sequence)
				self:SetPlaybackRate( 1 )
				self.TSwap = 2
			elseif self.TSwap == 2 then
				local sequence = self.Entity:LookupSequence("fire_right")
				self.Entity:ResetSequence(sequence)
				self:SetPlaybackRate( 1 )
				self.TSwap = 1
			end
		   
			self.CDown = CurTime() + 0.4
		end
return
end
   
function ENT:Think()
self.Entity:NextThink( CurTime() + 0.1 )
return true
end 