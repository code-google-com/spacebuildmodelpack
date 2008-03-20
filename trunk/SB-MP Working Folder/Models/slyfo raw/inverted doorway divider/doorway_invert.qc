// Output .MDL
$modelname Spacebuild/doorway_invert.mdl
$hboxset "default"
// Base or Reference .SMD
$body studio "doorway_invert_detail.SMD"

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
$sequence idle "doorway_invert_detail.SMD" loop fps 15

// Physics data
$collisionmodel "doorway_invert_phys.SMD" {
	$concave
	$mass 250.0
	$inertia 1.00
	$damping 0.00
	$rotdamping 0.00
}
