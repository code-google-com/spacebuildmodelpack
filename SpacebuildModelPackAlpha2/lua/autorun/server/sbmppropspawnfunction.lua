function Spawn_SBEP_Prop(ply,cmd,args)
        if #args < 3 then return end
        local model = args[1]
        local skin = args[2]
        local IsHab = (tonumber(args[3]) == 1)
 
        local ent = 0
        if IsHab then
                ent = ents.Create("base_livable_module")
        else
                ent = ents.Create("prop_physics")
        end
 
		ent:SetModel(model)
        ent:Spawn()
		
		if IsHab then
				ent:Activate()
		end
		
        ent:SetSkin(skin)
		ent:SetPos(ply:GetEyeTraceNoCursor().HitPos- Vector(0,0,ent:OBBMins().z))
		
		if IsHab then
				undo.Create("Habitable Module") 
				undo.SetPlayer(ply) 
				undo.AddEntity(ent) 
				undo.Finish( "Habitable Module ("..tostring(model)..")" ) 
 	 
				ply:AddCleanup( "props", ent ) 
		else
				undo.Create("Prop") 
				undo.SetPlayer(ply) 
				undo.AddEntity(ent) 
				undo.Finish( "Prop ("..tostring(model)..")" ) 
 	 
				ply:AddCleanup( "props", ent ) 
		end

	

end
concommand.Add("SpawnSBEPProp",Spawn_SBEP_Prop)