
--[[
	Planetfall Usermessage Extensions Module
	by Olivier 'LuaPineapple' Hamel
--]]

local DEV_MODE = true
local SPAM = false
local InternalVersion = 1.84

if USERMESSAGE_EXTENSIONS then
	if USERMESSAGE_EXTENSIONS > InternalVersion then
		return Msg("A more recent instance of the Planetfall Usermessage Extensions Module has been detected, aborting initialization.\n")
	elseif USERMESSAGE_EXTENSIONS < InternalVersion then
		if SERVER then
			if umsg.EngineChar then
				umsg.Char       = umsg.EngineChar
			end
			
			if umsg.EnginePoolString then
				umsg.PoolString = umsg.EnginePoolString
			end
		end
		
		Msg("A less recent instance of the Planetfall Usermessage Extensions Module has been detected, overriding instance.\n")
	elseif DEV_MODE then
		if SERVER then
			if umsg.EngineChar then
				umsg.Char       = umsg.EngineChar
			end
			
			if umsg.EnginePoolString then
				umsg.PoolString = umsg.EnginePoolString
			end
		end
		
		Msg("The same instance of the Planetfall Usermessage Extensions Module has been detected, overriding instance.\n")
	else
		return Msg("The same instance of the Planetfall Usermessage Extensions Module has been detected, aborting initialization.\n")
	end
else
	if SERVER then
		if umsg.EngineChar then
			umsg.Char       = umsg.EngineChar
		end
		
		if umsg.EnginePoolString then
			umsg.PoolString = umsg.EnginePoolString
		end
	end
	
	Msg("No instance of the Planetfall Usermessage Extensions Module has been detected, initializing.\n")
end

if SERVER then
	AddCSLuaFile("sh_usermessage_extension.lua")
end

_G["USERMESSAGE_EXTENSIONS"] = InternalVersion -- Explicit to reinforce the point

local MainPrint = print

local function print(...)
	if SPAM then
		return MainPrint(unpack(arg))
	end
end

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

if SERVER then
	umsg.PooledStringsRecord = umsg.PooledStringsRecord or {}
end

local CHAR_OFFSET  = 128   -- max is 255 if shifted
local SHORT_OFFSET = 32768 -- max is 65535 if shifted

local TypeInvalid = -1

