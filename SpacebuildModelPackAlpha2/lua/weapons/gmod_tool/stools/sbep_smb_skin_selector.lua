if (CLIENT and GetConVarNumber("CAF_UseTab") == 1) then 
	TOOL.Tab = "Custom Addon Framework"
	TOOL.Category		= "SBEP"	
else
	TOOL.Category		= "Render"
end

TOOL.Name			= "#SmallBridge Skin Selector" 
TOOL.Command 		= nil 
TOOL.ConfigName 	= ""

CreateClientConVar( "SBEP_SmallBridge_SkinNumber", 0, false, false ) 
CreateClientConVar( "SBEP_SmallBridge_GlassNumber", 0, false, false ) 

if ( CLIENT ) then
	language.Add( "Tool_sbep_smb_skin_selector_name" , "SBEP SmallBridge Skin Selector Tool" 				)
	language.Add( "Tool_sbep_smb_skin_selector_desc" , "Easily change skins of SmallBridge props." 			)
	language.Add( "Tool_sbep_smb_skin_selector_0"	 , "Left click a prop to switch to the selected skin." 	)
end


function TOOL:LeftClick( trace ) 
	if trace.Entity:IsValid() then
		print("Valid")
		print( trace.Entity:GetModel() )
		if string.find( trace.Entity:GetModel(), "SmallBridge" ) or string.find( trace.Entity:GetModel(), "smallbridge" ) then
			print("Model path match")
			if trace.Entity:SkinCount() == 10 then
				SkinInt = 1
			else
				SkinInt = 0
			end
			
			SkinNumber  = GetConVarNumber( "SBEP_SmallBridge_SkinNumber" )
			GlassNumber = GetConVarNumber( "SBEP_SmallBridge_GlassNumber" )
			
			if SkinInt == 1 then
				Skin = 2 * SkinNumber + GlassNumber
			elseif SkinInt == 0 then
				Skin = SkinNumber
			end
			
			trace.Entity:SetSkin(Skin)
			
			return true
		
		end	
	end
end 


function TOOL:RightClick( trace ) 

end  

//local TOOL = TOOL
function TOOL.BuildCPanel(CPanel) 

	CPanel:AddControl("Header", 	
				{ 	
				Text = "Tool_sbep_smb_skin_selector_name", 
				Description = "Tool_sbep_smb_skin_selector_desc" 
				})

	combobox = {} 
		combobox.Label = "Skin" 
		combobox.MenuButton = 0 
		combobox.Options = {} 
			combobox.Options["Scrappers"]	= { SBEP_SmallBridge_SkinNumber = 0 } 
			combobox.Options["Advanced" ]	= { SBEP_SmallBridge_SkinNumber = 1 } 
			combobox.Options["SlyBridge"]	= { SBEP_SmallBridge_SkinNumber = 2 } 
			combobox.Options["MedBridge"]	= { SBEP_SmallBridge_SkinNumber = 3 } 
			combobox.Options["Jaanus"   ]	= { SBEP_SmallBridge_SkinNumber = 4 } 
	CPanel:AddControl("ComboBox", combobox)  
	
	checkbox = {} 
		checkbox.Label = "Glass" 
		checkbox.Description = "If ticked, the glass skin will be selected, if available."
		checkbox.Command = "SBEP_SmallBridge_GlassNumber"
	CPanel:AddControl("CheckBox", checkbox)
	
 end  