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


function SBEPCCC(ply, data)
	local cmd = ply:GetCurrentCommand()
	ply.SBEPYaw = cmd:GetMouseX()
	ply.SBEPPitch = cmd:GetMouseY()
	
end  
 
hook.Add("SetupMove", "SBEPControls", SBEPCCC)

function HPLink( cont, pod, weap )
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
				if cont.Skewed then
					weap:SetPos( pod:GetPos() + ( pod:GetForward() * ( cont.HP[i]["Pos"].x + weap.APPos.y ) ) + ( pod:GetRight() * ( cont.HP[i]["Pos"].y + weap.APPos.x ) ) + ( pod:GetUp() * ( cont.HP[i]["Pos"].z + weap.APPos.z ) ) )
				else
					weap:SetPos( pod:GetPos() + ( pod:GetForward() * ( cont.HP[i]["Pos"].x + weap.APPos.x ) ) + ( pod:GetRight() * ( cont.HP[i]["Pos"].y + weap.APPos.y ) ) + ( pod:GetUp() * ( cont.HP[i]["Pos"].z + weap.APPos.z ) ) )
				end
				weap:SetAngles( pod:GetAngles() )
				weap:GetPhysicsObject():EnableCollisions(false)
				weap.HPNoc = constraint.NoCollide(pod, weap, 0, 0, 0, true)
				weap.HPWeld = constraint.Weld(pod, weap, 0, 0, 0, true)
				weap:SetParent( pod )
				--pod:SetNetworkedEntity( "SBHPE_"..i, weap ) 
				cont.HP[i]["Ent"] = weap
				weap.Pod = pod
				weap.HPN = i
				weap:GetPhysicsObject():EnableGravity(false)
				return true
			end
		end
	end
	return false
end