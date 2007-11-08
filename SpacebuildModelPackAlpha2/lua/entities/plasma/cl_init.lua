
include('shared.lua')

function ENT:Initialize()
	self.Size = 32
end

function ENT:Draw()
	//self.Entity:DrawModel( )
	render.SetMaterial( Material( "sprites/heatwave" ) )
	local pos = self.Entity:GetPos( )
	render.DrawSprite( pos, self.Size, self.Size, Color( 255, 255, 255, 150 ) )

	render.SetMaterial( Material( "sprites/strider_blackball" ) )
	render.DrawSprite( pos, math.Max( self.Size - 4, 0 ), math.Max( self.Size - 4, 0 ), Color( 255, 255, 255, 255 ) )
end

function ENT:OnRemove()
end




