function GenerateUVs(tileWidth, tileHeight, texture)
	
	--This is the table we'll fill with uvs and return
	local uvs = {}

	local textureWidth = texture:GetWidth()
	local textureHeight = texture:GetHeight()
	local width = tileWidth / textureWidth 
	local height = tileHeight / textureHeight
	local cols = textureWidth / tileWidth
	local rows = textureHeight / tileWidth

	local ux = 0
	local uy = 0
	local vx = width
	local vy = height 

	for j = 0, rows - 1 do
		for i = 0, cols - 1 do

		table.insert(uvs, {ux, uy, vx, vy})

		--advance the UVs to the next column
		ux = ux + width
		vx = vx + width 

		end

		--Put the UVs back at the start of the next row 
		ux = 0
		vx = width
		uy = uy + height
		vy = vy + height
	end
	return uvs
end

function ShallowClone(t)
	local clone = {}
	for k, v in pairs(t) do
		clone[k] = v
	end
	return clone
end

function DeepClone(t)
	local clone = {}
	for k, v in pairs(t) do
		if type(v) == "table" then
			clone[k] = DeepClone(v)
		else
		clone[k] = v
		end
	end
	return clone
end

function DeepCopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[DeepCopy(orig_key)] = DeepCopy(orig_value)
        end
       -- setmetatable(copy, DeepCopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

--[[function deepcompare(t1,t2,ignore_mt)
local ty1 = type(t1)
local ty2 = type(t2)
if ty1 ~= ty2 then return false end
-- non-table types can be directly compared
if ty1 ~= 'table' and ty2 ~= 'table' then return t1 == t2 end
-- as well as tables which have the metamethod __eq
local mt = getmetatable(t1)
if not ignore_mt and mt and mt.__eq then return t1 == t2 end
for k1,v1 in pairs(t1) do
local v2 = t2[k1]
if v2 == nil or not deepcompare(v1,v2) then return false end
end
for k2,v2 in pairs(t2) do
local v1 = t1[k2]
if v1 == nil or not deepcompare(v1,v2) then return false end
end
return true
end]]