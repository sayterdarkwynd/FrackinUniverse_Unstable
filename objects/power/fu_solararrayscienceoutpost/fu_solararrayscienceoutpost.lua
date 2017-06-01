function init()
	
	storage.checkticks = 0
	storage.truepos = isn_getTruePosition()
end

function update(dt)
	storage.checkticks = storage.checkticks + 1
	if storage.checkticks >= 10 then
		storage.checkticks = 0
		isn_getCurrentPowerOutput()
	end
end

function isn_getCurrentPowerOutput(divide)
	if isn_powerGenerationBlocked == true then
		animator.setAnimationState("meter", "0")
		return 0
	end
	
	local generated = 0
	local genmult = 1
	local location = isn_getTruePosition()
	local light = world.lightLevel(location)
	if light > 0.2 then generated = generated + 0.45 end
	if light > 0.4 then generated = generated + 0.55 end
	if light > 0.6 then generated = generated + 0.65 end
	if light > 0.8 then generated = generated + 0.75 end
	
	if location[2] < 500 then genmult = 4.5
	elseif location[2] > 800 then genmult = 6.5
	elseif location[2] > 1000 then genmult = 8 end
	
	generated = generated * genmult
	generated = math.min(generated,12)
	
	if generated >= 2 then animator.setAnimationState("meter", "4")
	elseif generated >= 1.5  then animator.setAnimationState("meter", "3")
	elseif generated >= 1 then animator.setAnimationState("meter", "2")
	elseif generated >= 0.5 then animator.setAnimationState("meter", "1")
	else animator.setAnimationState("meter", "0")
	end
	
	local divisor = isn_countPowerDevicesConnectedOnOutboundNode(0)
	if divisor < 1 then return 0 end
	
	if divide == true then return generated / divisor
	else return generated end
end

function onNodeConnectionChange()
	if isn_checkValidOutput() == true then object.setOutputNodeLevel(0, true)
	else object.setOutputNodeLevel(0, false) end
end

function isn_powerGenerationBlocked()
	-- Power generation does not occur if...
	--if world.info == nil then return true end -- it's on a ship (doesn't work right now)
	local location = isn_getTruePosition()
	if world.underground(location) == true then return true end -- it's underground
	if world.liquidAt(location) == true then return true end -- it's submerged in liquid
	if world.tileIsOccupied(location,false) == true then return true end -- there's a wall in the way
	if world.lightLevel(location) < 0.2 then return true end -- not enough light
end

function isn_getTruePosition()
	if storage.truepos ~= nil then return storage.truepos
	else
		storage.truepos = {entity.position()[1] + math.random(2,3), entity.position()[2] + 1}
		return storage.truepos
	end
end