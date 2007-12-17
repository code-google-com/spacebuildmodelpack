// Output .MDL
$modelname Spacebuild/PJBR.mdl
// Base or Reference .SMD
$body studio "PJR.smd"
$scale 1.0
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
$surfaceprop "metal"

// sequences: all sequences are in $cd
 $sequence idle "PJR_ref" fps 5 ACT_IDLE 1


 $collisionjoints "PJRphys.smd" { 
 // Mass in kilograms 

   $concave
	$mass 40.0
	$inertia 1.00
	$damping 0.00
	$rotdamping 0.00
	$rootbone "bone01"

	$jointconstrain "bone02" x limit 0.00 0.00 0.00
	$jointconstrain "bone02" y limit 0.00 0.00 0.00
	$jointconstrain "bone02" z limit 0.00 0.00 0.00

	$jointconstrain "bone03" x limit 0.00 0.00 0.00
	$jointconstrain "bone03" y limit 0.00 0.00 0.00
	$jointconstrain "bone03" z limit -90.00 0.00 0.00

	$jointconstrain "bone08" x limit 0.00 0.00 0.00
	$jointconstrain "bone08" y limit 0.00 21.00 0.00
	$jointconstrain "bone08" z limit 0.00 0.00 0.00

	$jointconstrain "bone05" x limit 0.00 0.00 0.00
	$jointconstrain "bone05" y limit -17.00 0.00 0.00
	$jointconstrain "bone05" z limit 0.00 0.00 0.00
}