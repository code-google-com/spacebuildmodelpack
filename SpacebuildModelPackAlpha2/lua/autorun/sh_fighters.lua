--VecOff is a local vector offset, use it to reposition the vehicle
--AngOff is a rotational offset, use it if the vehicle faces up or right
--Docklist is a list of the Hangars the ship can dock at
--all names lower case because the GetName() function returns lowercase sometimes
list.Set("sbepfighters","sword",{VecOff=Vector(0,0,0), AngOff=Angle(0,0,0), Docklist={"swordhangar"}})
list.Set("sbepfighters","assaultpodc",{VecOff=Vector(50,0,0), AngOff=Angle(0,0,0), Docklist={"swordhangar"}})
--Drone = Clunker, damned if I know why
--is is programmed differently
list.Set("sbepfighters","drone",{VecOff=Vector(50,0,0), AngOff=Angle(0,0,0), Docklist={"swordhangar"}})
--Large Transport is too large for the hangar
list.Set("sbepfighters","largetransport",{VecOff=Vector(0,0,50), AngOff=Angle(0,0,0), Docklist={}})
--Small Transport is longer than the hangar, but it should do
list.Set("sbepfighters","smalltransport",{VecOff=Vector(0,0,50), AngOff=Angle(0,0,0), Docklist={"swordhangar"}})