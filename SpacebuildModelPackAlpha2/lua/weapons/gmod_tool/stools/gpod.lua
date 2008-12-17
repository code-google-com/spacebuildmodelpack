
TOOL.Category		= "Construction"
TOOL.Name			= "#Gyro-Pod"
TOOL.Command		= nil
TOOL.ConfigName		= ""


TOOL.ent = {}


// Add Default Language translation (saves adding it to the txt files)
if ( CLIENT ) then

	language.Add( "Tool_gpod_name", "Gyro-Pod" )
	language.Add( "Tool_gpod_desc", "Make stuff fly." )
	language.Add( "Tool_gpod_0", "Right-Click to spawn the gyro, left click a prop followed by a gyro to link the two. The last vehicle linked to the gyro will control its motion." )
	language.Add( "Tool_gpod_1", "Now click a Gyro-Pod." )
	
	language.Add( "Tool_turret_type", "Type of weapon" )
	
end

function TOOL:LeftClick( trace )

if ( !trace.Hit ) then return end
	
	--if ( SERVER && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end
	--if (CLIENT) then return true end
	
	if (self:GetStage() == 0) and (!trace.Entity.GPod) and (trace.Entity:IsValid()) then
		--self.ST = 1
		self.LEnt = trace.Entity
		self:SetStage(1)
		return true
	elseif (self:GetStage() == 1) and (trace.Entity.GPod) and (trace.Entity:IsValid()) then
		trace.Entity:Link(self.LEnt)
		self:SetStage(0)
		self.LEnt = nil
		return true
	else
		return false
	end
	
	return true

end

function TOOL:RightClick( trace )
	
if ( !trace.Hit ) then return end
	
	if ( SERVER && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end
	if (CLIENT) then return true end
		
	local SpawnPos = trace.HitPos + trace.HitNormal * 20
	
	local ply = self:GetOwner()
	
	local ent = ents.Create( "GyroPod2" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	
	undo.Create("Gyro-Pod")
		undo.AddEntity( ent )
		undo.SetPlayer( ply )
	undo.Finish()
	return true

end

function TOOL:Reload(trace)
	self:SetStage(0)
	self.LEnt = nil
end

function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "Header", { Text = "#Tool_gpod_name", Description	= "#Tool_gpod_desc" }  )

end
