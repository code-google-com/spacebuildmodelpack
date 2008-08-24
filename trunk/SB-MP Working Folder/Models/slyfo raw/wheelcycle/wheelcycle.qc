// Output .MDL
$modelname Spacebuild/wheelcycle.mdl
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
$sequence idle "wheelcycle_detail" loop fps 15

 // This specifies the players viewpoint when you get in the car. 
 // The rotation MUST be correct or your view will rotate when you get in the car. 
 $attachment "vehicle_driver_eyes" "car.view" 0.00 0.00 30.55 rotate 0 0 0 

 // This specifes where you end up in relation to the car  when you get out.  
 $attachment "vehicle_driver_exit" "car.body" 0.00 -100.00 25.00 rotate 0 0 0

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
