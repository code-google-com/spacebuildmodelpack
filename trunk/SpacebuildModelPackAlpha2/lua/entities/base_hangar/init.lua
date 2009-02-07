
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )
local Fighters = list.Get("sbepfighters")

function ENT:MakeWire()
	local InputTable = {}
	table.insert(InputTable,"Launchspeed")
	for k,v in pairs(self.Bay) do
		table.insert(InputTable,"Disable "..tostring(k))
	end
	for k,v in pairs(self.Bay) do
		table.insert(InputTable,"Eject "..tostring(k))
	end
	self.Inputs = Wire_CreateInputs(self.Entity,InputTable)
	local OutputTable = {Name = {}, Type = {}, Desc = {}}
	for k,v in pairs(self.Bay) do
		table.insert(OutputTable.Name,"Ship "..tostring(k))
		table.insert(OutputTable.Type,"STRING")
	end
	self.Outputs = WireLib.CreateSpecialOutputs(self.Entity,OutputTable.Name,OutputTable.Type,OutputTable.Desc)
end

function ENT:TriggerInput(iname, value)
	if (iname == "Launchspeed") then
		self.Entity:SetLaunchSpeed(value)
	end
	local input = string.Explode(" ",iname)
	for k,v in pairs(self.Bay) do
		if (iname == "Disable "..tostring(k)) then
			self.Entity:SetDisabled(v,value)
		end
		if (iname == "Eject "..tostring(k)) then
			self.Entity:Eject(v,value)
		end
	end
end

function ENT:SetLaunchSpeed(value)
	self.LaunchSpeed = value
end

function ENT:SetDisabled(bay,value)
	if (value != 0) then
		bay.disabled = true
	else
		bay.disabled = false
	end
end

function ENT:Eject(bay,value)
	if (value != 0) then
		if bay.ship then
			bay.ship.Cont.Launchy = true
		end
	end
end

function ENT:Think()
	--For each bay on the hangar
	for k, v in pairs(self.Bay) do
		--If the ship's gone then remove references to it and its constraint
		--logic for if someone removes the fighter
		if ( !v.ship || !v.ship:IsValid() ) then
			v.weld = nil
			v.ship = nil
			Wire_TriggerOutput(self.Entity, "Ship "..tostring(k), "")
		end
		--if can't find weld, look for it and if it exists re-reference
		--necessary for dupe as constraints get added after entities
		if not ( v.weld and v.weld:IsValid() ) then
			--for all the welds of the ship
			for l,w in pairs(constraint.FindConstraints( v.ship, "Weld" )) do
				--if the weld is also constrained to the hangar
				if (w.Ent1 == self.Entity || w.Ent2 == self.Entity) then
					--re-reference the weld
					v.weld = w.Constraint
				else
					v.ship = nil
				end
			end
		end
		--Launch procedure
		--If the ship is activated
		if ( v.ship && v.ship.Cont && v.ship.Cont.Launchy ) then
			--unweld and launch
			if (v.weld and v.weld:IsValid()) then
				v.weld:Remove()
			end
			v.weld = nil
			if (v.EP == v.ship.ExitPoint) then
				v.ship.ExitPoint = nil
			end
			v.ship.Cont.Speed = self.LaunchSpeed
			v.ship = nil
			Wire_TriggerOutput(self.Entity, "Ship "..tostring(k), "")
		end
	end
end

function ENT:Touch( ent )
	--if the entity is a valid vehicle on the fighter table and isn't launched
	if ( ent:IsValid() && self.Entity:IsInBoth(ent) && (ent.Cont != nil) && (ent:IsVehicle() && !ent.Cont.Launchy && !ent.Cont.EMount
		or ent.EMount && !ent.Launchy)) then
		local fighter = string.lower(ent.Cont:GetName())
		local index,dock = self.Entity:findNearestDock(ent,fighter)
		if (!dock) then return end
		if ( !dock.ship && !self.Entity:alreadyDocked(ent) ) then
			local vecOff = Fighters[fighter]["VecOff"]
			--workaround so that rotation doesn't alter the original vector
			vecOff = Vector(vecOff.x,vecOff.y,vecOff.z)
			local dockAng = self.Entity:alignToDock(ent,fighter,dock)
			vecOff:Rotate(dockAng)
			ent:SetPos( self.Entity:LocalToWorld(dock.pos - vecOff) )
			ent:SetAngles( self.Entity:LocalToWorldAngles(dockAng) )
			dock.ship = ent
			dock.weld = constraint.Weld(self.Entity, ent, 0, 0, 0, true)
			if (dock.EP && !ent.ExitPoint) then
				ent.ExitPoint = dock.EP
				dock.EP.Vec = ent
			end
			local pilot = dock.ship.Pod:GetPassenger()
			if (pilot:IsPlayer()) then
				if (dock.pexit && !ent.ExitPoint) then
					--local colgroup = pilot:GetCollisionGroup()
					--pilot:SetCollisionGroup( COLLISION_GROUP_NONE )
					pilot:ExitVehicle()
					pilot:SetPos( self.Entity:LocalToWorld(dock.pexit) )
					--pilot:SetCollisionGroup( colgroup )
				elseif ent.ExitPoint then
					pilot:ExitVehicle()
				end
			end
			Wire_TriggerOutput(self.Entity, "Ship "..tostring(index), ent.Cont:GetName())
		end
	end
