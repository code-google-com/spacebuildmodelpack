ENT.Type 			= "anim"
ENT.Base 			= "base_gmodentity"
ENT.PrintName		= "Police Wing - Small"
ENT.Author			= "Paradukes + SlyFo"
--ENT.Category		= "SBEP-Weapons"

ENT.Spawnable		= true
ENT.AdminSpawnable	= true


function ENT:SetActive( val )
	self.Entity:SetNetworkedBool("ClTracking",val,true)
end

function ENT:GetActive()
	return self.Entity:GetNetworkedBool("ClTracking")
end