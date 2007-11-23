// Output .MDL
$modelname Spacebuild/test3.mdl
$hboxset "default"
// Base or Reference .SMD
$body studio "test3.SMD"

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
$scale 1.0

// sequences: all sequences are in $cd
$sequence idle_closed "test3_idle_closed" loop fps 1
$sequence idle_open "test3_idle_open" loop fps 1
$sequence test_open "test3_open" loop fps 10
$sequence test_close "test3_close" loop fps 10

// Physics data
$collisionmodel "test3phys.SMD" {
	$concave
	$mass 100.0
	$inertia 1.00
	$damping 0.00
	$rotdamping 0.00
}
