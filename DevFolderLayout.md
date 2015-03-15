# Introduction #

This page explains the folder layout for the Dev Full SVN

# Addon Folder #

AT time of writing the addon folder is called "SpacebuildModelPackAlpha2", while this may change it's content will not.

  * The info.txt file is used by Gmod to identify the Addon
  * models folder holds models
  * Materials folder holds materials
  * Settings holds spawn menus, vehicle menus, and map menus
  * LUA folder holds LUA scrips

Currently all materials and models in the addon are places in a sub folder called 'spacebuild', If you need to distinguish certain files place them in another subfolder of this directory.

# Working Folder #
SB-MP Working Folder contains all files for working on, this includes raw texture images, uncompiled models, and other such files.

This folder has the following sub folders
  * Addon Files: - Place for adding files that need to be checked before adding to the main addon, this is best used for placing work you are not sure about When, or how it needs to be added. this will be rarely used, but should not be ignored.
  * Compiled models: this is used for placing the SMD files, Compile scripts, and any other nesserery files for a model before it is compiled. this is so a model can be recompiled at ease later with a different mass or similar.
  * Conspt Art: This folder is to be used for storing artwork relating to consepts.
  * ImagesScreenshots : This folder is used for any good screenshots of models, or in game use of models, primarily used for forum updates.
  * LUA: this folder is for LUA files that are currently being worked on, but are not yet ready for testing.
  * Models: This folder is for the Raw model files, for instance .MAX, .W3d, .M3D, .OBJ Etc, place any models raw data you are working on here.
  * OutDated : this folder is for any files that are outdated and should **not** be added to the final version of the addon.
  * Textures: this folder contains textures for use
    1. MT: this folder contains fully converted textures that are ready for use or implementation into the game
    1. on-VMT: this folder contains raw images that need to be converted into textures, **DO NOT PLACE IMAGES HERE IF THEY ARE NOT FOR CONVERSION**
    1. atlib: This is for material Library's for 3d modeling applications, use this to store your material library's
    1. aw: Place images here that are Raw image files, and need to be edited to work as textures
    1. riginal Texture Images: This is for the original texture images that have been converted to VMF/VMT
  * DXF Models: This folder is for DXF exports from Hammer that need to be converted into working models.
  * Untextured: This folder is for models that have yet to be textured.
  * Un-Collided Models: this folder is for models that do not have a working collision mesh
  * Reference: Place files here that are to be used for Reference when producing other files, for instance vehicle scripts, specialist compile scripts, LUA documentation, Etc