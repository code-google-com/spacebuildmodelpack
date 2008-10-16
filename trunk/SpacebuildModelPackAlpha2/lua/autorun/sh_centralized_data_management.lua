--[[
	Planetfall Data Record System
	by Olivier 'LuaPineapple' Hamel
	
	Todo:
	Add networking for tables (multilevel?)
	Add fast transmit network option (using usermessages)
--]]

local DEV_MODE = true
local InternalVersion = 1.2

if PLANETFALL_DATA_SYSTEM then
	if PLANETFALL_DATA_SYSTEM > InternalVersion then
		return Msg("A more recent instance of the Planetfall Data Record System has been detected, aborting initialization.\n")
	elseif PLANETFALL_DATA_SYSTEM < InternalVersion then
		Msg("A less recent instance of the Planetfall Data Record System has been detected, overriding instance.\n")
	elseif DEV_MODE then
		return Msg("The same instance of the Planetfall Data Record System has been detected, overriding instance.\n")
	else
		return Msg("The same instance of the Planetfall Data Record System has been detected, aborting initialization.\n")
	end
else
	Msg("No instance of the Planetfall Data Record System has been detected, initializing.\n")
end

_G["PLANETFALL_DATA_SYSTEM"] = InternalVersion -- Explicit to reinforce the point

if SERVER then AddCSLuaFile("sh_centralized_data_management.lua") end

NW_VAR_TYPE_ANGLE   = 1
NW_VAR_TYPE_BOOLEAN = 2
NW_VAR_TYPE_ENTITY  = 3
NW_VAR_TYPE_NUMBER  = 4
NW_VAR_TYPE_STRING  = 5
NW_VAR_TYPE_VECTOR  = 6

NW_VAR_TYPE_TABLE   = 7

local entity_meta = FindMetaTable("Entity")

