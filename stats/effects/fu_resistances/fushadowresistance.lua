function init()
  effect.addStatModifierGroup({
    {stat = "shadowResistance", amount = config.getParameter("resistanceValue",0)}
  })
end

function update(dt)
end

function uninit()
  
end