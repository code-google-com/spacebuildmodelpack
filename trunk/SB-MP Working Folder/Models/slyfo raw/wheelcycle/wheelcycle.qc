// Output .MDL
$modelname Slyfo/wheelcycle.mdl
$hboxset "default"
// Base or Reference .SMD
$body studio "wheelcycle.SMD"

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
$sequence idle "wheelcycle_detail" loop fps 1

 // This specifies the players viewpoint when you get in the car. 
 // The rotation MUST be correct or your view will rotate when you get in the car. 
 $attachment "vehicle_driver_eyes" "car.view" 0.00 0.00 98.74 rotate 0 0 0 

 // This specifies where you end up in relation to the car  when you get out.  
 $attachment "vehicle_driver_exit" "car.body" 0.00 -100.00 93.19 rotate 0 0 0

 // Hyst: This specifies where the player will actually appear in the car.
 $attachment "vehicle_feet_passenger0" "car.view" 0.00 0.00 68.19 rotate 0 -90 0

 $keyvalues { 
   vehicle_exit { 
     "exit1" "upright" } 
 } 


// Physics data
$collisionmodel "wheelcycle_phys.SMD" {
$concave
$mass 1000.0
$inertia 1.00
$damping 0.00
$rotdamping 0.00
}
