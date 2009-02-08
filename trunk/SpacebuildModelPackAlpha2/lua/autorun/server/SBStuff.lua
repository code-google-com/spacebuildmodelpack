-- This function basically deals with stuff that happens when a player hops out of a vehicle
function SetExPoint(player, vehicle)
	if vehicle.ExitPoint && vehicle.ExitPoint:IsValid() then
		local EPP = vehicle.ExitPoint:GetPos()
		local VP = vehicle:GetPos()
		local Dist = EPP:Distance(VP)
		if Dist <= 500 then
			player:SetPos(vehicle.ExitPoint:GetPos() + vehicle.ExitPoint:GetUp() * 10)
			vehicle.ExitPoint.CDown = CurTime() + 0.5
		end
	end
	
	if player.CamCon then
		player.CamCon = false
		player:SetViewEntity()
	end
end

hook.Add("PlayerLeaveVehicle", "PlayerRepositioning", SetExPoint)

--For controling certain entities
function SBEPCCC(ply, data)
	local cmd = ply:GetCurrentCommand()
	ply.SBEPYaw = cmd:GetMouseX()
	ply.SBEPPitch = cmd:GetMouseY()
	
end  
 
hook.Add("SetupMove", "SBEPControls", SBEPCCC)

--This is all the hardpointing stuff
function HPLink( cont, pod, weap )
	if weap.Mounted then return false end
	if !cont.HPC then return false end
	for i = 1, cont.HPC do
		if !cont.HP[i]["Ent"] || !cont.HP[i]["Ent"]:IsValid() then
			local TypeMatch = false
			if type(cont.HP[i]["Type"]) == "string" then
				if type(weap.HPType) == "string" then
					--print("Double String")
					if cont.HP[i]["Type"] == weap.HPType then
						TypeMatch = true
					end
				elseif type(weap.HPType) == "table" then
					--print("String - Table")
					if table.HasValue( weap.HPType, cont.HP[i]["Type"] ) then
						TypeMatch = true
					end
				end
			elseif type(cont.HP[i]["Type"]) == "table" then
				if type(weap.HPType) == "string" then
					--print("Table - String")
					if table.HasValue( cont.HP[i]["Type"], weap.HPType ) then
						TypeMatch = true
					end
				elseif type(weap.HPType) == "table" then
					--print("Double Table")
					for _,v in pairs(cont.HP[i]["Type"]) do
						if table.HasValue( weap.HPType, v ) then
							TypeMatch = true
						end
					end
				end
			end			
			
			if TypeMatch then
				--[[Paradukes' old code
				weap:SetAngles( pod:GetAngles() )
				local PAngle = pod:GetAngles()
				if weap.APAng then
					PAngle:RotateAroundAxis( pod:GetUp(), weap.APAng.y )
					PAngle:RotateAroundAxis( pod:GetRight(), weap.APAng.p )
					PAngle:RotateAroundAxis( pod:GetForward(), weap.APAng.r )
				end
				if cont.HP[i]["Angle"] then
					PAngle:RotateAroundAxis( pod:GetUp(), cont.HP[i]["Angle"].y )
					PAngle:RotateAroundAxis( pod:GetRight(), cont.HP[i]["Angle"].p )
					PAngle:RotateAroundAxis( pod:GetForward(), cont.HP[i]["Angle"].r )
				end
				weap:SetAngles( PAngle )
				
				if cont.Skewed then
					weap:SetPos( pod:GetPos() + ( pod:GetForward() * ( cont.HP[i]["Pos"].x + weap.APPos.y ) ) + ( pod:GetRight() * ( cont.HP[i]["Pos"].y + weap.APPos.x ) ) + ( pod:GetUp() * ( cont.HP[i]["Pos"].z + weap.APPos.z ) ) )
				else
					weap:SetPos( pod:GetPos() + ( pod:GetForward() * ( cont.HP[i]["Pos"].x + weap.APPos.x ) ) + ( pod:GetRight() * ( cont.HP[i]["Pos"].y + weap.APPos.y ) ) + ( pod:GetUp() * ( cont.HP[i]["Pos"].z + weap.APPos.z ) ) )
				end]]
				
				------Fishface60's new code-------
				local APAng = weap.APAng or Angle(0,0,0)
				local HPAng = cont.HP[i]["Angle"] or Angle(0,0,0)
				weap:SetAngles(pod:LocalToWorldAngles(APAng+HPAng))
				
				local APPos = weap.APPos or Vector(0,0,0)
				APPos = Vector(APPos.x,APPos.y,APPos.z)
				APPos:Rotate(APAng+HPAng)
				local HPPos = cont.HP[i]["Pos"] or Vector(0,0,0)
				HPPos = Vector(HPPos.x,HPPos.y,HPPos.z)
				if cont.Skewed then
					if (type(cont.Skewed) == "boolean" and cont.Skewed == true) then
						HPPos:Rotate(Angle(0,-90,0))
					elseif type(cont.Skewed) == "angle" then
						HPPos:Rotate(cont.Skewed)
					end
				end
				weap:SetPos(pod:LocalToWorld(APPos+HPPos))
				
				weap:GetPhysicsObject():EnableCollisions(false)
				weap.HPNoc = constraint.NoCollide(pod, weap, 0, 0, 0, true)
				weap.HPWeld = constraint.Weld(pod, weap, 0, 0, 0, true)
				weap:SetParent( pod )
				pod:SetNetworkedEntity( "HPW_"..i, weap ) 
				cont.HP[i]["Ent"] = weap
				weap.Pod = pod
				weap.HPN = i
				weap.Mounted = true
				weap:GetPhysicsObject():EnableGravity(false)
				return true
			end
		end
	end
	return false
end