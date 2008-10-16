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
ENT.MassOverride    = 2500 -- This will override your entities's mass

ENT.ResList = {}
-- Example Entry
--[[
ENT.ResList["energy"].Capacity      = 0
ENT.ResList["energy"].DefaultAmount = 0
--]]

ENT.SBMPCallOnClientUMsgHookName = "Base_SBMP_Entity_CallOnClient" -- Don't touch this
