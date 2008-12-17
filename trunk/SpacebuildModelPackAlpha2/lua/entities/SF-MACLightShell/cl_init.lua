
include('shared.lua')
killicon.AddFont("seeker_missile", "CSKillIcons", "C", Color(255,80,0,255))


function ENT:Initialize()

end

function ENT:Draw()
	
	self.Entity:DrawModel()

end

function ENT:Think()

	local dlight = DynamicLight( self:EntIndex() )
	if ( dlight ) then
		--local r, g, b, a = self:GetColor()
		dlight.Pos = self:GetPos()
		dlight.r = 50
		dlight.g = 50
		dlight.b = 200
		dlight.Brightness = 10
		dlight.Decay = 500 * 5
		dlight.Size = 500
		dlight.DieTime = CurTime() + 1
	end
		
end