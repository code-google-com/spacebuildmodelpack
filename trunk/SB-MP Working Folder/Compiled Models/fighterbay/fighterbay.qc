// Output .MDL
$modelname Spacebuild/fighterfirgoflarge.mdl
$hboxset "default"
// Base or Reference .SMD
$body studio "fighterbay.SMD"

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
$sequence idle "fighterbay_ref" loop fps 15

// Physics data
$collisionmodel "fighterbay.SMD" {
	$concave
	$mass 400.0
	$inertia 1.00
	$damping 0.00
	$rotdamping 0.00
}
