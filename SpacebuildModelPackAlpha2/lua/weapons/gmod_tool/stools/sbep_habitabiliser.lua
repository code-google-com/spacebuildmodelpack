if !GAMEMODE.IsSpacebuildDerived then return end

if not CAF or not CAF.GetAddon("Resource Distribution") then return end
 if (CLIENT and GetConVarNumber("CAF_UseTab") == 1) then TOOL.Tab = "Custom Addon Framework" end

TOOL.Category		= "SBEP"
TOOL.Name			= "#Habitabiliser" 
TOOL.Command 		= nil 
TOOL.ConfigName 	= ""

if ( CLIENT ) then
	language.Add( "Tool_sbep_habitabiliser_name" , "SBEP Habitabiliser Tool" )
	language.Add( "Tool_sbep_habitabiliser_desc" , "Easily turn props into habitable modules." )
	language.Add( "Tool_sbep_habitabiliser_0", "Left click a prop to turn it into a habitable module." )
	language.Add( "undone_Habitable Module", "Undone Habitable Module" )
end

function TOOL:LeftClick( trace ) 
	if trace.Entity:IsValid() then
		local traceEnt = trace.Entity
		local ply = self:GetOwner()
		
		local prop = {}
		prop.model	= traceEnt:GetModel()
		prop.pos	= traceEnt:GetPos()
		prop.angles	= traceEnt:GetAngles()
		prop.skin	= traceEnt:GetSkin()
		
		/*--------------------------
		local EntWeldTable = constraint.FindConstraints( traceEnt, "Weld" )
		PrintTable( EntWeldTable )
		----------------------------*/
		
		traceEnt:Remove()
		
		local habmod = ents.Create("base_livable_module")
		habmod:SetModel(prop.model)
		habmod:Spawn()
		habmod:Activate()
		habmod:SetPos(prop.pos)
		habmod:SetAngles(prop.angles)
		habmod:SetSkin(prop.skin)
		habmod:SetPlayer(ply)
		habmod:GetPhysicsObject():EnableMotion(false)
		
		/*-------
		for i, entweld in pairs(EntWeldTable) do
			constraint.Weld(habmod, Entity(EntWeldTable[i]["Entity"][2]["Index"]), EntWeldTable[i]["Bone1"], EntWeldTable[i]["Bone2"], EntWeldTable[i]["forcelimit"], EntWeldTable[i]["nocollide"])
		end
		---------*/
		/*---------------------------
		for i,entweld in pairs(EntWeldTable) do
			if entweld["Ent1"]:EntIndex() == traceEnt:EntIndex() then
                local straint = constraint.Weld( habmod, entweld[i]["Ent2"], 0, 0, entweld[i]["forcelimit"], oentweld[i]["nocollide"])
                straint.OnDieFunctions = entweld["Constraint"].OnDieFunctions
			else
                local straint = constraint.Weld(habmod,entweld[i]["Ent2"],0,0,entweld[i]["forcelimit"],entweld[i]["nocollide"])
                straint.OnDieFunctions = entweld["Constraint"].OnDieFunctions
			end
		end
		------------------------*/
		
		print("Habitabilised.")
		
		undo.Create( "Habitable Module" ) 
			undo.SetPlayer(ply) 
			undo.AddEntity(habmod) 
			undo.Finish() 
 	 
		ply:AddCleanup( "sbep_hab_mods" , habmod ) 
		
		return true
	end	
end 
   
   
function TOOL:RightClick( trace ) 

end  

function TOOL.BuildCPanel(panel) 
	
	panel:AddControl("Header", 	
				{ 	
				Text = "Tool_sbep_habitabiliser_name", 
				Description = "Tool_sbep_habitabiliser_desc" 
				})

	BindLabel = {}
	BindLabel.Text = "\nLeft Click to turn a prop into a Habitable Module. \nThis tool does not yet save constraints, so you will\n need to re-weld things afterwards. Or use\n this tool on the prop before attaching it\n in the first place."
	BindLabel.Description = "Disclaimer."
	panel:AddControl("Label", BindLabel )
	
 end  