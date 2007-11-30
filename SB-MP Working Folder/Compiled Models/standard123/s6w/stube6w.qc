// Output .MDL
$modelname Spacebuild/stube6w128.mdl
$hboxset "default"
// Base or Reference .SMD
$body studio "stube6w.SMD"

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
$sequence idle "stube6w_ref" loop fps 15

// Physics data
$collisionmodel "stube6wphys.SMD" {
	$concave
	$mass 400.0
	$inertia 1.00
	$damping 0.00
	$rotdamping 0.00
}
