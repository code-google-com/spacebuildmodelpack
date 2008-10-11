// Joystick interface module
// Version 1.0
// Written by Night-Eagle

/*

I HIGHLY SUGGEST YOU USE THE JOYSTICK CONFIGURATOR AS OPPOSED TO USING
THESE REVERSE-COMPATIBILITY FUNCTIONS.

Functions you SHOULD use, if you decide not to use the joystick
	configurator:
joystick.GetJoystick(n)
joystick.NumJoysticks()

joystick:NumAxes()
joystick:NumButtons()
joystick:NumHats()
joystick:NumPovs()
joystick:GetAxis(n)
joystick:GetButton(n)
joystick:GetHat(n)
joystick:GetPov(n)

Do NOT use any functions not listed here. Those not listed are subject
to change at my discretion.
	If you use joystick.GetJoystick(n) with an n that is not greater
than 0 and less than or equal to joystick.NumJoysticks(), a nil value
will be returned.

*/

HAT_CENTERED	= -1;
HAT_RIGHT		= 0;
HAT_RIGHTUP		= 1;
HAT_UP			= 2;
HAT_LEFTUP		= 3;
HAT_LEFT		= 4;
HAT_LEFTDOWN	= 5;
HAT_DOWN		= 6;
HAT_RIGHTDOWN	= 7;

HAT_C	= -1;
HAT_0	= 0;
HAT_1	= 1;
HAT_2	= 2;
HAT_3	= 3;
HAT_4	= 4;
HAT_5	= 5;
HAT_6	= 6;
HAT_7	= 7;
HAT_8	= 0;

require("joystick")

if type(joystick) ~= "table" then
	return
end
joystick.version = 1.0
if not joystick.binaryversion then
	joystick.binaryversion = 1.0
end

joystick.load = function()
	joystick.fresh = {}
	for i=0,joystick.count()-1 do
		joystick.fresh[i] = CurTime()
	end
	
	joystick.NumJoysticks = function()
		return joystick.count()
	end
	
	joystick.poll = function(joy)
		joystick.refresh(joy)
		joystick.fresh[joy] = CurTime()
	end
	
	joystick.GetJoystick = function(n)
		n = math.Round(n)-1
		if n >= 0 and n <= joystick.count()-1 then
			local j = {enum = n}
			for k,v in pairs(joystick.meta) do
				j[k] = v
			end
			
			return j
		end
	end
	
	joystick.meta = {
		NumAxes = function(self)
			return joystick.count(self.enum,1)
		end,
		NumButtons = function(self)
			return joystick.count(self.enum,2)
		end,
		NumHats = function(self)
			return joystick.count(self.enum,3)
		end,
		GetButton = function(self,n)
			if CurTime() > joystick.fresh[self.enum] + 0.001 then
				joystick.poll(self.enum)
			end
			
			return joystick.button(self.enum,n-1) > 0
		end,
		GetAxis = function(self,n)
			if CurTime() > joystick.fresh[self.enum] + 0.001 then
				joystick.poll(self.enum)
			end
			
			return joystick.axis(self.enum,n-1)/256-127
		end,
		GetHat = function(self,n)
			if CurTime() > joystick.fresh[self.enum] + 0.001 then
				joystick.poll(self.enum)
			end
			
			local pov = joystick.pov(self.enum,n-1)
			if pov > 100000 then
				return -1
			else
				pov = 2-math.Round(pov)/4500
				if pov < 0 then
					pov = pov + 8
				end
				
				return pov
			end
		end,
		GetName = function(self)
			return joystick.name(self.enum)
		end,
	}
	joystick.meta.NumPovs = joystick.meta.NumHats
	joystick.meta.GetPov = joystick.meta.GetHat
	
	Msg("Night-Eagle's joystick module loaded.\nScript version ",joystick.version,".\nBinary version ",joystick.binaryversion,".\n")
end

joystick.load()
include("joyconfig.lua")
