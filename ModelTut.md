Preliminary Steps:
  * 1: Get the VTF Import plugin for your version of max
  * 2: get the SMD Export plugin for your version of max
  * 3: Install the Source SDK from the tools menu of steam and run it.

  * Step 1: create a cube in Max
  * Step 2: convert it to an 'editable mesh' (right click convert to)
  * Optional: Step 3: name it 'Cube Collision Mesh'
  * Step 4: right click and 'freeze selection' on the cube to freeze it
  * Optional: Step 5: open the Layers menu and create a new layer and add the Collision Cube to it
  * Step 6: Create a second cube the same size shape and position
  * Step 7: do something to the cube to make it pretty (cut something out of it, change the shape etc)
  * Step 8: Go to the Materials folder in the space build model pack and find a texture for your cube (get "VTF shell extensions" to see thumbnails in my computer)
  * Step 9: in max press M to open the material editor
  * Step 10: select a grey ball (texture slot) and then under 'Maps' click the 'diffuse map' button
  * step 11: Navigate to the spacebuild model pack materials folder (Example: gmod/gmod/addons/spacebuild model pack/materials/spacebuild) and select the texture you wish to use (Ensure you use the texture and not the texture\_Bump or other supplimentry texture
  * Step 12: drag the material from the materals window onto your cube model
  * Step 13: select the cube model and select File/Export Selected/
  * Step 14: make sure you have selected 'Source SMD' as the export file type, make a new folder for your model, name it (Example: Model.smd) and then click 'save'
  * Step 15: the export window will appear, select 'reference' and click OK
  * ------------This first file is the graphical model that a player can see but nothing else-----------------
  * Step 16: follow steps 13-14 but name your model with a _ref on the end (Example Model\_ref.smd)
  * Step 16: select 'Sequence' and make the range 0 - 1 and click Ok
  * -----------This file is an animation file, every model has one even if it is not animated-----------------
  * Step 17: hide your cube (right click hide selection)
  * Step 18: Unfreeze your collision cube (right click Unfreeze all)
  * Step 19: select the cube and in the modifers pannel (on the right the blue rainbow shapped icon/tab) select polygon mode
  * Step 20: Select your ENTIRE collision model it will turn red.
  * Step 21: find the 'smoothing groups' section in the modifer pannel
  * Step 22: Clear all smothing groups then set the group to 1 (Every CONVEX MESH (CBA to explain now basicaly a primitive) in the collision mesh has to have it's own smoothing group (there are exceptions))
  * Step 23: Export this cube as another 'reference' SMD but add PHYS to the end (Example: ModelPHYS.smd)
  * ----------This file is a collision model, whenever something collides (or doesn't collide) with your model this file is used to determine how and where)_


  * Step 24: Get GUIstudioMDL and set it up correctly for EP1 content (i wont explain that here, google it)
  * Step 25: Select the game Counter Strike Source (or anything that is not Half Life 2 it doesn't work, i don't know why)
  * Step 26: in the folder with your model create a new notepad file and call it something .qc (NOT A .TXT file if you can't see .txt disable 'hide extentions for known file types in the folder options menu of my computer) Example MODEL.QC)
  * Step 27: open the file with notepad and enter the following (modified for your model)

Code:
```
// This is a QC file, anything not to be used has a double slash before it and is a comment ingored by the compiler


// Output .MDL This is the model your making, change the first part to change the folder it's saved in for example /MYMODEL/MODEL.MDL would place it in /models/MYMODEL/ and call it MODEL.MDL
$modelname NewStuff/Model.mdl
//Ignore the next line
$hboxset "default" 
// Base or Reference .SMD (This is the graphical model we made first, change this to whatever the first SMD you exported was
$body studio "Model.SMD"

// Directory of materials that the model uses (In this case Spacebuild (remeber the material we selected was in /materials/spacebuild) if you where using the puddle textures it would be 'Puddle'
$cdmaterials Spacebuild

//Ignore this part
$keyvalues
{
prop_data
{
// Ignore this unless you know the material types (sound effects when shot)
"base" "Metal.Small"
}
}

//Model properties ignore these
$staticprop
$surfaceprop "metal"
$scale 1.0

// sequences: all sequences are in $cd  Change this to whatever the animation file (second one) is called DO NOT ADD .smd at the end
$sequence idle "model_ref" loop fps 1

// Physics data section
//change this line to the final (collison model) file
$collisionmodel "modelPHYS.SMD" {
   $concave
//change this line to edit the 'weight' in game (weight stool style)
   $mass 100.0
   $inertia 1.00
   $damping 0.00
   $rotdamping 0.00
}

```
  * step 28: save this file
  * Step 29: in GUIstudiomdl open the QC file you just made, make sure the game is set to CSS and hit compile, wait for it to finish. if it says something about 'truncating' the collision model failed if it says 'collision model too large (for more complicated models) check the 'full collide' box
  * Optional: Step 30: Copy the materials you used to a folder of the same name in counterstrike's materials (given you compiled in CSS mode) IE: Copy Gmod/Gmod/Addons/Spacebuildmodelpack/Materials/Spacebuild ->TO-> steam/steamapps/**YOUR USER NAME**/Counter strike/Cstrike/Materials/Spacebuild
  * OPTIONAL: Step 31 Load the Half Life Model Viewer (from source SDK, or /sourcesdk/ep1/bin/HLMV.EXE and find and open your model (in this example /Newstuff/Model.mdl) you should now be able to preview your model outside of gmod to check it worked
  * Step 32: go to your counterstrike directory and fine your model (in this example steam/steamapps/**YOUR USER NAME**/ Counter strike/ Cstrike/ Models/) Copy the directory you compiled to (in this case /Newstuff) to the addons /models folder
  * Step 33: Load gmod and use the 'browse' menu to find and spawn your model
  * Step 34: Gloat