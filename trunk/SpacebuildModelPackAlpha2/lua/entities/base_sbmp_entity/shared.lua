SBMP = SBMP or {}
SBMP.MasterResourcesRequiredOverrideVar = false -- Make this true to remove all need for resources

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"

ENT.PrintName		= "Base SBMP Enitty"
ENT.Author			= "Olivier 'LuaPineapple' Hamel"
ENT.Contact			= "evilpineapple@cox.net"
ENT.Purpose			= "RD3 sucks. (This statement does not represent in any way the opinion of the SBEP, or any of it's other dev members. Blah blah blah *legal jargon*.)"
ENT.Instructions	= "You shouldn't need them. If you do then stop right now and jump off a cliff."
ENT.Category		= "Spacebuild Enhancement Project" -- Who changed the title anyways?

ENT.Spawnable		= false
ENT.AdminSpawnable	= false

ENT.Model           = "models/Spacebuild/emount4_fighter.mdl" -- This is your entities's model
--ENT.MassOverride    = 2500 -- This will override your entities's mass

ENT.ResList = {}
-- Example Entry
--[[
ENT.ResList["energy"].Capacity      = 0
ENT.ResList["energy"].DefaultAmount = 0
--]]

ENT.WireInputsList  = {}
ENT.WireOutputsList = {}

ENT.SBMPCallOnClientUMsgHookName = "Base_SBMP_Entity_CallOnClient" -- Don't touch this you fool!

SBMP = SBMP or {}
SBMP.RegisteredServersideCallOnClientHook = SBMP.RegisteredServersideCallOnClientHook or false

function ENT:Think()
	if self.OnBaseThink then
		self:OnBaseThink()
	elseif self.OnThink then
		self:OnThink()
	end
end

function SBMP.BaseEntityCallOnClientUMsgHook(msg)
	if not msg.ReadGeneric then return end
	--print("msg: ", msg)
	local ent        = msg:ReadEntity()
	local func_key   = msg:ReadString()
	local paramiters = msg:ReadGeneric()
	--print("call on client client")
	--print("entity: ", ent)
	--print("function key: '", func_key, "'")
	--print("paramiters: ", paramiters)
	--if type(paramiters) == "table" then
	--	PrintTable(paramiters)
	--end
	local ok, err
	
	if ent[func_key] and type(ent[func_key]) == "function" then
		ok, err = pcall(ent[func_key], ent, paramiters)
		
		if not ok then
			print("CallOnClient SBMP base entity error:")
			ErrorNoHalt(err, "\n")
			print("Function key: ", func_key, "; Type: ", type(ent[func_key]))
		end
	else
		print(type(ent[func_key]))
	end
end

if CLIENT or (SERVER and (not SBMP.RegisteredServersideCallOnClientHook)) then
	if SERVER then
		SBMP.RegisteredServersideCallOnClientHook = true
	end
	
	usermessage.Hook(ENT.SBMPCallOnClientUMsgHookName, SBMP.BaseEntityCallOnClientUMsgHook)
end