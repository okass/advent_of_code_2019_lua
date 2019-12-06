local fuel = 0

-- puzzle 1
for v in io.lines("input.txt") do
	fuel = fuel + (math.floor(tonumber(v) / 3) - 2)
end	

print("Needed fuel without parts: "..fuel)

-- puzzle 2
fuel = 0

function calculate_fuel_module(module_fuel)
	local fuel_mod = 0
	local previous_fuel = module_fuel
	
	while previous_fuel > 0 do
		local sub_fuel = math.floor(previous_fuel / 3) - 2
		if sub_fuel < 0 then sub_fuel = 0 end
		fuel_mod = fuel_mod + sub_fuel
		previous_fuel = sub_fuel
	end
	
	return fuel_mod
end

for module_mass in io.lines("input.txt") do
	module_fuel = math.floor(tonumber(module_mass) / 3) - 2
	
	fuel = fuel + module_fuel + calculate_fuel_module(module_fuel)
end	

print("Needed fuel with parts: "..fuel)