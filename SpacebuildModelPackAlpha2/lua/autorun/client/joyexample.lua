local ply
local NumPadJoyConfig = {}
timer.Simple(5,function ()
		--the 4 axis controled keys
		NumPadJoyConfig.eight = jcon.register{
			type = "digital",
			description = "8",
			category = "NumPad",
			on = false,
			val = 8,
		}

		NumPadJoyConfig.two = jcon.register{
			type = "digital",
			description = "2",
			category = "NumPad",
			on = false,
			val = 2,
		}

		NumPadJoyConfig.six = jcon.register{
			type = "digital",
			description = "6",
			category = "NumPad",
			on = false,
			val = 6,
		}
		NumPadJoyConfig.four = jcon.register{
			type = "digital",
			description = "4",
			category = "NumPad",
			on = false,
			val = 4,
		}
		--non axis (digital) keys
		NumPadJoyConfig.plus = jcon.register{
			type = "digital",
			description = "+",
			category = "NumPad",
			on = false,
			val = 12,
		}

		NumPadJoyConfig.enter = jcon.register{
			type = "digital",
			description = "enter",
			category = "NumPad",
			on = false,
			val = 11,
		}

		NumPadJoyConfig.zero	 = jcon.register{
			type = "digital",
			description = "0",
			category = "NumPad",
			on = false,
			val = 0,
		}

		NumPadJoyConfig.dot = jcon.register{
			type = "digital",
			description = ".",
			category = "NumPad",
			on = false,
			val = 10,
		}

		NumPadJoyConfig.minus = jcon.register{
			type = "digital",
			description = "-",
			category = "NumPad",
			on = false,	
			val = 13,
		}

		NumPadJoyConfig.seven = jcon.register{
			type = "digital",
			description = "7",
			category = "NumPad",
			on = false,	
			val = 7,
		}

		NumPadJoyConfig.nine = jcon.register{
			type = "digital",
			description = "9",
			category = "NumPad",
			on = false,	
			val = 9,
		}

		NumPadJoyConfig.one = jcon.register{
			type = "digital",
			description = "1",
			category = "NumPad",
			on = false,	
			val = 1,
		}

		NumPadJoyConfig.three = jcon.register{
			type = "digital",
			description = "3",
			category = "NumPad",
			on = false,	
			val = 3,
		}

		NumPadJoyConfig.dash = jcon.register{
			type = "digital",
			description = "/",
			category = "NumPad",
			on = false,	
			val = 15,
		}

		NumPadJoyConfig.star = jcon.register{
			type = "digital",
			description = "*",
			category = "NumPad",
			on = false,	
			val = 14,
		}

ply = LocalPlayer() --so we don't have to call the func 3534523 times

function NumPadJoyControl()
	for k,v in pairs(NumPadJoyConfig) do
		if type(v) == "table" and v.IsJoystickReg then
			if v:GetType() == "digital" then
				if v:GetValue() then
					if not v.on then
						Msg("+gm_special ".. v.val .."\n")
						ply:ConCommand("+gm_special ".. v.val .."\n")
						v.on = true
					end
				else
					if v.on then
						ply:ConCommand("-gm_special ".. v.val .."\n")
						v.on = false
					end
				end
			else
				if math.abs(v:GetValue()) > 150 then
					if not v.on then
						ply:ConCommand("+gm_special ".. v.val .."\n")
						v.on = true
					end
				else
					if v.on then
						ply:ConCommand("-gm_special ".. v.val .."\n")
						v.on = false
					end
				end
			end
		end
	end
end
hook.Add("Think","NumPadJoyControl",NumPadJoyControl)
end)
