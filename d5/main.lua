local handle = io.open("input.txt", "rb")
local input = handle:read("*all")
handle:close()

local program = {}
local prog_orig = {}
local i = 1

function read_value(pos, mode)
	if mode == 0 then
		return program[pos + 1]
	elseif mode == 1 then
		return pos
	end
end

-- thank arrays that start with 1 /s
local instruction = {
	[1] = function(pos, mode) -- add
		local x = read_value(program[pos + 1], mode[1])
		local y = read_value(program[pos + 2], mode[2])
		local z = program[pos + 3] + 1
		
		program[z] = x + y
		i = i + 4
		return false
	end,
	[2] = function(pos, mode) -- multiple
		local x = read_value(program[pos + 1], mode[1])
		local y = read_value(program[pos + 2], mode[2])
		local z = program[pos + 3] + 1
		
		program[z] = x * y
		i = i + 4
		return false
	end,
	[3] = function(pos, mode) -- input value from console
		local inp = false
		
		while not inp do
			print("Enter value to store at address "..program[pos + 1]..":")
			inp = tonumber(io.read())
		end
		
		program[program[pos + 1] + 1] = inp
		i = i + 2
		return false
	end,
	[4] = function(pos, mode) -- output value at specified address to console
		print("Value at address "..(program[pos + 1] + 1)..":", 
				program[program[pos + 1] + 1])
		
		i = i + 2
		return false
	end,
	[5] = function(pos, mode) -- jump-if-true
		local state = read_value(program[pos + 1], mode[1])
		
		if state > 0 then
			i = read_value(program[pos + 2], mode[2]) + 1
		else
			i = i + 3
		end
		
		return false
	end,
	[6] = function(pos, mode) -- jump-if-false
		local state = read_value(program[pos + 1], mode[1])
		
		if state == 0 then
			i = read_value(program[pos + 2], mode[2]) + 1
		else
			i = i + 3
		end
		
		return false
	end,
	[7] = function(pos, mode) -- less than (first arg is less)
		local var_one = read_value(program[pos + 1], mode[1])
		local var_two = read_value(program[pos + 2], mode[2])
		
		if var_one < var_two then
			program[program[pos + 3] + 1] = 1
		else
			program[program[pos + 3] + 1] = 0
		end
		
		i = i + 4
		return false
	end,
	[8] = function(pos, mode) -- equals
		local var_one = read_value(program[pos + 1], mode[1])
		local var_two = read_value(program[pos + 2], mode[2])
		
		if var_one == var_two then
			program[program[pos + 3] + 1] = 1
		else
			program[program[pos + 3] + 1] = 0
		end
		
		i = i + 4
		return false
	end,
	[99] = function(pos, mode) -- halt
		return true
	end,
}

-- reads program from input file
for v in input:gmatch("[^,]+") do
	table.insert(program, tonumber(v))
	table.insert(prog_orig, tonumber(v))
end

function clear_memory()
	for i,v in ipairs(prog_orig) do
		program[i] = v
	end
end

function read_instruction(val)
	local instr, mode = 0, {0, 0, 0}
	local it = 1
	for v in string.gmatch(tostring(val):reverse(), ".") do
		if it == 1 then
			instr = tonumber(v)
		elseif it == 2 then
			instr = instr + (tonumber(v) * 10)
		elseif it == 3 then
			mode[1] = tonumber(v)
		elseif it == 4 then
			mode[2] = tonumber(v)
		elseif it == 5 then
			mode[3] = tonumber(v)
		end
		
		it = it + 1
	end
	
	instr = tonumber(instr)
	--print("intr:", instr, mode[1], mode[2], mode[3], val, tostring(val):reverse())
	return instr, mode
end

function exec()
	for n,v in ipairs(program) do
		if n == i then
			local instr, mode = read_instruction(v)
			local result = instruction[instr](i, mode)
			if result then break end
		end
	end
end

exec()

clear_memory()