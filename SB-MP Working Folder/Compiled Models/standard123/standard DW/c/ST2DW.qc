// Output .MDL
$modelname Spacebuild/ST2DW.mdl
$hboxset "default"
// Base or Reference .SMD
$body studio "ST2DW.SMD"

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
$sequence idle "ST2DW_ref" loop fps 15

// Physics data
$collisionmodel "ST2DWphys.SMD" {
	$concave
	$mass 400.0
	$inertia 1.00
	$damping 0.00
	$rotdamping 0.00
}
