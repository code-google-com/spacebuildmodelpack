// Output .MDL
$modelname Slyfo/rextop.mdl
$hboxset "default"
// Base or Reference .SMD
$body studio "rextop_detail.smd"

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
$sequence idle "rextop_detail.smd" loop fps 15

// Physics data
$collisionmodel "rextop_phys.smd" {
	$concave
	$mass 500.0
	$inertia 1.00
	$damping 0.00
	$rotdamping 0.00
}
