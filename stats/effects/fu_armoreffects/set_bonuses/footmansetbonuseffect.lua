require "/stats/effects/fu_armoreffects/setbonuses_common.lua"

weaponBonus={
	{stat = "critChance", amount = 6},
	{stat = "critBonus", baseMultiplier = 1.03},
	{stat = "grit", amount = 0.15}
}

armorBonus={
	{stat = "shieldStaminaRegen", baseMultiplier = 1.17},
        {stat = "shieldRegen", baseMultiplier = 1.17},
        {stat = "shieldHealth", baseMultiplier = 1.17},
        {stat = "perfectBlockLimitRegen", baseMultiplier = 1.17}
}

setName="fu_footmanset"


function init()
	setSEBonusInit(setName)
	weaponBonusHandle=effect.addStatModifierGroup({})

	checkWeapons()

	armorBonusHandle=effect.addStatModifierGroup(armorBonus)
end

function update(dt)
	if not checkSetWorn(self.setBonusCheck) then
		effect.expire()
	else

		checkWeapons()
	end
end

function checkWeapons()
local weaponSword=weaponCheck({"shortsword"})
local weaponShield=weaponCheck({"shield"})

	local weapons=weaponCheck({"shortsword","shield"})
	if weaponSword["either"] and weaponShield["either"] then--setting to either means we can have shortsword with anything else, or broadsword. setting to both means broadsword or dual wield shortswords.
		effect.setStatModifierGroup(weaponBonusHandle,weaponBonus)
	else
		effect.setStatModifierGroup(weaponBonusHandle,{})
	end
end