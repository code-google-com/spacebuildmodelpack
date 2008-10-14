// Joyconfig
// Version 1.0
// Written by Night-Eagle

/*

Developer notes:

jcon.register(<tblRegisterFormat>)
		//Returns <tblReg> or nil if your <tblRegisterFormat> is bad.

<tblRegisterFormat> = {
	type = <strType>,
			//"digital" or "analog", case-sensitive.
	
	description = <strDescription>,
			//Keep it to one or two words, user-friendly name.
	
	category = <strCategory>,
			//Groups similar registers, user-friendly name.
	
	max = <intUpperOutputBoundary>,
			//Upper output value for analog type registers (Output scales to a range, see below)
			//Omit to default to 255
	
	min = <intLowerOutputBoundary>,
			//Lower output value for analog type registers (Output scales to a range, see above)
			//Omit to default to 0
}

<tblReg>.IsJoystickReg
<tblReg>:GetValue()
<tblReg>:GetType()
<tblReg>:GetDescription()
<tblReg>:GetCategory()

*/

// TODO:
// Reset invert on bind removal

if not joystick then
	return
end

local Tex_Corner8 	= surface.GetTextureID( "gui/corner8" )
local Tex_Inv = surface.GetTextureID("gui/sniper_corner")
local axisn = function(index,axismod)
	return ({"X","Y","Z","RX","RY","RZ","S1","S2"})[index]..({[0] = "-",[1] = "",[2] = "+"})[axismod or 1]
end

jcon = {}
jcon.version = 1.2

// Current settings globals

// Calibration

jcon.cal = {}
for i=0,joystick.count()-1 do
	jcon.cal[i] = {
		axes = {},
	}
	for axis = 0,7 do
		jcon.cal[i].axes[axis] = {
			max = 65535,
			min = 0,
			scale = 1,
			center = 32767,
			dead = 0,
		}
	end
end

// Session variables
jcon.cur = 1
jcon.m = {
	x=0,
	y=0,
	c=0,
	f=0,
}
jcon.drag = {
	type = nil,
	device = nil,
	index = nil,
	axismod = nil,
	hatpos = nil,
	threshmin = nil,
	threshmax = nil,
}

// End

//Input modification / Calibration
//These functions are not range protected to cut process overhead
jcon.getAxis = function(j,n)
	local s = jcon.cal[j].axes[n]
	local o = joystick.axis(j,n) - s.center
	
	//Msg(s.dead..".")
	if math.abs(o) < s.dead then
		return 32767
	end
	return o*s.scale+32767
end

//Macros
jcon.shat = function(n) //"Simple hat", not the past participle of the verb "shit"
	if n > 36000 then
		return -1
	end
	return n/4500
end

--'
/*
jcon.createbind = function(dat)
	/*
	jcon.createbind{
		device = 0,
		type = "axis",
		index = 0,
		axismod = 1,
		hatpos = 0,
	}
	
	axismod = 0 for left half, 1 for all, 2 for right half (Axes only)
	*//*
	//Msg("Attempting to create a bind for a/an ",dat.type,"...\n")
	if
		type(dat.device) == "number" and
		dat.device >= 0 and
		dat.device <= joystick.count()-1 and
		type(dat.type) == "string" and
		({
			axis = true,
			button = true,
			hat = true,
		})[dat.type] and
		type(dat.index) == "number"
	then
		if dat.type == "axis" and
			type(dat.axismod) == "number" and
			dat.axismod >= 0 and
			dat.axismod <= 2
		then
			//Msg("Created bind for axis!\n")
		elseif dat.type == "button" then
			//Msg("Created bind for button!\n")
		elseif dat.type == "hat" then
			//Msg("Created bind for hat!\n")
		end
	end
end
*/
--'

//GUI Macros
jcon.button = function(self,name,text,dx,dy,w,h,action)
	local dat = {}
	local x = dx + 5
	local y = dy + 28
	if not self:GetTable().buttons then
		self:GetTable().buttons = {}
	end
	
	dat.f = vgui.Create("DButton",self,name)
	dat.f:SetPos(x,y)
	dat.f:SetSize(w,h)
	dat.f:SetText(text)
	dat.f:SetParent(self)
	dat.f.DoClick = action
	self:GetTable().buttons[name] = dat
end

function jcon.buttonActionSignal(self,name)
	local dat = self:GetTable().buttons
	if dat and dat[name] then
		dat[name].a(dat[name].f)
	end
end


jcon.text = function(self,name,text,dx,dy,w,h)
	local x = dx + 5
	local y = dy + 28
	
	local f = vgui.Create("TextEntry",self,name)
	f:SetPos(x,y)
	f:SetSize(w,h)
	f:SetText(text)
	
	return f
end

jcon.label = function(self,name,text,dx,dy,w,h)
	local x = dx + 5
	local y = dy + 28
	
	local f = vgui.Create("Label",self,name)
	f:SetPos(x,y)
	f:SetSize(w,h)
	f:SetText(text)
	
	return f
end

