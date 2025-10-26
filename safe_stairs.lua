local args = { ... }
if #args < 1 then
    print("Usage: stairs 10")
    print(" - Fuel in slot 1")
    print(" - Blocks in slot 2")
    print(" - Stairs in slot 3")
    return
end

local nn = args[1]

print("Starting, nn = " .. nn)

local function refuel()
        turtle.select(1)
        turtle.refuel(10)
        print("Current fuel: " .. turtle.getFuelLevel())
end

local function selectBlock()
    turtle.select(2)
end

local function selectStairs()
    turtle.select(3)
end

local function digUp()
    while turtle.detectUp() do
        turtle.digUp()
    end
end

local function digDown()
    while turtle.detectDown() do
        turtle.digDown()
    end
end

local function dig()
    while turtle.detect() do
        turtle.dig()
    end
end

local function placeFloor()
    if not turtle.detectDown() then
        selectBlock()
        turtle.placeDown()
    end    
end

local function placeWall()
    if not turtle.detect() then
        selectBlock()
        turtle.place()
    end
end

local function cutDownOnce()
    -- block to place stairs on
    placeFloor()
   
    -- three blocks above stairs,
    -- this plus two
    digUp()
    turtle.up()
    digUp()
    
    -- now foward and down two to
    -- get to next iteration
    dig()
    turtle.forward()
    digUp()
    digDown() 
    turtle.down()
    digDown()
    turtle.down() 

    -- make sure we have a final
    -- floor block
    placeFloor()        
end

function cutDown(nn)
    for _ii = 1, nn do
        cutDownOnce()
    end

    -- move to start stairs
    dig()
    turtle.forward()
    placeFloor()
    digUp()
end

local function turnAround()
    turtle.turnLeft()
    turtle.turnLeft()
end

local function buildOneStair()
    selectStairs()
    turtle.place()
    digUp()
    turtle.up()
    dig()
    turtle.forward()
    
    -- we're over stairs, place
    -- guardrails
    turtle.turnLeft()
    placeWall()
    turtle.turnLeft()
    turtle.turnLeft()
    placeWall()
    turtle.turnLeft()            
end 

local function buildStairs(nn)
    for _ii = 1, nn do
        buildOneStair()
    end
end

refuel()
cutDown(nn)
turnAround()
buildStairs(nn)
dig()
turtle.forward()
turnAround()
