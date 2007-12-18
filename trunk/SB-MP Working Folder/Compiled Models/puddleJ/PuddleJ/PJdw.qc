// Output .MDL
$modelname Spacebuild/PJdw.mdl
$hboxset "default"
// Base or Reference .SMD
$body studio "PJdw.SMD"

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
$sequence idle "PJ_ref" loop fps 1

// Physics data
$collisionmodel "PJdwphys.SMD" {
	$concave
	$mass 400.0
	$inertia 1.00
	$damping 0.00
	$rotdamping 0.00
}
