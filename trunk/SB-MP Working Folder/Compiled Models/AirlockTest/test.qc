// Output .MDL
$modelname Spacebuild/test.mdl
$hboxset "default"
// Base or Reference .SMD
$body studio "test.SMD"

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
$sequence idle_open "test_idle_open" loop fps 30
$sequence idle_closed "test_idle_closed" loop fps 30
$sequence open "test_open" loop fps 30
$sequence close "test_close" loop fps 30

// Physics data
$collisionmodel "testphys.SMD" {
	$concave
	$mass 100.0
	$inertia 1.00
	$damping 0.00
	$rotdamping 0.00
}
