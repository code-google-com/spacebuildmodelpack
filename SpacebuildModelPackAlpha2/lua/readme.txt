----------------------------
-- NOTE FROM LUAPINEAPPLE --
----------------------------

Don't be an ass and keep RD2 support present (at least until I can kick uRD out the door). Use a if-then-end to disable RD3 stuff in case of the lack of RD3 (and likewise for RD2).

You probably want to use uRD's API anyways, it's currently much better then RD3's and better then RD2's and will only get better as time goes on. (RD3 is a dead end in my opinion. And uRD will confirm it.)

PEOPLE! START PREFIXING YOUR DAMN FILES CORRECTLY:

cl_ (Client)
sh_ (Shared)
sv_ (Server)

Helps keep stuff neat and readable, not to mention it'll enable AddLua support (it's like a merge of Include and AddCSLuaFile but it does it all in one call and it does loads/sends the file automatically).

----------------------------
-- NOTE FROM LUAPINEAPPLE --
----------------------------




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