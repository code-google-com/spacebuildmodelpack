
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )
local Fighters = list.Get("sbepfighters")

function ENT:Think()
	--For each bay on the hangar
	for k, v in pairs(self.Bay) do
		--If the ship's gone then remove references to it and its constraint
		--logic for if someone removes the fighter
		if ( !v.ship || !v.ship:IsValid() ) then
			v.weld = nil
			v.ship = nil
		end
		--if can't find weld, look for it and if it exists re-reference
		--necessary for dupe as constraints get added after entities
		if ( !v.weld || !v.weld:IsValid() ) then
			--for all the welds of the ship
			for l,w in pairs(constraint.FindConstraints( v.ship, "Weld" )) do
				--if the weld is also constrained to the hangar
				if (w.Ent1 == self.Entity || w.Ent2 == self.Entity) then
					--re-reference the weld
					v.weld = w.Constraint
				end
			end
		end
		--Launch procedure
		--If the ship is activated
		if ( v.ship && v.ship.Cont.Launchy ) then
			--unweld and launch
			v.weld:Remove()
			v.weld = nil
			v.ship.Cont.Speed = self.LaunchSpeed
			v.ship = nil
		end
	end
end

function ENT:Touch( ent )
	--if the entity is a valid vehicle on the fighter table and isn't launched
	if ( ent:IsValid() && ent:IsVehicle() && self.Entity:IsInBoth(ent) && (ent.Cont != nil) && !ent.Cont.Launchy ) then
		local fighter = string.lower(ent.Cont:GetName())
		local dock = self.Entity:findNearestDock(ent,fighter)
		if (!dock) then return end
		if ( !dock.ship && !self.Entity:alreadyDocked(ent) ) then
			ent:SetPos( self.Entity:LocalToWorld(dock.pos + Fighters[fighter]["VecOff"]) )
			ent:SetAngles( self.Entity:alignToDock(ent,fighter,dock) )
			dock.ship = ent
			dock.weld = constraint.Weld(self.Entity, ent, 0, 0, 0, true)
			if (dock.ship:GetPassenger():IsPlayer()) then
				local pilot = dock.ship:GetPassenger()
				local colgroup = pilot:GetCollisionGroup()
				pilot:SetCollisionGroup( COLLISION_GROUP_NONE )
				pilot:ExitVehicle()
				pilot:SetPos( self.Entity:LocalToWorld(dock.pexit) )
				pilot:SetCollisionGroup( colgroup )
			end
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
		if (v.ship == nil) then
			--find the distance from the fighter
			local tdis = pos:Distance(v.pos)
			local tclosest = v
			--store the smallest distance
			if (!dis || tdis < dis) then
				dis = tdis
				closest = tclosest
			end
		end
	end
	--return the bay with the closest distance
	return closest
end

--find the nearest alignment of the fighter to possible alignments
function ENT:alignToDock(ent,fighter,dock)
	local fighterface = ent:GetAngles()
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
			angle = tangle
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
	local info = self.BaseClass.BuildDupeInfo(self) or {}
	info["ships"] = {}
	for k, v in pairs(self.Bay) do
		if (v.ship) and (v.ship:IsValid()) then
			info["ships"][k] = v.ship:EntIndex()
		end
	end
	return info
end

function ENT:ApplyDupeInfo(ply, ent, info, GetEntByID)
	self.BaseClass.ApplyDupeInfo(self, ply, ent, info, GetEntByID)
	for k, v in pairs(info.ships) do
		self.Bay[k]["ship"] = GetEntByID(v)
		if (!self.Bay[k]["ship"]) then
			self.Bay[k]["ship"] = ents.GetByIndex(v)
		end
	end
end
