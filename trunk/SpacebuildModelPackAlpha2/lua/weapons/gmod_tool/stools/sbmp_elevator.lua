-- By Olivier 'LuaPineapple' Hamel

TOOL.Category		= "SBMP"
TOOL.Name			= "Lift"
TOOL.Command		= nil
TOOL.ConfigName		= ""

if CLIENT then
    language.Add("Tool_sbmp_elevator_name", "SBMP: Lift")
    language.Add("Tool_sbmp_elevator_desc", "Going Up and down and up and down and up and down and up and down...")
    language.Add("Tool_sbmp_elevator_0",    "Left Click: Spawns an lift that won't spaz out and bash your brains in.")
	
	language.Add("sboxlimit_sbmp_lifts", "You've hit the SBMP Lift limit!")
	language.Add("undone_SBMP: Lift", "Undone SBMP Lift")
end

if SERVER then
	CreateConVar('sbox_maxsbmp_lifts', 10)
end


TOOL.ClientConVar["model"] = "models/SmallBridge/SBpanelelev2s/sbpanelelev2s.mdl"

cleanup.Register("sbmp_lifts")

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

local AngZero = Angle( 0, 0, 0)
local VecZero = Vector(0, 0, 0)

function TOOL:Think()
	if not (self.GhostEntity and self.GhostEntity:IsValid() and self.GhostEntity:GetModel() == self:GetClientInfo("model")) then
		self:MakeGhostEntity(self:GetClientInfo("model"), VecZero, AngZero)
	end

	return self:UpdateDaGhost(self.GhostEntity, self:GetOwner())
end

function TOOL.BuildCPanel(panel)
	panel:AddControl("PropSelect", {Label = "Lift Model:",
									ConVar = "sbmp_elevator_model",
									Category = "SBMP Elevators",
									Models = list.Get("SBMP_ElevatorMdls")})
end

