local MODE = MODE

wn = wn or {}
wn.Points = wn.Points or {}

wn.Points.NPC_DEFENSE_SPAWN= wn.Points.NPC_DEFENSE_SPAWN or {}
wn.Points.NPC_DEFENSE_SPAWN.Color = Color(243,9,9)
wn.Points.NPC_DEFENSE_SPAWN.Name = "NPC_DEFENSE_SPAWN"

wn.Points.PLY_DEFENSE_SPAWN = wn.Points.PLY_DEFENSE_SPAWN or {}
wn.Points.PLY_DEFENSE_SPAWN.Color = Color(51,243,9)
wn.Points.PLY_DEFENSE_SPAWN.Name = "PLY_DEFENSE_SPAWN"

wn.Points.DEFENSE_POINT = wn.Points.DEFENSE_POINT or {}
wn.Points.DEFENSE_POINT.Color = Color(13,9,243)
wn.Points.DEFENSE_POINT.Name = "DEFENSE_POINT"


MODE.SUBMODES = {
    STANDARD = {
        name = "Standard",
        description = "Classic 6 waves of combine attacks",
        waves = 6,
        enemy_type = "combine"
    },
    EXTENDED = {
        name = "Extended",
        description = "Extended mode: 12 waves with bosses and special enemies",
        waves = 12,
        enemy_type = "combine"
    },
    ZOMBIE = {
        name = "Zombie",
        description = "6 waves of zombie apocalypse",
        waves = 6,
        enemy_type = "zombie"
    }
}