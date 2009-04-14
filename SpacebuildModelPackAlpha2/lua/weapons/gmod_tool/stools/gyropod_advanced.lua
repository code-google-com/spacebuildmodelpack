TOOL.Category		= "Construction"
TOOL.Name			= "#Gyro-Pod Advanced"
TOOL.Command		= nil
TOOL.ConfigName		= ""
TOOL.ent = {}
TOOL.ClientConVar[ "model" ] = "models/props_combine/headcrabcannister01a.mdl"

if ( CLIENT ) then
	language.Add( "Tool_gyropod_advanced_name", "DataSchmuck's Enhanced Gyro-Pod" )
	language.Add( "Tool_gyropod_advanced_desc", "Customize controls & sensitivity with inputs. Last vehicle linked controls direction. Reload to select model." )
	language.Add( "Tool_gyropod_advanced_0", "Right-Click to spawn.  Left click a prop or vehicle to start linking it.  You MUST link the Gyro to every major prop." )
	language.Add( "Tool_gyropod_advanced_1", "Now click the Gyro-Pod.  THE ERROR MESSAGE IS YOUR CONFIRMATION THAT IT LINKED CORRECTLY. Reload to cancel linking" )	
	language.Add( "Tool_turret_type", "Type of weapon" )	
end

if (SERVER) then
	CreateConVar('sbox_maxgyropod_advanceds', 20)
end	
cleanup.Register( "gyropod_advanceds" )	

--Link an entity to the gyropod
function TOOL:LeftClick( trace )
if ( !trace.Hit ) then return end
	if (self:GetStage() == 0) and (!trace.Entity.GPod) and (trace.Entity:IsValid()) then
		self.LEnt = trace.Entity
		self:SetStage(1)
		return true
	elseif (self:GetStage() == 1) and (trace.Entity.GPod) and (trace.Entity:IsValid()) then
		trace.Entity:Link(self.LEnt)
		self:SetStage(0)
		return true
	else
		return false
	end
	return true
end

--Spawn the gyropod
function TOOL:RightClick( trace )
	if (!trace.HitPos) then return false end
	if (trace.Entity:IsPlayer()) then return false end
	if ( CLIENT ) then return true end
	local ply = self:GetOwner()
	if ( trace.Entity:IsValid() && trace.Entity:GetClass() == "gyropod_advanced" && trace.Entity:GetTable().pl == ply ) then
		return true
	end
	if ( !self:GetSWEP():CheckLimit( "gyropod_advanceds" ) ) then return false end
	local Ang = trace.HitNormal:Angle()
	Ang.pitch = Ang.pitch + 90
	local Model = self:GetClientInfo( "model" )
	local datagpod = MakeDataGPod( ply, Model, trace.HitPos, Ang )
	local min = datagpod:OBBMins()
	datagpod:SetPos( trace.HitPos - trace.HitNormal * min.z )	
	undo.Create("Gyro Pod Advanced")
		undo.AddEntity( datagpod )
		undo.SetPlayer( ply )
	undo.Finish()
	ply:AddCleanup( "gyropod_advanceds", datagpod )
	return true
end

--Set the gyropds model, also clear the selected ent
function TOOL:Reload( trace )
	self.LEnt = nil
	if (self:GetStage()== 0) then
		if CLIENT and trace.Entity:IsValid() then return true end
		if not trace.Entity:IsValid() then return end
		local model = trace.Entity:GetModel()
		self:GetOwner():ConCommand("gyropod_advanced_model "..model);
		self.Model = model
	end
	self:SetStage(0)
	return true;
end

if (SERVER) then
	
	--stuff needed for setting up ghost and model selection
	function MakeDataGPod( pl, Model, Pos, Ang )
		if ( !pl:CheckLimit( "gyropod_advanceds" ) ) then return false end
		local datagpod = ents.Create( "gyropod_advanced" )
		if (!datagpod:IsValid()) then return false end
		datagpod:SetAngles(Ang)
		datagpod:SetPos(Pos)
		datagpod:SetModel(Model)
		datagpod:Spawn()
		datagpod:GetTable():SetPlayer( pl )
		local ttable = {
			pl = pl
		}
		table.Merge(datagpod:GetTable(), ttable )
		pl:AddCount( "gyropod_advanceds", datagpod )
		return datagpod
	end
	duplicator.RegisterEntityClass("gyropod_advanced", MakeDataGPod, "Model", "Pos", "Ang", "Vel", "aVel", "frozen")
end

--Show the spawn ghost
--[[function TOOL:UpdateGhostDataGPod( ent, player )
	if ( !ent || !ent:IsValid() ) then return end
	local tr 	= utilx.GetPlayerTrace( player, player:GetCursorAimVector() )
	local trace 	= util.TraceLine( tr )
	if (!trace.Hit || trace.Entity:IsPlayer() || trace.Entity:GetClass() == "gyropod_advanced" ) then
		ent:SetNoDraw( true )
		return
	end
	local Ang = trace.HitNormal:Angle()
	Ang.pitch = Ang.pitch + 90
	local min = ent:OBBMins()
	ent:SetPos( trace.HitPos - trace.HitNormal * min.z )
	ent:SetAngles( Ang )
	ent:SetNoDraw( false )
end

--more ghost and model stuff
function TOOL:Think()
	if (!self.GhostEntity || !self.GhostEntity:IsValid() || self.GhostEntity:GetModel() != self.Model ) then
		self:MakeGhostEntity( self:GetClientInfo("model"), Vector(0,0,0), Angle(0,0,0) )
	end

	self:UpdateGhostDataGPod( self.GhostEntity, self:GetOwner() )
end]]