//Panel
jcon.jconpanel = {
	Init = function(self)
		self:GetParent():GetTable().m = {
			x=0,
			y=0,
		}
		self:GetParent():GetTable().cur = jcon.cur
	end,
	Paint = function(self)
		local curdevice = self:GetParent():GetTable().cur
		local status = ""
		//When the new version of Garry's Mod comes out, replace CurTime() in joystick.lua with unpredicted...
		joystick.refresh(curdevice-1)
		
		local m = self:GetParent():GetTable().m
		m.debug = nil
		local c = {
			[1] = Color(0,0,0,50),
			[2] = Color(50,100,255,100),
			[3] = Color(255,0,0,100),
			[4] = Color(0,255,0,100),
		}
		local col = c[1]
		local y = 0
		
		//Current device
		draw.RoundedBox(4,0,y,502,24,col)
		draw.DrawText(curdevice..": "..string.sub(joystick.name(curdevice-1),1,30),"Trebuchet24",5,y,Color(255,255,255,255),0)
		
		//Status bar
		
		y = y + 29
		//Prev Next
		y = y + 29
		
		//Axes
		if m.y > y and m.y < y+179 and m.x > 24 and m.x < 152 then
			col = c[4]
			//surface.SetDrawColor(c[4].r,c[4].g,c[4].b,c[4].a)
			//surface.DrawRect(24,y,128,179)
			
			local axis = math.Round((m.y-y-6)/23)
			local axismod = 1
			if m.x-24 < 32 then
				axismod = 0
			elseif m.x-24 > 96 then
				axismod = 2
			end
			status = "Axis "
			if axis >= 0 and axis <= 7 then
				if axismod == 1 then
					draw.RoundedBox(8,24-4,y+axis*23-4,128+8,18+8,col)
				elseif axismod == 0 then
					draw.RoundedBox(8,24-4,y+axis*23-4,64+8,18+8,col)
				elseif axismod == 2 then
					draw.RoundedBox(8,24-4+64,y+axis*23-4,64+8,18+8,col)
				end
				
				if m.c == 1 then
					jcon.drag = {
						type = "axis",
						device = curdevice-1,
						index = axis,
						axismod = axismod,
						hatpos = nil,
					}
					m.c = 0
				end
			end
			m.debug = axis
			status = status..axisn(axis+1,axismod)
		end
		
		surface.SetDrawColor(c[1].r,c[1].g,c[1].b,c[1].a)
		surface.DrawRect(87,y,2,179)
		surface.SetDrawColor(c[1].r,c[1].g,c[1].b,c[1].a*.5)
		surface.DrawRect(55,y,2,179)
		surface.DrawRect(119,y,2,179)
		surface.SetDrawColor(c[1].r,c[1].g,c[1].b,c[1].a)
		for axis = 0,7 do
			draw.DrawText(axisn(axis+1),"Trebuchet18",12,y+axis*23,Color(255,255,255,255),1)
			surface.SetDrawColor(c[1].r,c[1].g,c[1].b,c[1].a)
			surface.DrawRect(24,y+axis*23,128,18)
			surface.SetDrawColor(c[3].r,c[3].g,c[3].b,c[3].a)
			surface.DrawRect(24,y+axis*23,(jcon.getAxis(curdevice-1,axis)+256)/512,18)
		end
		
		y = y + 184
		
		//Buttons
		
		if m.y > y and m.y < y+198 and m.x > 12 and m.x < 153 then
			col = c[4]
			local sel = {}
			sel.x = math.Round((m.x-24)/29)
			sel.y = math.Round((m.y-y-16)/29)
			local button = sel.y*5+sel.x
			if button >= 0 and button <= 31 then
				draw.RoundedBox(8,8+sel.x*29,y+sel.y*29-4,24+8,24+8,col)
				status = "Button "..button+1
				
				if m.c == 1 then
					jcon.drag = {
						type = "button",
						device = curdevice-1,
						index = button,
						axismod = nil,
						hatpos = nil,
					}
					m.c = 0
				end
			end
		end
		
		surface.SetDrawColor(c[1].r,c[1].g,c[1].b,c[1].a)
		col = c[1]
		local bn = 0
		for by = 0,6 do
			for bx = 0,4 do
				if bn <= 31 then
					if joystick.button(curdevice-1,bn) > 0 then
						col = c[3]
					end
					
					draw.RoundedBox(8,12+bx*29,y+by*29,24,24,col)
					draw.DrawText(bn+1,"Trebuchet18",12+bx*29+12,y+by*29+4,Color(255,255,255,255),1)
					
					bn = bn+1
					col = c[1]
				end
			end
		end
		
		y = y + 203
		
		//Hats
		
		//Hat 0
		if m.y > y and m.y < y+72 and m.x > 2 and m.x < 74 then
			col = c[4]
			//surface.SetDrawColor(c[4].r,c[4].g,c[4].b,c[4].a)
			//surface.DrawRect(2,y,72,72)
			
			local sel = {}
			sel.x = math.Round((m.x-14)/24)
			sel.y = math.Round((m.y-y-12)/24)
			local pos = sel.y*3+sel.x
			
			local mapt = {
				[1] = 0,
				[3] = 6,
				[4] = -1,
				[5] = 2,
				[7] = 4,
			}
			local maptn = {
				[1] = "Up",
				[3] = "Left",
				[4] = "Center",
				[5] = "Right",
				[7] = "Down",
			}
			
			if mapt[pos] then
				draw.RoundedBox(8,2+sel.x*24-4,y+sel.y*24-4,24+8,24+8,col)
				m.debug = mapt[pos]
				status = "Hat 1 "..maptn[pos]
				
				if m.c == 1 then
					jcon.drag = {
						type = "hat",
						device = curdevice-1,
						index = 0,
						axismod = nil,
						hatpos = mapt[pos],
					}
					m.c = 0
				end
			end
		end
		
		do
			col = c[1]
			
			local shat = jcon.shat(joystick.pov(curdevice-1,0))
			local y = y
			local tex = Tex_Corner8
			surface.SetTexture( tex )
			surface.SetDrawColor(col.r,col.g,col.b,col.a)
			
			//Center
			if shat == -1 then
				col = c[3]
			end
			surface.SetDrawColor(col.r,col.g,col.b,col.a)
			surface.DrawRect(26,y+24,24,24)
			draw.DrawText(1,"Trebuchet18",38,y+27,Color(255,255,255,255),1)
			col = c[1]
			
			//Right
			if shat >= 1 and shat <= 3 then
				col = c[3]
			end
			surface.SetDrawColor(col.r,col.g,col.b,col.a)
			surface.DrawRect(50,y+24,16,24)
			surface.DrawRect(66,y+32,8,8)
			surface.DrawTexturedRectRotated(70,y+28,8,8,270)
			surface.DrawTexturedRectRotated(70,y+44,8,8,180)
			col = c[1]
			
			//Up
			if ({[7]=true,[0]=true,[1]=true})[shat] then //I bet you didn't expect that.
				col = c[3]
			end
			surface.SetDrawColor(col.r,col.g,col.b,col.a)
			surface.DrawRect(34,y,8,8)
			surface.DrawRect(26,y+8,24,16)
			surface.DrawTexturedRectRotated(30,y+4,8,8,0)
			surface.DrawTexturedRectRotated(46,y+4,8,8,270)
			col = c[1]
			
			//Left
			if shat >= 5 and shat <= 7 then
				col = c[3]
			end
			surface.SetDrawColor(col.r,col.g,col.b,col.a)
			surface.DrawRect(10,y+24,16,24)
			surface.DrawRect(2,y+32,8,8)
			surface.DrawTexturedRectRotated(6,y+28,8,8,0)
			surface.DrawTexturedRectRotated(6,y+44,8,8,90)
			col = c[1]
			
			//Down
			if shat >= 3 and shat <= 5 then
				col = c[3]
			end
			surface.SetDrawColor(col.r,col.g,col.b,col.a)
			surface.DrawRect(34,y+64,8,8)
			surface.DrawRect(26,y+48,24,16)
			surface.DrawTexturedRectRotated(46,y+68,8,8,180)
			surface.DrawTexturedRectRotated(30,y+68,8,8,90)
			col = c[1]
		end
		
		//Hat 1
		if m.y > y and m.y < y+72 and m.x > 79 and m.x < 151 then
			col = c[4]
			//surface.SetDrawColor(c[4].r,c[4].g,c[4].b,c[4].a)
			//surface.DrawRect(79,y,72,72)
			
			local sel = {}
			sel.x = math.Round((m.x-79-12)/24)
			sel.y = math.Round((m.y-y-12)/24)
			local pos = sel.y*3+sel.x
			
			local mapt = {
				[1] = 0,
				[3] = 6,
				[4] = -1,
				[5] = 2,
				[7] = 4,
			}
			local maptn = {
				[1] = "Up",
				[3] = "Left",
				[4] = "Center",
				[5] = "Right",
				[7] = "Down",
			}
			
			if mapt[pos] then
				draw.RoundedBox(8,79+sel.x*24-4,y+sel.y*24-4,24+8,24+8,col)
				m.debug = mapt[pos]
				status = "Hat 2 "..maptn[pos]
				
				if m.c == 1 then
					jcon.drag = {
						type = "hat",
						device = curdevice-1,
						index = 1,
						axismod = nil,
						hatpos = mapt[pos],
					}
					m.c = 0
				end
			end
		end
		
		do
			col = c[1]
			
			local shat = jcon.shat(joystick.pov(curdevice-1,1))
			local y = y
			local tex = Tex_Corner8
			surface.SetTexture( tex )
			surface.SetDrawColor(col.r,col.g,col.b,col.a)
			
			//Center
			if shat == -1 then
				col = c[3]
			end
			surface.SetDrawColor(col.r,col.g,col.b,col.a)
			surface.DrawRect(103,y+24,24,24)
			draw.DrawText(2,"Trebuchet18",115,y+27,Color(255,255,255,255),1)
			col = c[1]
			
			//Right
			if shat >= 1 and shat <= 3 then
				col = c[3]
			end
			surface.SetDrawColor(col.r,col.g,col.b,col.a)
			surface.DrawRect(127,y+24,16,24)
			surface.DrawRect(143,y+32,8,8)
			surface.DrawTexturedRectRotated(147,y+28,8,8,270)
			surface.DrawTexturedRectRotated(147,y+44,8,8,180)
			col = c[1]
			
			//Up
			if ({[7]=true,[0]=true,[1]=true})[shat] then //I bet you didn't expect that.
				col = c[3]
			end
			surface.SetDrawColor(col.r,col.g,col.b,col.a)
			surface.DrawRect(111,y,8,8)
			surface.DrawRect(103,y+8,24,16)
			surface.DrawTexturedRectRotated(107,y+4,8,8,0)
			surface.DrawTexturedRectRotated(123,y+4,8,8,270)
			col = c[1]
			
			//Left
			if shat >= 5 and shat <= 7 then
				col = c[3]
			end
			surface.SetDrawColor(col.r,col.g,col.b,col.a)
			surface.DrawRect(87,y+24,16,24)
			surface.DrawRect(79,y+32,8,8)
			surface.DrawTexturedRectRotated(83,y+28,8,8,0)
			surface.DrawTexturedRectRotated(83,y+44,8,8,90)
			col = c[1]
			
			//Down
			if shat >= 3 and shat <= 5 then
				col = c[3]
			end
			surface.SetDrawColor(col.r,col.g,col.b,col.a)
			surface.DrawRect(111,y+64,8,8)
			surface.DrawRect(103,y+48,24,16)
			surface.DrawTexturedRectRotated(123,y+68,8,8,180)
			surface.DrawTexturedRectRotated(107,y+68,8,8,90)
		end
		
		//DEBUG CURSOR
		if false then
			surface.SetDrawColor(0,0,0,100)
			surface.DrawRect(m.x,m.y,16,8)
			surface.SetFont("Trebuchet18")
			draw.RoundedBox(4,m.x+16,m.y,surface.GetTextSize(tostring(m.debug))+16,24,Color(0,0,0,100))
			draw.DrawText(tostring(m.debug),"Trebuchet18",m.x+16+8,m.y+4,Color(255,255,255,255),0)
		end
		
		local y = self:GetTall()-24
		//Status bar
		draw.RoundedBox(4,0,y,502,24,col)
		draw.DrawText(status or "","Trebuchet24",5,y,Color(255,255,255,255),0)
		
		//Ensure value
		self:GetParent():GetTable().cur = curdevice
	end,
	OnCursorMoved = function(self,x,y)
		self:GetParent():GetTable().m.x = x
		self:GetParent():GetTable().m.y = y
	end,
	OnCursorExited = function(self)
		self:GetParent():GetTable().m.x = 0
		self:GetParent():GetTable().m.y = 0
		self:GetParent():GetTable().m.c = 0
		self:GetParent():GetTable().m.f = 0
	end,
	OnMousePressed = function(self,mc)
		self:GetParent():GetTable().m.c = 1
		self:GetParent():GetTable().m.f = 0
	end,
	OnMouseReleased = function(self,mc)
		self:GetParent():GetTable().m.c = -1
	end,
}

