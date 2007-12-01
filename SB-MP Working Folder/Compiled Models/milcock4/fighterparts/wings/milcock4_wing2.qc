// Output .MDL
$modelname Spacebuild/milcock4_wing2.mdl
$hboxset "default"
// Base or Reference .SMD
$body studio "milcock4_wing2_detail.SMD"

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
$sequence idle "milcock4_wing2_detail" loop fps 15

// Physics data
$collisionmodel "milcock4_wing2_phys.SMD" {
	$concave
	$mass 40.0
	$inertia 1.00
	$damping 0.00
	$rotdamping 0.00
}
