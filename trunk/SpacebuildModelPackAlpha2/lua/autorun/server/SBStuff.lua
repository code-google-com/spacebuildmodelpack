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
			if cont.HP[i]["Type"] == weap.HPType then
				if cont.Skewed then
					weap:SetPos( pod:GetPos() + ( pod:GetForward() * ( cont.HP[i]["Pos"].x + weap.APPos.y ) ) + ( pod:GetRight() * ( cont.HP[i]["Pos"].y + weap.APPos.x ) ) + ( pod:GetUp() * ( cont.HP[i]["Pos"].z + weap.APPos.z ) ) )
				else
					weap:SetPos( pod:GetPos() + ( pod:GetForward() * ( cont.HP[i]["Pos"].x + weap.APPos.x ) ) + ( pod:GetRight() * ( cont.HP[i]["Pos"].y + weap.APPos.y ) ) + ( pod:GetUp() * ( cont.HP[i]["Pos"].z + weap.APPos.z ) ) )
				end
				weap:SetAngles( pod:GetAngles() )
				weap:GetPhysicsObject():EnableCollisions(false)
				weap.HPWeld = constraint.Weld(pod, weap, 0, 0, 0, true)
				weap.HPNoc = constraint.NoCollide(pod, weap, 0, 0, 0, true)
				weap:SetParent( pod )
				cont.HP[i]["Ent"] = weap
				weap.Pod = pod
				weap.HPN = i
				weap:GetPhysicsObject():EnableGravity(false)
				return
			end
		end
	end
end