vgui.Register("jconpanel",jcon.jconpanel)

jcon.menu = function()
	if joystick.count() == 0 then
		//TODO: DirectInput keyboard support.
		Msg("No joysticks detected.\n")
		return
	end
	local menu = {}
	menu.main = jcon.genwhitegui("Device Menu")
		menu.main:SetName("menu.main")
		menu.main:SetPos(math.max(0,ScrW()*.5-512),ScrH()*.5-256)
		menu.main:SetSize(512,576)
		menu.main:SetVisible(true)
		function menu.main:OnClick(key,value)
			jcon.buttonActionSignal(menu.main,key)
		end
	menu.panel = vgui.Create("jconpanel",menu.main,"jconpanel")
		menu.panel:SetPos(5,28)
		menu.panel:SetSize(512-10,576-33)
		menu.panel:SetVisible(true)
		menu.panel:SetMouseInputEnabled(true)
	local y = 0
	//jcon.cur
	y = y + 29
	jcon.button(menu.main,"Prev","<",0,29,24,24,function(self)
		self:GetParent():GetTable().cur = math.max(1,self:GetParent():GetTable().cur-1)
	end)
	jcon.button(menu.main,"Next",">",29,29,24,24,function(self)
		self:GetParent():GetTable().cur = math.min(joystick.count(),self:GetParent():GetTable().cur+1)
	end)
	jcon.button(menu.main,"Calibrate","Calibrate Axes...",58,29,94,24,function(self)
		jcon.calimenu(self:GetParent():GetTable().cur)
	end)
	y = y + 29
end



//
// Axis Calibration
//

jcon.cali = {}

