AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local RD_Version_Determined = false -- Because the first base_sbmp_entity derivative entity will most likely spawn AFTER RD2 is loaded into memory

function ENT:Initialize()
	self.Entity:SetModel(self.Model)
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	
	local Phys = self.Entity:GetPhysicsObject()
	
	if Phys:IsValid() then
		Phys:SetMass(self.MassOverride) // a bit heavier please
		Phys:Wake()
	end
	
	self:InitResources()
	
	-- Mostly because we might have an intermediate entity class between the core sbmp base and the end entity (like the weapons for example)
	
	if self.OnBaseInit then
		self:OnBaseInit()
	elseif self.OnInit then
		self:OnInit()
	end
end

function ENT:InitResources()
	if not RD_Version_Determined then
		self:DetermineRDVersion()
	end
	
	self.UseRD = RD_Version_Determined
	
	local has_res = false
	
	if RD_Version_Determined == 3 then
		-- Need someone to fill this for RD3, I'm not touching that stuff with an eight meter pole
	elseif RD_Version_Determined then
		for k, v in pairs(self.ResList) do
			has_res = true -- Far less then elegant
			RD_AddResource(self.Entity, k, v.Capacity)
			RD_SupplyResource(self.Entity, k, v.DefaultAmount)
		end
	end
	
	self.UseRD = (not has_res) and nil or self.UseRD
end

function ENT:DetermineRDVersion()
	if Dev_Unlink_All then -- RD2 is present and it is so much cooler then RD3 (if it even dared show it's face at RD2's party) that we'll use it instead
		RD_Version_Determined = 2
	else
		if CAF and CAF.GetAddon("Resource Distribution") then -- Oh well...
			RD_Version_Determined = 3
		end
	end
end

function ENT:Use(activator, caller)
	if self.OnBaseUse then
		self:OnBaseUse(activator, caller)
	end
	
	if self.OnUse then
		self:OnUse(activator, caller)
	end
end

function ENT:TriggerInput(iname, value)
	if self.OnBaseWireInput then
		self:OnBaseWireInput(iname, value)
	elseif self.OnWireInput then
		self:OnWireInput(iname, value)
	end
end

function ENT:OnRemove()
	if self.UseRD then
		self:Unlink()
	end
	
	if self.OnBaseDie then
		self:OnBaseDie()
	elseif self.OnDie then
		self:OnDie()
	end
end

function ENT:Unlink()
	if not self.UseRD then return end
	
	if self.UseRD == 3 then
		-- Need someone to fill this for RD3, I'm not touching that stuff with an eight meter pole
		return
	end
	
	if Dev_Unlink_All then
		return Dev_Unlink_All(self.Entity)
	end
end

-- Note that it does not check that there is a function of that name on the client.
-- On the server side that is, it'll check on the client but you'll have wasted a whole data transmission.

function ENT:CallOnClient(function_key, data, use_string_pooling)
	if not (umsg.Generic and function_key and (type(function_key) == "string") and self and self.IsValid and self:IsValid()) then return end
	
	local RF = RecipientFilter()
	RF:AddAllPlayers()
	
	umsg.Start("Base_SBMP_Entity_CallOnClient", RF)
		umsg.Entity(self.Entity)
		umsg.PoolString(function_key)
		umsg.Generic(data, use_string_pooling)
	umsg.End()
end
