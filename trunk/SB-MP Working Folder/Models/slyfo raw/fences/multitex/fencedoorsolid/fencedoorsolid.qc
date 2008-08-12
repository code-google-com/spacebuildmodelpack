// Output .MDL
$modelname Slyfowalls/fencedoorsolid.mdl
$hboxset "default"
// Base or Reference .SMD
$body studio "fencedoorsolid_detail.smd"
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
$sequence idle "fencedoorsolid_detail.smd" loop fps 15

// Physics data
$collisionmodel "fencedoorsolid_phys.smd" {
	$concave
	$mass 200.00
	$inertia 1.00
	$damping 0.00
	$rotdamping 0.00
}
