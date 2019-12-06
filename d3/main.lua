local i = 1
local wires = {{}, {}}

for line in io.lines("input.txt") do
	if #line == 0 then break end
	for v in line:gmatch("[^,]+") do
		local dir, lenght = v:sub(1,1), tonumber(v:sub(2))
		table.insert(wires[i], {["dir"] = dir, ["lenght"] = lenght})
	end
	i = i + 1
end

i = 1

local ground = {}
local x, y = 30000, 30000 -- could cause problems if numbers are bigger
local distance = 0xFFFF
local max_x, max_y = 0, 0
local min_x, min_y = 0xFFFF, 0xFFFF

ground[x] = {}
ground[x][y] = {}

-- creates circuit 
for n, wire in ipairs(wires) do
	for _, v in ipairs(wire) do
		local dir, len = v.dir, v.lenght
		ground[x][y][n] = true
		
		for i=1,len do
			if dir == "U" then
				if not ground[x]        then ground[x] = {} end
				if not ground[x][y + i] then ground[x][y + i] = {} end
				
				ground[x][y + i][n] = true
			elseif dir == "L" then
				if not ground[x - i]    then ground[x - i] = {} end
				if not ground[x - i][y] then ground[x - i][y] = {} end
				
				ground[x - i][y][n] = true
			elseif dir == "D" then
				if not ground[x]        then ground[x] = {} end
				if not ground[x][y - i] then ground[x][y - i] = {} end
				
				ground[x][y - i][n] = true
			elseif dir == "R" then
				if not ground[x + i]    then ground[x + i] = {} end
				if not ground[x + i][y] then ground[x + i][y] = {} end
				
				ground[x + i][y][n] = true
			end
		end
		
		if dir == "U" then
			y = y + len
		elseif dir == "L" then
			x = x - len
		elseif dir == "D" then
			y = y - len
		elseif dir == "R" then
			x = x + len
		end
		
		if x > max_x then 
			max_x = x 
		elseif x < min_x then
			min_x = x
		end
		
		if y > max_y then 
			max_y = y 
		elseif y < min_y then
			min_y = y
		end
	end
	
	x, y = 30000, 30000
end

-- zero out starting point
ground[x][y] = nil
local crosspoints = {}

-- reads circuit and calculates distances
for x, row in pairs(ground) do
	for y, val in pairs(row) do
		if val[1] and val[2] then
			table.insert(crosspoints, {x, y})
			local x_dist, y_dist = math.abs(30000 - x), math.abs(30000 - y)
			local dist = x_dist + y_dist
			if dist < distance then 
				distance = dist 
			end
		end
	end
end

print("Lowest distance:", distance, "\n")
--print("max x,y:", max_x, max_y, "min x,y", min_x, min_y)

-- puzzle 2
local paths = {}
x, y = 30000, 30000
local stp = 1
local steps = {1, 1}
local final_steps = 0xFFFF

for _, point in ipairs(crosspoints) do
	for n, wire in ipairs(wires) do
		for _, v in ipairs(wire) do
			local dir, len = v.dir, v.lenght
			
			for i=1,len do
				if dir == "U" then
					y = y + 1
				elseif dir == "L" then
					x = x - 1
				elseif dir == "D" then
					y = y - 1
				elseif dir == "R" then
					x = x + 1
				end
				
				if x == point[1] and y == point[2] then 
					steps[n] = stp
				end
				
				stp = stp + 1
			end
		end
		
		x, y = 30000, 30000 
		stp = 1
	end
	
	if steps[1] + steps[2] < final_steps then
		final_steps = steps[1] + steps[2]
	end
	steps = {1, 1}
end

print("Least steps to reach crossing point:", final_steps)

os.execute("PAUSE") -- added for checking how much memory process ended up using