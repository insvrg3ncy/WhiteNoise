-- White Noise - Map Points System (Server)

if SERVER then
	-- Load map points from entities on map load
	hook.Add("InitPostEntity", "WN_LoadMapPoints", function()
		-- Find all info_target entities with specific keyvalues
		for _, ent in ipairs(ents.FindByClass("info_target")) do
			local pointType = ent:GetKeyValues().point_type or ent:GetKeyValues().PointType
			if pointType then
				wn.AddMapPoint(pointType, ent:GetPos(), ent:GetAngles())
			end
		end
		
		-- Also check for custom point entities
		for _, ent in ipairs(ents.FindByClass("info_wn_point")) do
			local pointType = ent:GetKeyValues().point_type or "Spawnpoint"
			wn.AddMapPoint(pointType, ent:GetPos(), ent:GetAngles())
		end
	end)
end
