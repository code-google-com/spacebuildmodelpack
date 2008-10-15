

EFFECT.Mat = Material( "effects/tool_tracer" )

/*---------------------------------------------------------
   Init( data table )
---------------------------------------------------------*/
function EFFECT:Init( data )
	// Keep the start and end pos - we're going to interpolate between them
	self.StartPos = data:GetStart()
	self.EndPos = data:GetOrigin()
	
	self.Alpha = 255
	
	self.Entity:SetRenderBoundsWS( self.StartPos, self.EndPos )
end

/*---------------------------------------------------------
   THINK
---------------------------------------------------------*/
function EFFECT:Think( )

	self.Alpha = self.Alpha - FrameTime() * 2048
	
	
	
	if (self.Alpha < 0) then return false end
	return true

end

/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render( )

	if ( self.Alpha < 1 ) then return end
	
	
		
	
	self.Length = (self.StartPos - self.EndPos):Length()
		
	render.SetMaterial( self.Mat )
	local texcoord = math.Rand( 0, 1 )
	
	
	for i=1, 6 do
	
		
		
		render.DrawBeam( self.StartPos, 										// Start
					 self.EndPos,											// End
					 8,													// Width
					 texcoord,														// Start tex coord
					 texcoord + self.Length / 128,									// End tex coord
					 Color( 255, 255, 255, self.Alpha ) )		// Color (optional)
	end

end
