include('shared.lua')

function ENT:Initialize()
	if self.OnBaseInit then
		self:OnBaseInit()
	elseif self.OnInit then
		return self:OnInit()
	end
end
