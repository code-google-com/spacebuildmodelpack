SBMP = SBMP or {}

function SBMP.WeaponExplosionDamageHandler(victim, inflicter, attacker, amount, dmginfo)
	if dmginfo:IsExplosionDamage() then
		if (victim == inflicter) and inflicter.IsSBMPWeapon then return end
		
		if inflicter.IsSBMPWeapon then
			local ok, err = pcall(inflicter.DamageEntity, inflicter, victim, amount, dmginfo:GetReportedPosition())
			--print(inflicter, " hurt ", victim, " with damage ", amount)
			if not ok then ErrorNoHalt(err, "\n") end
		end
	end
end
hook.Add("EntityTakeDamage", "SBMP.WeaponExplosionDamageHandler_EntityTakeDamage", SBMP.WeaponExplosionDamageHandler)