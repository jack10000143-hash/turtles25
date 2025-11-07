local px, pz, py = 0, 0, 0
local dx, dz, dy = 0, 0, 0

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

local function digHole(depth, length)
	digDown()
	digForward()
	turnAround()
	digForward()
	digUp()
end

digHole(depth, length)
