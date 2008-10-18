include('shared.lua')

function ENT:Initialize()
	self.Firing = false
	
	self.TraceSettings = {}
	self.TraceSettings.mask = MASK_PLAYERSOLID
	self.TraceSettings.filter = self.Entity
end