local TypeAngle   = 1
local TypeBoolean = 2
local TypeColour  = 3 -- Table subset
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
	--[[
	umsg.EnginePoolString = umsg.PoolString
	umsg.EngineChar       = umsg.Char
	
	function umsg.PoolString(val)
		if umsg.PooledStringsRecord[val] then return end
		if type(val) ~= "string" then return Error("Attempted to pool a non string value: '", val, "'; Type: ", type(val), "\n") end
		
		umsg.PooledStringsRecord[val] = val
		Msg("Pooled string '", val, "'.\n")
		
		return umsg.EnginePoolString(val)
	end
	
	function umsg.Char(val)
		print(val)
		
		return umsg.EngineChar(val)
	end
	--]]
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
		print("----")
		print("sending number: ", number)
		
		if false then
			umsg.Char(TypeNumber_Long)
			return umsg.Long(number)
		end
		
		if type(number) ~= "number" then
			debug.Trace()
			ErrorNoHalt("Got a non number: ", number, "; Type: ", type(number))
			umsg.Char(TypeNumber_Char)
			return umsg.Char(0)
		end
		
		if number == 0 then
			print("sent it as a char because it's zero")
			umsg.Char(TypeNumber_Char)
		elseif number < 0 then
			if number >= -128 then -- Char
				print("sent it as a char (neg)")
				umsg.Char(TypeNumber_Char)
				return umsg.Short(number)
			elseif number >= -255 then -- CharAbsNeg
				print("sent it as a char abs neg")
				umsg.Char(TypeNumber_CharAbsNeg)
				return umsg.CharAbsNeg(number)
			elseif number >= -32768 then -- Short
				print("sent it as a short(neg)")
				umsg.Char(TypeNumber_Short)
				return umsg.Short(number)
			elseif number >= -65535 then -- ShortAbsNeg
				print("sent it as a short abs neg")
				umsg.Char(TypeNumber_ShortAbsNeg)
				return umsg.ShortAbsNeg(number)
			end
		elseif number <= 127 then -- Char
			print("sent it as a char")
			umsg.Char(TypeNumber_Char)
			return umsg.Char(number)
		elseif number <= 255 then -- CharAbs
			print("sent it as a char abs")
			umsg.Char(TypeNumber_CharAbs)
			return umsg.CharAbs(number)
		elseif number <= 32767 then -- Short
			print("sent it as a short")
			umsg.Char(TypeNumber_Short)
			return umsg.Short(number)
		elseif number <= 65535 then -- ShortAbs
			print("sent it as a short abs")
			umsg.Char(TypeNumber_ShortAbs)
			return umsg.ShortAbs(number)
		else -- Long
			print("sent it as a long (default)")
			umsg.Char(TypeNumber_Long)
			return umsg.Long(number)
		end
	end
	
	function umsg.Generic(data, use_string_pooling) -- Don't use this if possible, figure out your own umsg.
		local data_type = type(data)
		print("---")
		print("sending generic: ", data)
		
		if data_type == "Angle" then
			umsg.Char(TypeAngle)
			print("Type is angle")
			return umsg.Angle(data)
		elseif data_type == "boolean" then
			umsg.Char(TypeBoolean)
			print("Type is boolean")
			return umsg.Bool(data)
		elseif data_type == "nil" then
			print("Type is nill")
			return umsg.Char(TypeNil) -- To tell the client NOT to read
		elseif data_type == "number" then
			print("Type is number")
			return umsg.Number(data)
		elseif data_type == "string" then
			print("Type is string")
			umsg.Char(TypeString)
			
			if use_string_pooling then
				print("sending pooled")
				umsg.PoolString(data)
			else
				print("sending normal")
			end
			
			return umsg.String(data)
		elseif data_type == "table" then
			print("Type is table")
			if (table.Count(data) == 4) and data.r and data.g and data.b and data.a then -- It's a colour!
				umsg.Char(TypeColour)
				print("it's a colour")
				return umsg.Colour(data)
			end
			
			umsg.Char(TypeTable)
			print("generic table")
			for k, v in pairs(data) do
				print("sending KV: ", k, v)
				umsg.SendTableKV(k, v, use_string_pooling)
			end
			
			return umsg.Char(TypeNil) -- Marks the end of the list
		elseif data_type == "Vector" then
			umsg.Char(TypeVector)
			print("Type is vector")
			return umsg.Vector(data)
		else -- Has to be some sort of userdata value
			if data.EntIndex and data.IsValid and data.GetBonePosition and data.IsPlayer and data.IsWeapon then -- We can be reasonably sure it's an entity :S
				umsg.Char(TypeEntity)
				print("Type is entity, maybe")
				return umsg.Entity(data)
			end
		end
		
		umsg.Char(TypeInvalid)
		
		ErrorNoHalt("Unknown/unhandled data type: '", data_type, "' for object '", data, "'.\n")
		
		return -1
	end
	
	function umsg.SendTableKV(k, v, use_string_pooling)
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
			print("sent key: ", k)
			print("sent val: ", v)
			umsg.Generic(k, use_string_pooling)
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
			print("---\nRead kv")
			local key_value, key_type = self:ReadGeneric()
			print("key: ", key_value, key_type)
			if key_type ~= TypeInvalid then -- if it's not valid then skip this KV pair
				if key_type == nil then return tbl end -- Bail, we're done here
				
				tbl[key_value] = self:ReadGeneric()
				print("value: ", tbl[key_value])
			end
			if SPAM then PrintTable(tbl) end
			print("reading next pair")
			return self:ReadNextTableKV(tbl)
		end
		
		function bf_read:ReadGeneric() -- Returns value followed by data type enumeration (ReadTableKV needs this)
			print("---")
			print("start read")
			print("self: ", self)
			local data_type = self:ReadChar()
			print("data type enum: ", data_type)
			
			if data_type == TypeInvalid then
				print("read invalid")
				return TypeInvalid, TypeInvalid
			elseif data_type == TypeAngle then
				print("read angle")
				return self:ReadAngle(), data_type
			elseif data_type == TypeBoolean then
				print("read boolean")
				return self:ReadBool(), data_type
			elseif data_type == TypeEntity then
				print("read entity")
				return self:ReadEntity(), data_type
			elseif data_type == TypeNil then
				print("read nil")
				return nil, nil
			elseif data_type == TypeNumber_Char then
				print("read char")
				return self:ReadChar(), data_type
			elseif data_type == TypeNumber_CharAbs then
				print("read char abs")
				return self:ReadCharAbs(), data_type
			elseif data_type == TypeNumber_CharAbsNeg then
				print("read char abs neg")
				return self:ReadCharAbs()  * -1, data_type
			elseif data_type == TypeNumber_Short then
				print("read short")
				return self:ReadShort(), data_type
			elseif data_type == TypeNumber_ShortAbs then
				print("read short abs")
				return self:ReadShortAbs(), data_type
			elseif data_type == TypeNumber_ShortAbsNeg then
				print("read short abs neg")
				return self:ReadShortAbs() * -1, data_type
			elseif data_type == TypeNumber_Long then
				print("read long")
				return self:ReadLong(), data_type
			elseif data_type == TypeString then
				print("read string")
				return self:ReadString(), data_type
			elseif data_type == TypeTable then
				print("read table")
				return self:ReadNextTableKV({}), data_type
			elseif data_type == TypeVector then
				print("read vector")
				return self:ReadVector(), data_type
			elseif data_type == TypeColour then
				return self:ReadColour()
			end
			
			ErrorNoHalt("Got invalid umsg type enum: ", data_type, "\n")
		end
	else
		ErrorNoHalt("Unable to obtain the usermessage userdata metatable!\n*The Planetfall Usermessage Extensions Module will not function!!*\n--|| RISK OF CLIENTS CRASHING IS VERY VERY VERY HIGH, ABORT SERVER SESSION IF POSSIBLE! ||--\n--|| YOU MUST REPORT THIS TO OLIVIER 'LUAPINEAPPLE' HAMEL RIGHT AWAY! ||--\n--|| SKYPE USERNAME: LuaPineapple ||--\n--|| STEAM USERNAME: Evil_Pineapple. ||--\n--|| EMAIL: evil_pineapple.cox.net ||--\n")
	end
end

