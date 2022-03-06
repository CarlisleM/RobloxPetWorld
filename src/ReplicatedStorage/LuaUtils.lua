local module = {}

local ALLOWED_DS_TYPES = {
	["nil"] = true,
	["boolean"] = true,
	["number"] = true,
	["string"] = true,
	["table"] = true,
}

function module:checkDsFriendlyTypes(obj, key)
	local objType = typeof(obj)
	if not ALLOWED_DS_TYPES[objType] then
		return false
	elseif objType == "table" then
		for k, v in pairs(obj) do
			if not self:checkDsFriendlyTypes(k) then
				return false
			end
			if not self:checkDsFriendlyTypes(v) then
				return false
			end
		end
	end

	return true
end

function module:inTable(t, valueToFind)
	for i, v in pairs(t) do
		if v == valueToFind then
			return true
		end
	end
	
	return false
end

function module:shuffleArray(t)
	local rand = Random.new (tick())
	for i = #t, 2, -1 do
		local j = rand:NextInteger(1, i)
		t[i], t[j] = t[j], t[i]
	end
	return t
end

function module:tableLength(t)
	local count = 0
	for _ in pairs(t or {}) do count = count + 1 end
	return count
end

local function tablesEqual(arr1, arr2)
	if (arr1 == nil or arr2 == nil) and arr1 ~= arr2 then
		return false
	end

	for i, v in pairs(arr1) do
		if (typeof(v) == "table") then
			if (tablesEqual(v, arr2[i]) == false) then
				return false
			end
		else
			if (v ~= arr2[i]) then
				return false
			end
		end
	end
	
	for i, v in pairs(arr2) do
		if (typeof(v) == "table") then
			if (tablesEqual(v, arr1[i]) == false) then
				return false
			end
		else
			if (v ~= arr1[i]) then
				return false
			end
		end
	end

	return true
end
	
function module:tablesEqual(arr1, arr2)
	-- Return true if all values in both tables are true.
	return tablesEqual(arr1, arr2)
end

local function copyTable(obj)
	if type(obj) ~= 'table' then return obj end
    local res = {}
    for k, v in pairs(obj) do res[copyTable(k)] = copyTable(v) end
    return res
end

function module:copyTable(obj)
	return copyTable(obj)
end

function module:slice(array, offset, length)
	local results = {}

	for index = offset or 1, length or #array do
		table.insert(results, array[index])
	end

	return results
end

function module:convertSecondsToMSFormat(timeAmount)
	return ("%02d:%02d"):format(math.floor(timeAmount/60),timeAmount%60)
end

return module
