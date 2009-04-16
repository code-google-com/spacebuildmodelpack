SBEP = SBEP or {}

function SBEP.JoystickReorder(category,order)
	--if SERVER then return end
	local oldCatTab = jcon.reg.cat[category]
	--print("Old Order:")
	--PrintTable(oldCatTab)
	local newCatTab = {}
	--print("New Order:")
	--PrintTable(order)
	if #oldCatTab != #order then
		ErrorNoHalt("New order hasn't got the same number of entries as old order")
		return
	end
	for order,description in ipairs(order) do
		for _,data in ipairs(oldCatTab) do
			if data.description == description then
				newCatTab[order] = data
			end
		end
		--PrintTable(newCatTab)
	end
	jcon.reg.cat[category] = newCatTab
	--print("========Joystick Reordered=========")
end

local function JoyReorder()
	SBEP.JoystickReorder("Fighters",{"Pitch","Yaw","Roll","Thrust","Accelerate/Decelerate",
					"Strafe Up","Strafe Down","Strafe Right","Strafe Left","Fire 1","Fire 2",
					"Launch","Yaw/Roll Switch"})
	SBEP.JoystickReorder("Gyro-Pod",{"Pitch","Yaw","Roll","Thrust","Accelerate/Decelerate",
					"Strafe Up","Strafe Down","Strafe Right","Strafe Left","Launch",
					"Yaw/Roll Switch"})
	SBEP.JoystickReorder("Rover",{"Turning","Accelerate/Decelerate","Strafe","Strafe Left",
					"Strafe Right","Jump","Fire 1","Fire 2"})
	SBEP.JoystickReorder("Boarding Pod",{"Pitch","Yaw","Roll","Yaw/Roll Switch","Launch"})
end

local function JoyReorderHook()
	timer.Simple(5,JoyReorder)
end

if CLIENT then
	hook.Add("JoystickInitialize","JoystickReorder",JoyReorderHook)
end
concommand.Add("SBEP_ReorderJoystick",JoyReorder)