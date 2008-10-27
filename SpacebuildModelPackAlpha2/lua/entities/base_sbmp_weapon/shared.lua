--[[
	BE SURE TO CHECK OUT BASE_SBMP_ENTITY! IT ALSO HAS LOADS OF USEFUL OPTIONS THAT YOU CAN USE FOR YOUR WEAPON!
	
	DO NOT! I REPEAT! DO NOT ADD AN EXPLOSION DAMANGE CAUSING STATMENT ON YOUR ON ENTITY KILL OR ONDAMAGE CALLBACKS!
	ONLY ADD AN EXPLOSION DAMAGE STATMENT IN YOUR ON FIRE CALLBACK!
--]]

ENT.Type            = "anim"
ENT.Base            = "base_sbmp_entity"

ENT.PrintName       = "Base SBMP Weapon"
ENT.Author          = "Olivier 'LuaPineapple' Hamel"
ENT.Contact         = "evilpineapple@cox.net"
ENT.Purpose         = "Insta-ban justifier."
ENT.Instructions    = "There's a manual you know."
ENT.Category        = "Spacebuild Enhancement Project" -- Who changed the title?

ENT.IsSBMPWeapon    = true -- DO, NOT, CHANGE, THIS!

ENT.Spawnable		= false
ENT.AdminSpawnable	= false
-- Unimplamented, you can use CallOnClient if you so wish
--ENT.IsWeaponShared  = false -- Make this true if you want access to the functionality clientside as well (will create some more network vars so don't use this unless you have too)
ENT.IsToggleable    = true -- Can the weapon be stopped after it starts firing or will it only stop when it runs out of ammo or has to cool down?

ENT.IsAutomatic          = true  -- Like an automatic firearm, keeps firing by itself until it can't, if you use this override OnToggleFiring as well as OnStartFiring and OnEndFiring
ENT.IsCoherentBeamWeapon = false -- (THIS DOESN'T MEAN YOU HAVE TO FIRE BEAM SHOTS!) Use this if you have more then four rounds per second, it will override FiringRate and IsAutomatic
-- mostly used for weapons which discharge some kind of prolonged pulse and not distinct rounds although that is not nessesary

ENT.FiringRate    = 2 -- Rounds per second, if this is more then five then you should maybe make this a coherent beam weapon (it'll fire every frame)
ENT.CooldownDelay = 3 -- Number of seconds you have to wait after being done firing before you can start firing again

ENT.ResourcesManagedByUser = true -- if true then it's your job to do the res stuff (it'll initiate everthing for you though)

ENT.ResTable = {}
-- Example Entry
--[[
ENT.ResList["energy"].Capacity      = 0
ENT.ResList["energy"].DefaultAmount = 0
ENT.ResList["energy"].CostPerShot  = 55
--]]


