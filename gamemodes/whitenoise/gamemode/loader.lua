local function IncluderFunc(fileName)
	if (fileName:find("sv_")) then
		include(fileName)
	elseif (fileName:find("shared.lua") or fileName:find("sh_")) then
		if (SERVER) then
			AddCSLuaFile(fileName)
		end

		include(fileName)
	elseif (fileName:find("cl_")) then
		if (SERVER) then
			AddCSLuaFile(fileName)
		else
			include(fileName)
		end
	end
end

-- Load files from directories recursively
local function LoadFromDir(directory)
    local files, folders = file.Find(directory .. "/*", "LUA")
    
	for _, v in ipairs(folders) do
        LoadFromDir(directory .. "/" .. v)
	end

	for _, v in ipairs(files) do
		IncluderFunc(directory .. "/" .. v)
	end
end

LoadFromDir("whitenoise/gamemode/libraries")

-- Mode loader system
wn.modesHooks = {}
wn.modes = wn.modes or {}

local function LoadModes()
    local directory = "whitenoise/gamemode/modes"
    local files, folders = file.Find(directory .. "/*", "LUA")
    
    for _, v in ipairs(files) do
        MODE = {}

        IncluderFunc(directory .. "/" .. v)
        if table.IsEmpty(MODE) then continue end
        
        local saved = wn.modes[MODE.name] and wn.modes[MODE.name].saved or {}

        if MODE.base then
            table.Inherit(MODE,wn.modes[MODE.base])
        end

        wn.modes[MODE.name] = MODE
        
        wn.modes[MODE.name].saved = saved

        for k, v2 in pairs(MODE) do
            if isfunction(v2) then
                wn.modesHooks[MODE.name] = wn.modesHooks[MODE.name] or {}
                wn.modesHooks[MODE.name][k] = v2
            end
        end

        MODE = nil
	end

    for _, v in ipairs(folders) do
        MODE = {}

        LoadFromDir(directory .. "/" .. v)
        if table.IsEmpty(MODE) then continue end

        local saved = wn.modes[MODE.name] and wn.modes[MODE.name].saved or {}

        if MODE.base then
            table.Inherit(MODE,wn.modes[MODE.base])
        end

        wn.modes[MODE.name] = MODE

        wn.modes[MODE.name].saved = saved

        for k, v2 in pairs(MODE) do
            if isfunction(v2) then
                wn.modesHooks[MODE.name] = wn.modesHooks[MODE.name] or {}
                wn.modesHooks[MODE.name][k] = v2
            end
        end

        MODE = nil
	end
end

LoadModes()

print("White Noise modes loaded!")

wn.oldHook = wn.oldHook or hook.Call

function wn:HookCall(name, gmTable, ...)
	local mode = wn.modes[wn.CROUND]
	if not mode then return wn.oldHook(name, gmTable, ...) end
	
	local hookFunc = wn.modesHooks[wn.CROUND] and wn.modesHooks[wn.CROUND][name]
	if hookFunc then
		return hookFunc(...)
	end
	
	return wn.oldHook(name, gmTable, ...)
end

hook.Call = function(name, gmTable, ...)
	return wn:HookCall(name, gmTable, ...)
end
