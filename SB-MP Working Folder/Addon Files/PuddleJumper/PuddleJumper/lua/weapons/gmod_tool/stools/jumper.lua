--#########################################
--						Stargate Staff Weapon Stool v1.0 by aVoN
--						aka System of a pWne!^
--#########################################

/*
	Stargate Staff Weapon Tool for GarrysMod10
	Copyright (C) 2007  aVoN

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

--################# Header
include("weapons/gmod_tool/stargate_base_tool.lua");
TOOL.Category="Weapons"
TOOL.Name="#Jumper"

-- The keys for the numpad. 1 is shoot, 2 is explode all current shots

-- The default model for the GhostPreview
TOOL.ClientConVar["model"] = "models/puddle/pjd.mdl";
-- Holds modles for a selection in the tooltab and allows individual Angle and Position offsets {Angle=Angle(1,2,3),Position=Vector(1,2,3} for the GhostPreview


-- Information about the SENT to spawn
TOOL.Entity.class = "shuttle";

-- The default offset Angle, the sent should additional rotated - For Ghostpreview, when something looks strange
-- Optionally you can also do this for special models in TOOL.Models. E.g. ["my_model"] = {Angle=Angle(1,2,3)},
TOOL.Entity.angle = Angle(0,0,0);
TOOL.Entity.limit = StarGate.CFG:Get("drone","limit",1); -- Spawnlimit

-- Add the topic texts, you see in the upper left corner
TOOL.Topic["name"] = "Puddle Jumper Spawner";
TOOL.Topic["desc"] = "Puddle Jumper launcher";
TOOL.Topic[0] = "Left click, to spawn a Puddle Jumper";
-- Adds additional "language" - To the end of these files, the string "_*classname*" will be added, using TOOL.Entity["class"]. 
-- E.g. TOOL.Language["Undone"] will add the language "Undone_prop_physics" when TOOL.Entity["class"] is "prop_physics"
TOOL.Language["Undone"] = "Puddle Jumper removed";
TOOL.Language["Cleanup"] = "Puddle Jumpers";
TOOL.Language["Cleaned"] = "Removed all Puddle Jumpers";
TOOL.Language["SBoxLimit"] = "Hit the Puddle Jumper limit";
--################# Code

--################# LeftClick Toolaction @aVoN
function TOOL:LeftClick(t)
	if(t.Entity and t.Entity:IsPlayer()) then return false end;
	if(t.Entity and t.Entity:GetClass() == self.Entity.class) then return false end;
	if(CLIENT) then return true end;
	if(not self:CheckLimit()) then return false end;
	local p = self:GetOwner();
	local shoot = self:GetClientNumber("shoot");
	local explode = self:GetClientNumber("explode");
	local track = self:GetClientNumber("track");
	local model = self:GetClientInfo("model");
	local eye_track = self:GetClientNumber("eye_track");
	--######## Spawn SENT
	local e = self:SpawnSENT(p,t,shoot,explode,track,model,eye_track);
	if(util.tobool(self:GetClientNumber("autolink"))) then
		self:AutoLink(e,t.Entity); -- Link to that energy system, if valid
	end
	--######## Weld things?
	local c;
	if(t.Entity:IsValid() and util.tobool(self:GetClientNumber("autoweld"))) then
		c = constraint.Weld(e,t.Entity,0,t.PhysicsBone,0,true);
		t.Entity:DeleteOnRemove(e);
	end
	--######## Cleanup and undo register
	self:AddUndo(p,e,c);
	self:AddCleanup(p,c,e);
	return true;
end

--################# The PreEntitySpawn function is called before a SENT got spawned. Either by the duplicator or with the stool.@aVoN
function TOOL:PreEntitySpawn(p,e,shoot,explode,track,model,eye_track)
	e:SetModel(model);
end

--################# The PostEntitySpawn function is called after a SENT got spawned. Either by the duplicator or with the stool.@aVoN
function TOOL:PostEntitySpawn(p,e,shoot,explode,track,model,eye_track)
	if(shoot) then
		numpad.OnDown(p,shoot,"DroneOn",e);
		numpad.OnUp(p,shoot,"DroneOff",e);
	end
	if(explode) then
		numpad.OnDown(p,explode,"DroneExplode",e);
	end
	-- Track (Wire or Players)
	if(track) then
		numpad.OnDown(p,track,"DroneTrackOn",e);
		numpad.OnUp(p,track,"DroneTrackOff",e);
	end
	-- Track by EyeTrace
	if(eye_track) then
		numpad.OnDown(p,eye_track,"DroneEyeOn",e);
		numpad.OnUp(p,eye_track,"DroneEyeOff",e);
	end
end

--################# Controlpanel @aVoN
function TOOL:ControlsPanel(Panel)
	Panel:AddControl("Header",{Text="Puddle Jumper",Description=""});
	Panel:AddControl("Checkbox",{Label="W = slow, Shift = fast, D = reverse, R = Cloak, LC = fire, RC = track.",Command="",Description="All Hail AVON"});
end

--################# Numpad shoot bindings - Only for the server


--################# Register Stargate hooks. Needs to be called after all functions are loaded!
TOOL:Register();