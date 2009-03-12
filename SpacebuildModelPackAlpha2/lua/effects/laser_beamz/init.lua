

EFFECT.Mat = Material( "weapons/gausslaser_orange" )

/*---------------------------------------------------------
   Init( data table )
---------------------------------------------------------*/
function EFFECT:Init( data )
	self.StartPos = data:GetStart()
	self.EndPos = data:GetOrigin()
	self.EndTime = CurTime() + data:GetMagnitude()
	
	self.Alpha = 255
	
	self.Entity:SetRenderBoundsWS( self.StartPos, self.EndPos )
	self.full_time = data:GetMagnitude()
	self.TimeLeft = self.EndTime - CurTime()
	
	self.r = (data:GetAngle().p or 255)/255
	self.g = (data:GetAngle().y or 255)/255
	self.b = (data:GetAngle().r or 255)/255
	
	self.Mat:SetMaterialVector("$color",Vector(self.r,self.g,self.b))
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
	render.DrawBeam( self.StartPos,self.EndPos,32*self.Frac,texcoord,texcoord - self.Length / 128,Color( self.r, self.g, self.b, self.Frac*self.Alpha ) )

end
