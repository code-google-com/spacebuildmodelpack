function ENT:Draw()
	// self.BaseClass.Draw(self)
	self:DrawEntityOutline( 0.0 ) 			
	self.Entity:DrawModel() 				
end -- Draw end