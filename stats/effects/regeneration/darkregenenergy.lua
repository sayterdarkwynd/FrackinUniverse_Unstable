require "/scripts/vec2.lua"
require "/scripts/util.lua"
require "/scripts/interp.lua"

function init()
  local bounds = mcontroller.boundBox()
  self.healingRate = 1.01 / config.getParameter("healTime", 420)
  script.setUpdateDelta(10)
end


function activateVisualEffects()
  local lightLevel = getLight()
  if lightLevel <= 25 then
    animator.setParticleEmitterOffsetRegion("blood", mcontroller.boundBox())
    animator.setParticleEmitterActive("blood", true)  
  end

end
  
function getLight()
  local position = mcontroller.position()
  position[1] = math.floor(position[1])
  position[2] = math.floor(position[2])
  local lightLevel = world.lightLevel(position)
  lightLevel = math.floor(lightLevel * 100)
  return lightLevel
end

function nighttimeCheck()
	nighttime = world.timeOfDay() > 0.5 -- true if daytime
end

function undergroundCheck()
	underground = world.underground(mcontroller.position()) 
end

function update(dt)
  local lightLevel = getLight()
  if nighttime or underground then
	if lightLevel <= 1 then
	    self.healingRate = 1.01 / config.getParameter("healTime", 180)
	    status.modifyResourcePercentage("energy", self.healingRate * dt)
	elseif lightLevel <= 2 then
	    self.healingRate = 1.008 / config.getParameter("healTime", 200)
	    status.modifyResourcePercentage("energy", self.healingRate * dt)
	elseif lightLevel <= 5 then
	    self.healingRate = 1.007 / config.getParameter("healTime", 220)
	    status.modifyResourcePercentage("energy", self.healingRate * dt)
	elseif lightLevel <= 7 then
	    self.healingRate = 1.006 / config.getParameter("healTime", 240)
	    status.modifyResourcePercentage("energy", self.healingRate * dt)
	elseif lightLevel <= 12 then
	    self.healingRate = 1.005 / config.getParameter("healTime", 280)
	    status.modifyResourcePercentage("energy", self.healingRate * dt)
	elseif lightLevel <= 15 then
	    self.healingRate = 1.004 / config.getParameter("healTime", 320)
	    status.modifyResourcePercentage("energy", self.healingRate * dt)
	elseif lightLevel <= 18 then
	    self.healingRate = 1.003 / config.getParameter("healTime", 350)
	    status.modifyResourcePercentage("energy", self.healingRate * dt)
	elseif lightLevel <= 22 then
	    self.healingRate = 1.002 / config.getParameter("healTime", 380)
	    status.modifyResourcePercentage("energy", self.healingRate * dt)
	elseif lightLevel <= 25 then
	    self.healingRate = 1.001 / config.getParameter("healTime", 420)
	    status.modifyResourcePercentage("energy", self.healingRate * dt)
	end  
  end
		
end

function uninit()

end