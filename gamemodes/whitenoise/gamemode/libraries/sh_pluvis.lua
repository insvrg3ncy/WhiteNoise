-- White Noise - Pluvis Library (adapted from original)
-- Utility functions for White Noise gamemode

wn = wn or {}

-- Map points system
wn.MapPoints = wn.MapPoints or {}

function wn.GetMapPoints(type)
	wn.MapPoints[type] = wn.MapPoints[type] or {}
	return wn.MapPoints[type]
end

function wn.AddMapPoint(type, pos, ang)
	if not wn.MapPoints[type] then
		wn.MapPoints[type] = {}
	end
	
	table.insert(wn.MapPoints[type], {
		pos = pos,
		ang = ang or Angle(0, 0, 0)
	})
end

-- Utility functions
function wn.tpPlayer(pos, ply, index, offset)
	if not pos then return end
	
	local offsetVec = Vector(
		math.cos(math.rad(index * 15)) * offset,
		math.sin(math.rad(index * 15)) * offset,
		0
	)
	
	return pos + offsetVec
end

function wn.earanim(ply)
	-- Ear animation placeholder
	-- Implement ear animation logic here
end

-- ConVars
if not ConVarExists("wn_potatopc") then
	CreateConVar("wn_potatopc", "0", {FCVAR_ARCHIVE}, "Enable potato PC mode (disables blur effects)")
end

wn.ConVars = wn.ConVars or {}
wn.ConVars.potatopc = GetConVar("wn_potatopc")
