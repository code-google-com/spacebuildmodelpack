--VecOff is a local vector offset, use it to reposition the vehicle
--AngOff is a rotational offset, use it if the vehicle faces up or right
--Docklist is a list of the Hangars the ship can dock at
--all names lower case because the GetName() function returns lowercase sometimes
local all = {"swordhangar", "swordhangarlarge", "swordhangarspacious", "dockingclamp", "dockingclampt", "dockingclampx"}
list.Set("sbepfighters","sword",{VecOff=Vector(-50,0,0), AngOff=Angle(0,0,0), Docklist={"swordhangar", "swordhangarlarge", "swordhangarspacious", "dockingclamp", "dockingclampt", "dockingclampx"}})
--is is programmed differently
list.Set("sbepfighters","assaultpodc",{VecOff=Vector(0,0,75), AngOff=Angle(0,0,0), Docklist=all})
--Drone = Clunker, damned if I know why
list.Set("sbepfighters","drone",{VecOff=Vector(0,0,0), AngOff=Angle(0,0,0), Docklist=all})
--Large Transport is too large for the hangar
list.Set("sbepfighters","largetransport",{VecOff=Vector(10,0,-30), AngOff=Angle(0,0,0), Docklist={"dockingclamp", "dockingclampt", "dockingclampx"}})
--Small Transport is longer than the hangar, but it should do
list.Set("sbepfighters","smalltransport",{VecOff=Vector(0,0,0), AngOff=Angle(0,0,0), Docklist={"swordhangar", "swordhangarlarge", "swordhangarspacious", "dockingclamp", "dockingclampt", "dockingclampx"}})
--The Arwing is too large to fit if the wings are attached, uncomment if wings are parented
list.Set("sbepfighters","arwing",{VecOff=Vector(0,0,50), AngOff=Angle(0,0,0), Docklist={/*"swordhangar", "swordhangarlarge", */"swordhangarspacious", "dockingclamp", "dockingclampt", "dockingclampx"}})
--The light corvette fits into hangars easily, even smallbridge
list.Set("sbepfighters","lightcombatcorvette",{VecOff=Vector(0,0,50), AngOff=Angle(0,0,0), Docklist=all})
--The Cargo Crate Mover won't even fit into a docking clamp
list.Set("sbepfighters","cratemover",{VecOff=Vector(0,0,0), AngOff=Angle(0,0,0), Docklist={"swordhangarspacious"}})