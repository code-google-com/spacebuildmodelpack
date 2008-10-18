SBMP = SBMP or {}

function SBMP.WeaponExplosionDamageHandler(victim, inflicter, attacker, amount)
	if victim == inflicter then return end
	--print(inflicter.IsSBMPWeapon)
	
	if inflicter.IsSBMPWeapon then
		local ok, err = pcall(inflicter.DamageEntity, inflicter, victim, amount)
		
		if not ok then ErrorNoHalt(err, "\n") end
	end
end
hook.Add("EntityTakeDamage", "SBMP.WeaponExplosionDamageHandler_EntityTakeDamage", SBMP.WeaponExplosionDamageHandler)