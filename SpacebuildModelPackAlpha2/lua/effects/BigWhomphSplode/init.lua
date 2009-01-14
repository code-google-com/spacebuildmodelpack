
 /*--------------------------------------------------------- 
    Initializes the effect. The data is a table of data  
    which was passed from the server. 
 ---------------------------------------------------------*/ 
 function EFFECT:Init( data ) 
 	 
 	// This is how long the spawn effect  
 	// takes from start to finish. 
 	self.Time = 3
 	self.LifeTime = CurTime() + self.Time 
	
 	self.vOffset = data:GetOrigin()
 	self.CRenPos = data:GetOrigin()
 	self.vAng = data:GetAngle()
 	self.vFw = self.vAng:Forward()
 	self.vUp = self.vAng:Up()
 	self.vRi = self.vAng:Right()
	
	self.emitter = ParticleEmitter( self.vOffset )
	
	for i = 0, 360, 15 do
		local particle = self.emitter:Add( "particles/smokey", self.vOffset )
		if (particle) then
			particle:SetVelocity( Vector( math.cos(i) * 400 , math.sin(i) * 400 , 0 ) )
			particle:SetLifeTime( 0 )
			particle:SetDieTime( math.Rand( 2, 3 ) )
			particle:SetStartAlpha( math.Rand( 200, 255 ) )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( 90 )
			particle:SetEndSize( 70 )
			particle:SetRoll( math.Rand(0, 360) )
			particle:SetRollDelta( math.Rand(-0.2, 0.2) )
			particle:SetColor( 220 , 220 , 180 )
		end
	end
	local scount = math.random(20,25)
	for i = 0, scount do
		
		local particle = self.emitter:Add( "particles/smokey", self.vOffset )
		if (particle) then
			particle:SetVelocity( self.vFw * math.Rand(50, 350) + self.vUp * math.Rand(-200, 200) + self.vRi * math.Rand(-200, 200) )
			particle:SetLifeTime( 0 )
			particle:SetDieTime( math.Rand( 2, 3 ) )
			particle:SetStartAlpha( math.Rand( 200, 255 ) )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( 60 )
			particle:SetEndSize( 40 )
			particle:SetRoll( math.Rand(0, 360) )
			particle:SetRollDelta( math.Rand(-0.2, 0.2) )
			particle:SetColor( 220 , 220 , 180 )
		end
		
		local particle2 = self.emitter:Add( "particles/flamelet"..math.random(1,5), self.vOffset )
		if (particle2) then
			particle2:SetVelocity( self.vFw * math.Rand(30, 100) + self.vUp * math.Rand(-20, 20) + self.vRi * math.Rand(-20, 20) )
			particle2:SetLifeTime( 0 )
			particle2:SetDieTime( math.Rand( 2, 3 ) )
			particle2:SetStartAlpha( math.Rand( 200, 255 ) )
			particle2:SetEndAlpha( 0 )
			particle2:SetStartSize( 50 )
			particle2:SetEndSize( 40 )
			particle2:SetRoll( math.Rand(0, 360) )
			particle2:SetRollDelta( math.Rand(-0.2, 0.2) )
			particle2:SetColor( 200 , 200 , 200 )
		end			
	end
		
	self.emitter:Finish()
	
 	self.Entity:SetModel( "models/Combine_Helicopter/helicopter_bomb01.mdl" ) 
 	self.Entity:SetPos( self.vOffset )  
 end 
   

 
 
function EFFECT:Think( )
	local LTime = (self.LifeTime - CurTime()) - 1
	self.CRenPos = self.CRenPos + Vector(0,0,6)
	for i = 0, 2 do
		local AOff = math.Rand(0,360)
		local particle = self.emitter:Add( "particles/smokey", self.CRenPos + Vector( math.cos(AOff) * 10 , math.sin(AOff) * 10 , 0 ) )
		if (particle) then
			particle:SetVelocity( Vector( math.cos(AOff) * 10 , math.sin(AOff) * 10 , 0 ) )
			particle:SetLifeTime( 0 )
			particle:SetDieTime( math.Rand( LTime * 0.5, LTime ) )
			particle:SetStartAlpha( math.Rand( 200, 255 ) )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( 90 )
			particle:SetEndSize( 60 )
			particle:SetRoll( math.Rand(0, 360) )
			particle:SetRollDelta( math.Rand(-0.2, 0.2) )
			particle:SetColor( 220 , 220 , 180 )
		end
	end
	for i = 0, 4 do
		local AOff = math.Rand(0,360)
		local particle = self.emitter:Add( "particles/smokey", self.CRenPos + Vector( math.cos(AOff) * 60 , math.sin(AOff) * 60 , 0 ) )
		if (particle) then
			particle:SetVelocity( Vector( math.cos(AOff) * 80 , math.sin(AOff) * 80 , 40 ) )
			particle:SetLifeTime( 0 )
			particle:SetDieTime( math.Rand( LTime * 0.5, LTime ) )
			particle:SetStartAlpha( math.Rand( 200, 255 ) )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( 90 )
			particle:SetEndSize( 60 )
			particle:SetRoll( math.Rand(0, 360) )
			particle:SetRollDelta( math.Rand(-0.2, 0.2) )
			particle:SetColor( 220 , 220 , 180 )
		end
	end
	self.Entity:NextThink( CurTime() + 0.1 )
	return ( self.LifeTime > CurTime() )  
end 
   
   
   
 /*--------------------------------------------------------- 
    Draw the effect 
 ---------------------------------------------------------*/ 
function EFFECT:Render() 

end  