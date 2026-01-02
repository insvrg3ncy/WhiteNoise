-- White Noise - Simplex Library (adapted)
-- Simple utility functions

wn = wn or {}

-- Simple random functions
function wn.RandomFloat(min, max)
	return math.Rand(min or 0, max or 1)
end

function wn.RandomInt(min, max)
	return math.random(min or 0, max or 1)
end

-- Simple table functions
function wn.TableRandom(tbl)
	if not tbl or #tbl == 0 then return nil end
	return tbl[math.random(#tbl)]
end

function wn.TableShuffle(tbl)
	local shuffled = {}
	local indices = {}
	
	for i = 1, #tbl do
		indices[i] = i
	end
	
	while #indices > 0 do
		local randIndex = math.random(#indices)
		local actualIndex = indices[randIndex]
		table.insert(shuffled, tbl[actualIndex])
		table.remove(indices, randIndex)
	end
	
	return shuffled
end

-- Simple string functions
function wn.StringStartsWith(str, prefix)
	return string.sub(str, 1, string.len(prefix)) == prefix
end

function wn.StringEndsWith(str, suffix)
	return string.sub(str, -string.len(suffix)) == suffix
end

-- Simple math functions
function wn.Lerp(frac, from, to)
	return from + (to - from) * frac
end

function wn.Clamp(val, min, max)
	return math.Clamp(val, min, max)
end
