if not SBEP then SBEP = {} end 

--All this stuff is so that you only ever have to type this into the console ONCE. (And it will carry over all servers for all sessions until GMod is uninstalled or it's SQL database is destroied)
function HookzMeIntoTehSpawn()
	local ply = LocalPlayer()
	RunConsoleCommand("SBEP_Weapon_Color",ply:GetPData("SBEP_Weapon_Color_Red"),ply:GetPData("SBEP_Weapon_Color_Green"),ply:GetPData("SBEP_Weapon_Color_Blue"))
	Msg(ply:GetPData("SBEP_Weapon_Color_Red"))
end 
hook.Add("PostGamemodeLoaded","HookzMeIntoTehLoadupSpwnYo",HookzMeIntoTehSpawn)

function RecieveMyOwnColorPlz(um)
	local r = um:ReadShort()
	local g = um:ReadShort()
	local b = um:ReadShort()

	local ply = LocalPlayer()
	ply:SetPData("SBEP_Weapon_Color_Red",r)
	ply:SetPData("SBEP_Weapon_Color_Green",g)
	ply:SetPData("SBEP_Weapon_Color_Blue",b)
end
usermessage.Hook("IdLikeToRecieveMyOwnColorNow",RecieveMyOwnColorPlz)

local Player = FindMetaTable("Player") --Geezus, PData Requires this. Garry should fix this, since this func isn't on the client, but PData can exist on it.

function Player:UniqueID()
	return 0
end 