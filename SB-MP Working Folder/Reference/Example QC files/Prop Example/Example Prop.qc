// Output .MDL
$modelname smallbridge/example.mdl
$hboxset "default"
// Base or Reference .SMD
$body studio "example_mesh.SMD"

// Directory of materials that the model uses
$cdmaterials puddle

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
$sequence idle "Example_idle" loop fps 1

// Physics data
$collisionmodel "Example_phys.SMD" {
	$concave
	$mass 400.0   //HOW HEAVY IT IS
	$inertia 1.00
	$damping 0.00
	$rotdamping 0.00
}
