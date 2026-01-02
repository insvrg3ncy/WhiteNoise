-- White Noise - Utility Functions
-- Вспомогательные функции для режимов

wn = wn or {}

-- Get world size (for map size detection)
WHITENOISE_BIGMAP = 5700

function wn.GetWorldSize()
	local world = game.GetWorld()
	if not IsValid(world) then return 0 end
	
	local worldMin = world:GetInternalVariable("m_WorldMins")
	local worldMax = world:GetInternalVariable("m_WorldMaxs")
	
	if not worldMin or not worldMax then return 0 end
	
	local size = worldMin:Distance(worldMax)
	
	-- Add bonus for known big maps
	local bigMaps = {
		-- Add known big maps here if needed
	}
	
	if bigMaps[game.GetMap()] then
		size = size + 5000
	end
	
	return size
end

-- Add attachment to weapon (placeholder - needs implementation)
function wn.AddAttachmentForce(ply, weapon, attachment)
	if not IsValid(ply) or not IsValid(weapon) then return false end
	if not attachment then return false end
	
	-- If attachment is a table, add all attachments
	if istable(attachment) then
		for _, att in ipairs(attachment) do
			wn.AddAttachmentForce(ply, weapon, att)
		end
		return true
	end
	
	-- Try to use hg.AddAttachmentForce if available
	if hg and hg.AddAttachmentForce then
		return hg.AddAttachmentForce(ply, weapon, attachment)
	end
	
	-- Fallback: just return true (attachment system will be implemented later)
	return true
end

-- Add armor to player (placeholder - needs implementation)
function wn.AddArmor(ply, armor)
	if not IsValid(ply) then return false end
	if not armor then return false end
	
	-- If armor is a table, add all armor pieces
	if istable(armor) then
		for _, arm in ipairs(armor) do
			wn.AddArmor(ply, arm)
		end
		return true
	end
	
	-- Try to use wn.AddArmor if available
	if wn and wn.AddArmor then
		return wn.AddArmor(ply, armor)
	end
	
	-- Fallback: just return true (armor system will be implemented later)
	return true
end

-- Apply appearance to player (placeholder - needs implementation)
function ApplyAppearance(ply)
	if not IsValid(ply) then return end
	
	-- Try to use hg.ApplyAppearance if available
	if hg and hg.ApplyAppearance then
		return hg.ApplyAppearance(ply)
	end
	
	-- Fallback: do nothing (appearance system will be implemented later)
end

-- Initialize harm tracking
wn.HarmDone = wn.HarmDone or {}

hook.Add("PlayerHurt", "WN_TrackHarm", function(victim, attacker, damage)
	if not IsValid(victim) or not IsValid(attacker) or not attacker:IsPlayer() then return end
	
	wn.HarmDone[victim] = wn.HarmDone[victim] or {}
	wn.HarmDone[victim][attacker] = (wn.HarmDone[victim][attacker] or 0) + damage
end)

hook.Add("PlayerDeath", "WN_ClearHarm", function(ply)
	if wn.HarmDone[ply] then
		wn.HarmDone[ply] = nil
	end
end)

hook.Add("WN_StartRound", "WN_ClearAllHarm", function()
	wn.HarmDone = {}
end)