if entity_meta then
	-- ALTHOUGH YOU CAN SEND TABLES IT IS VERY EXPENSIVE TO DO SO! USE IT WISELY!!!
	
	-- The Laws Of Table-Sending And General Networking With The Planetfall Data Record System:
	--[[
		1. Thou shall not use non-string or non-number indexes.
		2. Thou shall not have the character '_' in thy string indexes.
		3. Thou shall not attempt to send something other then one of these types:
			a. Angle
			b. Boolean
			c. Entity
			d. Number
			e. String
			f. Vector
		4. Thou shalt not bitch that this is slow.
		5. Thou shalt take note that thy Lord is doing this in French class and thy Lord's teacher is late. Hold on, I'll go look for him; He's not here.
		6. Thou shalt be aware that namespace collisions mayhaps occur while using tables if thou has not followed thy Lord's instructions.
		7. Thou shalt note that thy Loard does not give a flying shit if thou encounters problems with this if thou has not follow thy Lord's command and report an actual error message!
	--]]
	
	-- NOTE: There will be a clientside cache system so you don't need to constantly rebuild the table, I will add a similar cache system serverside that only updates relevant nodes. Maybe; it's implamentation will not be trivial.
	
	function entity_meta:SetDataField(record, key, value, NETWORK_VAR_TYPE, INTERNAL_TBL_LEVEL)
		if CLIENT and NETWORK_VAR_TYPE then return Error("Client cannot set managed networked data!\n") end
		
		self.CentralizedDataRecord = self.CentralizedDataRecord or {}
		self.CentralizedDataRecord[record] = self.CentralizedDataRecord[record] or {}
		
		self.CentralizedDataRecord[record][key] = value
		
		if NW_VAR_TYPE_ANGLE == NETWORK_VAR_TYPE then
			key = "NW_PF_DATA_ANGLE_"   .. record .. "_" .. key
			
			self.CentralizedDataRecord[key] = value
			return self:SetNetworkedAngle(key, value)
		elseif NW_VAR_TYPE_BOOLEAN == NETWORK_VAR_TYPE then
			key = "NW_PF_DATA_BOOLEAN_"   .. record .. "_" .. key
			
			self.CentralizedDataRecord[key] = value
			return self:SetNetworkedBool(key, value)
		elseif NW_VAR_TYPE_ENTITY == NETWORK_VAR_TYPE then
			key = "NW_PF_DATA_ENTITY_"   .. record .. "_" .. key
			
			self.CentralizedDataRecord[key] = value
			return self:SetNetworkedEntity(key, value)
		elseif NW_VAR_TYPE_NUMBER == NETWORK_VAR_TYPE then -- Might want to add some discriminator paramiter so we can have both NWInt and NWFloat
			key = "NW_PF_DATA_NUMBER_"   .. record .. "_" .. key
			
			self.CentralizedDataRecord[key] = value
			return self:SetNetworkedNumber(key, value)
		elseif NW_VAR_TYPE_STRING == NETWORK_VAR_TYPE then
			key = "NW_PF_DATA_String_"   .. record .. "_" .. key
			
			self.CentralizedDataRecord[key] = value
			return self:SetNetworkedString(key, value)
		elseif NW_VAR_TYPE_VECTOR == NETWORK_VAR_TYPE then
			key = "NW_PF_DATA_VECTOR_"   .. record .. "_" .. key
			
			self.CentralizedDataRecord[key] = value
			return self:SetNetworkedVector(key, value)
		elseif NW_VAR_TYPE_TABLE ==   NETWORK_VAR_TYPE then -- CURRENTLY DISABLED AND NON WORKING, WON'T BE FIXED UNTIL I (OR SOMEONE ELSE) HAVE A REAL NEED FOR THIS!
			return Error("Networking tables is currently incomplete and cannot be used.\n")
		end
	end
	
	function entity_meta:GetDataField(record, key, NETWORK_VAR_TYPE, INTERNAL_TBL_LEVEL)
		self.CentralizedDataRecord = self.CentralizedDataRecord or {}
		self.CentralizedDataRecord[record] = self.CentralizedDataRecord[record] or {}
		
		-- Only do this crap on the client since we already have it cached on the server
		if NETWORK_VAR_TYPE and CLIENT then
			if NW_VAR_TYPE_ANGLE == NETWORK_VAR_TYPE then
				return self:GetNetworkedAngle("NW_PF_DATA_ANGLE_"    .. record .. "_" .. key, value)
			elseif NW_VAR_TYPE_BOOLEAN == NETWORK_VAR_TYPE then
				return self:GetNetworkedBool(  "NW_PF_DATA_BOOLEAN_" .. record .. "_" .. key, value)
			elseif NW_VAR_TYPE_ENTITY ==  NETWORK_VAR_TYPE then
				return self:GetNetworkedEntity("NW_PF_DATA_ENTITY_"  .. record .. "_" .. key, value)
			elseif NW_VAR_TYPE_NUMBER ==  NETWORK_VAR_TYPE then -- FIX THIS, CURRENTLY THERE IS NO GETNETWORKEDNUMBER!
				return self:GetNetworkedFloat("NW_PF_DATA_NUMBER_"   .. record .. "_" .. key, value)
			elseif NW_VAR_TYPE_STRING ==  NETWORK_VAR_TYPE then
				return self:GetNetworkedString("NW_PF_DATA_String_"  .. record .. "_" .. key, value)
			elseif NW_VAR_TYPE_VECTOR ==  NETWORK_VAR_TYPE then
				return self:GetNetworkedVector("NW_PF_DATA_VECTOR_"  .. record .. "_" .. key, value)
			elseif NW_VAR_TYPE_TABLE ==   NETWORK_VAR_TYPE then -- CURRENTLY DISABLED AND NON WORKING, WON'T BE FIXED UNTIL I (OR SOMEONE ELSE) HAVE A REAL NEED FOR THIS!
				return Error("Networking tables is currently incomplete and cannot be used.\n")
			end
		else -- Not networked
			return self.CentralizedDataRecord[record][key]
		end
	end
else
	ErrorNoHalt("Unable to obtain the entity userdata metatable!\n*The Planetfall Data Record System will not function!*\n--|| YOU MUST REPORT THIS TO OLIVIER 'LUAPINEAPPLE' HAMEL RIGHT AWAY! ||--\n--|| SKYPE USERNAME: LuaPineapple ||--\n--|| STEAM USERNAME: Evil_Pineapple. ||--\n--|| EMAIL: evil_pineapple.cox.net ||--\n")
end
