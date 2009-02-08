
include('shared.lua')
--killicon.AddFont("seeker_missile", "CSKillIcons", "C", Color(255,80,0,255))
ENT.RenderGroup = RENDERGROUP_OPAQUE


function ENT:Initialize()

end

function ENT:Draw()
	
	self.Entity:DrawModel()

end

function ENT:Think()
	local HPC = self.Entity:GetNetworkedInt("HPC")
	local out = ""
	for HP=1,HPC do
		local Wep = self.Entity:GetNetworkedEntity("HPW_"..HP)
		if Wep then
			local Info = Wep.WInfo
			if Info then
				out = out..Info
				if HP ~= HPC then
					out = out..", "
				end
			end
		end
	end
	self.WInfo = out
end
