--[[
	Planetfall Usermessage Extensions Module
	by Olivier 'LuaPineapple' Hamel
--]]

local DEV_MODE = true
local InternalVersion = 1.65

if USERMESSAGE_EXTENSIONS then
	if USERMESSAGE_EXTENSIONS > InternalVersion then
		return Msg("A more recent instance of the Planetfall Usermessage Extensions Module has been detected, aborting initialization.\n")
	elseif USERMESSAGE_EXTENSIONS < InternalVersion then
		Msg("A less recent instance of the Planetfall Usermessage Extensions Module has been detected, overriding instance.\n")
	elseif DEV_MODE then
		Msg("The same instance of the Planetfall Usermessage Extensions Module has been detected, overriding instance.\n")
	else
		return Msg("The same instance of the Planetfall Usermessage Extensions Module has been detected, aborting initialization.\n")
	end
else
	Msg("No instance of the Planetfall Usermessage Extensions Module has been detected, initializing.\n")
end

_G["USERMESSAGE_EXTENSIONS"] = InternalVersion -- Explicit to reinforce the point

--[[
	You can pass as paramiters the following types using Generic:
	Angle
	Boolean
	Colour
	Entity -- Not my job to make sure it's valid though!
	Nil    -- Will not send any parameter data, just call the function on the client
	Number -- Floating point numbers are currently unsupported due to the fact that no one seems to be able to give me a clear range and I'm not sure the IEEE standard is appliable in this case
	String -- You can opt for pooling by adding true as a third parameter
	Table  -- Note that tables in tables is not supported, you can use this type to send a bunch of data at once
	Vector
--]]

local CHAR_OFFSET  = 128   -- max is 255 if shifted
local SHORT_OFFSET = 32768 -- max is 65535 if shifted

local TypeInvalid = -1

local TypeAngle   = 1
local TypeBoolean = 2
local Colour      = 3 -- Table subset
local TypeEntity  = 4 -- :S
local TypeNil     = 5 -- Bah
local TypeNumber_Char        = 6 -- Let's do some more serverside processing to minimize network transmissions
local TypeNumber_CharAbs     = 7
local TypeNumber_CharAbsNeg  = 8
local TypeNumber_Short       = 9
local TypeNumber_ShortAbs    = 10
local TypeNumber_ShortAbsNeg = 11
local TypeNumber_Long        = 12
local TypeString  = 13
local TypeTable   = 14
local TypeVector  = 15

local ColWhiteFull = Color(255, 255, 255, 255)

if SERVER then
	function umsg.CharAbs(val) -- Range: 0 - 255
		val = val or 0
		
		return umsg.Char(math.Clamp(val, 0, 255) - CHAR_OFFSET)
	end
	
	function umsg.ShortAbs(val) -- Range: 0 - 65535
		val = val or 0
		
		return umsg.Short(math.Clamp(val, 0, 65535) - SHORT_OFFSET)
	end
	
	function umsg.Colour(colour)
		colour = colour or ColWhiteFull
		
		self:CharAbs(colour.r)
		self:CharAbs(colour.g)
		self:CharAbs(colour.b)
		self:CharAbs(colour.a)
	end
	
	function umsg.Number(number)
		if type(number) ~= "number" then
			umsg.Char(TypeNumber_Char)
			return umsg.Char(0)
		end
		
		if number == 0 then
			umsg.Char(TypeNumber_Char)
		elseif number > 0 then
			if number >= -128 then -- Char
				umsg.Char(TypeNumber_Char)
			elseif number >= -255 then -- CharAbs
				umsg.Char(TypeNumber_CharAbsNeg)
			elseif number >= -32768 then -- Short
				umsg.Char(TypeNumber_Short)
			elseif number >= -65535 then -- ShortAbs
				umsg.Char(TypeNumber_ShortAbsNeg)
			end
		elseif number <= 127 then -- Char
			umsg.Char(TypeNumber_Char)
		elseif number <= 255 then -- CharAbs
			umsg.Char(TypeNumber_CharAbs)
		elseif number <= 32767 then -- Short
			umsg.Char(TypeNumber_Short)
		elseif number <= 65535 then -- ShortAbs
			umsg.Char(TypeNumber_ShortAbs)
		else -- Long
			umsg.Char(TypeNumber_Long)
		end
		
		umsg.Char(number)
	end
	
	function umsg.Generic(data, use_string_pooling) -- Don't use this if possible, figure out your own umsg.
		local data_type = type(data)
		
		if data_type == "Angle" then
			umsg.Char(TypeAngle)
			
			return umsg.Angle(data)
		elseif data_type == "boolean" then
			umsg.Char(TypeBoolean)
			
			return umsg.Bool(data)
		elseif data_type == "nil" then
			return umsg.Char(TypeNil) -- To tell the client NOT to read
		elseif data_type == "number" then
			return umsg.Number(number)
		elseif data_type == "string" then
			umsg.Char(TypeString)
			
			if use_string_pooling then
				return umsg.PoolString(data)
			else
				return umsg.String(data)
			end
		elseif data_type == "table" then
			if (table.Count(data) == 4) and data.r and data.g and data.b and data.a then -- It's a colour!
				return umsg.Colour(data)
			end
			
			umsg.Char(TypeTable)
			
			for k, v in pairs(data) do
				umsg_send_kv(k, v, use_string_pooling)
			end
			
			return umsg.Char(TypeNil) -- Marks the end of the list
		elseif data_type == "Vector" then
			umsg.Char(TypeVector)
			
			return umsg.Vector(data)
		else -- Has to be some sort of userdata value
			if data.EntIndex and data.IsValid and data.GetBonePosition and data.IsPlayer and data.IsWeapon then -- We can be reasonably sure it's an entity :S
				umsg.Char(TypeEntity)
				
				return umsg.Entity(data)
			end
		end
		
		umsg.Char(TypeInvalid)
		
		ErrorNoHalt("Unknown/unhandled data type: '", data_type, "' for object '", data, "'.\n")
		
		return -1
	end
	
	local function umsg_send_kv(k, v, use_string_pooling)
		local data_type_k = type(k)
		local data_type_v = type(v)
		
		-- Sorry if this looks ugly, but errors with usermessages are not acceptable
		
		if ((data_type_k == "Angle")   or
		    (data_type_k == "boolean") or
		    (data_type_k == "number")  or
		    (data_type_k == "string")  or
		    (data_type_k == "Vector")  or
		    (k.EntIndex and k.IsValid and k.GetBonePosition and k.IsPlayer and k.IsWeapon)) and
		   ((data_type_v == "Angle")   or
		    (data_type_v == "boolean") or
		    (data_type_v == "number")  or
		    (data_type_v == "string")  or
		    (data_type_v == "Vector")  or
		    (k.EntIndex and k.IsValid and k.GetBonePosition and k.IsPlayer and k.IsWeapon)) then
			return umsg.Generic(v, use_string_pooling)
		end
		
		umsg.Char(TypeInvalid)
	end
	
