// Output .MDL
$modelname Slyfowalls/fenceUlong.mdl
$hboxset "default"
// Base or Reference .SMD
$body studio "fenceUlong_detail.smd"
$texturegroup skinfamilies
{
	{ "grungewall"        }
	{ "grungewallblue"    }
	{ "badconcrete"       }
}
// Directory of materials that the model uses
$cdmaterials spacebuild

$keyvalues 
{
 prop_data 
{ 
"base" "Stone.Large"
} 
}

//Model properties
$staticprop
$surfaceprop "concrete"
$scale 1.0

// sequences: all sequences are in $cd
$sequence idle "fenceUlong_detail.smd" loop fps 15

// Physics data
$collisionmodel "fenceUlong_phys.smd" {
	$concave
	$mass 500.00
	$inertia 1.00
	$damping 0.00
	$rotdamping 0.00
}
