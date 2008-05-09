// Output .MDL
$modelname Slyfo/frigate1ramp.mdl
$hboxset "default"
// Base or Reference .SMD
$body studio "frigate1ramp_detail.smd"

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
$sequence idle "frigate1ramp_detail.smd" loop fps 15

// Physics data
$collisionmodel "frigate1ramp_phys.smd" {
	$concave
	$mass 500.0
	$inertia 1.00
	$damping 0.00
	$rotdamping 0.00
}
