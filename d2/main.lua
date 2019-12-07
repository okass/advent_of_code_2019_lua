local handle = io.open("input.txt", "rb")
local input = handle:read("*all")
handle:close()

local program = {}
local prog_orig = {}
local i = 1

local instruction = {
	[1] = function(pos)
		local x = program[program[pos + 1] + 1]
		local y = program[program[pos + 2] + 1]
		local z = program[pos + 3] + 1
		
		program[z] = x + y
		i = i + 4
		return false
	end,
	[2] = function(pos)
		local x = program[program[pos + 1] + 1]
		local y = program[program[pos + 2] + 1]
		local z = program[pos + 3] + 1
		
		program[z] = x * y
		i = i + 4
		return false
	end,
	[99] = function(pos)
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

function exec()
	for n,v in ipairs(program) do
		if n == i then
			local result = instruction[v](i)
			if result then break end
		end
	end
end

-- arguments 12 and 2
program[2] = 12
program[3] = 2

exec()

print("Value at pos 0: "..program[1])

-- puzzle 2

i = 1
clear_memory()

for noun = 0, 99, 1 do
	for verb = 0, 99, 1 do
		program[2] = noun
		program[3] = verb
		exec()
		local result = program[1]
		if result == 19690720 then
			print("Noun: "..noun.." Verb: "..verb)
			print("100 * noun + verb = "..(100 * noun + verb))
		end
		i = 1
		clear_memory()
	end
end