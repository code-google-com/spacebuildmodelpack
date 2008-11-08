include('shared.lua')

local ToolTip = ENT.PrintName
local SBMP_Fighter_Module_Config = {}

function ENT:Draw()
	self.Entity:DrawModel()
	
	if (LocalPlayer():GetEyeTrace().Entity == self.Entity) && (EyePos():Distance(self.Entity:GetPos()) < 512) then
		AddWorldTip(self.Entity:EntIndex(), "All-In-One Fighter Module", 0.5, self.Entity:GetPos(), self.Entity)
	end
end

function ENT.LoadJoystick()
	Msg("HOOKED: Wired fighter system ready.\n")
	
	--the 6 axis controled keys
	SBMP_Fighter_Module_Config[1] = {
		type = "analog",
		description = "Axis 1 (Pitch)",
		category = "SBMP Fighter Module",
		val = 0
	}
	SBMP_Fighter_Module_Config[2] = {
		type = "analog",
		description = "Axis 2 (Yaw)",
		category = "SBMP Fighter Module",
		val = 0
	}
	SBMP_Fighter_Module_Config[3] = {
		type = "analog",
		description = "Axis 3 (Roll)",
		category = "SBMP Fighter Module",
		val = 0
	}
	SBMP_Fighter_Module_Config[4] = {
		type = "analog",
		description = "Axis 4 (Thrust)",
		category = "SBMP Fighter Module",
		val = 0
	}
	SBMP_Fighter_Module_Config[5] = {
		type = "analog",
		description = "Axis 5 (Other)",
		category = "SBMP Fighter Module",
		val = 0
	}
	SBMP_Fighter_Module_Config[6] = {
		type = "analog",
		description = "Axis 6 (Other)",
		category = "SBMP Fighter Module",
		val = 0
	}
	--non axis (digital) keys
	SBMP_Fighter_Module_Config[7] = {
		type = "digital",
		description = "Digital 1 (Toggle Yaw->Roll)",
		category = "SBMP Fighter Module",
		val = 0
	}
	SBMP_Fighter_Module_Config[8] = {
		type = "digital",
		description = "Digital 2 (Other)",
		category = "SBMP Fighter Module",
		val = 0
	}
	SBMP_Fighter_Module_Config[9] = {
		type = "digital",
		description = "Digital 3 (Other)",
		category = "SBMP Fighter Module",
		val = 0
	}
	SBMP_Fighter_Module_Config[10] = {
		type = "digital",
		description = "Digital 4 (Other)",
		category = "SBMP Fighter Module",
		val = 0
	}
	SBMP_Fighter_Module_Config[11] = {
		type = "digital",
		description = "Digital 5 (Other)",
		category = "SBMP Fighter Module",
		val = 0
	}
	SBMP_Fighter_Module_Config[12] = {
		type = "digital",
		description = "Digital 6 (Other)",
		category = "SBMP Fighter Module",
		val = 0
	}
	SBMP_Fighter_Module_Config[13] = {
		type = "digital",
		description = "Digital 7 (Other)",
		category = "SBMP Fighter Module",
		val = 0
	}
	SBMP_Fighter_Module_Config[14] = {
		type = "digital",
		description = "Digital 8 (Other)",
		category = "SBMP Fighter Module",
		val = 0
	}
	SBMP_Fighter_Module_Config[15] = {
		type = "digital",
		description = "Digital 9 (Other)",
		category = "SBMP Fighter Module",
		val = 0
	}
	SBMP_Fighter_Module_Config[16] = {
		type = "digital",
		description = "Digital 10 (Other)",
		category = "SBMP Fighter Module",
		val = 0
	}
	
	for k, v in pairs(SBMP_Fighter_Module_Config) do
		--v.uid = string.gsub(v.category .. "_" .. v.description, " ", "")
		v.uid = "SBMPJSEngine" .. k
		
		SBMP_Fighter_Module_Config[k] = jcon.register(v)
	end
end

function ENT.Update()
	for k,v in ipairs(SBMP_Fighter_Module_Config) do
		if type(v) == "table" and v.IsJoystickReg then
			if v:GetType() == "digital" then
				local Val = v:GetValue() and 1 or 0
				
				if v.val ~= Val then
					RunConsoleCommand("~sbmp_update_fighter_data", k, Val)
					
					v.val = Val
				end
			else
				local Val = v:GetValue() or 0
				
				if v.val ~= Val then
					RunConsoleCommand("~sbmp_update_fighter_data", k, Val)
					
					v.val = Val
				end
			end
		end
	end
end

timer.Create("SBMP_JS_Timer", .1, 0, ENT.Update)

hook.Add("JoystickInitialize", "cl_sbmp_fighter_engine_joystick_sent_init", ENT.LoadJoystick)
