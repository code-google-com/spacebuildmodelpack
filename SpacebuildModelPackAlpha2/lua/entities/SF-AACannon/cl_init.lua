
include('shared.lua')
--killicon.AddFont("seeker_missile", "CSKillIcons", "C", Color(255,80,0,255))


function ENT:Initialize()
	self.WInfo = "AA-Blaster Cannon"
end

function ENT:Draw()
	
	self.Entity:DrawModel()

end
