// Output .MDL
$modelname Votekick/ring_ctrl.mdl
$hboxset "default"
// Base or Reference .SMD
$body studio "ring_ctrl_detail.SMD"

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
$sequence idle "ring_ctrl_ref.SMD" loop fps 15


// Physics data
$collisionmodel "ring_ctrl_phys.SMD" {
	$concave
	$mass 800.0
	$inertia 1.00
	$damping 0.00
	$rotdamping 0.00
}