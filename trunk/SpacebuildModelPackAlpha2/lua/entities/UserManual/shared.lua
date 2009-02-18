if( SERVER ) then

	AddCSLuaFile( "shared.lua" )

 function ENT:SpawnFunction( ply, tr )
   local ent = ents.Create("UserManual") 		// Create the entity
   ent:SetPos(tr.HitPos + Vector(0, 0, 20)) 	// Set it to spawn 20 units over the spot you aim at when spawning it
   ent:Spawn() 									// Spawn it
   
   return ent 									// You need to return the entity to make it work
  end 

function ENT:Initialize()

self.Entity:SetModel( "models/Spacebuild/BibleBlack/bible.mdl" )
self.Entity:PhysicsInit( SOLID_VPHYSICS )
self.Entity:SetMoveType( MOVETYPE_VPHYSICS )							
self.Entity:SetSolid( SOLID_VPHYSICS )
self.Entity:SetUseType( SIMPLE_USE )


local phys = self.Entity:GetPhysicsObject()
if (phys:IsValid()) then
	phys:Wake()
end
end

function ENT:Think()
end 

function ENT:Use( activator, caller )
	umsg.Start("my_message", activator) 	//putting activator here tells the server to only send the message to this player
	umsg.Entity( activator ) 				//not necessary, you could send a dummy bool
											//you might even try sending nothing at all, I don't know if that works
umsg.End()

end

function ENT:Touch( ent )
	if ent.HasHardpoints then
		if ent.Cont && ent.Cont:IsValid() then HPLink( ent.Cont, ent.Entity, self.Entity ) end
	end
end

end


if( CLIENT ) then

function ENT:Draw()

   // self.BaseClass.Draw(self)
   self:DrawEntityOutline( 0.0 ) 			
   self.Entity:DrawModel() 					
   end
   
function my_message_hook( um )
	local player = um:ReadEntity()
	local Wrapping = false
if Wrapping == true then
	High = surface.ScreenHeight()
	Wide = surface.ScreenWidth()
else
	High = 600
	Wide = 800
end
	local files = file.Find( "manuals/manual*.txt" )
	local numfiles = table.Count( files )
	local oWide = (Wide - 50)
	local WRatio = (oWide / numfiles)
	local Intro = file.Read( "manuals/intro.txt" )
	local Instructions = {}
	local tabname = {}	
		cFrame = vgui.Create( "frame" );
		cFrame:SetSize( oWide , High - 50 );
		cFrame:PostMessage( "SetTitle", "text", "User Manual" );
		cFrame:SetPos( 25 , 25 );
		cFrame:SetVisible( true ); 
		
		cLabel = vgui.Create( "label", cFrame );
		cLabel:SetSize( oWide-10 , High - 90 );
		cLabel:SetPos( 10 , 70 );
		cLabel:SetContentAlignment( 7 )
		cLabel:SetText( Intro )


	

	
		for k,v in pairs( files ) do 
	curfile = file.Read( "manuals/"..v )
	cutoff = string.find( curfile , ">T<" )
	tabname[k] = string.Left( curfile , cutoff-1 )
	Instructions[k] = string.Replace( curfile , tabname[k]..">T<" , "" )
	cButton = vgui.Create( "button" , cFrame );
		cButton:SetSize( ( WRatio - 10 ) , 30 );
		cButton:SetPos( ( k - 1 ) * ( WRatio + 5 ) , 35 );
		cButton:SetVisible( true );
		cButton:SetText( tabname[k] );
		function cButton.DoClick()
			cLabel:SetContentAlignment( 7 )
			cLabel:SetText( Instructions[k] );
		end
	end
end
usermessage.Hook("my_message", my_message_hook)   
end


ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "User Manual"
ENT.Author = "Asphid_Jackal"
ENT.Contact = "nullonentry"
ENT.Purpose = "Instructions"
ENT.Instructions = "Read.  Learn.  Know." 
ENT.Category = "SBEP - Other"
ENT.Spawnable = true
ENT.AdminSpawnable = true 
ENT.SPL				= nil
ENT.HPType			= "Book"
ENT.APPos			= Vector(20,0,10)
--[[ENT.APAng			= Angle(0,0,0)]]
ENT.FTime			= 0
ENT.HasHardpoints	= false