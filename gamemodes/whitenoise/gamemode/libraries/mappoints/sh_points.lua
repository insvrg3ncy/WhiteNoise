-- White Noise - Map Points System (Shared)

wn = wn or {}

-- Map points storage
wn.MapPoints = wn.MapPoints or {}

-- Get map points by type
function wn.GetMapPoints(type)
	if not type then return {} end
	wn.MapPoints[type] = wn.MapPoints[type] or {}
	return wn.MapPoints[type]
end

-- Add map point
function wn.AddMapPoint(type, pos, ang)
	if not type or not pos then return end
	
	if not wn.MapPoints[type] then
		wn.MapPoints[type] = {}
	end
	
	table.insert(wn.MapPoints[type], {
		pos = pos,
		ang = ang or Angle(0, 0, 0)
	})
end

-- Clear map points
function wn.ClearMapPoints(type)
	if type then
		wn.MapPoints[type] = {}
	else
		wn.MapPoints = {}
	end
end
