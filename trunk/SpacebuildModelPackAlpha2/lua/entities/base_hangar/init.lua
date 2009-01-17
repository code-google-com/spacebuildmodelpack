
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
	for k, v in pairs(self.Bay) do
		if (v.ship == nil) then
			local tdis = pos:Distance(v.pos)
			local tclosest = v
			if (!dis || tdis < dis) then
				dis = tdis
				closest = tclosest
			end
		end
	end
	return closest
end

function ENT:alignToDock(ent,fighter,dock)
	local fighterface = self.Entity:GetVector(ent,Fighters[fighter]["Faces"])
	local adif
	for k,v in pairs(dock.canface) do
		local tangle = self.Entity:GetVector(self.Entity,v)
		local tadif = fighterface:DotProduct(tangle)
		if (!adif || tadif >= adif) then
			adif = tadif
			angle = tangle
		end
	end
	return angle:Angle()
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

function ENT:GetVector(ent,alignment)
	if (alignment == "forward") then
		return ent:GetForward()
	elseif (alignment == "backward") then
		return ent:GetForward()*-1
	elseif (alignment == "right") then
		return ent:GetRight()
	elseif (alignment == "left") then
		return ent:GetRight()*-1
	elseif (alignment == "up") then
		return ent:GetUp()
	elseif (alignment == "down") then
		return ent:GetUp()*-1
	else
		return false
	end
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
