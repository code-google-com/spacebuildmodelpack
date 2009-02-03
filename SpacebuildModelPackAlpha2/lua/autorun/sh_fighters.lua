--[[
VecOff is a local vector offset, use it to reposition the vehicle
AngOff is a rotational offset, use it if the vehicle faces up or right
Docklist is a list of the Hangars the ship can dock at
all names lower case because the GetName() function returns lowercase sometimes
]]
--[[The table heirachy has been designed so that you decide what the largest ship you'll allow
into the hangar is and all the smaller classes will also be able to dock at it.
Semi-counter-intuitively this means that the small table has the most entries.]]
local heavy = {"swordhangarspacious","deck","deckdouble","deckdoublewide","landingpad"}
local large = {"dockingclamp", "dockingclampt", "dockingclampx","mbhangarside2"}
table.Add(large,heavy)
local medium = {"swordhangar", "swordhangarlarge","swordhangarsingle"}
table.Add(medium,large)
local small = {"sbhangar","sbfighterbay1","sbfighterbay2","sbfighterbay3","sbfighterbay4","sbclamp"}
table.Add(small,medium)
local tiny = {}
table.Add(tiny,small)
list.Set("sbepfighters","cratemover",		{VecOff=Vector(0,0,145), 	AngOff=Angle(0,0,0), Docklist=heavy})
list.Set("sbepfighters","largetransport",	{VecOff=Vector(0,0,105), 	AngOff=Angle(0,0,0), Docklist=large})
list.Set("sbepfighters","sai",				{VecOff=Vector(-21,0,13), 	AngOff=Angle(0,0,0), Docklist=large})
list.Set("sbepfighters","smalltransport",	{VecOff=Vector(0,0,75), 	AngOff=Angle(0,0,0), Docklist=medium})
list.Set("sbepfighters","sword",			{VecOff=Vector(40,0,80), 	AngOff=Angle(0,0,0), Docklist=medium})
list.Set("sbepfighters","spike",			{VecOff=Vector(256,0,0), 	AngOff=Angle(0,0,0), Docklist=medium})
list.Set("sbepfighters","fork",				{VecOff=Vector(69,0,-11), 	AngOff=Angle(0,0,0), Docklist=medium})
list.Set("sbepfighters","katana",			{VecOff=Vector(0,0,0), 		AngOff=Angle(0,0,0), Docklist=medium})
list.Set("sbepfighters","knife",			{VecOff=Vector(-75,0,15), 	AngOff=Angle(0,0,0), Docklist=small})
list.Set("sbepfighters","sawblade",			{VecOff=Vector(-96,0,0), 	AngOff=Angle(0,0,0), Docklist=small})
list.Set("sbepfighters","arwing",			{VecOff=Vector(0,0,40), 	AngOff=Angle(0,0,0), Docklist=small})
list.Set("sbepfighters","clunker",			{VecOff=Vector(0,0,60), 	AngOff=Angle(0,0,0), Docklist=small})
list.Set("sbepfighters","assaultpodc",		{VecOff=Vector(0,0,0),		AngOff=Angle(0,0,0), Docklist=tiny})
list.Set("sbepfighters","dagger",			{VecOff=Vector(23,0,0),		AngOff=Angle(0,0,0), Docklist=tiny})
list.Set("sbepfighters","dart",				{VecOff=Vector(16,0,0),		AngOff=Angle(0,0,0), Docklist=tiny})