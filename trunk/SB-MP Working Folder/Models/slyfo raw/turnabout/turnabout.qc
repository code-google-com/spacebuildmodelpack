// Output .MDL
$modelname Slyfo/turnabout.mdl
$hboxset "default"
// Base or Reference .SMD
$body studio "turnabout_detail.smd"

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
$sequence idle "turnabout_detail.smd" loop fps 15

// Physics data
$collisionmodel "turnabout_phys.smd" {
	$concave
	$mass 2000.0
	$inertia 1.00
	$damping 0.00
	$rotdamping 0.00
}
