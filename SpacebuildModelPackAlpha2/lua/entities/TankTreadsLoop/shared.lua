ENT.Type 			= "anim"
ENT.Base 			= "base_gmodentity"
ENT.PrintName		= "Tank Tread Loop"
ENT.Author			= "Paradukes + SlyFo"
ENT.Category		= "SBEP - Other"

ENT.Spawnable		= true
ENT.AdminSpawnable	= true


function ENT:SetLength( val )
	self:SetNetworkedInt( "TLength", val )
end
function ENT:GetLength()
	return self:GetNetworkedInt( "TLength" )
end

function ENT:SetSegSize( val )
	self:SetNetworkedInt( "SLength", val )
end
function ENT:GetSegSize()
	return self:GetNetworkedInt( "SLength" )
end

/*
function ENT:SetCurved( val )
	self:SetNetworkedBool( "Curvy", val )
end
function ENT:GetCurved()
	return self:GetNetworkedBool( "Curvy" )
end
*/

function ENT:SetRadius( val )
	self:SetNetworkedInt( "Radius", val )
end
function ENT:GetRadius()
	return self:GetNetworkedInt( "Radius" )
end

function ENT:SetSpacing( val )
	self:SetNetworkedInt( "Space", val )
end
function ENT:GetSpacing()
	return self:GetNetworkedInt( "Space" )
end

function ENT:SetCont( val )
	self.Entity:SetNetworkedEntity("ClCont",val,true)
end

function ENT:GetCont()
	return self.Entity:GetNetworkedEntity("ClCont")
end