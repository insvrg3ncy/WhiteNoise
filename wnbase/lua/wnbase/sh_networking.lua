-- White Noise Base - Networking System
-- Adapted from Homigrad

wn = wn or {}

if (CLIENT) then
    local entityMeta = FindMetaTable("Entity")
    local playerMeta = FindMetaTable("Player")

    wn.net = wn.net or {}
    wn.net.globals = wn.net.globals or {}

    net.Receive("WNGlobalVarSet", function()
        local key, var = net.ReadString(), net.ReadType()

    	wn.net.globals[key] = var
		
        hook.Run("OnGlobalVarSet", key, var)
    end)

    net.Receive("WNNetVarSet", function()
        local index = net.ReadUInt(16)

		local key = net.ReadString()
    	local var = net.ReadType()
		
        wn.net[index] = wn.net[index] or {}
        wn.net[index][key] = var
		
		if IsValid(Entity(index)) then
			hook.Run("OnNetVarSet", index, key, var)
		else
			wn.net[index].waiting = true
		end
    end)
	
    net.Receive("WNNetVarDelete", function()
    	wn.net[net.ReadUInt(16)] = nil
    end)

    net.Receive("WNLocalVarSet", function()
    	local key = net.ReadString()
    	local var = net.ReadType()

    	wn.net[LocalPlayer():EntIndex()] = wn.net[LocalPlayer():EntIndex()] or {}
    	wn.net[LocalPlayer():EntIndex()][key] = var

    	hook.Run("OnLocalVarSet", key, var)
    end)

    function GetNetVar(key, default) -- luacheck: globals GetNetVar
    	local value = wn.net.globals[key]

    	return value != nil and value or default
    end

    function entityMeta:GetNetVar(key, default)
    	local index = self:EntIndex()

    	if (wn.net[index] and wn.net[index][key] != nil) then
    		return wn.net[index][key]
    	end

    	return default
    end

    playerMeta.GetLocalVar = entityMeta.GetNetVar

	hook.Add("InitPostEntity", "OnRequestFullUpdate_wn", function()
		LocalPlayer():SyncVars()
	end)

	function playerMeta:SyncVars()
		net.Start("WN_request_fullupdate")
		net.SendToServer()
	end
else
	util.AddNetworkString("WN_request_fullupdate")

	net.Receive("WN_request_fullupdate",function(len,ply)
		ply.cooldown_sendnet = ply.cooldown_sendnet or 0
		if ply.cooldown_sendnet < CurTime() then
			ply.cooldown_sendnet = CurTime() + 1

			ply:SyncVars()
		end
	end)

	gameevent.Listen( "OnRequestFullUpdate" )
	hook.Add("OnRequestFullUpdate", "OnRequestFullUpdate_wn", function(data)
		local id = data.userid
		local ply = Player(id)
		
		ply:SyncVars()
	end)
	
	
    local entityMeta = FindMetaTable("Entity")
    local playerMeta = FindMetaTable("Player")

    wn.net = wn.net or {}
    wn.net.list = wn.net.list or {}
    wn.net.locals = wn.net.locals or {}
    wn.net.globals = wn.net.globals or {}

    util.AddNetworkString("WNGlobalVarSet")
    util.AddNetworkString("WNLocalVarSet")
    util.AddNetworkString("WNNetVarSet")
    util.AddNetworkString("WNNetVarDelete")

    local function CheckBadType(name, object)
		return false
    	--[[if (isfunction(object)) then
    		ErrorNoHalt("Net var '" .. name .. "' contains a bad object type!")

    		return true
    	elseif (istable(object)) then
    		for k, v in pairs(object) do
    			if (CheckBadType(name, k) or CheckBadType(name, v)) then
    				return true
    			end
    		end
    	end--]]
    end

    function GetNetVar(key, default)
    	local value = wn.net.globals[key]

    	return value != nil and value or default
    end

    function SetNetVar(key, value, receiver)
    	if (CheckBadType(key, value)) then return end
    	--if (GetNetVar(key) == value) then return end
		
    	wn.net.globals[key] = value

    	net.Start("WNGlobalVarSet")
    	net.WriteString(key)
    	net.WriteType(value)

    	if (receiver == nil) then
    		net.Broadcast()
    	else
    		net.Send(receiver)
    	end
    end

    function playerMeta:SyncVars()
    	for k, v in pairs(wn.net.globals) do
    		net.Start("WNGlobalVarSet")
    			net.WriteString(k)
    			net.WriteType(v)
    		net.Send(self)
    	end

    	for k, v in pairs(wn.net.locals[self] or {}) do
    		net.Start("WNLocalVarSet")
    			net.WriteString(k)
    			net.WriteType(v)
    		net.Send(self)
    	end

    	for entity, data in pairs(wn.net.list) do
    		if (IsValid(entity)) then
    			local index = entity:EntIndex()

    			for k, v in pairs(data) do
    				net.Start("WNNetVarSet")
    					net.WriteUInt(index, 16)
    					net.WriteString(k)
    					net.WriteType(v)
    				net.Send(self)
    			end
    		end
    	end
    end
	
    function playerMeta:GetLocalVar(key, default)
    	if (wn.net.locals[self] and wn.net.locals[self][key] != nil) then
    		return wn.net.locals[self][key]
    	end

    	return default
    end

    function playerMeta:SetLocalVar(key, value)
    	if (CheckBadType(key, value)) then return end

    	wn.net.locals[self] = wn.net.locals[self] or {}
    	wn.net.locals[self][key] = value

    	net.Start("WNLocalVarSet")
    		net.WriteString(key)
    		net.WriteType(value)
    	net.Send(self)
    end

    function entityMeta:GetNetVar(key, default)
    	if (wn.net.list[self] and wn.net.list[self][key] != nil) then
    		return wn.net.list[self][key]
    	end

    	return default
    end

    function entityMeta:SetNetVar(key, value, receiver)
    	if (CheckBadType(key, value)) then return end

		wn.net.list[self] = wn.net.list[self] or {}

		--if not wn.IsChanged(value, key, wn.net.list[self]) then return end

    	if (wn.net.list[self][key] != value) then
    		wn.net.list[self][key] = value 
    	end
		
		self:SendNetVar(key, receiver)
	end

    function entityMeta:SendNetVar(key, receiver)
    	net.Start("WNNetVarSet")
    	net.WriteUInt(self:EntIndex(), 16)
    	net.WriteString(key)
    	net.WriteType(wn.net.list[self] and wn.net.list[self][key])

    	if (receiver == nil) then
    		net.Broadcast()
    	else
    		net.Send(receiver)
    	end
    end

    function entityMeta:ClearNetVars(receiver)
    	wn.net.list[self] = nil
    	wn.net.locals[self] = nil

    	net.Start("WNNetVarDelete")
    	net.WriteUInt(self:EntIndex(), 16)

    	if (receiver == nil) then
    		net.Broadcast()
    	else
    		net.Send(receiver)
    	end
    end
	
	hook.Add("EntityRemoved","WN_clear_net",function(ent,fullUpdate)
		ent:ClearNetVars()
	end)

	hook.Add("PlayerDisconnected","WN_clear_net",function(ply)
		ply:ClearNetVars()
	end)
end