end

function ENT:findNearestDock(ent,fighter)
	--the values to return
	local closest
	--The position of the dock
	local pos = self.Entity:WorldToLocal(ent:GetPos())
	local dis
	--for each of the bays
	for k, v in pairs(self.Bay) do
		--if it hasn't got a ship already in it
		if (v.ship == nil) and not v.disabled then
			--find the distance from the fighter
			local tdis = pos:Distance(v.pos)
			local tclosest = k
			--store the smallest distance
			if (!dis || tdis < dis) then
				dis = tdis
				closest = tclosest
			end
		end
	end
	--return the bay with the closest distance
	return closest,self.Bay[closest]
end

--find the nearest alignment of the fighter to possible alignments
function ENT:alignToDock(ent,fighter,dock)
	local fighterface = ent:LocalToWorldAngles(Fighters[fighter]["AngOff"])
	local adif
	--for each direction it can face
	for k,v in pairs(dock.canface) do
		--find the world angle for the direction
		local tangle = self.Entity:LocalToWorldAngles(v)
		--find the difference between these angles
		local tadif = sbep_AngleDifference(fighterface,tangle)
		--if the current difference is less
		if (!adif || tadif < adif) then
			--record the difference and the angle
			adif = tadif
			--angle = tangle
			angle = v
		end
	end
	--return the angle with the smallest difference in angle
	return angle
end

--find an arbitrary difference value between two angles
function sbep_AngleDifference(ang1,ang2)
	local pdif = math.AngleDifference(ang1.p,ang2.p)
	local ydif = math.AngleDifference(ang1.y,ang2.y)
	local rdif = math.AngleDifference(ang1.r,ang2.r)
	--that's right, this is like the Hypotenuse formula
	return math.sqrt(pdif*pdif + ydif*ydif + rdif*rdif)
end

function ENT:alreadyDocked(ent)
	for k, v in pairs(self.Bay) do
		if (ent == v.ship) then
			return true	
		end
	end
	return false
end

function ENT:IsInBoth(ent)
	if not ent.Cont then return false end
	local fighter = string.lower(ent.Cont:GetName())
	if (!Fighters[fighter]) then return false end
	local docklist = Fighters[fighter]["Docklist"]
	return (Fighters[fighter] && table.HasValue(docklist, string.lower(self.Entity:GetName())))
end

function ENT:Use(activator)
end

function ENT:BuildDupeInfo()
	local info = self.BaseClass.BaseClass.BuildDupeInfo(self) or {}
	info["ships"] = {}
	info["EPs"] = {}
	for k, v in pairs(self.Bay) do
		if (v.ship) and (v.ship:IsValid()) then
			info["ships"][k] = v.ship:EntIndex()
		end
		if (v.EP) and (v.EP:IsValid()) then
			info["EPs"][k] = v.EP:EntIndex()
		end
	end
	return info
end

function ENT:ApplyDupeInfo(ply, ent, info, GetEntByID)
	self.BaseClass.BaseClass.ApplyDupeInfo(self, ply, ent, info, GetEntByID)
	for k, v in pairs(info.ships) do
		self.Bay[k]["ship"] = GetEntByID(v)
		if (!self.Bay[k]["ship"]) then
			self.Bay[k]["ship"] = ents.GetByIndex(v)
		end
	end
	for k, v in pairs(info.EPs) do
		self.Bay[k]["EP"] = GetEntByID(v)
		if (!self.Bay[k]["EP"]) then
			self.Bay[k]["EP"] = ents.GetByIndex(v)
		end
	end
end
