-- White Noise Base - Shared ConVars

if SERVER then
	CreateConVar("wnbase_debug", "0", {FCVAR_ARCHIVE}, "Enable WNBase debug mode")
	CreateConVar("wnbase_reloadspawnmenu", "1", {FCVAR_ARCHIVE}, "Reload spawn menu on WNBase reload")
	CreateConVar("wnbase_defaultmenu", "1", {FCVAR_ARCHIVE}, "Add NPCs to default spawn menu")
	CreateConVar("wnbase_replace", "0", {FCVAR_ARCHIVE}, "Replace default NPCs with WNBase versions")
end

if CLIENT then
	CreateClientConVar("wnbase_debug", "0", true, false, "Enable WNBase debug mode")
end

WNBCVAR = WNBCVAR or {}
WNBCVAR.Debug = GetConVar("wnbase_debug")
WNBCVAR.ReloadSpawnMenu = GetConVar("wnbase_reloadspawnmenu")
WNBCVAR.DefaultMenu = GetConVar("wnbase_defaultmenu")
WNBCVAR.Replace = GetConVar("wnbase_replace")
