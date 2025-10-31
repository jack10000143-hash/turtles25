local args = { ... }
if #args < 1 then
    print("Usage: new-program <depth>")
    print(" - Will dig a staircase down N blocks")
    print(" - Auto-refuels with coal found while digging")
    print(" - Places chests when inventory is full")
    return
end

local depth = tonumber(args[1])
if not depth or depth < 1 then
    print("Error: depth must be a positive number")
    return
end

print("Starting staircase dig, depth = " .. depth)

-- Check if we have space in inventory
local function hasSpace()
    for slot = 1, 16 do
        if turtle.getItemCount(slot) == 0 then
            return true
        end
    end
    return false
end

-- Find coal in inventory and refuel with it
local function autoRefuel()
    local currentSlot = turtle.getSelectedSlot()
    
    for slot = 1, 16 do
        turtle.select(slot)
        local item = turtle.getItemDetail()
        if item and (item.name == "minecraft:coal" or item.name == "minecraft:charcoal") then
            local fuelBefore = turtle.getFuelLevel()
            turtle.refuel()
            local fuelAfter = turtle.getFuelLevel()
            if fuelAfter > fuelBefore then
                print("Refueled with " .. item.name .. ", fuel: " .. fuelAfter)
            end
        end
    end
    
    turtle.select(currentSlot)
end

-- Check if we need to refuel and do so
local function checkFuel()
    if turtle.getFuelLevel() < 100 then
        autoRefuel()
        if turtle.getFuelLevel() < 50 then
            print("Warning: Low fuel (" .. turtle.getFuelLevel() .. ")")
        end
    end
end

-- Find a chest in inventory
local function findChest()
    for slot = 1, 16 do
        turtle.select(slot)
        local item = turtle.getItemDetail()
        if item and item.name == "minecraft:chest" then
            return slot
        end
    end
    return nil
end

-- Place a chest and dump inventory
local function placeChestAndDump()
    local chestSlot = findChest()
    if not chestSlot then
        print("Error: No chest found in inventory! Cannot dump items.")
        return false
    end
    
    -- Dig space to the right for chest
    turtle.turnRight()
    while turtle.detect() do
        turtle.dig()
    end
    
    -- Place chest
    turtle.select(chestSlot)
    if not turtle.place() then
        print("Error: Could not place chest!")
        turtle.turnLeft()
        return false
    end
    
    print("Placed chest, dumping inventory...")
    
    -- Dump all items except chests
    for slot = 1, 16 do
        turtle.select(slot)
        local item = turtle.getItemDetail()
        if item and item.name ~= "minecraft:chest" then
            turtle.drop()
        end
    end
    
    turtle.turnLeft()
    return true
end

-- Check if inventory is full and handle it
local function checkInventory()
    if not hasSpace() then
        print("Inventory full, placing chest...")
        if not placeChestAndDump() then
            print("Failed to place chest, stopping...")
            return false
        end
    end
    return true
end

-- Dig and collect items, with fuel and inventory management
local function smartDig()
    while turtle.detect() do
        turtle.dig()
        checkFuel()
        if not checkInventory() then
            return false
        end
    end
    return true
end

local function smartDigUp()
    while turtle.detectUp() do
        turtle.digUp()
        checkFuel()
        if not checkInventory() then
            return false
        end
    end
    return true
end

local function smartDigDown()
    while turtle.detectDown() do
        turtle.digDown()
        checkFuel()
        if not checkInventory() then
            return false
        end
    end
    return true
end

-- Dig one step of the staircase
local function digStairStep()
    -- Clear the path ahead
    if not smartDig() then return false end
    
    -- Move forward
    if not turtle.forward() then
        print("Error: Could not move forward")
        return false
    end
    
    -- Clear above (2 blocks high)
    if not smartDigUp() then return false end
    turtle.up()
    if not smartDigUp() then return false end
    
    -- Go back down and dig the step down
    turtle.down()
    if not smartDigDown() then return false end
    turtle.down()
    
    return true
end

-- Main digging loop
local function digStaircase(steps)
    for i = 1, steps do
        print("Digging step " .. i .. " of " .. steps)
        
        if not digStairStep() then
            print("Error occurred at step " .. i)
            return false
        end
        
        -- Auto-refuel periodically
        if i % 5 == 0 then
            checkFuel()
        end
    end
    
    print("Staircase complete!")
    return true
end

-- Start the operation
checkFuel()
if turtle.getFuelLevel() == 0 then
    print("Error: No fuel available!")
    return
end

digStaircase(depth)
print("Final fuel level: " .. turtle.getFuelLevel())
