// Output .MDL
$modelname Spacebuild/SmallAirTank.mdl
$hboxset "default"
// Base or Reference .SMD
$body studio "SmallAirTank.SMD"

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
$sequence idle "SmallAirTank_ref" loop fps 15

// Physics data
$collisionmodel "SmallAirTankphys.SMD" {
	$concave
	$mass 100.0
	$inertia 1.00
	$damping 0.00
	$rotdamping 0.00
}
