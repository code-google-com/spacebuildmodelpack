function EFFECT:Init(data)
	self.Ent = data:GetEntity()
	
	if not (self.Ent and self.Ent:IsValid()) then return end
	
	self.Duration = data:GetMagnitude()
	self.StartTimestamp = CurTime() + self.Duration
end

function EFFECT:Think()
	if not self.Ent:IsValid() then return end
	
	local CTime = CurTime()
	
	local tmp2 = math.Clamp(255 * ((self.StartTimestamp - CurTime()) / self.Duration), 0, 255)
	
	self.Ent:SetColor(tmp2, tmp2, tmp2, tmp2)
	
	return true
end

function EFFECT:Render()
end
