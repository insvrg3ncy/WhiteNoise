-- White Noise - Player Class System (Shared)

wn = wn or {}
wn.PlayerClasses = wn.PlayerClasses or {}

-- Get player class
function wn.GetPlayerClass(ply)
	if not IsValid(ply) then return nil end
	return ply:GetNWString("WN_PlayerClass", "Base")
end

-- Get player class data
function wn.GetPlayerClassData(ply)
	local className = wn.GetPlayerClass(ply)
	return wn.PlayerClasses[className] or wn.PlayerClasses.Base
end

-- Set player class
function wn.SetPlayerClass(ply, className)
	if not IsValid(ply) then return false end
	if not wn.PlayerClasses[className] then return false end
	
	ply:SetNWString("WN_PlayerClass", className)
	
	if SERVER then
		local classData = wn.PlayerClasses[className]
		if classData.OnSpawn then
			classData:OnSpawn(ply)
		end
	end
	
	return true
end

-- Register player class
function wn.RegisterPlayerClass(className, classData)
	if not className or not classData then return false end
	
	-- Inherit from base if not specified
	if not classData.Base then
		classData.Base = "Base"
	end
	
	-- Inherit from base class
	if classData.Base and wn.PlayerClasses[classData.Base] then
		local baseClass = wn.PlayerClasses[classData.Base]
		classData = table.Inherit(classData, baseClass)
	end
	
	wn.PlayerClasses[className] = classData
	return true
end
