include('shared.lua')

function ENT:Initialize()
	self.BaseClass:Initialize(self)
	self.CMat = Material( "cable/blue_elec" )
	self.SMat = Material( "sprites/light_glow02_add" )
	self.EfPoints = {{},{},{},{},{},{}}
	self.EfPoints[1].x = -70
	self.EfPoints[1].y = -30
	self.EfPoints[1].z = 125
	self.EfPoints[1].sp = 0
	self.EfPoints[2].x = -190
	self.EfPoints[2].y = -30
	self.EfPoints[2].z = 60
	self.EfPoints[2].sp = 5
	self.EfPoints[3].x = -195
	self.EfPoints[3].y = -30
	self.EfPoints[3].z = -115
	self.EfPoints[3].sp = 0
	self.EfPoints[4].x = 195
	self.EfPoints[4].y = -30
	self.EfPoints[4].z = -125
	self.EfPoints[4].sp = 3
	self.EfPoints[5].x = 190
	self.EfPoints[5].y = -30
	self.EfPoints[5].z = 60
	self.EfPoints[5].sp = 2
	self.EfPoints[6].x = 70
	self.EfPoints[6].y = -30
	self.EfPoints[6].z = 125
	self.EfPoints[6].sp = 1
end