// Output .MDL
$modelname Slyfo/carrierbay.mdl
$hboxset "default"
// Base or Reference .SMD
$body studio "carrierbay_detail.smd"

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
$sequence idle "carrierbay.smd" loop fps 15

// Physics data
$collisionmodel "carrierbay_phys.smd" {
	$concave
	$mass 2000
	$inertia 1.00
	$damping 0.00
	$rotdamping 0.00
}