jcon.calimenu = function(curdevice)
	local cali = {}
	local cur
	cur = jcon.genwhitegui("Axis Calibration")
		cur:SetName("jconcalimain")
		cur:SetPos(ScrW()*.5-256,ScrH()*.5-256)
		cur:SetSize(512,512)
		cur:SetVisible(true)
		function cur:OnClick(key,value)
			jcon.buttonActionSignal(self,key)
		end
	cali.main = cur
	
	//Globals
	cali.main:GetTable().joy = curdevice
	cali.main:GetTable().m = {
			x=0,
			y=0,
			c=0,
			f=0,
		}
	cali.main:GetTable().cur = curdevice
	cali.main:GetTable().autocal = {}
	cali.main:GetTable().texMax = {}
	cali.main:GetTable().texMin = {}
	cali.main:GetTable().texCen = {}
	cali.main:GetTable().texSca = {}
	cali.main:GetTable().texDead = {}
	
	//Panel
	cur = vgui.Create("jconcali",cali.main,"jconcali")
		cur:SetPos(5,28)
		cur:SetSize(512-10,512-33)
		cur:SetVisible(true)
		cur:SetMouseInputEnabled(true)
	cali.panel = cur
	
	local y = 0
	y = y + 29
	//Space
	jcon.button(cali.main,"Calibrate","Auto-Calibrate",5,y,147,24,function(self)
		local dat = self:GetParent():GetTable()
		//Start auto-calibrate for all axes
		for i = 0,7 do
			local p = joystick.axis(dat.cur-1,i)
			jcon.cal[dat.cur-1].axes[i] = {
				max = p,
				min = p,
				scale = 0,
				center = p,
				dead = 0,
			}
			dat.autocal[i] = true
			dat.texMax[i]:SetText(p)
			dat.texMin[i]:SetText(p)
			dat.texCen[i]:SetText(p)
			dat.texSca[i]:SetText(0)
		end
	end)
	
	y = y + 29
	//Axes
	local dat = cali.main:GetTable()
	for axis = 0,7 do
		jcon.button(cali.main,"auto"..axis,"Auto",24,y+axis*46+23,64,18,function(self)
			local dat = self:GetParent():GetTable()
			//Start auto-calibrate for single axis
			local p = joystick.axis(dat.cur-1,axis)
			jcon.cal[dat.cur-1].axes[axis] = {
				max = p,
				min = p,
				scale = 0,
				center = p,
				dead = 0,
			}
			dat.autocal[axis] = true
			dat.texMax[axis]:SetText(p)
			dat.texMin[axis]:SetText(p)
			dat.texCen[axis]:SetText(p)
			dat.texSca[axis]:SetText(0)
		end)
		
		jcon.button(cali.main,"reset"..axis,"Reset",88,y+axis*46+23,64,18,function(self)
			local dat = self:GetParent():GetTable()
			//Reset to default
			//local p = joystick.axis(dat.cur-1,axis)
			jcon.cal[dat.cur-1].axes[axis] = {
				max = 65535,
				min = 0,
				scale = 1,
				center = 32767,
				dead = 0,
			}
			dat.autocal[axis] = false
			dat.texMax[axis]:SetText(65535)
			dat.texMin[axis]:SetText(0)
			dat.texCen[axis]:SetText(32767)
			dat.texSca[axis]:SetText(1)
			dat.texDead[axis]:SetText(0)
		end)
		
		local curset = jcon.cal[dat.cur-1].axes[axis]
		jcon.label(cali.main,"maxL"..axis,"Max:",512-40-44-5-24-5,y+axis*46,24,18)
		cali.main:GetTable().texMax[axis] = jcon.text(cali.main,"max"..axis,curset.max,512-40-44-5,y+axis*46,44,18)
		jcon.label(cali.main,"minL"..axis,"Min:",512-40-44-5-24-5-44-5-24,y+axis*46,24,18)
		cali.main:GetTable().texMin[axis] = jcon.text(cali.main,"min"..axis,curset.min,512-40-44-5-24-5-44-5,y+axis*46,44,18)
		jcon.button(cali.main,"setBound"..axis,"Set",512-40,y+axis*46,28,18,function(self)
			local axis = tonumber(string.sub(self:GetName(),9))
			
			if not axis or axis < 0 or axis > 7 then
				return
			end
			
			local dat = self:GetParent():GetTable()
			
			local curset = jcon.cal[dat.cur-1].axes[axis]
			local max = tonumber(dat.texMax[axis]:GetValue())
			local min = tonumber(dat.texMin[axis]:GetValue())
			
			if max and min then
				curset.max = max
				curset.min = min
				if max-min == 0 then
					curset.scale = 0
				else
					curset.scale = math.Round((max-min-1)/65536*100)/100
				end
				curset.center = math.Round((max+min-1)*.5) //-1
				
				dat.texCen[axis]:SetText(curset.center)
				dat.texSca[axis]:SetText(curset.scale)
			else
				dat.texMax[axis]:SetText(curset.max)
				dat.texMin[axis]:SetText(curset.min)
			end
		end)
		
		jcon.label(cali.main,"cenL"..axis,"Cen:",512-40-44-5-24-5,y+axis*46+23,24,18)
		cali.main:GetTable().texCen[axis] = jcon.text(cali.main,"cen"..axis,curset.center,512-40-44-5,y+axis*46+23,44,18)
		jcon.label(cali.main,"scaL"..axis,"Sca:",512-40-44-5-24-5-44-5-24,y+axis*46+23,24,18)
		cali.main:GetTable().texSca[axis] = jcon.text(cali.main,"sca"..axis,curset.scale,512-40-44-5-24-5-44-5,y+axis*46+23,44,18)
		jcon.button(cali.main,"setCenter"..axis,"Set",512-40,y+axis*46+23,28,18,function(self)
			local axis = tonumber(string.sub(self:GetName(),10))
			
			if not axis or axis < 0 or axis > 7 then
				return
			end
			
			local dat = self:GetParent():GetTable()
			
			local curset = jcon.cal[dat.cur-1].axes[axis]
			local cen = tonumber(dat.texCen[axis]:GetValue())
			local sca = tonumber(dat.texSca[axis]:GetValue())
			
			
			if cen and sca then
				curset.cen = cen
				curset.sca = sca
				
				local ds
				if curset.sca == 0 then
					ds = 1
				else
					ds = curset.sca
				end
				
				curset.min = curset.cen-32768*ds+1
				curset.max = curset.cen+32768*ds
				
				dat.texMax[axis]:SetText(curset.max)
				dat.texMin[axis]:SetText(curset.min)
			else
				dat.texCen[axis]:SetText(curset.center)
				dat.texSca[axis]:SetText(curset.scale)
			end
		end)
		
		jcon.label(cali.main,"deadL"..axis,"Deadzone:",24+64+64+5,y+axis*46+23,50,18)
		cali.main:GetTable().texDead[axis] = jcon.text(cali.main,"dead"..axis,curset.dead,24+64+64+5+50+5,y+axis*46+23,36,18)
		jcon.button(cali.main,"setDeadzone"..axis,"Set",24+64+64+5+50+5+36+5,y+axis*46+23,28,18,function(self)
			local axis = tonumber(string.sub(self:GetName(),12))
			
			if not axis or axis < 0 or axis > 7 then
				return
			end
			
			local dat = self:GetParent():GetTable()
			local curset = jcon.cal[dat.cur-1].axes[axis]
			
			local newdead = tonumber(dat.texDead[axis]:GetValue()) or 0
			curset.dead = newdead
		end)
	end
end

//Panel
jcon.jconcali = {
	Init = function(self)
		local dat = self:GetParent():GetTable()
	end,
	Paint = function(self)
		local dat = self:GetParent():GetTable()
		//When the new version of Garry's Mod comes out, replace CurTime() in joystick.lua with unpredicted...
		joystick.refresh(dat.cur-1)
		
		
		//Auto-Calibrate...
		for i,v in pairs(dat.autocal) do
			local curSet = jcon.cal[dat.cur-1].axes[i]
			local curPos = joystick.axis(dat.cur-1,i)+1
			local oldMin = curSet.min+1
			local oldMax = curSet.max+1
			if curPos > oldMax then
				jcon.cal[dat.cur-1].axes[i].max = curPos-1
				local range = curPos-oldMin-1
				if range > 0 then
					jcon.cal[dat.cur-1].axes[i].scale = 65536/range
				end
				//if calibratecenter then
					jcon.cal[dat.cur-1].axes[i].center = oldMin+range*.5-1
				//end
				
				//Update texts
				dat.texMax[i]:SetText(curPos-1)
				dat.texCen[i]:SetText(jcon.cal[dat.cur-1].axes[i].center)
				dat.texSca[i]:SetText(jcon.cal[dat.cur-1].axes[i].scale)
			elseif curPos < oldMin then
				jcon.cal[dat.cur-1].axes[i].min = curPos-1
				local range = oldMax-curPos-1
				if range > 0 then
					jcon.cal[dat.cur-1].axes[i].scale = 65536/range
				end
				//if calibratecenter then
					jcon.cal[dat.cur-1].axes[i].center = curPos+range*.5-1
				//end
				
				//Update texts
				dat.texMin[i]:SetText(curPos-1)
				dat.texCen[i]:SetText(jcon.cal[dat.cur-1].axes[i].center)
				dat.texSca[i]:SetText(jcon.cal[dat.cur-1].axes[i].scale)
			end
			//draw.DrawText(oldMax-oldMin,"Trebuchet18",160,58+i*23,Color(255,255,255,255),0)
			//draw.DrawText(curSet.scale,"Trebuchet18",160,58+i*23,Color(255,255,255,255),0)
			//draw.DrawText(oldMin,"Trebuchet18",160,58+i*23,Color(255,255,255,255),0)
		end
		//Get on with it!
		
		
		local m = jcon.m
		local c = {
			[1] = Color(0,0,0,50),
			[2] = Color(50,100,255,100),
			[3] = Color(255,0,0,100),
		}
		local col = c[1]
		local y = 0
		
		draw.RoundedBox(4,0,y,502,24,col)
		draw.DrawText(dat.cur..": "..string.sub(joystick.name(dat.cur-1),1,30),"Trebuchet24",5,y,Color(255,255,255,255),0)
		
		y = y + 29
		//Space
		y = y + 29
		//Axes
		
		//surface.SetDrawColor(c[1].r,c[1].g,c[1].b,c[1].a)
		//surface.DrawRect(87,y,2,363)
		for axis = 0,7 do
			if axis%2 == 0 then
				surface.SetDrawColor(c[1].r,c[1].g,c[1].b,c[1].a)
				surface.DrawRect(0,y+axis*46-2.5,512,46)
			end
			
			surface.SetDrawColor(c[1].r,c[1].g,c[1].b,c[1].a)
			surface.DrawRect(24+128-1,y+axis*46,2,18)
			draw.DrawText(axisn(axis+1),"Trebuchet18",12,y+axis*46+12,Color(255,255,255,255),1)
			surface.SetDrawColor(c[1].r,c[1].g,c[1].b,c[1].a)
			surface.DrawRect(24,y+axis*46,256,18)
			surface.SetDrawColor(c[3].r,c[3].g,c[3].b,c[3].a)
			surface.DrawRect(24,y+axis*46,(jcon.getAxis(dat.cur-1,axis)+256)/256,18)
			
			local curSet = jcon.cal[dat.cur-1].axes[axis]
			local curPos = joystick.axis(dat.cur-1,axis)
			//local curPos = jcon.getAxis(dat.cur-1,axis)
			draw.DrawText(curSet.min,"Trebuchet18",24,y+axis*46,Color(255,255,255,255),0)
			draw.DrawText(curPos,"Trebuchet18",24+128,y+axis*46,Color(255,255,255,255),1)
			draw.DrawText(curSet.max,"Trebuchet18",24+256,y+axis*46,Color(255,255,255,255),2)
		end
		
		y = y + 368
		surface.SetDrawColor(0,0,0,100)
		surface.DrawRect(0,y,512,18)
	end,
	OnCursorMoved = function(self,x,y)
		local dat = self:GetParent():GetTable()
		dat.m.x = x
		dat.m.y = y
	end,
	OnCursorExited = function(self)
		local dat = self:GetParent():GetTable()
		dat.m.x = 0
		dat.m.y = 0
		dat.m.c = 0
		dat.m.f = 0
	end,
	OnMousePressed = function(self,mc)
		local dat = self:GetParent():GetTable()
		dat.m.c = 1
		dat.m.f = 0
	end,
	OnMouseReleased = function(self,mc)
		local dat = self:GetParent():GetTable()
		dat.m.c = -1
	end,
}

