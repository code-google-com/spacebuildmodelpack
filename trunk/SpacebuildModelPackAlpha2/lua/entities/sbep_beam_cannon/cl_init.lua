include('shared.lua')

function ENT:OnInit()
	self.TraceSettings = {}
	self.TraceSettings.mask = MASK_PLAYERSOLID
	self.TraceSettings.filter = self.Entity
end