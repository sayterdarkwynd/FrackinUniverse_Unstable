function init()
  local alpha = math.floor(config.getParameter("alpha") * 255)
  effect.setParentDirectives(string.format("?multiply=ffffff%02x", alpha))

  effect.addStatModifierGroup({{stat = "invulnerable", amount = 1}})

  self.powerModifier = config.getParameter("powerModifier", 0)
  effect.addStatModifierGroup({{stat = "powerMultiplier", effectiveMultiplier = 2}})

  effect.addStatModifierGroup({
      {stat = "energyRegenPercentageRate", amount = -1},
      {stat = "energyRegenBlockTime", effectiveMultiplier = 0}
    })
  local bounds = mcontroller.boundBox()
  script.setUpdateDelta(5)
end

function update(dt)
  mcontroller.controlModifiers({speedModifier = 0.75})
end