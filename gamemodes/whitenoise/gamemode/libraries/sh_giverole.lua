-- White Noise - Give Role System
-- System for giving roles to players

wn = wn or {}

-- Role definitions
wn.Roles = wn.Roles or {}

-- Give role to player
function wn.GiveRole(ply, roleName, color)
	if not IsValid(ply) then return false end
	
	-- Support both old format (roleName only) and new format (roleName, color)
	if color then
		-- New format: roleName and color (for compatibility with zbattle)
		hook.Run("WN_GettingRole", ply, roleName, color)
		
		if SERVER then
			util.AddNetworkString("WN_GiveRole")
			net.Start("WN_GiveRole")
				net.WriteString(roleName or "Unknown")
				net.WriteColor(color or color_white)
			net.Send(ply)
		end
		
		ply:SetNWString("WN_Role", roleName)
		ply:SetNWColor("WN_RoleColor", color or color_white)
		
		return true
	else
		-- Old format: roleName only (for compatibility with existing code)
		if not wn.Roles[roleName] then return false end
		
		local role = wn.Roles[roleName]
		
		-- Set team if role has team
		if role.team then
			ply:SetTeam(role.team)
		end
		
		-- Set player class if role has class
		if role.class then
			wn.SetPlayerClass(ply, role.class)
		end
		
		-- Give equipment
		if role.equipment then
			for _, wep in ipairs(role.equipment) do
				ply:Give(wep)
			end
		end
		
		-- Call role callback
		if role.OnGive then
			role:OnGive(ply)
		end
		
		ply:SetNWString("WN_Role", roleName)
		
		return true
	end
end

if CLIENT then
	net.Receive("WN_GiveRole", function()
		local roleName = net.ReadString()
		local color = net.ReadColor()
		LocalPlayer().role = {
			name = roleName,
			color = color
		}
	end)
end

-- Register role
function wn.RegisterRole(roleName, roleData)
	if not roleName or not roleData then return false end
	
	wn.Roles[roleName] = roleData
	return true
end

-- Get player role
function wn.GetPlayerRole(ply)
	if not IsValid(ply) then return nil end
	return ply:GetNWString("WN_Role", "")
end
