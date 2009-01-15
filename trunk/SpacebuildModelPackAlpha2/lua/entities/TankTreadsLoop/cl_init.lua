
include('shared.lua')
killicon.AddFont("seeker_missile", "CSKillIcons", "C", Color(255,80,0,255))


function ENT:Initialize()
	self.Entity:SetModel("models/Slyfo/rover_tread.mdl")
	self.Scroll = 0
	self.PrevPos = self.Entity:GetPos()
	self.Straight = true
	self.ILock = 12 -- This is the interlock distance for the current tread model
	self.Entity:SetSegSize( Vector(1, 1, 1) )
end

function ENT:Draw()
	local OPos = self.Entity:GetPos()
	local OAng = self.Entity:GetAngles() + Angle( 0.01, 0.01, 0.01 )
	self.Entity:SetModel("models/Slyfo/rover_tread.mdl")
			
		//Setting up the origin points for the 4 sections of the tread.
		local LowStrPos = (self.Entity:GetPos() - self.Entity:GetUp() * self.Entity:GetRadius())
		local UppStrPos = (self.Entity:GetPos() + self.Entity:GetUp() * self.Entity:GetRadius())
		local BaCircPos = (self.Entity:GetPos() - self.Entity:GetForward() * self.Entity:GetLength() * 0.5)
		local FrCircPos = (self.Entity:GetPos() + self.Entity:GetForward() * self.Entity:GetLength() * 0.5)
		
		//Drawing the bottom straight section.
		local Scale = self.Entity:GetSegSize()
		local SDist = math.fmod(self.Scroll, Scale.x * self.ILock)
		
		for i = 0, self.Entity:GetLength() + 1, Scale.x * self.ILock do
			self.Entity:SetPos( LowStrPos + (self.Entity:GetForward() * (self.Entity:GetLength() * 0.5)) + self.Entity:GetForward() * -i + self.Entity:GetForward() * SDist )
			self.Entity:SetModelScale( Scale )
			self.Entity:DrawModel()
		end
		
		//Drawing the top straight section.
		local Scale = self.Entity:GetSegSize()
		local SDist = math.fmod(self.Scroll, Scale.x * self.ILock)
		local TAng = OAng - Angle( 0.01, 0.01, 0.01 )
		TAng:RotateAroundAxis( self.Entity:GetRight() , 180 )
		self.Entity:SetAngles( TAng )
		
		for i = 0, self.Entity:GetLength() + 1, Scale.x * self.ILock do
			self.Entity:SetPos( UppStrPos + (self.Entity:GetForward() * (self.Entity:GetLength() * 0.5)) + self.Entity:GetForward() * -i + self.Entity:GetForward() * SDist )
			self.Entity:SetModelScale( Scale )
			self.Entity:DrawModel()
		end
		
		//Drawing the front curved section.
		local Pie = 3.14159265358 // Yes, I know it's spelled wrong. Shut up.
		local Scale = self.Entity:GetSegSize()
		--local CircP = (2160 / (Pie * self.Entity:GetRadius()))
		local DegPI = 1 / ((Pie * ( self.Entity:GetRadius() * 2 )) / 360)
		local CircP = DegPI * (Scale.x * self.ILock)
		local SDist = -1 * math.fmod(self.Scroll * DegPI, Scale.x * self.ILock )
		
		for i = 0, 179, CircP do
			local NAng = OAng - Angle( 0.01, 0.01, 0.01 )
			self.Entity:SetAngles( NAng )
			local Sine = math.sin(math.rad(i + SDist)) * self.Entity:GetRadius()
			local CoSine = math.cos(math.rad(i + SDist)) * self.Entity:GetRadius()
			self.Entity:SetPos( FrCircPos + (self.Entity:GetForward() * Sine) + (self.Entity:GetUp() * CoSine) )
			NAng:RotateAroundAxis( self.Entity:GetRight(), 180 - (i + SDist) )
			self.Entity:SetAngles( NAng )
			self.Entity:SetModelScale( Scale )
			self.Entity:DrawModel()
		end
		
		//Drawing the back curved section.
		local Pie = 3.14159265358 // Yes, I know it's spelled wrong. Shut up.
		local Scale = self.Entity:GetSegSize()
		--local CircP = (2160 / (Pie * self.Entity:GetRadius()))
		local DegPI = 1 / ((Pie * ( self.Entity:GetRadius() * 2 )) / 360)
		local CircP = DegPI * (Scale.x * self.ILock)
		local SDist = -1 * math.fmod(self.Scroll * DegPI, Scale.x * self.ILock)
		
		for i = 180, 359, CircP do
			local NAng = OAng - Angle( 0.01, 0.01, 0.01 )
			self.Entity:SetAngles( NAng )
			local Sine = math.sin(math.rad(i + SDist)) * self.Entity:GetRadius()
			local CoSine = math.cos(math.rad(i + SDist)) * self.Entity:GetRadius()
			self.Entity:SetPos( BaCircPos + (self.Entity:GetForward() * Sine) + (self.Entity:GetUp() * CoSine) )
			NAng:RotateAroundAxis( self.Entity:GetRight(), 180 - (i + SDist) )
			self.Entity:SetAngles( NAng )
			self.Entity:SetModelScale( Scale )
			self.Entity:DrawModel()
		end
		
		
	self.Entity:SetPos( OPos )
	self.Entity:SetAngles( OAng - Angle( 0.01, 0.01, 0.01 ) )
end

function ENT:Think()
	local Cont = self.Entity:GetCont()
	if Cont && Cont:IsValid() then
		self.Scroll = Cont.Scroll
	else
		
		local Len = self.Entity:GetLength() * 0.5
		local EPos = self.Entity:GetPos() + (self.Entity:GetForward() * Len)
		local SPos = self.Entity:GetPos() + (self.Entity:GetForward() * -Len)
		self.Entity:SetRenderBoundsWS( SPos, EPos )
		
		local FDist = self.PrevPos:Distance( self.Entity:GetPos() + self.Entity:GetForward() * 50 )
		local BDist = self.PrevPos:Distance( self.Entity:GetPos() + self.Entity:GetForward() * -50 )
		self.Scroll = math.fmod(self.Scroll - ((FDist - BDist) * 0.5), self.Entity:GetSegSize().x * 12)
		
		self.PrevPos = self.Entity:GetPos()
		
	end
	
	if self:GetRadius() > 0 then self.Straight = false end
	
	self.Entity:NextThink( CurTime() + 0.1 ) 
	return true

end