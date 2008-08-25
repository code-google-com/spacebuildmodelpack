// Output .MDL
$modelname Slyfo/missile.mdl
$hboxset "default"
// Base or Reference .SMD
$body studio "missile_detail.smd"

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
$sequence idle "missile_detail.smd" loop fps 15

// Physics data
$collisionmodel "missile_phys.smd" {
	$concave
	$mass 500
	$inertia 1.00
	$damping 0.00
	$rotdamping 0.00
}
