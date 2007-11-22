// Output .MDL
$modelname Spacebuild/test2.mdl
$hboxset "default"
// Base or Reference .SMD
$body studio "test2.SMD"

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
$sequence idle_closed "test2_closed_idle" loop fps 30
$sequence idle_open "test2_open_idle" loop fps 30
$sequence test_open "test2_open" loop fps 30
$sequence test_close "test2_close" loop fps 30

// Physics data
$collisionmodel "test2phys.SMD" {
	$concave
	$mass 100.0
	$inertia 1.00
	$damping 0.00
	$rotdamping 0.00
}
