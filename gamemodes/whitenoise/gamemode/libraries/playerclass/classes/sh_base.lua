-- White Noise - Base Player Class

wn = wn or {}
wn.PlayerClasses = wn.PlayerClasses or {}

-- Base class definition
wn.PlayerClasses.Base = {
	name = "Base",
	description = "Base player class",
	color = Color(255, 255, 255),
	health = 100,
	armor = 0,
	speed = 1.0,
	jump = 1.0,
	weapons = {},
	models = {},
	abilities = {},
	
	OnSpawn = function(self, ply)
		-- Base spawn logic
		ply:SetHealth(self.health)
		ply:SetArmor(self.armor)
		ply:SetWalkSpeed(250 * self.speed)
		ply:SetRunSpeed(320 * self.speed)
		ply:SetJumpPower(200 * self.jump)
	end,
	
	OnDeath = function(self, ply)
		-- Base death logic
	end,
	
	OnAbility = function(self, ply, ability)
		-- Base ability logic
	end
}
