Updating to SB3/LS3/RD3, this will cause some things to not work with any of the older versions anymore.
The config file will be replaced with a new system once a final bug in it is fixed.

Check the lua/RD2/stools/sbmp_hab_mods/ folder and open the lua file in there. There are 2 examples of how to Add it to the new stool system.





these folders need to placed inside the "addonname/lua" folder.

Models can be added in autorun/config with this command:
AddLSShipHabModel("Module part name(just a name, to show in the stool)", "path here to the model")

exemple:
AddLSShipHabModel("Tube part", "models/Spacebuild/tube.mdl")


Updates:

*9-12-2007
	[Updated] Volume check(untested).
		This should fix the problem some people are having that 
		certain Resource Modules have different volumes 
		calculations then other of the same model...