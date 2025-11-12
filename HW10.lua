local px, pz, py = 0, 0, 0
local dx, dz, dy = 1, 0, 0
-- HW 10 additions to program
local args = {...}
local depth = tonumber(args[1])
local length = tonumber(args[2])



local function digDown()
	
	for i = 0, depth do
		turtle.digDown()
		turtle.down()
	end
end

local function digForward()
	for i = 0, length do
		turtle.dig()
		turtle.forward()
		px = px + dx
		pz = pz + dz
	end
end

function refuelWithCoal()                                                       
    local currentFuel = turtle.getFuelLevel()                                   
    print("Current fuel level: " .. currentFuel)                                
                                                                                
    -- Search for coal in inventory                                             
    for slot = 1, 16 do                                                         
        local item = turtle.getItemDetail(slot)                                 
        if item and (item.name == "minecraft:coal" or item.name ==              
"minecraft:charcoal") then                                                      
            print("Found " .. item.name .. " in slot " .. slot .. " (x" ..      
item.count .. ")")                                                              
                                                                                
            -- Select the slot with coal                                        
            turtle.select(slot)                                                 
                                                                                
            -- Try to refuel with one piece of coal                             
            if turtle.refuel(1) then                                            
                local newFuel = turtle.getFuelLevel()                           
                print("Refueled! New fuel level: " .. newFuel .. " (+" ..       
(newFuel - currentFuel) .. ")")                                                 
                return true                                                     
            else                                                                
                print("Failed to refuel with " .. item.name)                    
            end                                                                 
        end                                                                     
    end                                                                         
                                                                                
    print("No coal or charcoal found in inventory!")                            
    return false                                                                
end         

local function searchSquare(length)
	local x, y = 0, 0
	local dx, dy = 1, 0
	local steps = 1
	local turn_count = 0

	for _ = 1, length * length do
	
		turtle.dig()
		turtle.forward()
		local level = turtle.getFuelLevel()
		
		if level == 0 then 
			refuelWithCoal()
		end
		
		if x + dx >= length or x + dx < 0 or y + dy >= length or y + dy < 0 or turn_count >= steps then
			turtle.turnRight()
			turn_count = 0
			if dx == 1 then
				dy = 1
				dx = 0
			elseif dy == 1 then
				dx = -1
				dy = 0
			elseif dx == -1 then
				dy = -1
				dx = 0
			elseif dy == -1 then
				dx = 1
				dy = 0
				steps = steps + 1
			end
		end

		

		x = x + dx
		y = y + dy
		turn_count = turn_count + 1
	end
end

local function turnAround()
	turtle.turnRight()
	turtle.turnRight()
end

local function digUp()
	for i = 0, depth do
		turtle.up()
	end	
end

function listInventory()
    local inventory = {}
    
    -- Check each slot in the turtle's inventory (slots 1-16)
    for slot = 1, 16 do
        local item = turtle.getItemDetail(slot)
        if item then
            table.insert(inventory, {
                slot = slot,
                name = item.name,
                count = item.count
            })
        end
    end
    
    -- Print the inventory list
    if #inventory == 0 then
        print("Inventory is empty")
    else
        print("Turtle Inventory:")
        print("================")
        for i, item in ipairs(inventory) do
            print("Slot " .. item.slot .. ": " .. item.name .. " x" .. item.count)
        end
    end
    
    return inventory
end



local function digHole(depth, length)
	digDown()
	--digForward()
	searchSquare(length)
	turnAround()
	--digForward()
	turtle.forward(1)
	listInventory()
	digUp()
end

digHole(depth, length)
