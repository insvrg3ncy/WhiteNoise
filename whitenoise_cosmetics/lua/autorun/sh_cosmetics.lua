-- White Noise - Cosmetics System
-- Shared cosmetics code

WN = WN or {}
WN.Cosmetics = WN.Cosmetics or {}

-- Cosmetic categories
WN.Cosmetics.Categories = {
	["hats"] = {
		name = "Hats",
		icon = "icon16/user_suit.png",
		color = Color(255, 255, 255)
	},
	["masks"] = {
		name = "Masks",
		icon = "icon16/user_suit.png",
		color = Color(255, 255, 255)
	},
	["backpacks"] = {
		name = "Backpacks",
		icon = "icon16/package.png",
		color = Color(255, 255, 255)
	},
	["trails"] = {
		name = "Trails",
		icon = "icon16/star.png",
		color = Color(255, 255, 255)
	},
	["effects"] = {
		name = "Effects",
		icon = "icon16/lightning.png",
		color = Color(255, 255, 255)
	},
	["tags"] = {
		name = "Name Tags",
		icon = "icon16/tag.png",
		color = Color(255, 255, 255)
	}
}

-- Cosmetic items (mapped to IGS items)
WN.Cosmetics.Items = {
	-- Hats
	["wn_hat_beret"] = {
		name = "Beret",
		category = "hats",
		igs_item = "wn_hat_beret",
		description = "Classic military beret",
		model = "models/player/items/all_class/beret_demo.mdl",
		bone = "ValveBiped.Bip01_Head1",
		pos = Vector(0, 0, 0),
		ang = Angle(0, 0, 0)
	},
	["wn_hat_cap"] = {
		name = "Baseball Cap",
		category = "hats",
		igs_item = "wn_hat_cap",
		description = "Stylish baseball cap",
		model = "models/player/items/all_class/cap_demo.mdl",
		bone = "ValveBiped.Bip01_Head1",
		pos = Vector(0, 0, 0),
		ang = Angle(0, 0, 0)
	},
	["wn_hat_helmet"] = {
		name = "Combat Helmet",
		category = "hats",
		igs_item = "wn_hat_helmet",
		description = "Tactical combat helmet",
		model = "models/player/items/all_class/helmet_demo.mdl",
		bone = "ValveBiped.Bip01_Head1",
		pos = Vector(0, 0, 0),
		ang = Angle(0, 0, 0)
	},
	
	-- Masks
	["wn_mask_balaclava"] = {
		name = "Balaclava",
		category = "masks",
		igs_item = "wn_mask_balaclava",
		description = "Tactical face mask",
		model = "models/player/items/all_class/mask_demo.mdl",
		bone = "ValveBiped.Bip01_Head1",
		pos = Vector(0, 0, 0),
		ang = Angle(0, 0, 0)
	},
	["wn_mask_gas"] = {
		name = "Gas Mask",
		category = "masks",
		igs_item = "wn_mask_gas",
		description = "Protective gas mask",
		model = "models/player/items/all_class/gasmask_demo.mdl",
		bone = "ValveBiped.Bip01_Head1",
		pos = Vector(0, 0, 0),
		ang = Angle(0, 0, 0)
	},
	
	-- Backpacks
	["wn_backpack_tactical"] = {
		name = "Tactical Backpack",
		category = "backpacks",
		igs_item = "wn_backpack_tactical",
		description = "Military tactical backpack",
		model = "models/player/items/all_class/backpack_demo.mdl",
		bone = "ValveBiped.Bip01_Spine4",
		pos = Vector(0, 0, 0),
		ang = Angle(0, 0, 0)
	},
	
	-- Trails
	["wn_trail_white"] = {
		name = "White Trail",
		category = "trails",
		igs_item = "wn_trail_white",
		description = "Elegant white particle trail",
		effect = "wn_trail_white"
	},
	["wn_trail_glow"] = {
		name = "Glow Trail",
		category = "trails",
		igs_item = "wn_trail_glow",
		description = "Glowing particle trail",
		effect = "wn_trail_glow"
	},
	
	-- Effects
	["wn_effect_aura"] = {
		name = "Aura Effect",
		category = "effects",
		igs_item = "wn_effect_aura",
		description = "Mystical aura around player",
		effect = "wn_effect_aura"
	},
	["wn_effect_sparkles"] = {
		name = "Sparkles",
		category = "effects",
		igs_item = "wn_effect_sparkles",
		description = "Sparkling particle effect",
		effect = "wn_effect_sparkles"
	},
	
	-- Name Tags
	["wn_tag_vip"] = {
		name = "VIP Tag",
		category = "tags",
		igs_item = "wn_tag_vip",
		description = "VIP name tag",
		tag = "[VIP]"
	},
	["wn_tag_donator"] = {
		name = "Donator Tag",
		category = "tags",
		igs_item = "wn_tag_donator",
		description = "Donator name tag",
		tag = "[DONATOR]"
	}
}

-- Check if player has cosmetic (using IGS)
function WN.Cosmetics:HasCosmetic(ply, cosmeticId)
	if not IsValid(ply) then return false end
	
	local item = self.Items[cosmeticId]
	if not item then return false end
	
	-- Check IGS inventory
	if IGS and ply.HasPurchase then
		return ply:HasPurchase(item.igs_item)
	end
	
	return false
end

-- Get player's active cosmetics
function WN.Cosmetics:GetPlayerCosmetics(ply)
	if not IsValid(ply) then return {} end
	
	local cosmetics = {}
	
	if IGS and ply.HasPurchase then
		for cosmeticId, item in pairs(self.Items) do
			if ply:HasPurchase(item.igs_item) then
				-- Check if equipped
				local equipped = ply:GetNWString("WN_Cosmetic_" .. cosmeticId, "") == "1"
				if equipped then
					table.insert(cosmetics, cosmeticId)
				end
			end
		end
	end
	
	return cosmetics
end
