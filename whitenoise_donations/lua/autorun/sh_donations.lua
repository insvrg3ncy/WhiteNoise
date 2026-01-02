-- White Noise Donation System
-- Shared donation system code

WN = WN or {}
WN.Donations = WN.Donations or {}

-- Donation ranks/privileges
WN.Donations.Ranks = {
	["default"] = {
		name = "Player",
		color = Color(255, 255, 255),
		permissions = {}
	},
	["donator"] = {
		name = "Donator",
		color = Color(240, 240, 240),
		permissions = {
			"donator_tag",
			"donator_chat_color",
			"donator_weapon_skin"
		}
	},
	["vip"] = {
		name = "VIP",
		color = Color(255, 255, 200),
		permissions = {
			"donator_tag",
			"donator_chat_color",
			"donator_weapon_skin",
			"vip_spawn_weapon",
			"vip_custom_model",
			"vip_reserved_slot"
		}
	},
	["premium"] = {
		name = "Premium",
		color = Color(255, 255, 150),
		permissions = {
			"donator_tag",
			"donator_chat_color",
			"donator_weapon_skin",
			"vip_spawn_weapon",
			"vip_custom_model",
			"vip_reserved_slot",
			"premium_experience_boost",
			"premium_custom_title",
			"premium_priority_support"
		}
	},
	["sponsor"] = {
		name = "Sponsor",
		color = Color(255, 255, 100),
		permissions = {
			"donator_tag",
			"donator_chat_color",
			"donator_weapon_skin",
			"vip_spawn_weapon",
			"vip_custom_model",
			"vip_reserved_slot",
			"premium_experience_boost",
			"premium_custom_title",
			"premium_priority_support",
			"sponsor_admin_commands",
			"sponsor_custom_weapon",
			"sponsor_event_access"
		}
	}
}

-- Check if player has permission
function WN.Donations:HasPermission(ply, permission)
	if not IsValid(ply) then return false end
	
	local rank = ply:GetNWString("WN_DonationRank", "default")
	local rankData = self.Ranks[rank]
	
	if not rankData then return false end
	
	return table.HasValue(rankData.permissions, permission)
end

-- Get player rank data
function WN.Donations:GetRankData(ply)
	if not IsValid(ply) then return self.Ranks["default"] end
	
	local rank = ply:GetNWString("WN_DonationRank", "default")
	return self.Ranks[rank] or self.Ranks["default"]
end

-- Get player rank name
function WN.Donations:GetRankName(ply)
	local rankData = self:GetRankData(ply)
	return rankData.name
end

-- Get player rank color
function WN.Donations:GetRankColor(ply)
	local rankData = self:GetRankData(ply)
	return rankData.color
end
