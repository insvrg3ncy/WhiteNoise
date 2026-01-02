local max, halfValue = math.max, util.halfValue
--local Organism = wn.organism
wn.organism.module.liver = {}
local module = wn.organism.module.liver
module[1] = function(org)
	org.liver = {
		0, -- на половине начинаются отклонение от нормы
		0.5
	}

	--задаём макс значение от которого он будет отталкиватся всё в секундах
	org.toxic = {
		natural = {0, 10, 0.5},
	}
end

module[2] = function(owner, org, mulTime)
	if not org.alive or org.hearstop then return end
	local toxic = org.toxic.natural
	toxic[1] = toxic[1] + 0.1
	local liver = org.liver
	toxic[1] = max(toxic[1] - 0.1 * (1 - halfValue(liver[1], 1, liver[2])), 0)
end