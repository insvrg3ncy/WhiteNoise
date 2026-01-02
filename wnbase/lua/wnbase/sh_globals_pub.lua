-- White Noise Base - Public Globals
-- This file contains public global variables and functions for WNBase

WNBase = WNBase or {}
WNBase.Version = "1.0.0"

-- Color scheme - White theme
WNBase.Colors = {
	Primary = Color(255, 255, 255),
	Secondary = Color(240, 240, 240),
	Tertiary = Color(220, 220, 220),
	Accent = Color(200, 200, 200),
	Text = Color(255, 255, 255),
	TextDark = Color(50, 50, 50),
	Background = Color(255, 255, 255),
	BackgroundDark = Color(240, 240, 240),
}

-- NPC Types
WNBASE_SNPCTYPE_GROUND = 0
WNBASE_SNPCTYPE_FLY = 1
WNBASE_SNPCTYPE_WATER = 2

-- Utility functions
function WNBase:Print(message)
	print("[WNBase] " .. tostring(message))
end

function WNBase:Error(message)
	ErrorNoHalt("[WNBase ERROR] " .. tostring(message) .. "\n")
end
