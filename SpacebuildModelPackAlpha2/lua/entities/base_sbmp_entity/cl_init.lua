include('shared.lua')

function ENT:Initialize()
	if self.OnBaseInit then
		self:OnBaseInit()
	elseif self.OnInit then
		return self:OnInit()
	end
end

SBMP = SBMP or {}

function SBMP.BaseEntityCallOnClientUMsgHook(msg)
	if not msg.ReadGeneric then return end
	
	local ent        = msg:ReadEntity()
	local func_key   = msg:ReadString()
	local paramiters = msg:ReadGeneric()
	
	local ok, err
	
	if ent[func_key] and type(ent[func_key]) == "function" then
		ok, err = pcall(ent[func_key], paramiters)
		
		if not ok then ErrorNoHalt(err, "\n") end
	else
		print(type(ent[func_key]))
	end
end
usermessage.Hook(ENT.SBMPCallOnClientUMsgHookName, SBMP.BaseEntityCallOnClientUMsgHook)