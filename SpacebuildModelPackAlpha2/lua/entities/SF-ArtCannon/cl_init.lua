
include('shared.lua')
--killicon.AddFont("seeker_missile", "CSKillIcons", "C", Color(255,80,0,255))


function ENT:Initialize()

end

function ENT:Draw()
	
	self.Entity:DrawModel()

end

function ENT:Think()
	local ReloadTime = self.Entity:GetNetworkedFloat( "ReloadTime" ) or 0
	local ReloadPercent = ((5-( ReloadTime-CurTime())) / 5)*100
	if ReloadPercent > 100 then
		self.WInfo = "Artillery Cannon - Loaded"
	else
		self.WInfo = "Artillery Cannon - Loading: "..math.Round(ReloadPercent).."%"
	end
end