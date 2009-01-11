CreateClientConVar("SBHP_0", 0, true, true)
CreateClientConVar("SBHP_1", 1, true, true)
CreateClientConVar("SBHP_2", 0, true, true)
CreateClientConVar("SBHP_3", 0, true, true)
CreateClientConVar("SBHP_4", 0, true, true)
CreateClientConVar("SBHP_5", 0, true, true)
CreateClientConVar("SBHP_6", 0, true, true)
CreateClientConVar("SBHP_7", 0, true, true)
CreateClientConVar("SBHP_8", 0, true, true)
CreateClientConVar("SBHP_9", 0, true, true)
CreateClientConVar("SBHP_0a", 0, true, true)
CreateClientConVar("SBHP_1a", 0, true, true)
CreateClientConVar("SBHP_2a", 0, true, true)
CreateClientConVar("SBHP_3a", 0, true, true)
CreateClientConVar("SBHP_4a", 0, true, true)
CreateClientConVar("SBHP_5a", 0, true, true)
CreateClientConVar("SBHP_6a", 0, true, true)
CreateClientConVar("SBHP_7a", 0, true, true)
CreateClientConVar("SBHP_8a", 0, true, true)
CreateClientConVar("SBHP_9a", 0, true, true)

local SBHPjcon = {}	
local SBHPJoystickControl = function()
	SBHPjcon.hp0 = jcon.register{
		uid = "sbhp_0",
		type = "digital",
		description = "Select 0",
		category = "Hardpoint Control",
	}
	SBHPjcon.hp1 = jcon.register{
		uid = "sbhp_1",
		type = "digital",
		description = "Select 1",
		category = "Hardpoint Control",
	}
	SBHPjcon.hp2 = jcon.register{
		uid = "sbhp_2",
		type = "digital",
		description = "Select 2",
		category = "Hardpoint Control",
	}
	SBHPjcon.hp3 = jcon.register{
		uid = "sbhp_3",
		type = "digital",
		description = "Select 3",
		category = "Hardpoint Control",
	}
	SBHPjcon.hp4 = jcon.register{
		uid = "sbhp_4",
		type = "digital",
		description = "Select 4",
		category = "Hardpoint Control",
	}
	SBHPjcon.hp5 = jcon.register{
		uid = "sbhp_5",
		type = "digital",
		description = "Select 5",
		category = "Hardpoint Control",
	}
	SBHPjcon.hp6 = jcon.register{
		uid = "sbhp_6",
		type = "digital",
		description = "Select 6",
		category = "Hardpoint Control",
	}
	SBHPjcon.hp7 = jcon.register{
		uid = "sbhp_7",
		type = "digital",
		description = "Select 7",
		category = "Hardpoint Control",
	}
	SBHPjcon.hp8 = jcon.register{
		uid = "sbhp_8",
		type = "digital",
		description = "Select 8",
		category = "Hardpoint Control",
	}
	SBHPjcon.hp9 = jcon.register{
		uid = "sbhp_9",
		type = "digital",
		description = "Select 9",
		category = "Hardpoint Control",
	}
	SBHPjcon["alt"] = jcon.register{
		uid = "sbhp_alt",
		type = "digital",
		description = "Alt Select",
		category = "Hardpoint Control",
	}
end
hook.Add("JoystickInitialize","SBHPJoystickControl",SBHPJoystickControl)

function SBEPHPWS()
	local ply = LocalPlayer()
	local CD = ply:GetNetworkedInt( "SBHPCD" ) or 0
	local HPC = ply:GetVehicle():GetNetworkedInt( "HPC" ) or 0
	local n = 0
	if HPC > 0 then
		for n = 1, HPC + 1 do
			if (input.IsKeyDown(n) || joystick && SBHPjcon["hp"..n-1]:GetValue()) && CurTime() > CD then
				local x = n - 1
				local str = ""
				if input.IsKeyDown(81) || input.IsKeyDown(82) || (joystick && SBHPjcon["alt"]:GetValue()) then
					str = "SBHP_"..x.."a"
					str2 = " for alt-fire"
				else
					str = "SBHP_"..x
					str2 = ""
				end
				
				local i = 0
				local CS = LocalPlayer():GetInfo( str )
				local s = ""
				if string.byte(CS) == 48 then
					i = 1
					s = " enabled"
				else
					i = 0
					s = " disabled"
				end
				
				--LocalPlayer():ChatPrint(CS..", "..x)
				
				RunConsoleCommand(str,i)
				--LocalPlayer():ChatPrint("Hardpoint "..x..s..str2) 
				ply:SetNetworkedInt( "SBHPCD", CurTime() + 0.3 )
			end
		end
	end
end

hook.Add("Think", "SBEPHPWS", SBEPHPWS)

function SBHud() 
	local ply = LocalPlayer()
	local HPC = ply:GetVehicle():GetNetworkedInt( "HPC" ) or 0
	local n = 0
	if HPC > 0 then
		for n = 1, HPC do
			local c = 0
			local info = LocalPlayer():GetInfo( "SBHP_"..n )
			--if info == "0.00" || info == "0" || info == 0 || info == "0.0" then -- Before
			if string.byte(info) == 48 then -- After
				c = 100
			else
				c = 240
			end
			
			draw.WordBox( 10, 40, (ScrH() * 0.45) + (n * 40), n, "Default",Color(30,c,30,c),Color(255,255,255,255))
			
			info = LocalPlayer():GetInfo( "SBHP_"..n.."a" )
			if string.byte(info) == 48 then 
				c = 100
			else
				c = 240
			end
			
			draw.WordBox( 10, 70, (ScrH() * 0.45) + (n * 40), n, "Default",Color(30,c,30,c),Color(255,255,255,255))
			
			--local WEnt = ply:GetVehicle():GetNetworkedEntity( "SBHPE_"..n ) or nil
			--if WEnt && WEnt:IsValid() then
				
			--end
		end
	end
end 
hook.Add("HUDPaint", "SBHud", SBHud)