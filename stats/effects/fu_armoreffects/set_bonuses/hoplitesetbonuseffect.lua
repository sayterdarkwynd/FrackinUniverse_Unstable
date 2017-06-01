setName="fu_hopliteset"

weaponBonus={
	{stat = "critChance", amount = 6},
        {stat = "powerMultiplier", baseMultiplier = 1.15}
}

armorBonus={
	{stat = "critChance", amount = 3}
}

armorEffect={
	{stat = "grit", amount = 0.12},
        {stat = "shieldRegen", amount = 0.3},
        {stat = "protoImmunity", amount = 1.0}
}

require "/stats/effects/fu_armoreffects/setbonuses_common.lua"

function init()
	setSEBonusInit(setName)

        armorEffectHandle=effect.addStatModifierGroup(armorEffect)
	weaponBonusHandle=effect.addStatModifierGroup({})

	armorBonusHandle=effect.addStatModifierGroup({})


	checkWeapons()
        checkArmor()
end

function update(dt)
	if not checkSetWorn(self.setBonusCheck) then
		effect.expire()
	else
		checkWeapons()
		checkArmor()
	end
end

function checkArmor()
if (world.type() == "mountainous4") or (world.type() == "mountainous3") or (world.type() == "mountainous2") or (world.type() == "mountainous") then
	effect.setStatModifierGroup(
	armorBonusHandle,armorBonus)
else
	effect.setStatModifierGroup(
	armorBonusHandle,{})
	end
end

function checkWeapons()
	local weapons=weaponCheck({"shortspear", "spear"})
	if weapons["either"] then
		effect.setStatModifierGroup(weaponBonusHandle,weaponBonus)
	else
		effect.setStatModifierGroup(weaponBonusHandle,{})
	end
end