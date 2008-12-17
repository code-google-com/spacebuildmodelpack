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

function SBEPHPWS()
	local ply = LocalPlayer()
	local CD = ply:GetNetworkedInt( "SBHPCD" ) or 0
	local HPC = ply:GetVehicle():GetNetworkedInt( "HPC" ) or 0
	local n = 0
	if HPC > 0 then
		for n = 1, HPC + 1 do
			if input.IsKeyDown(n) && CurTime() > CD then
				local x = n - 1
				local str = ""
				if input.IsKeyDown(81) || input.IsKeyDown(82) then
					str = "SBHP_"..x.."a"
					str2 = " for alt-fire"
				else
					str = "SBHP_"..x
					str2 = ""
				end
				
				local i = 0
				local CS = LocalPlayer():GetInfo( str )
				local s = ""
				if CS == "0.00" || CS == "0" || CS == 0 then
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
			if info == "0.00" || info == "0" || info == 0 then
				c = 100
			else
				c = 240
			end
			
			draw.WordBox( 10, 40, (ScrH() * 0.45) + (n * 40), n, "Default",Color(30,c,30,c),Color(255,255,255,255))
			
			info = LocalPlayer():GetInfo( "SBHP_"..n.."a" )
			if info == "0.00" || info == "0" then
				c = 100
			else
				c = 240
			end
			
			draw.WordBox( 10, 70, (ScrH() * 0.45) + (n * 40), n, "Default",Color(30,c,30,c),Color(255,255,255,255))
		end
	end
end 
hook.Add("HUDPaint", "SBHud", SBHud)
