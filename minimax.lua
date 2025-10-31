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
    local refueled = false
    
    for slot = 1, 16 do
        turtle.select(slot)
        local item = turtle.getItemDetail()
        if item and (item.name == "minecraft:coal" or item.name == "minecraft:charcoal") then
            local fuelBefore = turtle.getFuelLevel()
            local itemCount = turtle.getItemCount()
            
            -- Refuel with all coal in this slot
            turtle.refuel(itemCount)
            
            local fuelAfter = turtle.getFuelLevel()
            if fuelAfter > fuelBefore then
                print("Refueled with " .. item.name .. ", fuel: " .. fuelBefore .. " -> " .. fuelAfter)
                refueled = true
            end
        end
    end
    
    turtle.select(currentSlot)
    return refueled
end

-- Check if we need to refuel and do so
local function checkFuel()
    local currentFuel = turtle.getFuelLevel()
    
    -- Be more aggressive about refueling - refuel if below 200
    if currentFuel < 200 then
        print("Fuel low (" .. currentFuel .. "), searching for coal...")
        local refueled = autoRefuel()
        
        if not refueled and currentFuel < 50 then
            print("Critical: Very low fuel (" .. currentFuel .. ") and no coal found!")
            return false
        elseif not refueled then
            print("Warning: Low fuel (" .. currentFuel .. ") and no coal found")
        end
    end
    
    return true
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

-- Check if we've hit bedrock
local function isAtBedrock()
    local success, data = turtle.inspectDown()
    if success and data.name == "minecraft:bedrock" then
        return true
    end
    return false
end

-- Find stone blocks in inventory for crafting stairs
local function findStoneBlocks()
    local stoneSlots = {}
    for slot = 1, 16 do
        turtle.select(slot)
        local item = turtle.getItemDetail()
        if item and (item.name == "minecraft:stone" or 
                     item.name == "minecraft:cobblestone" or
                     item.name == "minecraft:deepslate" or
                     item.name == "minecraft:cobbled_deepslate") then
            table.insert(stoneSlots, {slot = slot, count = item.count, name = item.name})
        end
    end
    return stoneSlots
end

-- Find floor blocks in inventory (blocks that can be used for flooring)
local function findFloorBlocks()
    local floorSlots = {}
    for slot = 1, 16 do
        turtle.select(slot)
        local item = turtle.getItemDetail()
        if item and (item.name == "minecraft:stone" or 
                     item.name == "minecraft:cobblestone" or
                     item.name == "minecraft:deepslate" or
                     item.name == "minecraft:cobbled_deepslate" or
                     item.name == "minecraft:dirt" or
                     item.name == "minecraft:grass" or
                     item.name == "minecraft:gravel") then
            table.insert(floorSlots, {slot = slot, count = item.count, name = item.name})
        end
    end
    return floorSlots
end

-- Select a block suitable for flooring
local function selectBlock()
    local floorSlots = findFloorBlocks()
    if #floorSlots > 0 then
        turtle.select(floorSlots[1].slot)
        return true
    end
    return false
end

-- Place floor block if there isn't one already
local function placeFloor()
    if not turtle.detectDown() then
        if selectBlock() then
            if turtle.placeDown() then
                print("Placed floor block")
                return true
            else
                print("Warning: Could not place floor block")
                return false
            end
        else
            print("Warning: No suitable floor blocks available")
            return false
        end
    end
    return true
end

-- Craft stairs from stone blocks
local function craftStairs()
    local stoneSlots = findStoneBlocks()
    if #stoneSlots == 0 then
        print("No stone blocks found for crafting stairs!")
        return false
    end
    
    print("Crafting stairs from available stone blocks...")
    local stairsCrafted = 0
    
    -- Craft stairs using 3x3 pattern: stone in slots 1,2,4,5,7,8 makes 4 stairs
    while #stoneSlots > 0 and stairsCrafted < depth do
        -- Clear crafting area (slots 1-9)
        for slot = 1, 9 do
            turtle.select(slot)
            if turtle.getItemCount() > 0 then
                -- Move non-stone items to later slots
                for targetSlot = 10, 16 do
                    if turtle.getItemCount(targetSlot) == 0 then
                        turtle.transferTo(targetSlot)
                        break
                    end
                end
            end
        end
        
        -- Set up stair crafting pattern
        -- Pattern: X X _
        --          X X _  
        --          X X _
        local pattern = {1, 2, 4, 5, 7, 8}
        local stonesUsed = 0
        
        for _, craftSlot in ipairs(pattern) do
            if #stoneSlots > 0 and stonesUsed < 6 then
                local stoneSlot = stoneSlots[1]
                turtle.select(stoneSlot.slot)
                turtle.transferTo(craftSlot, 1)
                stoneSlot.count = stoneSlot.count - 1
                stonesUsed = stonesUsed + 1
                
                if stoneSlot.count <= 0 then
                    table.remove(stoneSlots, 1)
                end
            end
        end
        
        -- Craft the stairs
        if turtle.craft() then
            stairsCrafted = stairsCrafted + 4
            print("Crafted 4 stairs, total: " .. stairsCrafted)
        else
            print("Failed to craft stairs")
            break
        end
    end
    
    print("Finished crafting. Total stairs: " .. stairsCrafted)
    return stairsCrafted > 0
end

-- Find stairs in inventory
local function findStairs()
    for slot = 1, 16 do
        turtle.select(slot)
        local item = turtle.getItemDetail()
        if item and string.find(item.name, "_stairs") then
            return slot
        end
    end
    return nil
end

-- Place one stair block
local function placeStair()
    local stairSlot = findStairs()
    if not stairSlot then
        return false
    end
    
    turtle.select(stairSlot)
    return turtle.placeDown()
