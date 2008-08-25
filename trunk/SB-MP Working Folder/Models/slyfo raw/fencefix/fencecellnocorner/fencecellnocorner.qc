// Output .MDL
$modelname Slyfowalls/fencecellnocorner.mdl
$hboxset "default"
// Base or Reference .SMD
$body studio "fencecellnocorner_detail.smd"
$texturegroup skinfamilies
{
{ "grungewall"        }
{ "grungewallblue"    }
{ "grungewallpurple"  }
{ "grungewallorange"  }
{ "grungewallblack"   }
{ "grungewallteal"    }
{ "badconcrete"       }
}
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
$sequence idle "fencecellnocorner_detail.smd" loop fps 15

// Physics data
$collisionmodel "fencecellnocorner_phys.smd" {
	$concave
	$mass WEIGHT
	$inertia 1.00
	$damping 0.00
	$rotdamping 0.00
}
