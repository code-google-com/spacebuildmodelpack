// Output .MDL
$modelname Spacebuild/ST4wDS.mdl
$hboxset "default"
// Base or Reference .SMD
$body studio "ST4wDS.SMD"

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
$sequence idle "ST4wDS_ref" loop fps 15

// Physics data
$collisionmodel "ST4wDSphys.SMD" {
	$concave
	$mass 400.0
	$inertia 1.00
	$damping 0.00
	$rotdamping 0.00
}
