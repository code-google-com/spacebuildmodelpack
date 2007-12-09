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