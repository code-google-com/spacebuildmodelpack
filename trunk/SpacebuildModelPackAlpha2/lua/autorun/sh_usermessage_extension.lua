--[[
	Planetfall Usermessage Extensions Module
	by Olivier 'LuaPineapple' Hamel
--]]

local InternalVersion = 1.0

if USERMESSAGE_EXTENSIONS then
	if USERMESSAGE_EXTENSIONS > InternalVersion then
		return Msg("A more recent instance of the Planetfall Usermessage Extensions Module has been detected, aborting initialization.\n")
	elseif USERMESSAGE_EXTENSIONS < InternalVersion then
		Msg("A less recent instance of the Planetfall Usermessage Extensions Module has been detected, overriding instance.\n")
	else
		return Msg("The same instance of the Planetfall Usermessage Extensions Module has been detected, aborting initialization.\n")
	end
else
	Msg("No instance of the Planetfall Usermessage Extensions Module has been detected, initializing.\n")
end

_G["USERMESSAGE_EXTENSIONS"] = InternalVersion -- Explicit to reinforce the point

local CHAR_OFFSET  = 128   -- max is 255 if shifted
local SHORT_OFFSET = 32768 -- max is 65535 if shifted

if SERVER then
	function umsg.CharAbs(val)
		return umsg.Char(math.Clamp(val, 0, 255) - CHAR_OFFSET)
	end
	
	function umsg.DoubleCharAbs(val)
		umsg.CharAbs(val)
		umsg.CharAbs(val - 255) -- Minus 255 to account for the data we already sent
	end
	
	function umsg.ShortAbs(val)
		return umsg.Short(math.Clamp(val, 0, 65535) - SHORT_OFFSET)
	end
	
	function umsg.DoubleShortAbs(val)
		umsg.ShortAbs(val)
		umsg.ShortAbs(val - 65535) -- Minus 65535 to account for the data we already sent
	end
	
	function umsg.Colour(colour)
		if not colour then 
		self:CharAbs(colour.r)
		self:CharAbs(colour.g)
		self:CharAbs(colour.b)
		self:CharAbs(colour.a)
	end
else
	local bf_read = FindMetaTable("bf_read")
	
	if bf_read then
		function bf_read:ReadCharAbs()
			return math.Clamp((self:ReadChar() + CHAR_OFFSET), 0, 255)
		end
		
		function bf_read:ReadDoubleCharAbs()
			return (self:ReadCharAbs() + self:ReadCharAbs())
		end
		
		function bf_read:ReadShortAbs()
			return math.Clamp((self:ReadShort() + SHORT_OFFSET), 0, 65535)
		end
		
		function bf_read:ReadDoubleShortAbs()
			return (self:ReadShortAbs() + self:ReadShortAbs())
		end
		
		function bf_read:ReadColour()
			return Color(self:ReadCharAbs(), self:ReadCharAbs(), self:ReadCharAbs(), self:ReadCharAbs())
		end
	else
		ErrorNoHalt("Unable to obtain the usermessage userdata metatable!\n*The Planetfall Usermessage Extensions Module will not function!!*\n--|| RISK OF CLIENTS CRASHING IS VERY VERY VERY HIGH, ABORT SERVER SESSION IF POSSIBLE! ||--\n--|| YOU MUST REPORT THIS TO OLIVIER 'LUAPINEAPPLE' HAMEL RIGHT AWAY! ||--\n--|| SKYPE USERNAME: LuaPineapple ||--\n--|| STEAM USERNAME: Evil_Pineapple. ||--\n--|| EMAIL: evil_pineapple.cox.net ||--\n")
	end
end