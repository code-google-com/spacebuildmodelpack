// Output .MDL
$modelname Spacebuild/tubet.mdl
$hboxset "default"
// Base or Reference .SMD
$body studio "tubet.smd"

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
$sequence idle "tubet_ref" loop fps 15

// Physics data
$collisionmodel "tubetphys.smd" {
	$concave
	$mass 400.0
	$inertia 1.00
	$damping 0.00
	$rotdamping 0.00
}