vgui.Register("jconcali",jcon.jconcali)

jcon.paint = function()
	local m = jcon.m
	m.x, m.y = gui.MousePos()
	
	if jcon.drag.type then
		draw.RoundedBox(4,m.x+12,m.y,64,40,Color(0,0,0,150))
		local disp = jcon.drag.type
		disp = string.upper(string.sub(disp,1,1))..string.sub(disp,2)
		if jcon.drag.type == "axis" then
			local disp = axisn(jcon.drag.index+1,jcon.drag.axismod)
			draw.DrawText(disp,"Trebuchet18",m.x+18,m.y+22,Color(255,255,255,255),0)
		elseif jcon.drag.type == "button" then
			draw.DrawText(jcon.drag.index+1,"Trebuchet18",m.x+18,m.y+22,Color(255,255,255,255),0)
		elseif jcon.drag.type == "hat" then
			local maptr = {
				[0] = "Up",
				[6] = "Left",
				[-1] = "Center",
				[2] = "Right",
				[4] = "Down",
			}
			disp = disp.." "..jcon.drag.index+1
			draw.DrawText(tostring(maptr[jcon.drag.hatpos]),"Trebuchet18",m.x+18,m.y+22,Color(255,255,255,255),0)
		end
		
		draw.DrawText(disp,"Trebuchet18",m.x+18,m.y+2,Color(255,255,255,255),0)
	end
end

hook.Add("PostRenderVGUI","jcon.paint",jcon.paint)

jcon.mpress = function(mc)
	jcon.m.c = 1
end
jcon.mrel = function(mc)
	jcon.m.c = -1
	jcon.drag = {}
end

hook.Add("GUIMousePressed","jcon.mpress",jcon.mpress)
hook.Add("GUIMouseReleased","jcon.mrel",jcon.mrel)



//
// Control Registration
//

jcon.reg = {}


//
// Console Command
//

jcon.reg.start = function()
	jcon.menu()
	jcon.reg.menu()
end
concommand.Add("joyconfig",jcon.reg.start)

//
// Menu
//

jcon.reg.menu = function()
	local menu = {}
	local cur
	cur = jcon.genwhitegui("Joystick Configuration")
		cur:SetName("jfigmain")
		cur:SetPos(ScrW()*.5,ScrH()*.5-256)
		cur:SetSize(512,512)
		cur:SetVisible(true)
		function cur:OnClick(key,value)
			jcon.buttonActionSignal(self,key)
		end
	menu.main = cur
	
	cur = vgui.Create("jfigmenu",menu.main,"jfigmenu")
		cur:SetPos(5,28)
		cur:SetSize(512-10,512-33)
		cur:SetVisible(true)
		cur:SetMouseInputEnabled(true)
	menu.panel = cur
	
	jcon.button(menu.main,"openJoystick","Device Menu",5,5,96,18,function(self)
		jcon.menu()
	end)
end

