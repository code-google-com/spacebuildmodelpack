// Output .MDL
$modelname Spacebuild/tube90b.mdl
$hboxset "default"
// Base or Reference .SMD
$body studio "tube90b.smd"

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
$sequence idle "tube90b_ref" loop fps 15

// Physics data
$collisionmodel "tube90bphys.smd" {
	$concave
	$mass 400.0
	$inertia 1.00
	$damping 0.00
	$rotdamping 0.00
}
