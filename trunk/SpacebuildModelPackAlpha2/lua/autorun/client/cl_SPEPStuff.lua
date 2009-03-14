if not SBEP then SBEP = {} end 

--All this stuff is so that you only ever have to type this into the console ONCE. (And it will carry over all servers for all sessions until GMod is uninstalled or it's SQL database is destroied)
function HookzMeIntoTehSpawn()
	local ply = LocalPlayer()
	if not ply:IsValid() then timer.Simple(1,HookzMeIntoTehSpawn) else
	if file.Exists("SBEPSettings.txt") then
		local settings = file.Read("SBEPSettings.txt")
		local lines = string.Explode(";",settings)
		for k,v in pairs(lines) do
			local cmdargs = string.Explode(" ",v)
			local cmd = cmdargs[1]
			cmdargs[1] = nil
			local tbl = {}
			for k,v in pairs(cmdargs) do
				table.insert(tbl,v)
			end
			RunConsoleCommand(cmd,unpack(tbl))
		end
	end
	end
end 
hook.Add("PostGamemodeLoaded","HookzMeIntoTehLoadupSpwnYo",HookzMeIntoTehSpawn)

function RecieveMyOwnColorPlz(um)
	local r = um:ReadShort()
	local g = um:ReadShort()
	local b = um:ReadShort()

	local ply = LocalPlayer()
	file.Write("SBEPSettings.txt","SBEP_Weapon_Color "..r.." "..g.." "..b)
end
usermessage.Hook("IdLikeToRecieveMyOwnColorNow",RecieveMyOwnColorPlz)
