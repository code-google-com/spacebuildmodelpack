// Output .MDL
$modelname Spacebuild/neopodrag.mdl
// Base or Reference .SMD
$body studio "neopodphys.smd"
$scale 1.0
// Directory of materials that the model uses
$cdmaterials spacebuild

$keyvalues 
{
 prop_data 
{ 
"base" "Metal.Large"
} 
}

//Model properties
$surfaceprop "metal"

// sequences: all sequences are in $cd
 $sequence idle "neopodr_ref" fps 5 ACT_IDLE 1

 // This specifies the players viewpoint when you get in the car. 
 // The rotation MUST be correct or your view will rotate when you get in the car. 
$attachment "vehicle_driver_eyes" "car.view" 0.00 0.00 0.00 rotate 0 -90 0 

 // This specifes where you end up in relation to the car  when you get out.  
$attachment "vehicle_driver_exit" "car.body" -20.00 60.00 -60.00 rotate 0 0 0

 $keyvalues { 
   vehicle_exit { 
     "exit1" "upright" } 
 } 

 $collisionjoints "neopodphys.smd" { 
 // Mass in kilograms 

   $rootbone "Bone03" 
   $concave
 
	$concave
	$mass 40.0
	$inertia 1.00
	$damping 0.00
	$rotdamping 0.00
 
   $jointconstrain Bone03 x limit 0.000000 0.000000 0.000000
   $jointconstrain Bone03 y limit 0.000000 0.000000 0.000000
   $jointconstrain Bone03 z limit 0.000000 0.000000 0.000000
   $jointconstrain Bone05 x limit 0.000000 0.000000 1.000000
   $jointconstrain Bone05 y limit 0.000000 0.000000 1.000000
   $jointconstrain Bone05 z limit 0.000000 180.000000 1.000000

 }