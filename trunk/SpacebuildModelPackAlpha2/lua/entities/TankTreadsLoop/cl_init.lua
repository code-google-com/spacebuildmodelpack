
include('shared.lua')
killicon.AddFont("seeker_missile", "CSKillIcons", "C", Color(255,80,0,255))


function ENT:Initialize()
	self.Entity:SetModel("models/Slyfo/rover_tread.mdl")
	self.Scroll = 0
	self.PrevPos = self.Entity:GetPos()
	self.Straight = true
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
		local SDist = math.fmod(self.Scroll, Scale * 12)
		
		for i = 1, self.Entity:GetLength(), Scale * 12 do
			self.Entity:SetPos( LowStrPos + (self.Entity:GetForward() * (self.Entity:GetLength() * 0.5)) + self.Entity:GetForward() * -i + self.Entity:GetForward() * SDist )
			self.Entity:SetModelWorldScale( Vector(Scale, Scale, Scale) )
			self.Entity:DrawModel()
		end
		
		//Drawing the top straight section.
		local Scale = self.Entity:GetSegSize()
		local SDist = math.fmod(self.Scroll, Scale * 12)
		local TAng = OAng
		TAng:RotateAroundAxis( self.Entity:GetRight() , 180 )
		self.Entity:SetAngles( TAng )
		
		for i = 1, self.Entity:GetLength(), Scale * 12 do
			self.Entity:SetPos( UppStrPos + (self.Entity:GetForward() * (self.Entity:GetLength() * 0.5)) + self.Entity:GetForward() * -i + self.Entity:GetForward() * SDist )
			self.Entity:SetModelWorldScale( Vector(Scale, Scale, Scale) )
			self.Entity:DrawModel()
		end
		
		/*Drawing the front curved section.
		local Pie = 3.14159265358 // Yes, I know it's spelled wrong. Shut up.
		local Scale = self.Entity:GetSegSize()
		local SDist = -1 * math.fmod(self.Scroll, Scale * 12)
		local CircP = (Scale * 12) / ((Pie * ( self.Entity:GetRadius() * 2 )) / 360)
		
		for i = 1, self.Entity:GetLength(), CircP do
			self.Entity:SetAngles( OAng )
			local Sine = math.sin(math.rad(i + SDist)) * self.Entity:GetRadius()
			local CoSine = math.cos(math.rad(i + SDist)) * self.Entity:GetRadius()
			self.Entity:SetPos( OPos + (self.Entity:GetForward() * Sine) + (self.Entity:GetUp() * CoSine) )
			local NAng = OAng + Angle( 0.01, 0.01, 0.01 )
			NAng:RotateAroundAxis( self.Entity:GetRight(), 180 - i )
			self.Entity:SetAngles( NAng + Angle( 0.01, 0.01, 0.01 ) )
			self.Entity:SetModelWorldScale( Vector(Scale, Scale, Scale) )
			self.Entity:DrawModel()
		end
		*/
		
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
		self.Scroll = math.fmod(self.Scroll - ((FDist - BDist) * 0.5), self.Entity:GetSegSize() * 12)
		
		self.PrevPos = self.Entity:GetPos()
		
	end
	
	if self:GetRadius() > 0 then self.Straight = false end
	
	self.Entity:NextThink( CurTime() + 0.1 ) 
	return true

end