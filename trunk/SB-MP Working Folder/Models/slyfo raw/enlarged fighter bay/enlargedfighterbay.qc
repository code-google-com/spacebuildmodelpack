// Output .MDL
$modelname Spacebuild/enlargedfighterbay.mdl
$hboxset "default"
// Base or Reference .SMD
$body studio "enlargedfighterbay.SMD"

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
$sequence idle "enlargedfighterbay_ref.SMD" loop fps 15

// Physics data
$collisionmodel "enlargedfighterbay_phys.SMD" {
	$concave
	$mass 2500.0
	$inertia 1.00
	$damping 0.00
	$rotdamping 0.00
}
