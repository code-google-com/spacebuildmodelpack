TOOL.Category   = "SBMP"
TOOL.Name       = "Beam Cannon"
TOOL.Command    = nil
TOOL.ConfigName = ""

TOOL.ClientConVar["config"] = 2

cleanup.Register("sbmp_beam_cannon")

function TOOL:LeftClick(trace)
	if (not trace.Entity) or trace.Entity:IsPlayer() then return false end
	if CLIENT then return true end

	if not self:GetOwner():CheckLimit("sbmp_beam_cannon") then return false end

	local config  = self:GetClientNumber("config")
	
	local ply = self:GetOwner()
	local Pos = trace.HitPos
	local Ang = trace.HitNormal:Angle()
	Ang.pitch = Ang.pitch + 90
	
	local ent = MakeSBMPBeamCannon(ply, Ang, Pos, config)
	
	ent:SetPos(trace.HitPos - trace.HitNormal * ent:OBBMins().z)
	
	if trace.Entity:IsValid() then
		local const = constraint.Weld(ent,      trace.Entity, 0, trace.PhysicsBone, 0)
		nocollide   = constraint.NoCollide(ent, trace.Entity, 0, trace.PhysicsBone)
	end

	undo.Create("sbmp_beam_cannon")
		undo.AddEntity(ent)
		undo.AddEntity(const)
		undo.AddEntity(nocollide)
		undo.SetPlayer(ply)
	undo.Finish()
	
	ply:AddCleanup("sbmp_beam_cannon", ent)
	
	return true
end

function TOOL.BuildCPanel(cp)
	cp:AddControl("Header", {Text = "#Tool_sbmp_beam_cannon_name", Description	= "#Tool_sbmp_beam_cannon_desc"})
	
	local combo = {}
	combo.Label = "Beam Cannon Types"
	combo.MenuButton = 0
	combo.Folder = "settings/menu/main/construct/sbmp_beam_cannon/"
	combo.Options = {}
	-- combo.Options["Anti-Fighter Beam"] = {sbmp_beam_cannon_config = 1}
	combo.Options["Green Slasher"]     = {sbmp_beam_cannon_config = 2}
	combo.Options["Gold Slasher"]      = {sbmp_beam_cannon_config = 3}
	combo.Options["Green Cannon"]      = {sbmp_beam_cannon_config = 4}
	combo.Options["Gold Cannon"]       = {sbmp_beam_cannon_config = 5}

	cp:AddControl("ComboBox", combo) 
end


if CLIENT then
	language.Add("Tool_sbmp_beam_cannon_name", "Beam Cannon")
	language.Add("Tool_sbmp_beam_cannon_desc", "Create a Beam Cannon.")
	language.Add("Tool_sbmp_beam_cannon_0",    "Left-Click: Spawn a Beam Cannon.")

	language.Add("Undone_sbmp_beam_cannon",    "Beam Cannon Undone")
	language.Add("Cleanup_sbmp_beam_cannon",   "Beam Cannons")
	language.Add("Cleaned_sbmp_beam_cannon",   "Cleaned up all Beam Cannons")
	language.Add("SBoxLimit_sbmp_beam_cannon", "Maximum Beam Cannons Reached")
else
    CreateConVar("sbox_maxsbmp_beam_cannon", 4)
	
	function MakeSBMPBeamCannon(ply, Ang, Pos, config)
		if not ply:CheckLimit("sbmp_beam_cannon") then return Error("Attempted to spawn more then the maximum allotted number of beam cannons.") end
		--if not ((config == 1) or (config == 2) or (config == 3) or (config == 4) or (config == 5)) then return Error("Invalid configuration, got: '", config, "'; Type: ", type(config), "\n") end
		if not ((config == 2) or (config == 3) or (config == 4) or (config == 5)) then return Error("Invalid configuration, got: '", config, "'; Type: ", type(config), "\n") end
		
		local ent = ents.Create("sbmp_beam_cannon")
		if not (ent and ent:IsValid()) then return Error("Unable to create the sbmp_beam_cannon entity!\n") end
		
		ent:SetAngles(Ang)
		ent:SetPos(Pos)
		ent:Spawn()
		
		ent:SetOwner("Owner", ply)
		ent:Setup(config)
		
		ply:AddCount("sbmp_beam_cannon", ent)
		
		return ent
	end
	
	duplicator.RegisterEntityClass("sbmp_cannon", MakeSBMPBeamCannon, "Ang", "Pos", "config", "Vel", "aVel", "frozen")
end
