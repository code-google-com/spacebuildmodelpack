// Output .MDL
$modelname Slyfo/walkerconcept.mdl
$hboxset "default"
// Base or Reference .SMD
$body studio "walkerconcept_detail.smd"

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
$sequence idle "walkerconcept_sequence.smd" loop fps 25

// Physics data
$collisionmodel "walkerconcept_phys.smd" {
	$concave
	$mass 1000.0
	$inertia 1.00
	$damping 0.00
	$rotdamping 0.00
}
