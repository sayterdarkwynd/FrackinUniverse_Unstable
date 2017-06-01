require "/stats/effects/fu_armoreffects/setbonuses_common.lua"

armorBonus={
	{stat = "maxHealth", baseMultiplier = 1.12},
	{stat = "powerMultiplier", baseMultiplier = 1.12},
	{stat = "sulphuricImmunity", amount = 1},
	{stat = "poisonResistance", amount = 0.15},
	{stat = "physicalResistance", amount = 0.15}
}

armorEffect={
	{stat = "sulphuricImmunity", amount = 1}
}

setName="fu_chitinset"

function init()
	setSEBonusInit(setName)
	armorEffectHandle=effect.addStatModifierGroup(armorEffect)
	armorBonusHandle=effect.addStatModifierGroup({})
	checkArmor()
end

function update(dt)
	if not checkSetWorn(self.setBonusCheck) then
		effect.expire()
	else
		checkArmor()
	end
end

function checkArmor()
	if (world.type() == "sulphuric") or (world.type() == "sulphuricdark") or (world.type() == "sulphuricocean") then
		effect.setStatModifierGroup(armorBonusHandle,armorBonus)
	else
		effect.setStatModifierGroup(armorBonusHandle,{})
	end
end