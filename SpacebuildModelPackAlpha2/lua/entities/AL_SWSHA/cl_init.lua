include('shared.lua')

function ENT:Initialize()
	self.BaseClass:Initialize(self)
	self.CMat = Material( "cable/blue_elec" )
	self.SMat = Material( "sprites/light_glow02_add" )
	self.EfPoints = {{},{},{},{}}
	self.EfPoints[1].x = -65
	self.EfPoints[1].y = -110
	self.EfPoints[1].z = 50
	self.EfPoints[1].sp = 0
	self.EfPoints[2].x = -90
	self.EfPoints[2].y = 95
	self.EfPoints[2].z = -60
	self.EfPoints[2].sp = 3
	self.EfPoints[3].x = 90
	self.EfPoints[3].y = 95
	self.EfPoints[3].z = -60
	self.EfPoints[3].sp = 0
	self.EfPoints[4].x = 65
	self.EfPoints[4].y = -110
	self.EfPoints[4].z = 50
	self.EfPoints[4].sp = 1
end