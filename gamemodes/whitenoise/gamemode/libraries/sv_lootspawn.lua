-- White Noise - Loot Spawn System (Server)

if SERVER then
	wn = wn or {}
	wn.LootSpawn = wn.LootSpawn or {}
	
	-- Loot definitions
	wn.LootSpawn.LootTypes = wn.LootSpawn.LootTypes or {}
	
	-- Spawned loot
	wn.LootSpawn.SpawnedLoot = wn.LootSpawn.SpawnedLoot or {}
	
	-- Register loot type
	function wn.LootSpawn:RegisterLootType(lootType, lootData)
		if not lootType or not lootData then return false end
		
		self.LootTypes[lootType] = lootData
		return true
	end
	
	-- Spawn loot at position
	function wn.LootSpawn:SpawnLoot(pos, lootType)
		if not pos then return nil end
		
		local lootData = self.LootTypes[lootType]
		if not lootData then return nil end
		
		-- Spawn loot entity
		local loot = ents.Create(lootData.class or "prop_physics")
		if not IsValid(loot) then return nil end
		
		loot:SetPos(pos)
		loot:SetModel(lootData.model or "models/props_junk/cardboard_box004a.mdl")
		loot:SetAngles(Angle(0, math.random(0, 360), 0))
		loot:Spawn()
		loot:Activate()
		
		-- Store loot data
		loot.WN_LootType = lootType
		loot.WN_LootData = lootData
		
		table.insert(self.SpawnedLoot, loot)
		
		return loot
	end
	
	-- Clear all loot
	function wn.LootSpawn:ClearAll()
		for _, loot in ipairs(self.SpawnedLoot) do
			if IsValid(loot) then
				loot:Remove()
			end
		end
		
		self.SpawnedLoot = {}
	end
	
	-- Spawn loot at random map points
	function wn.LootSpawn:SpawnAtRandomPoints(lootType, count)
		count = count or 10
		
		local spawnPoints = wn.GetMapPoints("LootSpawn")
		if #spawnPoints == 0 then
			spawnPoints = wn.GetMapPoints("Spawnpoint")
		end
		
		if #spawnPoints == 0 then return end
		
		for i = 1, count do
			local point = table.Random(spawnPoints)
			if point then
				self:SpawnLoot(point.pos, lootType)
			end
		end
	end
end