end

-- Build stairs back up the stairway
local function buildStairsUp(maxSteps)
    print("Building stairs back up the stairway...")
    
    -- Turn around to face back up the stairway
    turtle.turnLeft()
    turtle.turnLeft()
    
    local stairsPlaced = 0
    
    for i = 1, maxSteps do
        -- Check if we have stairs to place
        local stairSlot = findStairs()
        if not stairSlot then
            print("No more stairs available! Placed " .. stairsPlaced .. " stairs.")
            break
        end
        
        print("Placing stair " .. (stairsPlaced + 1) .. " (step " .. i .. " of " .. maxSteps .. ")")
        
        -- Place stair block down
        if placeStair() then
            stairsPlaced = stairsPlaced + 1
        else
            print("Warning: Could not place stair at step " .. i)
        end
        
        -- Move up and forward to next position
        turtle.up()
        if not turtle.forward() then
            print("Error: Could not move forward at step " .. i)
            return false
        end
        
        -- Check fuel and inventory
        if not checkFuel() then
            print("Fuel issues while building stairs")
            return false
        end
    end
    
    print("Finished building stairs! Placed " .. stairsPlaced .. " total stairs.")
    return true
end

-- Place a chest and dump inventory
local function placeChestAndDump()
    local chestSlot = findChest()
    if not chestSlot then
        print("Error: No chest found in inventory! Cannot dump items.")
        return false
    end
    
    print("Inventory full, placing chest to the right...")
    
    -- Turn right to place chest to the side
    turtle.turnRight()
    
    -- Dig space for chest if needed
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
    
    print("Chest placed successfully, dumping inventory...")
    
    -- Dump all items except chests and coal (keep coal for fuel)
    local itemsDumped = 0
    for slot = 1, 16 do
        turtle.select(slot)
        local item = turtle.getItemDetail()
        if item then
            -- Keep chests and coal, dump everything else
            if item.name ~= "minecraft:chest" and 
               item.name ~= "minecraft:coal" and 
               item.name ~= "minecraft:charcoal" then
                local count = turtle.getItemCount()
                turtle.drop()
                itemsDumped = itemsDumped + count
                print("Dumped " .. count .. " " .. item.name)
            end
        end
    end
    
    print("Dumped " .. itemsDumped .. " items into chest")
    
    -- Turn back to original direction
    turtle.turnLeft()
    
    -- Verify we now have space
    if hasSpace() then
        print("Inventory cleared, resuming digging...")
        return true
    else
        print("Warning: Inventory still full after dumping!")
        return false
    end
end

-- Check if inventory is full and handle it
local function checkInventory()
    if not hasSpace() then
        if not placeChestAndDump() then
            print("Failed to place chest and dump inventory, stopping...")
            return false
        end
        
        -- Double-check we have space now
        if not hasSpace() then
            print("Critical: Still no inventory space after chest dump!")
            return false
        end
    end
    return true
end

-- Dig and collect items, with fuel and inventory management
local function smartDig()
    while turtle.detect() do
        turtle.dig()
        if not checkFuel() then
            return false
        end
        if not checkInventory() then
            return false
        end
    end
    return true
end

local function smartDigUp()
    while turtle.detectUp() do
        turtle.digUp()
        if not checkFuel() then
            return false
        end
        if not checkInventory() then
            return false
        end
    end
    return true
end

local function smartDigDown()
    while turtle.detectDown() do
        turtle.digDown()
        if not checkFuel() then
            return false
        end
        if not checkInventory() then
            return false
        end
    end
    return true
end

-- Dig one step of the staircase
local function digStairStep()
    -- Check fuel before each major operation
    if not checkFuel() then
        print("Error: Cannot continue due to fuel issues")
        return false
    end
    
    -- Check if we hit bedrock
    if isAtBedrock() then
        print("Hit bedrock! Stopping excavation.")
        return false
    end
    
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
    
    -- Place floor block if there isn't one already
    placeFloor()
    
    return true
end

-- Main digging loop
local function digStaircase(steps)
    local actualSteps = 0
    
    for i = 1, steps do
        print("Digging step " .. i .. " of " .. steps)
        
        if not digStairStep() then
            if isAtBedrock() then
                print("Reached bedrock at step " .. i)
                actualSteps = i - 1
                break
            else
                print("Error occurred at step " .. i)
                return false, 0
            end
        end
        
        actualSteps = i
        
        -- Auto-refuel periodically
        if i % 5 == 0 then
            checkFuel()
        end
    end
    
    print("Excavation complete! Dug " .. actualSteps .. " steps.")
    return true, actualSteps
end

-- Start the operation
print("Initial fuel level: " .. turtle.getFuelLevel())
if not checkFuel() then
    print("Error: Cannot start - fuel issues!")
    return
end

if turtle.getFuelLevel() == 0 then
    print("Error: No fuel available and no coal found!")
    return
end

-- Dig the staircase
local success, actualSteps = digStaircase(depth)
if not success then
    print("Failed to complete staircase excavation")
    return
end

-- Craft stairs from collected blocks
if actualSteps > 0 then
    print("Now crafting stairs from collected blocks...")
    if craftStairs() then
        print("Stairs crafted successfully!")
        
        -- Build stairs back up
        if buildStairsUp(actualSteps) then
            print("Stairway construction complete!")
        else
            print("Failed to build stairs back up")
        end
    else
        print("Failed to craft stairs - no suitable blocks found")
    end
else
    print("No steps were dug, nothing to build")
end

print("Final fuel level: " .. turtle.getFuelLevel())
