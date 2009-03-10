

EFFECT.Mat = Material( "weapons/gausslaser_orange" )

/*---------------------------------------------------------
   Init( data table )
---------------------------------------------------------*/
function EFFECT:Init( data )
	-- Keep the start and end pos - we're going to interpolate between them
	self.StartPos = data:GetStart()
	self.EndPos = data:GetOrigin()
	self.EndTime = CurTime() + data:GetMagnitude()
	
	self.Alpha = 255
	
	self.Entity:SetRenderBoundsWS( self.StartPos, self.EndPos )
	self.full_time = data:GetMagnitude()
	self.TimeLeft = self.EndTime - CurTime()
end

/*---------------------------------------------------------
   THINK
---------------------------------------------------------*/
function EFFECT:Think()
	if (self.TimeLeft <= 0) then return false end
	return true

end

/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render()
	self.TimeLeft = self.EndTime - CurTime()
	self.Frac = self.TimeLeft/self.full_time
	self.Length = (self.StartPos - self.EndPos):Length()
		
	render.SetMaterial( self.Mat )
	local texcoord = CurTime()

		render.DrawBeam( self.StartPos, 										-- Start
					 self.EndPos,											-- End
					 32*self.Frac,											-- Width
					 texcoord,														-- Start tex coord
					 texcoord - self.Length / 128,									-- End tex coord
					 Color( 255, 255, 255, self.Frac*self.Alpha ) )		-- Color (optional)

end
