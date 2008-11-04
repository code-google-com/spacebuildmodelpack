include('shared.lua')

local ToolTip = ENT.PrintName

function ENT:Draw()
	self.Entity:DrawModel()
	
	if (LocalPlayer():GetEyeTrace().Entity == self.Entity) && (EyePos():Distance(self.Entity:GetPos()) < 512) then
		AddWorldTip(self.Entity:EntIndex(), "All-In-One Fighter Module", 0.5, self.Entity:GetPos(), self.Entity)
	end
end

hook.Add("JoystickInitialize", "joynumpad", function()
	Msg("HOOKED: Wired fighter system ready.\n")
	
	SBMP_Fighter_Module_Config = {}
	--the 6 axis controled keys
	SBMP_Fighter_Module_Config[1] = jcon.register{
		type = "analog",
		description = "Axis 1 (Pitch)",
		category = "SBMP Fighter Module",
		val = 0
	}
	SBMP_Fighter_Module_Config[2] = jcon.register{
		type = "analog",
		description = "Axis 2 (Yaw)",
		category = "SBMP Fighter Module",
		val = 0
	}
	SBMP_Fighter_Module_Config[3] = jcon.register{
		type = "analog",
		description = "Axis 3 (Roll)",
		category = "SBMP Fighter Module",
		val = 0
	}
	SBMP_Fighter_Module_Config[4] = jcon.register{
		type = "analog",
		description = "Axis 4 (Thrust)",
		category = "SBMP Fighter Module",
		val = 0
	}
	SBMP_Fighter_Module_Config[5] = jcon.register{
		type = "analog",
		description = "Axis 5 (Other)",
		category = "SBMP Fighter Module",
		val = 0
	}
	SBMP_Fighter_Module_Config[6] = jcon.register{
		type = "analog",
		description = "Axis 6 (Other)",
		category = "SBMP Fighter Module",
		val = 0
	}
	--non axis (digital) keys
	SBMP_Fighter_Module_Config[7] = jcon.register{
		type = "digital",
		description = "Digital 1 (Toggle Yaw->Roll)",
		category = "SBMP Fighter Module",
		val = 0
	}
	SBMP_Fighter_Module_Config[8] = jcon.register{
		type = "digital",
		description = "Digital 2 (Other)",
		category = "SBMP Fighter Module",
		val = 0
	}
	SBMP_Fighter_Module_Config[9] = jcon.register{
		type = "digital",
		description = "Digital 3 (Other)",
		category = "SBMP Fighter Module",
		val = 0
	}
	SBMP_Fighter_Module_Config[10] = jcon.register{
		type = "digital",
		description = "Digital 4 (Other)",
		category = "SBMP Fighter Module",
		val = 0
	}
	SBMP_Fighter_Module_Config[11] = jcon.register{
		type = "digital",
		description = "Digital 5 (Other)",
		category = "SBMP Fighter Module",
		val = 0
	}
	SBMP_Fighter_Module_Config[12] = jcon.register{
		type = "digital",
		description = "Digital 6 (Other)",
		category = "SBMP Fighter Module",
		val = 0
	}
	SBMP_Fighter_Module_Config[13] = jcon.register{
		type = "digital",
		description = "Digital 7 (Other)",
		category = "SBMP Fighter Module",
		val = 0
	}
	SBMP_Fighter_Module_Config[14] = jcon.register{
		type = "digital",
		description = "Digital 8 (Other)",
		category = "SBMP Fighter Module",
		val = 0
	}
	SBMP_Fighter_Module_Config[15] = jcon.register{
		type = "digital",
		description = "Digital 9 (Other)",
		category = "SBMP Fighter Module",
		val = 0
	}
	SBMP_Fighter_Module_Config[16] = jcon.register{
		type = "digital",
		description = "Digital 10 (Other)",
		category = "SBMP Fighter Module",
		val = 0
	}

	function UpdateJS_SBMP()
		for k,v in ipairs(SBMP_Fighter_Module_Config) do
			if type(v) == "table" and v.IsJoystickReg then
				if v:GetType() == "digital" then
					local Val = v:GetValue()
					
					if Val then
						Val = 1
					else
						Val = 0
					end
					
					if v.val ~= Val then
						RunConsoleCommand("sbmp_update_fighter_data", k, Val)
					end
					
					v.val = Val
				else
					local Val = v:GetValue() or 0
					
					if v.val ~= Val then
						RunConsoleCommand("sbmp_update_fighter_data", k, Val)
					end
					
					v.val = Val
				end
			end
		end
	end
	
	timer.Create("SBMP_JS_Timer",.1,0,UpdateJS_SBMP)
end)
