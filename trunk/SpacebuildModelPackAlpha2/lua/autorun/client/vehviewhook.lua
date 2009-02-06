--save a reference to the original function
local calcVehView

--the new function
local function SBMP_OverrideOrigin( Vehicle, ply, origin, angles, fov )
	--call the original function
	view = calcVehView(Vehicle,ply,origin,angles,fov)
	local ViewEnt = ply:GetNetworkedEntity("Controller")
	local OffsetOut = ply:GetNetworkedInt("OffsetOut") or 1000
	if (ViewEnt and ViewEnt:IsValid()) then
		local pos = ViewEnt:GetPos()
		local offset = view.angles:Forward() * OffsetOut
		view.origin = pos - offset
	end
	--return the changed view
	return view 
end

local function replaceHook()
	calcVehView = GAMEMODE.CalcVehicleThirdPersonView
	--print("Old Function = "..tostring(calcVehView))
	--print("New Function = "..tostring(SBMP_OverrideOrigin))
	--replace the original function
	GAMEMODE.CalcVehicleThirdPersonView = SBMP_OverrideOrigin
	--print("Current Function = "..tostring(GAMEMODE.CalcVehicleThirdPersonView))
end

hook.Add( "Initialize", "replaceHook", replaceHook )