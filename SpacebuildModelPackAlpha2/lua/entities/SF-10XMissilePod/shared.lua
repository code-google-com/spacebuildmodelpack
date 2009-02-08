ENT.Type 			= "anim"
ENT.Base 			= "base_gmodentity"
ENT.PrintName		= "10x Missile Pod"
ENT.Author			= "Paradukes"
ENT.Category		= "SBEP-Weapons"
ENT.Instructions	= "The guidance system for the missiles can be configured by wired inputs. 0 = Unguided, 1 = Non-Tracking, 2 = Tracking, 3 = Homing, 4 = Seeking, 5 = Optical. For more information, visit the thread." 

ENT.Spawnable		= true
ENT.AdminSpawnable	= true
ENT.Owner			= nil
ENT.SPL				= nil
ENT.MCDown			= 0
ENT.CDown1			= true
ENT.CDown1			= 0
ENT.CDown2			= true
ENT.CDown2			= 0
ENT.HPType			= "Large"
ENT.APPos			= Vector(-10,0,17)

function ENT:SetShots( val )
	local CVal = self.Entity:GetNetworkedInt( "Shots" )
	if CVal != val then
		self.Entity:SetNetworkedInt( "Shots", val )
	end
end