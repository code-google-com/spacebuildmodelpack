include('shared.lua')

function ENT:Initialize()
	self.BaseClass:Initialize(self)
	self.CMat = Material( "cable/blue_elec" )
	self.SMat = Material( "sprites/light_glow02_add" )
	self.EfPoints = {{},{},{},{},{},{}}
	self.EfPoints[1].x = -60
	self.EfPoints[1].y = 10
	self.EfPoints[1].z = 60
	self.EfPoints[1].sp = 0
	self.EfPoints[2].x = -95
	self.EfPoints[2].y = 10
	self.EfPoints[2].z = 2
	self.EfPoints[2].sp = 2
	self.EfPoints[3].x = -87
	self.EfPoints[3].y = 10
	self.EfPoints[3].z = -60
	self.EfPoints[3].sp = 0
	self.EfPoints[4].x = 87
	self.EfPoints[4].y = 10
	self.EfPoints[4].z = -60
	self.EfPoints[4].sp = 4
	self.EfPoints[5].x = 95
	self.EfPoints[5].y = 10
	self.EfPoints[5].z = 0
	self.EfPoints[5].sp = 5
	self.EfPoints[6].x = 60
	self.EfPoints[6].y = 10
	self.EfPoints[6].z = 60
	self.EfPoints[6].sp = 6
end