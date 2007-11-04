// Output .MDL
$modelname Spacebuild/cargo1.mdl
$hboxset "default"
// Base or Reference .SMD
$body studio "cargo1.SMD"

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
$sequence idle "cargo1_ref" loop fps 15

// Physics data
$collisionmodel "cargo1phys.SMD" {
	$concave
	$mass 100.0
	$inertia 1.00
	$damping 0.00
	$rotdamping 0.00
}
