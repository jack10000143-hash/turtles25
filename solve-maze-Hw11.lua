local px, pz, py = 0, 0, 0
local dx, dz = 1, 0

local function turnRight()
	turtle.turnRight()
	if dx == 1 and dz == 0 then
	  dx, dz = 0, 1
	elseif dx == 0 and dz == 1 then
	  dx, dz = -1, 0
	elseif dx == -1 and dz == 0 then
	  dx, dz = 0, -1
	elseif dx == -1 and dz == 0 then
	  dx, dz = 1, 0
	end
end

local function goForward()
	local success, data = turtle.detect()
	if success and data == turtle.detect() then
	  turtle.forward()
	  px = px + dx
	  pz = pz + dz
	  return true
	end
end

local function victory()
    print("We finished the maze!")
    turtle.up()
    for _ = 1,4 do
        turtle.turnRight()
    end    
end

local function look()
    local ok, data = turtle.inspectDown()
    
    if ok and data.name:find("green") then
        print("At start")
    end
    
    if ok and data.name:find("yellow") then
      victory()
      return true
    end  
    
    return false
end


turtle.refuel(10)
if turtle.getFuelLevel() < 10 then
    print("Insert fuel in slot 1")
    return
end

while true do
    local done = look()
    if done then
        return
    end

    -- Idea:
    -- While we dect a block
    -- forward, turn right.
    if turtle.detect() then
      turtle.turnRight()
    end
    if turtle.detect() then
      turtle.turnLeft()
      turtle.turnLeft()
    end
    if turtle.detect() then
      turtle.turnLeft()
    end
    if turtle.detect() then
      turtle.turnRight()
      turtle.turnRight()
    end
    turtle.turnRight()
    if turtle.detect() then
      turtle.turnLeft()
    end
    if turtle.detect() then
      turnRight()
    end
    if turtle.detect() then
      turtle.turnRight()
    end
    if turtle.detect() then
      turtle.turnLeft()
    end
    turtle.forward()
end
