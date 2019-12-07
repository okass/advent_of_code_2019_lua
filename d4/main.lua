local handle = io.open("input.txt")
local min,max = handle:read("*all"):match("(.-)-(.+)")
min = tonumber(min)
max = tonumber(max)
handle:close()
local i = min
local count = 0

print("Range: "..min.." - "..max)

-- since max allowed digits are 6
function isDouble(val)
	val = tostring(val)
	
	for i=1,5 do
		if (val:sub(i,i)) == (val:sub(i + 1, i + 1)) then 
			return true 
		end
	end
	
	return false
end

function isIncreasing(val)
	val = tostring(val)
	
	for i=1,5 do
		local digit, next_digit = tonumber(val:sub(i, i)), 
										tonumber(val:sub(i + 1, i + 1))
		
		if digit > next_digit then 
			return false
		end
	end
	
	return true
end

-- puzzle 1

while i <= max do
	if isDouble(i) and isIncreasing(i) then
		count = count + 1
	end
	i = i + 1
end

print("Possible variation count:", count, "\n")

-- puzzle 2

function isDoubleOnly(val)
	val = tostring(val)
	
	for i=1,5 do
		-- check if free double exists
		if val:sub(i,i) ~= val:sub(i + 2, i + 2)
			and val:sub(i,i) ~= val:sub(i - 1, i - 1)
			and val:sub(i,i) == val:sub(i + 1, i + 1) then
			
			return true
		end
	end
	
	return false
end

count = 0
i = min

while i <= max do
	if isDouble(i) and isIncreasing(i) and isDoubleOnly(i) then
		count = count + 1
	end
	i = i + 1
end

print("Possible variation count without large groups:", count)