ENT.Type 			= "anim"
ENT.Base 			= "base_gmodentity"
ENT.PrintName		= "S-Foils - Left"
ENT.Author			= "Paradukes"
ENT.Category		= "SBEP-Rover Gear"

ENT.Spawnable		= true
ENT.AdminSpawnable	= true
ENT.Owner			= nil
ENT.SPL				= nil
ENT.HPType			= "RLeftPanel"
ENT.APPos			= Vector(0,0,0)
ENT.HasHardpoints	= true


function ENT:SetFold( val )
	self:SetNetworkedInt( "FoldA", val )
end
function ENT:GetFold()
	return self:GetNetworkedInt( "FoldA" )
end