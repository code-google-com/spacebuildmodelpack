// Output .MDL
$modelname Spacebuild/sword.mdl
$hboxset "default"
// Base or Reference .SMD
$body studio "sword.smd"

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
$sequence idle "sword_ref" loop fps 15

// Physics data
$collisionmodel "swordphys.smd" {
	$concave
	$mass 40.0
	$inertia 1.00
	$damping 0.00
	$rotdamping 0.00
}