jcon.reg.form  = {
	Init = function(self)
		local dat = self:GetParent():GetTable()
		dat.m = {
			x=0,
			y=0,
		}
		dat.scroll = 1
	end,
	Paint = function(self)
		local dat = self:GetParent():GetTable()
		local m = dat.m
		local status = ""
		
		local scrollmax = 1
		if dat.tabcat then
			scrollmax = #jcon.reg.cat[dat.tabcat]
		end
		
		//When the new version of Garry's Mod comes out, replace CurTime() in joystick.lua with unpredicted...
		//joystick.refresh(dat.cur-1)
		
		local cols = {
			Unsel = Color(0,0,0,50),
			Sel = Color(0,255,0,100),
			Press = Color(255,0,0,100),
			Act = Color(0,0,255,100),
		}
		local col = cols.Unsel
		
		//Background for registers
		draw.RoundedBox(4,10+128,2,364,453,Color(0,0,0,100))
		
		//Scrollbars
		draw.RoundedBox(4,10+128+344,2+4,16,453-8,Color(255,255,255,63))
		
		local s = {}
		
		if m.x >= 482 and m.x <= 498 and m.y >= 6 and m.y <= 451 then
			if m.y <= 22 then
				s[1] = true
			elseif m.y >= 435 then
				s[3] = true
			else
				s[2] = true
			end
		end
		if s[1] then
			if m.c == 1 then
				m.c = 0
				m.f = "scrollup"
			elseif m.c == -1 and m.f == "scrollup" then
				m.c = 0
				m.f = 0
				dat.scroll = dat.scroll-1
				if dat.scroll < 1 then
					dat.scroll = 1
				end
			end
			
			if not (m.f == "scrollup") then
				draw.RoundedBox(4,482+2,6+2,12,12,Color(0,255,0,100))
			else
				draw.RoundedBox(4,482+2,6+2,12,12,Color(255,0,0,100))
			end
		else
			draw.RoundedBox(4,482+2,6+2,12,12,Color(0,0,0,100))
		end
		if s[3] then
			if m.c == 1 then
				m.c = 0
				m.f = "scrolldown"
			elseif m.c == -1 and m.f == "scrolldown" then
				m.c = 0
				m.f = 0
				dat.scroll = dat.scroll+1
				if dat.scroll > scrollmax-8 then
					dat.scroll = math.max(1,scrollmax-8)
				end
			end
			
			if not (m.f == "scrolldown") then
				draw.RoundedBox(4,482+2,435+2,12,12,Color(0,255,0,100))
			else
				draw.RoundedBox(4,482+2,435+2,12,12,Color(255,0,0,100))
			end
		else
			draw.RoundedBox(4,482+2,435+2,12,12,Color(0,0,0,100))
		end
		
		do
			local mpos = 22+((dat.scroll-1)/(scrollmax-8))*413
			local mtall = 1/math.max(1,(scrollmax-8))*413
			
			if s[2] then
				if m.c == 1 then
					m.c = 0
					m.f = "scroll"
					
					dat.scroll = math.Clamp(math.floor((m.y-22)*(scrollmax-8)/413)+1,1,math.max(1,scrollmax-8))
					mpos = 22+((dat.scroll-1)/(scrollmax-8))*413
					mtall = 1/math.max(1,(scrollmax-8))*413
				elseif m.c == -1 and m.f == "scroll" then
					m.c = 0
					m.f = 0
				end
				
				if m.f ~= "scroll" then
					draw.RoundedBox(4,484,mpos,12,mtall,Color(0,255,0,100))
				else
					dat.scroll = math.Clamp(math.floor((m.y-22)*(scrollmax-8)/413)+1,1,math.max(1,scrollmax-8))
					mpos = 22+((dat.scroll-1)/(scrollmax-8))*413
					mtall = 1/math.max(1,(scrollmax-8))*413
					draw.RoundedBox(4,484,mpos,12,mtall,Color(255,0,0,100))
				end
			else
				draw.RoundedBox(4,484,mpos,12,mtall,Color(0,0,0,100))
			end
		end
		
		//Macros
		local transBind = function(reg)
			local bind = reg.bind
			bind.type = jcon.drag.type
			bind.device = jcon.drag.device
			bind.index = jcon.drag.index
			bind.axismod = jcon.drag.axismod
			bind.hatpos = jcon.drag.hatpos
			
			if reg.type == "digital" and bind.type == "axis" then
				//Increased by 1 to prevent errors from truncating of values (And to get over the neutral hump)
				bind.threshmin = jcon.drag.threshmin or ({[true] = 32767, [false] = 49151})[bind.axismod ~= 1]
				bind.threshmax = jcon.drag.threshmax or 65535
			end
			
			jcon.drag = {}
		end
		
		//Y Pos
		local y = 5
		y = y+18+5
		
		//Category listing
		
		local cats = 0
		for k,v in pairs(jcon.reg.cat) do
			cats = cats + 1
		end
		
		local sel = math.Round((m.y-y+10)/20)
		local press = -1
		if m.x >= 5 and m.x <= 138 and sel >= 1 and sel <= cats then
			sel = sel-1
			if m.c == 1 then
				m.f = "tab"..sel
				m.c = 0
			elseif m.c == -1 and m.f == "tab"..sel then
				m.c = 0
				m.f = 0
				dat.tab = sel
				dat.scroll = 1
			elseif m.c == 0 and m.f == "tab"..sel then
				press = sel
			end
		else
			sel = -1
		end
		
		surface.SetTexture(Tex_Corner8)
		local i = 0
		for k,v in pairs(jcon.reg.cat) do
			if dat.tab ~= i then
				if i ~= sel and i ~= press then
					col = cols.Unsel
				elseif i == press then
					col = cols.Press
				else
					col = cols.Sel
				end
				
				surface.SetDrawColor(col.r,col.g,col.b,col.a)
				surface.DrawRect(13,y+20*i,128-3,20)
				surface.DrawRect(5,y+20*i+8,8,4)
				surface.DrawTexturedRectRotated(9,y+20*i+4,8,8,0)
				surface.DrawTexturedRectRotated(9,y+20*i+16,8,8,90)
			else
				dat.tabcat = k
			end
			
			draw.DrawText(k,"Trebuchet18",10,y+20*i+2,Color(255,255,255,255),0)
			i = i+1
		end
		if tonumber(dat.tab) and dat.tab >= 0 and dat.tab <= cats-1 then
			local k = dat.tabcat
			local v = jcon.reg.cat[k]
			i = dat.tab
			
			col = cols.Unsel
			surface.SetDrawColor(col.r,col.g,col.b,col.a)
			do
				surface.DrawRect(13,y+20*i,128-3,20)
				surface.DrawRect(5,y+20*i+8,8,4)
				surface.DrawTexturedRectRotated(9,y+20*i+4,8,8,0)
				surface.DrawTexturedRectRotated(9,y+20*i+16,8,8,90)
			end
			col = cols.Act
			surface.SetDrawColor(col.r,col.g,col.b,col.a)
			do
				surface.DrawRect(13,y+20*i,128-3,20)
				surface.DrawRect(5,y+20*i+8,8,4)
				surface.DrawTexturedRectRotated(9,y+20*i+4,8,8,0)
				surface.DrawTexturedRectRotated(9,y+20*i+16,8,8,90)
			end
			surface.SetTexture(Tex_Inv)
			surface.DrawTexturedRectRotated(130,y+20*i-8,16,16,180)
			surface.DrawTexturedRectRotated(130,y+20*i+20+8,16,16,270)
			surface.SetTexture(Tex_Corner8)
			
			draw.DrawText(k,"Trebuchet18",10,y+20*i+2,Color(255,255,255,255),0)
			
			--"
			--" Draw the registration forms
			--"
			
			local sel = -1
			if m.x >= 143 and m.x <= 497-21 and m.y >= 7 and m.y <= 450 then
				sel = math.floor((m.y-7+2.5)/50)
			end
			
			//for n,reg in pairs(v) do
			local n = -1
			for nn = dat.scroll,math.min(dat.scroll+8,#v) do
				reg = v[nn]
				n = n+1
				local col = Color(0,0,0,100)
				local hover = {}
				if sel == n then
					local runReg = true
					if reg.type == "analog" and
						m.x >= 138+10+128+5 and
						m.x <= 138+10+128+5+18 and
						m.y >= 50*n+2+10+18 and
						m.y <= 50*n+2+10+18+18
					then
						hover.Invert = true
						runReg = false
					elseif reg.type == "digital" then
						if reg.bind.type == "axis" and
							m.x >= 333-13 and
							m.x <= 333-13+18 and
							m.y >= 50*n+2+10+18 and
							m.y <= 50*n+2+10+18+18
						then
							hover.Invert = true
							runReg = false
						end
						if reg.bind.type == "axis" and
							m.x >= 333+10 and
							m.x <= 333+10+128 and
							m.y >= 50*n+2+10+18 and
							m.y <= 50*n+2+10+18+18
						then
							hover.Thresh = true
							runReg = false
						end
						
					end
					if runReg then
						if m.c == 1 then
							m.f = "reger"..n
							m.c = 0
						elseif m.c == -1 and m.f == "reger"..n then
							m.f = 0
							m.c = 0
							if jcon.drag then
								transBind(reg)
							end
						elseif m.c == -1 and jcon.drag.type then
							transBind(reg)
						end
						
						if m.f == "reger"..n then
							col = cols.Press
						else
							col = cols.Sel
						end
					end
				end
				draw.RoundedBox(4,138+5,2+5+50*n,333,45,col)
				draw.DrawText(reg.description,"Trebuchet18",138+12,50*n+2+5+4,Color(255,255,255,255),0)
				if tonumber(reg.bind.device) and reg.bind.device >= 0 and reg.bind.device <= joystick.count()-1 then
					draw.DrawText(joystick.name(reg.bind.device),"Trebuchet18",138+12+333-13,50*n+2+5+4,Color(255,255,255,255),2)
				end
				
				if reg.type == "analog" then
					surface.SetDrawColor(255,255,255,63)
					surface.DrawRect(138+10,50*n+2+10+18,128,18)
					surface.SetDrawColor(0,0,0,100)
					surface.DrawRect(138+10+63,50*n+2+10+18,2,18)
					surface.SetDrawColor(0,0,0,50)
					surface.DrawRect(138+10+31,50*n+2+10+18,2,18)
					surface.DrawRect(138+10+95,50*n+2+10+18,2,18)
					
					surface.SetDrawColor(0,255,0,150)
					surface.DrawRect(138+10,50*n+2+10+18,reg:getraw()/512,18)
					
					draw.RoundedBox(4,138+10+128+5,50*n+2+10+18,18,18,Color(255,255,255,63))
					if hover.Invert then
						if m.c == 1 then
							if not jcon.drag.type then
								m.c = 0
								m.f = "invert"..n
							else
								m.c = 0
								m.f = 0
								transBind(reg)
							end
						elseif m.c == -1 and m.f == "invert"..n then
							m.c = 0
							m.f = 0
							
							reg.bind.invert = not reg.bind.invert
						elseif m.c == -1 and jcon.drag.type then
							m.c = 0
							m.f = 0
							transBind(reg)
						end
						
						if m.f ~= "invert"..n then
							draw.RoundedBox(4,138+10+128+5,50*n+2+10+18,18,18,Color(0,255,0,150))
						else
							draw.RoundedBox(4,138+10+128+5,50*n+2+10+18,18,18,Color(255,0,0,150))
						end
					end
					
					if reg.bind.invert then
						draw.DrawText("X","Trebuchet18",138+10+128+14,50*n+2+10+19,Color(255,255,255,255),1)
					end
					if reg.bind.type == "axis" then
						draw.DrawText(axisn(reg.bind.index+1,reg.bind.axismod),"Trebuchet18",333+10+128,50*n+2+10+19,Color(255,255,255,255),2)
					elseif tonumber(reg.bind.index) then
						if reg.bind.type == "button" then
							draw.DrawText("Button "..reg.bind.index+1,"Trebuchet18",333+137,50*n+2+10+19,Color(255,255,255,255),2)
						elseif reg.bind.type == "hat" then
							local maptr = {
								[0] = "Up",
								[6] = "Left",
								[-1] = "Center",
								[2] = "Right",
								[4] = "Down",
							}
							draw.DrawText("Hat "..reg.bind.index+1 .." "..maptr[reg.bind.hatpos],"Trebuchet18",333+137,50*n+2+10+19,Color(255,255,255,255),2)
						end
					end
				elseif reg.type == "digital" then
					local col
					draw.RoundedBox(8,138+10,50*n+2+10+18,18,18,Color(255,255,255,63))
					if reg:GetValue() then
						draw.RoundedBox(8,138+10,50*n+2+10+18,18,18,Color(0,255,0,150))
					end
					
					if reg.bind.type == "axis" then
						surface.SetDrawColor(255,255,255,63)
						surface.DrawRect(333+10,50*n+2+10+18,128,18)
						surface.SetDrawColor(0,0,0,100)
						surface.DrawRect(333+10+63,50*n+2+10+18,2,18)
						surface.SetDrawColor(0,0,0,50)
						surface.DrawRect(333+10+31,50*n+2+10+18,2,18)
						surface.DrawRect(333+10+95,50*n+2+10+18,2,18)
						
						surface.SetDrawColor(255,0,0,150)
						surface.DrawRect(333+10,50*n+2+10+18,reg:getanalog()/512,18)
						
						local t = {}
						t.i = (tonumber(reg.bind.threshmin)/512) or 128
						t.a = ((tonumber(reg.bind.threshmax)/512) or 128) - t.i
						surface.SetDrawColor(0,0,255,150)
						if hover.Thresh then
							if m.c == 1 then
								if not jcon.drag.type then
									m.c = 0
									m.f = "thresh"..n
								else
									m.c = 0
									m.f = 0
									transBind(reg)
								end
							elseif m.c == -1 and m.f == "thresh"..n then
								m.c = 0
								m.f = 0
							elseif m.c == -1 and jcon.drag.type then
								m.c = 0
								m.f = 0
								transBind(reg)
							end
							
							if m.f ~= "thresh"..n then
								surface.SetDrawColor(0,255,0,150)
							else
								surface.SetDrawColor(255,255,0,150)
								
								reg.bind.threshmin = math.Clamp(math.Round((m.x-343)/8)*8*512,0,65535)
								
								t.i = (tonumber(reg.bind.threshmin)/512) or 128
								t.a = ((tonumber(reg.bind.threshmax)/512) or 128) - t.i
							end
						end
						surface.DrawRect(343+t.i,50*n+30,t.a,9)
						
						draw.RoundedBox(4,333-13,50*n+2+10+18,18,18,Color(255,255,255,63))
						if hover.Invert then
							if m.c == 1 then
								if not jcon.drag.type then
									m.c = 0
									m.f = "invert"..n
								else
									m.c = 0
									m.f = 0
									transBind(reg)
								end
							elseif m.c == -1 and m.f == "invert"..n then
								m.c = 0
								m.f = 0
								
								reg.bind.invert = not reg.bind.invert
							elseif m.c == -1 and jcon.drag.type then
								m.c = 0
								m.f = 0
								transBind(reg)
							end
							
							if m.f ~= "invert"..n then
								draw.RoundedBox(4,333-13,50*n+2+10+18,18,18,Color(0,255,0,150))
							else
								draw.RoundedBox(4,333-13,50*n+2+10+18,18,18,Color(255,0,0,150))
							end
						end
						
						if reg.bind.invert then
							draw.DrawText("X","Trebuchet18",333-13+9,50*n+2+10+19,Color(255,255,255,255),1)
						end
						
						draw.DrawText(axisn(reg.bind.index+1,reg.bind.axismod),"Trebuchet18",333+10+64,50*n+2+10+19,Color(255,255,255,255),1)
					elseif tonumber(reg.bind.index) then
						if reg.bind.type == "button" then
							draw.DrawText("Button "..reg.bind.index+1,"Trebuchet18",333+137,50*n+2+10+19,Color(255,255,255,255),2)
						elseif reg.bind.type == "hat" then
							local maptr = {
								[0] = "Up",
								[6] = "Left",
								[-1] = "Center",
								[2] = "Right",
								[4] = "Down",
							}
							draw.DrawText("Hat "..reg.bind.index+1 .." "..maptr[reg.bind.hatpos],"Trebuchet18",333+137,50*n+2+10+19,Color(255,255,255,255),2)
						end
					end
				end
			end
		end
		
		local col = Color(0,0,0,100)
		y = self:GetTall()-24
		draw.RoundedBox(4,0,y,502,24,col)
		draw.DrawText(status or "","Trebuchet24",5,y,Color(255,255,255,255),0)
		
		if m.c == -1 then
			m.c = 0
		end
	end,
	OnCursorMoved = function(self,x,y)
		local dat = self:GetParent():GetTable()
		dat.m.x = x
		dat.m.y = y
	end,
	OnCursorExited = function(self)
		local dat = self:GetParent():GetTable()
		dat.m.x = 0
		dat.m.y = 0
		dat.m.c = 0
		dat.m.f = 0
	end,
	OnMousePressed = function(self,mc)
		local dat = self:GetParent():GetTable()
		dat.m.c = 1
		dat.m.f = 0
	end,
	OnMouseReleased = function(self,mc)
		local dat = self:GetParent():GetTable()
		dat.m.c = -1
	end,
	OnMouseWheeled = function(self,delta)
		local dat = self:GetParent():GetTable()
		
		local scrollmax = 1
		if dat.tabcat then
			scrollmax = #jcon.reg.cat[dat.tabcat]
		end
		
		dat.scroll = math.Clamp(dat.scroll - delta,1,math.max(1,scrollmax-8))
	end,
}
vgui.Register("jfigmenu",jcon.reg.form)

//
// Functions
//
jcon.Load = function()
	
end
hook.Add("Initialize","JCONInit",jcon.Load)

jcon.Save = function()
	
end
hook.Add("ShutDown","JCONEnd",jcon.Save)

jcon.reg.cat = {}

jcon.register = function(dat)
	if
		(dat.type == "analog" or
		dat.type == "digital") and
		type(dat.description) == "string" and
		type(dat.category) == "string"
	then
		if not jcon.reg.cat[dat.category] then
			jcon.reg.cat[dat.category] = {}
		else
			for k,v in pairs(jcon.reg.cat[dat.category]) do
				if v.description == dat.description then
					return v
				end
			end
		end
		jcon.reg.cat[dat.category][#jcon.reg.cat[dat.category]+1] = {}
		local catreg = jcon.reg.cat[dat.category][#jcon.reg.cat[dat.category]]
		
		catreg.type = dat.type
		catreg.description = dat.description
		if dat.type == "analog" then
			catreg.min = dat.min or 0
			catreg.max = dat.max or 255
			catreg.value = 0
			catreg.bind = {}
			catreg.getdigital = function(self)
				if self.bind.type == "button" then
					return joystick.button(self.bind.device,self.bind.index) > 0
				elseif self.bind.type == "hat" then
					local n = jcon.shat(joystick.pov(self.bind.device,self.bind.index))
					if n == 0 and self.bind.hatpos == -1 then
						return false
					end
					if n == self.bind.hatpos or n == self.bind.hatpos+1 or ((n == self.bind.hatpos-1 and self.bind.hatpos > 0) or (self.bind.hatpos == 0 and n == 7)) then
						return true
					else
						return false
					end
				end
			end
			catreg.getraw = function(self)
				if self.bind.type == "axis" then
					local dat = jcon.getAxis(self.bind.device,self.bind.index)
					local ret = self.value
					
					if self.bind.axismod == 1 then
						ret = math.Clamp(dat,0,65535)
					elseif self.bind.axismod == 0 then
						ret = math.Clamp(65535-dat*2,0,65535)
					elseif self.bind.axismod == 2 then
						ret = math.Clamp(dat*2-65535,0,65535)
					else
						return ret
					end
					
					if self.bind.invert then
						ret = 65535-ret
					end
					
					return ret
				else
					local ret = self:getdigital()
					if ret == nil then
						return self.value
					else
						if self.bind.invert then
							ret = not ret
						end
						return ({[true]=65535,[false]=0})[ret]
					end
				end
			end
			catreg.GetValue = function(self)
			joystick.refresh(self.bind.device)
				return (self:getraw()+self.min)*(self.max-self.min)/65535
			end
		elseif dat.type == "digital" then
			catreg.value = false
			catreg.bind = {}
			catreg.getanalog = function(self)
				local dat = jcon.getAxis(self.bind.device,self.bind.index)
				local ret = self.value
				
				if self.bind.axismod == 1 then
					ret = math.Clamp(dat,0,65535)
				elseif self.bind.axismod == 0 then
					ret = math.Clamp(65535-dat*2,0,65535)
				elseif self.bind.axismod == 2 then
					ret = math.Clamp(dat*2-65535,0,65535)
				else
					return ret
				end
				
				if self.bind.invert then
					ret = 65535-ret
				end
				
				return ret
			end
			catreg.GetValue = function(self)
			joystick.refresh(self.bind.device)
				if self.bind.type == "button" then
					return joystick.button(self.bind.device,self.bind.index) > 0
				elseif self.bind.type == "hat" then
					local n = jcon.shat(joystick.pov(self.bind.device,self.bind.index))
					if n == 0 and self.bind.hatpos == -1 then
						return false
					end
					if n == self.bind.hatpos or n == self.bind.hatpos+1 or ((n == self.bind.hatpos-1 and self.bind.hatpos > 0) or (self.bind.hatpos == 0 and n == 7)) then
						return true
					else
						return false
					end
				elseif self.bind.type == "axis" then
					local n = self:getanalog()
					if n >= self.bind.threshmin and n <= self.bind.threshmax then
						return true
					end
					return false
				end
			end
		end
		
		catreg.IsJoystickReg = true
		catreg.GetType = function(self)
			return self.type
		end
		catreg.GetDescription = function(self)
			return self.description
		end
		catreg.GetCategory = function(self)
			return self.category
		end
		dat.type = nil
		dat.description = nil
		dat.category = nil
		for k,v in pairs(dat) do
			catreg[k] = v
		end
		return catreg
	end
end


/*
The only things you should use from a joystick register:

reg.IsJoystickReg
reg:GetValue()
reg:GetType()
reg:GetDescription()
reg:GetCategory()
*/
























































jcon.whitegui = [[
"hud.res"
{
	"whitegui"
	{
		"ControlName"		"Frame"
		"fieldName"		"eInv"
		"xpos"		"475"
		"ypos"		"355"
		"zpos"		"290"
		"wide"		"400"
		"tall"		"66"
		"autoResize"		"0"
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"settitlebarvisible"		"1"
		"title"		"%TITLE%"
		"sizable"		"1"
	}
	"frame_topGrip"
	{
		"ControlName"		"Panel"
		"fieldName"		"frame_topGrip"
		"xpos"		"8"
		"ypos"		"0"
		"wide"		"384"
		"tall"		"5"
		"autoResize"		"0"
		"pinCorner"		"0"
		"visible"		"0"
		"enabled"		"1"
		"tabPosition"		"0"
	}
	"frame_bottomGrip"
	{
		"ControlName"		"Panel"
		"fieldName"		"frame_bottomGrip"
		"xpos"		"8"
		"ypos"		"61"
		"wide"		"374"
		"tall"		"5"
		"autoResize"		"0"
		"pinCorner"		"0"
		"visible"		"0"
		"enabled"		"1"
		"tabPosition"		"0"
	}
	"frame_leftGrip"
	{
		"ControlName"		"Panel"
		"fieldName"		"frame_leftGrip"
		"xpos"		"0"
		"ypos"		"0"
		"wide"		"5"
		"tall"		"66"
		"autoResize"		"0"
		"pinCorner"		"0"
		"visible"		"0"
		"enabled"		"1"
		"tabPosition"		"0"
	}
	"frame_rightGrip"
	{
		"ControlName"		"Panel"
		"fieldName"		"frame_rightGrip"
		"xpos"		"395"
		"ypos"		"0"
		"wide"		"5"
		"tall"		"66"
		"autoResize"		"0"
		"pinCorner"		"0"
		"visible"		"0"
		"enabled"		"1"
		"tabPosition"		"0"
	}
	"frame_tlGrip"
	{
		"ControlName"		"Panel"
		"fieldName"		"frame_tlGrip"
		"xpos"		"0"
		"ypos"		"0"
		"wide"		"8"
		"tall"		"8"
		"autoResize"		"0"
		"pinCorner"		"0"
		"visible"		"0"
		"enabled"		"1"
		"tabPosition"		"0"
	}
	"frame_trGrip"
	{
		"ControlName"		"Panel"
		"fieldName"		"frame_trGrip"
		"xpos"		"392"
		"ypos"		"0"
		"wide"		"8"
		"tall"		"8"
		"autoResize"		"0"
		"pinCorner"		"0"
		"visible"		"0"
		"enabled"		"1"
		"tabPosition"		"0"
	}
	"frame_blGrip"
	{
		"ControlName"		"Panel"
		"fieldName"		"frame_blGrip"
		"xpos"		"0"
		"ypos"		"58"
		"wide"		"8"
		"tall"		"8"
		"autoResize"		"0"
		"pinCorner"		"0"
		"visible"		"0"
		"enabled"		"1"
		"tabPosition"		"0"
	}
	"frame_brGrip"
	{
		"ControlName"		"Panel"
		"fieldName"		"frame_brGrip"
		"xpos"		"382"
		"ypos"		"48"
		"wide"		"18"
		"tall"		"18"
		"autoResize"		"0"
		"pinCorner"		"0"
		"visible"		"0"
		"enabled"		"1"
		"tabPosition"		"0"
	}
	"frame_caption"
	{
		"ControlName"		"Panel"
		"fieldName"		"frame_caption"
		"xpos"		"0"
		"ypos"		"0"
		"wide"		"390"
		"tall"		"23"
		"autoResize"		"0"
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"		"0"
	}
}
]]

jcon.genwhitegui = function(caption)
	local frame = vgui.Create("Frame")
	frame:SetName("whitegui")
	frame:LoadControlsFromString(string.gsub(jcon.whitegui,"%%TITLE%%",caption))
	frame:SetName("caption")
	return frame
end

hook.Add("PopulateToolMenu", "AddJSConfigMenu", function()
													spawnmenu.AddToolMenuOption("Utilities", "Joystick", "JoystickMenu", "JoystickMenu", "", "", function(Panel)
																																					Panel:AddControl("Header", {Text = "Joystick Configuration Menu", Description = "Joystick Configuration Menu"})
																																					Panel:AddControl("Button", {Label = "Open Joystick Configuration Menu...", Command = "joyconfig"})
																																				 end, {})
												end)

Msg("Night-Eagle's joystick configurator loaded.\nVersion ", jcon.version, ".\n")
