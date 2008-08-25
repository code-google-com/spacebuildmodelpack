// Output .MDL
$modelname Slyfo/SMLdoublehowie.mdl
$hboxset "default"
// Base or Reference .SMD
$body studio "SMLdoublehowie_detail.smd"
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
$sequence idle "SMLdoublehowie_detail.smd" loop fps 15

// Physics data
$collisionmodel "SMLdoublehowie_phys.smd" {
	$concave
	$mass 2500
	$inertia 1.00
	$damping 0.00
	$rotdamping 0.00
}
