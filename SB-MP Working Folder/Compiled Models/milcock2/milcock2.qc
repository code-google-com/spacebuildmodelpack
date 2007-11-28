// Output .MDL
$modelname Spacebuild/milcock2.mdl
$hboxset "default"
// Base or Reference .SMD
$body studio "milcock2.SMD"

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
$staticprop
$surfaceprop "metal"
$scale 1.0

// sequences: all sequences are in $cd
$sequence idle "milcock2_ref" loop fps 15

 // This specifies the players viewpoint when you get in the car. 
 // The rotation MUST be correct or your view will rotate when you get in the car. 
 $attachment "vehicle_driver_eyes" "car.view" 0.00 0.00 0.00 rotate 0 -90 0 

 // This specifes where you end up in relation to the car  when you get out.  
 $attachment "vehicle_driver_exit" "car.body" -20.00 60.00 -60.00 rotate 0 0 0

 $keyvalues { 
   vehicle_exit { 
     "exit1" "upright" } 
 } 


// Physics data
$collisionmodel "milcock2phys.SMD" {
	$concave
	$mass 100.0
	$inertia 1.00
	$damping 0.00
	$rotdamping 0.00
}
