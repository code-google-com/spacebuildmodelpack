
include('shared.lua')
killicon.AddFont("seeker_missile", "CSKillIcons", "C", Color(255,80,0,255))


function ENT:Initialize()
	self.WInfo = "Large Torpedo"
end

function ENT:Draw()
	
	self.Entity:DrawModel()

end

function ENT:Think()

	if self:GetArmed() then
	
		local dlight = DynamicLight( self:EntIndex() )
		if ( dlight ) then
			--local r, g, b, a = self:GetColor()
			dlight.Pos = self:GetPos() + self:GetRight() * 50
			dlight.r = 200
			dlight.g = 200
			dlight.b = 60
			dlight.Brightness = 10
			dlight.Decay = 500 * 5
			dlight.Size = 900
			dlight.DieTime = CurTime() + 1
		end
	
	end
		
end