function TOOL.BuildCPanel( CPanel )
	CPanel:AddControl( "Header", { Text = "#Tool_gyropod_advanced_name", Description	= "#Tool_gyropod_advanced_desc" }  )
end

--The detailed instructions
function TOOL.BuildCPanel(panel)
	local BindLabel0 = {}
	local BindLabel1 = {}
	local BindLabel2 = {}
--[[	local BindLabel3 = {}
	local BindLabel4 = {}
	local BindLabel5 = {}
	local BindLabel6 = {}
	local BindLabel7 = {}
	local BindLabel8 = {}
	local BindLabel9 = {}
	local BindLabel10 = {}
	local BindLabel11 = {}]]
	BindLabel0.Text =
[[BASIC INSTRUCTIONS

1:  Right Click to create a Gyro-Pod.
2:  Left Click a prop.
3:  Left Click Gyro-Pod to create Link.
4: Repeat Steps 2 & 3 for all major props.
5:  Left click a vehicle.
6:  Left click Gyro-Pod to Link vehicle.
7:  Wire the 'Activate' input to a TOGGLED output.
8:  Wire movement controls to an Adv. Pod Controller.
9:  Place near center of ship.
10:  Orient the Gyro-Pod so it's aligned with ship.
11:  Weld Gyro-pod to ship.
12:  Enter your linked vehicle.
13:  Press key you wired to the 'Activate' input to turn on/off.
14:  Use MouseLook to control Pitch and Yaw.
15:  Use the keys you wired to the movement controls to move the ship through space.

ADVANCED CONTROLS (OPTIONAL)

DISABLE MOUSE LOOK 
Uses Input keys for Pitch and Yaw.
Wire a value of 1 to the 'No Mouse' input.
Wire Adv Pod Controller inputs or Numpad inputs to the PitchUP and Down and YawLeft and Right inputs.]]

	BindLabel1.Text =
[[MULTIPLIERS
Controls axis sensitivity.
Values from 0.0 to 0.99 reduce sensitivity.
Values greater than 1 increase sensitivity.
Negative values reverse input.
Defaults for all are 1

SPEED LIMIT
Limits the speed in MPH.
Default is 112.  Max is 112

AIMING MODE
Points ship towards GPS coords.
Wire AimMode to a TOGGLED output.
Wire the Aim XYZ (or AimVec) inputs to WORLD XYZ cords.

FREEZE SHIP
All CONSTRAINED entities will be frozen
Wire the Freeze Input to a TOGGLED output.
You CAN still use your physgun's reload function to unfreeze the ship.]]

	BindLabel2.Text =
[[TIPS
 *  Press Reload on any prop to set the model of the Gyro-Pod to that prop.
 *  If you see an error after you try to link a prop, DON'T WORRY, it worked.
 *  You only need to Gyro-Link a few of the main parts of your ship.
 *  If you need to cancel a link, press Reload (which will also reset the model).
 *  If you PARENT the Gyro-Pod, you will lose the ability to Link it or Wire it, so save parenting for last.
 *  The Gyro-Pod's Pitch and Yaw are ONLY controlled by your mouse movement while inside a vehicle, and ONLY by the LAST vehicle you linked to the Gyro-Pod.
 *  Try wiring a 'Not' gate to the 'Active' Output of your pod controller, then wiring the 'Freeze' Input of the Gyro-Pod to the 'Not' gate.
 *  Joystick is supported, but not tested
 

 Credit goes to Paradukes and the SBEP Team for creating the original Gyro-Pod.  I (DataSchmuck) just modified the code a bit.]]
	
	BindLabel0.Description = "Basic Instructions1"
	panel:AddControl("Label", BindLabel0 )
	
	BindLabel1.Description = "Basic Instructions2"
	panel:AddControl("Label", BindLabel1 )
	
	BindLabel2.Description = "Basic Instructions3"
	panel:AddControl("Label", BindLabel2 )
	
--[[	BindLabel3.Description = "Advanced"
	panel:AddControl("Label", BindLabel3 )
	
	BindLabel4.Description = "NoMouse"
	panel:AddControl("Label", BindLabel4 )
	
	BindLabel5.Description = "Multiplier"
	panel:AddControl("Label", BindLabel5 )
	
	BindLabel6.Description = "Speed Limit"
	panel:AddControl("Label", BindLabel6 )
	
	BindLabel7.Description = "Targeting Mode"
	panel:AddControl("Label", BindLabel7 )
	
	BindLabel8.Description = "Freeze Mode"
	panel:AddControl("Label", BindLabel8 )
	
	BindLabel9.Description = "Tips1"
	panel:AddControl("Label", BindLabel9 )	
	
	BindLabel10.Description = "Tips2"
	panel:AddControl("Label", BindLabel10 )	
	
	BindLabel11.Description = "Credits"
	panel:AddControl("Label", BindLabel11 )	]]
end