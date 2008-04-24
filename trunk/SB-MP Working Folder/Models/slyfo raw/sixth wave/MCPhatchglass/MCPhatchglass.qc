// Output .MDL
$modelname Slyfo/MCPhatchglass.mdl
$hboxset "default"
// Base or Reference .SMD
$body studio "MCPhatchglass_detail.smd"

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
$sequence idle "MCPhatchglass_detail.smd" loop fps 15

// Physics data
$collisionmodel "MCPhatchglass_phys.smd" {
	$concave
	$mass 500.0
	$inertia 1.00
	$damping 0.00
	$rotdamping 0.00
}
