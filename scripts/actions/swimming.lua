require "/scripts/poly.lua"

-- param keepGroundDistance
-- param keepCeilingDistance
-- param maxXVelocity
-- param maxYVelocity
function swimAlongGround(args, output)
  args = parseArgs(args, {
    keepGroundDistance = 10,
    keepCeilingDistance = 10,
    maxXVelocity = 8,
    maxYVelocity = 4
  })

  local keepGroundDistance = BData:getNumber(args.keepGroundDistance)
  local keepCeilingDistance = BData:getNumber(args.keepCeilingDistance)
  local maxXVelocity = BData:getNumber(args.maxXVelocity)
  local maxYVelocity = BData:getNumber(args.maxYVelocity)
  local baseParameters = mcontroller.baseParameters()

  if not keepGroundDistance or not keepCeilingDistance or not maxXVelocity or not maxYVelocity then return false end

  while true do
    local groundLine = poly.translate({{0, 0}, {0, -keepGroundDistance * 2}}, mcontroller.position())
    local ceilingLine = poly.translate({{0, 0}, {0, keepCeilingDistance}}, mcontroller.position())
    local groundPoint = world.lineCollision(groundLine[1], groundLine[2]) or groundLine[2]
    local ceilingPoint = world.lineCollision(ceilingLine[1], ceilingLine[2]) or ceilingLine[2]

    -- Move the ground point up by the height we want to keep,
    -- gives us the y position we want to stay around
    local groundApproachPoint = vec2.add(groundPoint, {0, keepGroundDistance})
    local keepGroundDistanceFactor = world.distance(groundApproachPoint, mcontroller.position())[2] / keepGroundDistance

    -- Keep away from the ceiling
    local keepCeilingDistanceFactor = (-keepCeilingDistance + world.distance(ceilingPoint, mcontroller.position())[2]) / keepCeilingDistance

    local yVelocityFactor = keepGroundDistanceFactor + keepCeilingDistanceFactor

    mcontroller.controlApproachVelocity({mcontroller.facingDirection() * maxXVelocity, yVelocityFactor * maxYVelocity}, baseParameters.liquidForce)

    coroutine.yield("running")
  end
end

-- param centerPosition
-- param maxDistance
-- param collisionArea
-- param lerpStep
-- output position
function findLiquidPosition(args, output)
  args = parseArgs(args, {
    centerPosition = "self",
    maxDistance = 10,
    collisionArea = {-1, -1, 1, 1},
    lerpStep = 1
  })

  local center = BData:getPosition(args.centerPosition)
  local maxDistance = BData:getNumber(args.maxDistance)
  local lerpStep = BData:getNumber(args.lerpStep)
  if center == nil or maxDistance == nil then return false end

  for i = 0, maxDistance, lerpStep do
    for a = 0, math.pi*2, math.pi/4 do
      local dir = {math.cos(a), math.sin(a)}
      local position = vec2.add(center, vec2.mul(dir, i))
      if not world.rectTileCollision(rect.translate(args.collisionArea, position)) and
        world.liquidAt(rect.translate(args.collisionArea, position))
      then
        BData:setPosition(output.position, position)
        return true
      end
    end
  end

  return false
end

-- param position
-- param maxAngle
-- param speed
function swimInGeneralDirection(args, output)
  args = parseArgs(args, {
    position = nil,
    maxAngle = 30,
    speed = mcontroller.baseParameters().flySpeed
  })

  local direction
  while true do
    mcontroller.controlDown()

    local position = BData:getPosition(args.position)
    local speed = BData:getNumber(args.speed)
    local maxAngle = util.toRadians(BData:getNumber(args.maxAngle))

    local toTarget = vec2.norm(world.distance(position, mcontroller.position()))
    if direction == nil or math.acos(vec2.dot(toTarget, direction)) > maxAngle then
      direction = vec2.rotate(toTarget, (util.randomDirection() * math.random() * maxAngle))
    end

    mcontroller.controlApproachVelocity(vec2.mul(direction, speed), mcontroller.baseParameters().liquidForce)
    mcontroller.controlFace(util.toDirection(toTarget[1]))
    util.debugLine(mcontroller.position(), vec2.add(mcontroller.position(), vec2.mul(direction, 10)), "blue")
    util.debugLine(mcontroller.position(), position, "yellow")

    coroutine.yield("running")
  end

  return true
end

function swarmLiquidPosition(args, output, _, dt)
  args = parseArgs(args, {
    maxRange = 8,
    minMoveDistance = 4,
    idleTime = 0.5,
    center = nil
  })

  local minMoveDistance, maxRange, idleTime = BData:getNumber(args.minMoveDistance), BData:getNumber(args.maxRange), BData:getNumber(args.idleTime)
  local bounds = mcontroller.boundBox()

  while true do
    local center = BData:getPosition(args.center)
    local position = center

    if world.lineTileCollision(position, mcontroller.position()) then
      return false
    end
    repeat
      local distance = math.random(0, maxRange)
      local angle = math.random() * math.pi * 2
      local offset = {math.cos(angle) * distance, math.sin(angle) * distance}
      position = vec2.add(center, offset)
      coroutine.yield("running")
    until not world.lineTileCollision(center, position)
      and not world.rectTileCollision(rect.translate(bounds, position))
      and world.liquidAt(rect.translate(bounds, position)) >= 0.5
      and world.magnitude(position, mcontroller.position()) > minMoveDistance

    repeat
      local toTarget = world.distance(position, mcontroller.position())
      mcontroller.controlFly(vec2.mul(vec2.norm(toTarget), mcontroller.baseParameters().liquidSpeed))

      if world.rectTileCollision(rect.translate(rect.pad(bounds, 0.25), mcontroller.position())) or
        not world.liquidAt(rect.translate(bounds, mcontroller.position())) >= 0.5
      then
        return false
      end
      coroutine.yield("running")
    until world.magnitude(position, mcontroller.position()) < 1.0

    local timer = idleTime
    while timer > 0 do
      timer = timer - dt
      dt = coroutine.yield("running")
    end
  end
end

--world
function entityInLiquid(args,outut)
  args = parseArgs(args, {
    entity = "target",
    excludeLiquidIds = nil --TO DO: create two tables, LiquidsIDs and GasIDs.
  })
  local entityId = BData:getEntity(args.entity)
  local excludeLiquidIds = BData:getTable(args.excludeLiquidIds)

  local liquid = world.liquidAt(world.entityPosition(entityId))
  if excludeLiquidIds then
    liquid = util.filter(liquid, function(liquid) return not contains(excludeLiquidIds, liquid[2][1]) end)
  end
  return liquid and liquid[2] >= 0.5
end
