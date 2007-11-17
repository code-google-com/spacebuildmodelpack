// Output .MDL
$modelname Spacebuild/strange.mdl
$hboxset "default"
// Base or Reference .SMD
$body studio "strange.SMD"

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
$sequence idle "strange_ref" loop fps 15

// Physics data
$collisionmodel "strange.SMD" {
	$concave
	$mass 4000.0
	$inertia 2.00
	$damping 0.00
	$rotdamping 0.00
}
