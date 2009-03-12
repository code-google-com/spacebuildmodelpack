include('shared.lua')

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