else
	
	local bf_read = FindMetaTable("bf_read")
	
	if bf_read then
		function bf_read:ReadCharAbs()
			return math.Clamp((self:ReadChar() + CHAR_OFFSET), 0, 255)
		end
		
		function bf_read:ReadShortAbs()
			return math.Clamp((self:ReadShort() + SHORT_OFFSET), 0, 65535)
		end
		
		function bf_read:ReadColour()
			return Color(self:ReadCharAbs(), self:ReadCharAbs(), self:ReadCharAbs(), self:ReadCharAbs())
		end
		
		function bf_read:ReadNextTableKV(tbl) -- Theoretically if I could serialize all tables correctly and filter them I could even read cyclic tables
			tbl = tbl
			
			local key_value, key_type = self:ReadGeneric()
			
			if key_type ~= TypeInvalid then -- if it's not valid then skip this KV pair
				if key_type == nil then return tbl end -- Bail, we're done here
				
				tbl[key_value] = self:ReadGeneric()
			end
			
			return self:ReadNextTableKV(tbl)
		end
		
		function bf_read:ReadGeneric() -- Returns value followed by data type enumeration (ReadTableKV needs this)
			local data_type = self:ReadChar()
			
			if data_type == TypeInvalid then
				return TypeInvalid, TypeInvalid
			elseif data_type == TypeAngle then
				return bf_read:ReadAngle(), data_type
			elseif data_type == TypeBoolean then
				return bf_read:ReadBool(), data_type
			elseif data_type == TypeEntity then
				return bf_read:ReadEntity(), data_type
			elseif data_type == TypeNil then
				return nil, nil
			elseif data_type == TypeNumber_Char then
				return bf_read:ReadChar(), data_type
			elseif data_type == TypeNumber_CharAbs then
				return bf_read:ReadCharAbs(), data_type
			elseif data_type == TypeNumber_CharAbsNeg then
				return bf_read:ReadCharAbs()  * -1, data_type
			elseif data_type == TypeNumber_Short then
				return bf_read:ReadShort(), data_type
			elseif data_type == TypeNumber_ShortAbs then
				return bf_read:ReadShortAbs(), data_type
			elseif data_type == TypeNumber_ShortAbsNeg then
				return bf_read:ReadShortAbs() * -1, data_type
			elseif data_type == TypeNumber_Long then
				return bf_read:ReadLong(), data_type
			elseif data_type == TypeString then
				return bf_read:ReadString(), data_type
			elseif data_type == TypeTable then
				return bf_read:ReadNextTableKV(), data_type
			end
		end
	else
		ErrorNoHalt("Unable to obtain the usermessage userdata metatable!\n*The Planetfall Usermessage Extensions Module will not function!!*\n--|| RISK OF CLIENTS CRASHING IS VERY VERY VERY HIGH, ABORT SERVER SESSION IF POSSIBLE! ||--\n--|| YOU MUST REPORT THIS TO OLIVIER 'LUAPINEAPPLE' HAMEL RIGHT AWAY! ||--\n--|| SKYPE USERNAME: LuaPineapple ||--\n--|| STEAM USERNAME: Evil_Pineapple. ||--\n--|| EMAIL: evil_pineapple.cox.net ||--\n")
	end
end

