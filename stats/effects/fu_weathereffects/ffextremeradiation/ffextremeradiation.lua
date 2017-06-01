function init()
  animator.setParticleEmitterOffsetRegion("flamesfu", mcontroller.boundBox())
  animator.setParticleEmitterActive("flamesfu", true)
  effect.setParentDirectives("fade=00FFBB=0.15")
  script.setUpdateDelta(5)
  self.tickDamagePercentage = 0.032
  self.tickTime = 1.0
  self.tickTimer = self.tickTime
  world.sendEntityMessage(entity.id(), "queueRadioMessage", "ffbiomeradiation", 5.0)
end



function update(dt)
  mcontroller.controlModifiers({
      groundMovementModifier = 0.90,
      runModifier = 0.80,
      jumpModifier = 0.80
    })
    
  self.tickTimer = self.tickTimer - dt
  if self.tickTimer <= 0 then
    self.tickTimer = self.tickTime
    status.applySelfDamageRequest({
        damageType = "IgnoresDef",
        damage = math.floor(status.resourceMax("health") * self.tickDamagePercentage) + 1,
        damageSourceKind = "hellfireweapon",
        sourceEntityId = entity.id()
      })
  end
end

function uninit()

end