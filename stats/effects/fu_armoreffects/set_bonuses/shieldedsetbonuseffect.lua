require "/stats/effects/fu_armoreffects/setbonuses_common.lua"

setName="fu_shieldedset"

weaponBonus={}

armorBonus={
  {stat = "gasImmunity", amount = 1},
  {stat = "breathProtection", amount = 1}
}

function init()
	setSEBonusInit(setName)
	weaponBonusHandle=effect.addStatModifierGroup({})

	armorBonusHandle=effect.addStatModifierGroup(armorBonus)
end

function update(dt)
	if not checkSetWorn(self.setBonusCheck) then
		effect.expire()
	else
		effect.setStatModifierGroup(
		armorBonusHandle,armorBonus)
	end
	mcontroller.controlModifiers({
		speedModifier = 1.15
	})
end
