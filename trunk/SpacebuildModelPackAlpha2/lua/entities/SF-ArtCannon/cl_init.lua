
include('shared.lua')
--killicon.AddFont("seeker_missile", "CSKillIcons", "C", Color(255,80,0,255))


function ENT:Initialize()

end

function ENT:Draw()
	
	self.Entity:DrawModel()

end

function ENT:Think()
	local ReloadTime = self.Entity:GetNetworkedInt( "ReloadTime" ) or 0
	local timeleft = ReloadTime - CurTime()
	if timeleft <=0 then
		self.WInfo = "Artillery Cannon - Ready"
	else
		self.WInfo = "Artillery Cannon - Reload: "..math.Round(timeleft)
	end
end