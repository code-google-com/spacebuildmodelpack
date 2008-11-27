TOOL.Category		= "SBMP"
TOOL.Name			= "Lift"
TOOL.Command		= nil
TOOL.ConfigName		= ""

if CLIENT then
    language.Add("Tool_sbmp_elevator_name", "SBMP: Lift")
    language.Add("Tool_sbmp_elevator_desc", "Spawns an lift that won't spaz out and bash your brains in.")
    language.Add("Tool_sbmp_elevator_0",    "Primary: Create Lift")
	
	language.Add("sboxlimit_sbmp_lifts", "You've hit the SBMP Lift limit!")
	language.Add("undone_SBMP: Lift", "Undone SBMP Lift")
end

if SERVER then
	CreateConVar('sbox_maxsbmp_lifts', 10)
end


TOOL.ClientConVar["model"] = "models/SmallBridge/SBpanelelev2s/sbpanelelev2s.mdl"

cleanup.Register("sbmp_lifts")


local EmptyTable = {}

local MDLs = {}
MDLs["models/SmallBridge/SBpanelelev0s/SBpanelelev0s.mdl"]   = EmptyTable
MDLs["models/SmallBridge/SBpanelelev2s/sbpanelelev2s.mdl"]   = EmptyTable
MDLs["models/SmallBridge/SBpanelelev1s/sbpanelelev1s.mdl"]   = EmptyTable
MDLs["models/SmallBridge/SBpanelelev3s/sbpanelelev3s.mdl"]   = EmptyTable
MDLs["models/SmallBridge/SBpanelelev2sE/sbpanelelev2se.mdl"] = EmptyTable

MDLs["models/SmallBridge/SBpanelelev3sdw/sbpanelelev3sdw.mdl"]   = EmptyTable
MDLs["models/SmallBridge/SBpanelelev2sEdw/sbpanelelev2sedw.mdl"] = EmptyTable
MDLs["models/SmallBridge/SBpanelelev2sdw/sbpanelelev2sdw.mdl"]   = EmptyTable
MDLs["models/SmallBridge/SBpanelelev1sdw/sbpanelelev1sdw.mdl"]   = EmptyTable
MDLs["models/SmallBridge/SBpanelelev0sdw/sbpanelelev0sdw.mdl"]   = EmptyTable

MDLs["models/Slyfo/inversebayhatch.mdl"] = EmptyTable
MDLs["models/Slyfo/mcpdropbayhatch.mdl"] = EmptyTable

MDLs["models/Spacebuild/pad.mdl"]      = EmptyTable
MDLs["models/Spacebuild/stubecap.mdl"] = EmptyTable

MDLs["models/Spacebuild/medbridge2_doublehull_centralcolumnelevatorpad.mdl"] = EmptyTable
MDLs["models/Spacebuild/medbridge2_doublehull_hanger_crosswalk.mdl"]         = EmptyTable

MDLs["models/Spacebuild/medbridge2_fighterbayshortcap2.mdl"] = EmptyTable
MDLs["models/Spacebuild/medbridge2_fighterbayshortcap.mdl"]  = EmptyTable
MDLs["models/Spacebuild/medbridge2_fighterbay2longcap.mdl"]  = EmptyTable

MDLs["models/Slyfo/flatpallet.mdl"] = EmptyTable
MDLs["models/Slyfo/boxpallet.mdl"]  = EmptyTable

MDLs["models/SmallBridge/SBdoor/sbdoor.mdl"]             = EmptyTable
MDLs["models/SmallBridge/SBdoorwide/sbdoorwide.mdl"]     = EmptyTable
MDLs["models/SmallBridge/SBdoorsquare/sbdoorsquare.mdl"] = EmptyTable

MDLs["models/SmallBridge/SBwalkwayE2/sbwalkwaye2.mdl"] = EmptyTable
MDLs["models/SmallBridge/SBwalkwayX/sbwalkwayx.mdl"]   = EmptyTable
MDLs["models/SmallBridge/SBwalkwayT/sbwalkwayt.mdl"]   = EmptyTable
MDLs["models/SmallBridge/SBwalkwayE/sbwalkwaye.mdl"]   = EmptyTable
MDLs["models/SmallBridge/SBwalkwayR/sbwalkwayr.mdl"]   = EmptyTable

MDLs["models/SmallBridge/SBlanddockramp1/SBlanddockramp1.mdl"]   = EmptyTable
MDLs["models/SmallBridge/SBlanddockramp1dw/SBlanddockramp1dw.mdl"]   = EmptyTable
MDLs["models/SmallBridge/SBlanddockramp1dwdh/SBlanddockramp1dwdh.mdl"]   = EmptyTable

MDLs["models/SmallBridge/SBbridgeO1cover/SBbridgeO1cover.mdl"]   = EmptyTable

MDLs["models/SmallBridge/SBEdoorsN/SBEdoorsN.mdl"]   = EmptyTable
MDLs["models/SmallBridge/SBEdoorsN2/SBEdoorsN2.mdl"]   = EmptyTable


function TOOL:LeftClick(trace)
	if (not trace.HitPos) or trace.Entity:IsPlayer() then return false end
	if CLIENT then return true end

	local ply = self:GetOwner()
	
	if not ply:CheckLimit("sbmp_lifts") then return false end
	
	local Ang = trace.HitNormal:Angle()
	Ang.pitch = Ang.pitch + 90
	
	local ent = ents.Create("sbmp_lift")
	ent:SetModel(self:GetClientInfo("model"))
	ent:SetPos(trace.HitPos - trace.HitNormal * ent:OBBMins().z)
	ent:SetAngles(Ang)
	ent:Spawn()
	
	undo.Create("SBMP: Lift")
		undo.AddEntity(ent)
		undo.SetPlayer(ply)
	undo.Finish()

	ply:AddCleanup("sbmp_lifts", ent)

	return true
end

function TOOL:UpdateDaGhost(ent, ply)
	if not (ent and ent:IsValid()) then return end
	
	local trace = util.TraceLine(util.GetPlayerTrace(ply, ply:GetCursorAimVector()))

	if (not trace.Hit) or trace.Entity:IsPlayer() then
		return ent:SetNoDraw(true)
	end
	
	local Ang = trace.HitNormal:Angle()
	Ang.pitch = Ang.pitch + 90
	
	ent:SetPos(trace.HitPos - trace.HitNormal * ent:OBBMins().z)
	ent:SetAngles(Ang)
	
	return ent:SetNoDraw(false)
end

local VecZero = Vector(0, 0, 0)
local AngZero = Angle( 0, 0, 0)

function TOOL:Think()
	if not (self.GhostEntity and self.GhostEntity:IsValid() and self.GhostEntity:GetModel() == self:GetClientInfo("model")) then
		self:MakeGhostEntity(self:GetClientInfo("model"), VecZero, AngZero)
	end

	return self:UpdateDaGhost(self.GhostEntity, self:GetOwner())
end

function TOOL.BuildCPanel(panel)
	panel:AddControl("Header", {Text = "Lift", Description = "Up and down and up and down and up and down and up and down..."})
	
	panel:AddControl("PropSelect", {Label = "Lift Model:",
									ConVar = "sbmp_elevator_model",
									Category = "SBMP Elevators",
									Models = MDLs})
end

