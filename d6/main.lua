local input = {}
local root = ""

-- read input
for line in io.lines("input.txt") do
	local parent, child = line:match("(.-)%)(.+)")
	
	if parent == "COM" then root = child end
	
	-- create parent object
	if not input[parent] then 
		input[parent] = {}
		input[parent].children = {}
	end
	-- if second iter and was child then creates children table
	if not input[parent].children then
		input[parent].children = {}
	end
	
	if not input[child] then
		input[child] = {}
		input[child].parent = parent
	else
		input[child].parent = parent
	end
	
	table.insert(input[parent].children, child)
end

-- count
local deepness = 1
local total = 0
for i, v in pairs(input) do
	if i ~= "COM" then 
		if i == root then deepness = deepness - 1 end
		local last = v.parent
		
		while last ~= "COM"  or nil do
			last = input[last].parent
			deepness = deepness + 1
		end
	end
	
	total = total + deepness
	deepness = 1
end

print("orbit sum", total)

-- puzzle 2

local orbitJumps = 0
local comp_tbl = {}

function findPath(top, tbl, bottom)
	local jumps = 0
	local last = top
	local root_2 = "COM"
	if bottom then root_2 = bottom end
	comp_tbl[tbl] = {}
	
	while last ~= root_2  or nil do
		table.insert(comp_tbl[tbl], input[last].parent)
		last = input[last].parent
		jumps = jumps + 1
	end
	orbitJumps = orbitJumps + jumps
end

findPath(input["YOU"].parent, "YOU")
findPath(input["SAN"].parent, "SAN")

-- find crossection
local cross = ""

function find_cross()
	for _,v in pairs(comp_tbl["YOU"]) do
		for _,v2 in pairs(comp_tbl["SAN"]) do
			if v == v2 then 
				cross = v
				return
			end
		end
	end
end

find_cross() -- smh for some reason loop breaking didnt work
orbitJumps = 0
findPath(input["YOU"].parent, "YOU", cross)
findPath(input["SAN"].parent, "SAN", cross)

print("\ncrossection at", cross)
print("orbit jumps required to reach santa", orbitJumps)