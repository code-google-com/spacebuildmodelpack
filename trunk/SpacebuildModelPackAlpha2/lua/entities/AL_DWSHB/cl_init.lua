include('shared.lua')

function ENT:Initialize()
	self.BaseClass:Initialize(self)
	self.CMat = Material( "cable/blue_elec" )
	self.SMat = Material( "sprites/light_glow02_add" )
	self.EfPoints = {{},{},{},{}}
	self.EfPoints[1].x = -175
	self.EfPoints[1].y = 100
	self.EfPoints[1].z = 60
	self.EfPoints[1].sp = 0
	self.EfPoints[2].x = -200
	self.EfPoints[2].y = -110
	self.EfPoints[2].z = -50
	self.EfPoints[2].sp = 3
	self.EfPoints[3].x = 200
	self.EfPoints[3].y = -110
	self.EfPoints[3].z = -50
	self.EfPoints[3].sp = 0
	self.EfPoints[4].x = 175
	self.EfPoints[4].y = 100
	self.EfPoints[4].z = 60
	self.EfPoints[4].sp = 1
end