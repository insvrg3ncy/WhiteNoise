WNBaseInstalled = true

--[[
======================================================================================================================================================
                                           NETWORK
======================================================================================================================================================
--]]

if SERVER then
    util.AddNetworkString("WNBaseListFactions")
    util.AddNetworkString("WNBase_GetFactionsFromServer")
    util.AddNetworkString("WNBaseClientReload")
    util.AddNetworkString("WNBaseReload")
    util.AddNetworkString("WNBaseUpdateSpawnMenuFactionDropDown")

    net.Receive("WNBase_GetFactionsFromServer", function(_, ply)
        WNBaseListFactions(_, ply)
    end)

    net.Receive("WNBaseReload", function()
        WNBase_RegisterHandler:NetworkedReload()
    end)
end

if CLIENT then
    net.Receive("WNBaseClientReload", function()
        WNBase_RegisterHandler:Reload()
    end)
end

--[[
======================================================================================================================================================
                                           PARTICLES
======================================================================================================================================================
--]]

game.AddParticles("particles/wnbase/wnbase_blood_impact.pcf")
game.AddParticles("particles/wnbase/hl2mmod_muzzleflashes_npc.pcf")

game.AddParticles("particles/striderbuster.pcf")
game.AddParticles("particles/mortarsynth_fx.pcf")

PrecacheParticleSystem("blood_impact_wnbase_white")
PrecacheParticleSystem("blood_impact_wnbase_black")
PrecacheParticleSystem("blood_impact_wnbase_blue")
PrecacheParticleSystem("blood_impact_wnbase_synth")
PrecacheParticleSystem("striderbuster_break")
PrecacheParticleSystem("striderbuster_break_shell")

PrecacheParticleSystem("hl2mmod_muzzleflash_npc_ar2")
PrecacheParticleSystem("hl2mmod_muzzleflash_npc_pistol")
PrecacheParticleSystem("hl2mmod_muzzleflash_npc_shotgun")

--[[
======================================================================================================================================================
                                           DECALS
======================================================================================================================================================
--]]

game.AddDecal("WNBaseBloodBlack", {
    "decals/wnbase_blood_black/blood1",
    "decals/wnbase_blood_black/blood2",
    "decals/wnbase_blood_black/blood3",
    "decals/wnbase_blood_black/blood4",
    "decals/wnbase_blood_black/blood5",
    "decals/wnbase_blood_black/blood6",
})

game.AddDecal("WNBaseBloodSynth", {
    "decals/wnbase_blood_synth/blood1",
    "decals/wnbase_blood_synth/blood2",
    "decals/wnbase_blood_synth/blood3",
    "decals/wnbase_blood_synth/blood4",
    "decals/wnbase_blood_synth/blood5",
    "decals/wnbase_blood_synth/blood6",
})

game.AddDecal("WNBaseBloodRed", {
    "decals/wnbase_blood_red/blood1",
    "decals/wnbase_blood_red/blood2",
    "decals/wnbase_blood_red/blood3",
    "decals/wnbase_blood_red/blood4",
    "decals/wnbase_blood_red/blood5",
    "decals/wnbase_blood_red/blood6",
})

game.AddDecal("WNBaseBloodWhite", {
    "decals/wnbase_blood_white/blood1",
    "decals/wnbase_blood_white/blood2",
    "decals/wnbase_blood_white/blood3",
    "decals/wnbase_blood_white/blood4",
    "decals/wnbase_blood_white/blood5",
    "decals/wnbase_blood_white/blood6",
})

game.AddDecal("WNBaseBloodBlue", {
    "decals/wnbase_blood_blue/blood1",
    "decals/wnbase_blood_blue/blood2",
    "decals/wnbase_blood_blue/blood3",
    "decals/wnbase_blood_blue/blood4",
    "decals/wnbase_blood_blue/blood5",
    "decals/wnbase_blood_blue/blood6",
})

--[[
======================================================================================================================================================
                                           SOUNDS
======================================================================================================================================================
--]]

sound.Add( {
	name = "WNBase.Melee1",
	channel = CHAN_AUTO,
	volume = 0.6,
	level = 75,
	pitch = {95, 105},
	sound = {
        "npc/fast_zombie/claw_strike1.wav",
		"npc/fast_zombie/claw_strike2.wav",
		"npc/fast_zombie/claw_strike3.wav",
    }
} )

sound.Add( {
	name = "WNBase.Melee2",
	channel = CHAN_AUTO,
	volume = 0.6,
	level = 75,
	pitch = {95, 105},
	sound = {
        "physics/body/body_medium_impact_hard1.wav",
		"physics/body/body_medium_impact_hard2.wav",
		"physics/body/body_medium_impact_hard3.wav",
        "physics/body/body_medium_impact_hard4.wav",
		"physics/body/body_medium_impact_hard5.wav",
		"physics/body/body_medium_impact_hard6.wav",
    }
} )

sound.Add( {
	name = "WNBase.Ricochet",
	channel = CHAN_AUTO,
	volume = 0.8,
	level = 75,
	pitch = {90, 110},
	sound = {
        "weapons/fx/rics/ric1.wav",
        "weapons/fx/rics/ric2.wav",
        "weapons/fx/rics/ric3.wav",
        "weapons/fx/rics/ric4.wav",
        "weapons/fx/rics/ric5.wav"
    }
} )

sound.Add({
    name = "WNBase.Step",
	channel = CHAN_AUTO,
	volume = 0.7,
	level = 80,
	pitch = {90, 110},
	sound = {
        "npc/footsteps/hardboot_generic1.wav",
        "npc/footsteps/hardboot_generic2.wav",
        "npc/footsteps/hardboot_generic3.wav",
        "npc/footsteps/hardboot_generic4.wav",
        "npc/footsteps/hardboot_generic5.wav",
        "npc/footsteps/hardboot_generic6.wav",
        "npc/footsteps/hardboot_generic8.wav",
    },
})

--[[
======================================================================================================================================================
                                           SET SPAWN MENU CATEGORY ICONS
======================================================================================================================================================
--]]

list.Set("ContentCategoryIcons", "HL2: Humans + Resistance",    "games/16/hl2.png")
list.Set("ContentCategoryIcons", "HL2: Combine",                "games/16/hl2.png")
list.Set("ContentCategoryIcons", "HL2: Zombies + Enemy Aliens",  "games/16/hl2.png")

--[[
======================================================================================================================================================
                                           ESSENTIAL GLOBALS
======================================================================================================================================================
--]]

WNBase_RegisterHandler = {}
WNBaseNPCs = {}
WNBaseSpawnMenuNPCList = {}
WNBaseDynSplatterInstalled = file.Exists("dynsplatter", "LUA")
WNBaseNPCWeps = WNBaseNPCWeps or {}

if SERVER then
    WNBaseNPCInstances = WNBaseNPCInstances or {}
    WNBaseNPCInstances_NonScripted = WNBaseNPCInstances_NonScripted or {}
    WNBaseBehaviourTimerFuncs = WNBaseBehaviourTimerFuncs or {}
    WNBaseRelationshipEnts = WNBaseRelationshipEnts or {}
    WNBaseGibs = WNBaseGibs or {}
    WNBasePatchTable = {}
    WNBaseLastSavedFileTimeRegistry = WNBaseLastSavedFileTimeRegistry or {}
end

--[[
======================================================================================================================================================
                                           INCLUDES
======================================================================================================================================================
--]]

local function IncludeFiles()
    include("wnbase/sh_globals_pri.lua")
    include("wnbase/sh_globals_pub.lua")
    include("wnbase/sh_hooks.lua")
    include("wnbase/sh_cvars.lua")
    include("wnbase/sh_properties.lua")
    include("wnbase/sh_networking.lua")
    include("wnbase/sh_armor.lua")

    if SERVER then
        include("wnbase/sv_schedules.lua")
        include("wnbase/sv_schedules_deprecated.lua")
        include("wnbase/sv_meta_npc_extended.lua")
        include("wnbase/sv_behaviour_system.lua")
        include("wnbase/sv_spawnnpc.lua")
        include("wnbase/sv_replacer.lua")
        include("wnbase/sv_fakeragdoll.lua")
        include("wnbase/sv_equipment.lua")
        include("wnbase/controller/sv.lua")
        include("wnbase/controller/sh.lua")

        local files = file.Find("wnbase/npc_patches/*","LUA")
        local enhPath = "wnbase/npc_patches/"
        for _, v in ipairs(files) do
            include(enhPath..v)
        end
    end

    if CLIENT then
        include("wnbase/cl_spawnmenu.lua")
        include("wnbase/cl_toolmenu.lua")
        include("wnbase/cl_fakeragdoll.lua")
        include("wnbase/controller/cl.lua")
        include("wnbase/controller/sh.lua")
    end
end

local function AddCSLuaFiles()
    AddCSLuaFile("wnbase/sh_cvars.lua")
    AddCSLuaFile("wnbase/sh_globals_pri.lua")
    AddCSLuaFile("wnbase/sh_globals_pub.lua")
    AddCSLuaFile("wnbase/sh_override_functions.lua")
    AddCSLuaFile("wnbase/sh_hooks.lua")
    AddCSLuaFile("wnbase/sh_properties.lua")

    AddCSLuaFile("wnbase/cl_spawnmenu.lua")
    AddCSLuaFile("wnbase/cl_toolmenu.lua")
    AddCSLuaFile("wnbase/cl_fakeragdoll.lua")
    AddCSLuaFile("wnbase/controller/cl.lua")
    AddCSLuaFile("wnbase/controller/sh.lua")

    local _, dirs = file.Find("wnbase/entities/*","LUA")
    for _, v in ipairs(dirs) do
        AddCSLuaFile("wnbase/entities/"..v.."/shared.lua")
    end
    
    -- Add armor entity files
    AddCSLuaFile("entities/wn_armor_base/shared.lua")
    AddCSLuaFile("entities/wn_armor_base/cl_init.lua")
end

AddCSLuaFiles()
IncludeFiles()

--[[
======================================================================================================================================================
                                           REGISTER / ADD TO SPAWN MENU FUNCS
======================================================================================================================================================
--]]

function WNBase_RegisterHandler:NPCsInherit(NPCTablesToInheritFrom)
    local New_NPCTablesToInheritFrom = {}

    for CurInheritClass, CurInheritTable in pairs(NPCTablesToInheritFrom) do
        for NPCClass, NPCTable in pairs(WNBaseNPCs) do
            if NPCClass == "npc_wnbase" then continue end

            if NPCTable.Inherit == CurInheritClass then
                table.Inherit(NPCTable, CurInheritTable)
                table.Inherit(NPCTable.Behaviours, CurInheritTable.Behaviours)

                NPCTable.BaseClass = nil
                NPCTable.Behaviours.BaseClass = nil

                New_NPCTablesToInheritFrom[NPCClass] = NPCTable
            end
        end
    end

    if !table.IsEmpty(New_NPCTablesToInheritFrom) then
        self:NPCsInherit(New_NPCTablesToInheritFrom)
    end
end

function WNBase_RegisterHandler:RegBase()
    WNBaseNPCs["npc_wnbase"] = {}
    WNBaseNPCs["npc_wnbase"].Behaviours = {}
    WNBaseNPCs["npc_wnbase"].IsWNBaseNPC = true

    local NPCBasePrefix = "wnbase/npc_base_"

    if SERVER && !WNBase_AddedBaseLuaFilesToClient then
        AddCSLuaFile(NPCBasePrefix.."sentence.lua")
        AddCSLuaFile(NPCBasePrefix.."shared.lua")
        WNBase_AddedBaseLuaFilesToClient = true
    end

    include(NPCBasePrefix.."sentence.lua")
    include(NPCBasePrefix.."shared.lua")

    if SERVER then
        include(NPCBasePrefix.."internal.lua")
        include(NPCBasePrefix.."util.lua")
        include(NPCBasePrefix.."init.lua")
    end
end

function WNBase_RegisterHandler:NPCReg( name )
    if name != "npc_wnbase" then
        local path = "wnbase/entities/"..name.."/"
        local sh = path.."shared.lua"
        local cl = path.."cl_init.lua"
        local sv = path.."init.lua"

        if file.Exists(sh, "LUA") && (CLIENT or file.Exists(sv, "LUA")) then
            WNBaseNPCs[name] = {}
            WNBaseNPCs[name].Behaviours = {}

            include(sh)

            if SERVER then
                include(sv)

                local bh = path.."behaviour.lua"
                if file.Exists(bh, "LUA") then
                    include(bh)
                end

                WNBaseNPCs[name].EInternalVars = {}
                for varname, var in pairs(WNBaseNPCs[name]) do
                    if string.StartWith(varname, "m_") then
                        WNBaseNPCs[name].EInternalVars[varname] = var
                    end
                end
            end

            if file.Exists(cl, "LUA") && CLIENT then
                include(cl)
            end
        end
    end
end

function WNBase_RegisterHandler:RegNPCs()
    table.Empty(WNBaseNPCs)
    self:RegBase()

    local _, dirs = file.Find("wnbase/entities/*","LUA")
    for _, v in ipairs(dirs) do
        self:NPCReg(v)
    end
end

function WNBase_RegisterHandler:AddNPCsToSpawnMenu()
    for cls, t in pairs( WNBaseNPCs ) do
        if t.Category == false then continue end
        if cls == "npc_wnbase" then continue end

        local WNBaseSpawnMenuTbl = {
            Name=t.Name,
            Category=t.Category,
            Class = t.Class,
            Weapons = t.Weapons,
            Models = t.Models,
            KeyValues = table.Copy(t.KeyValues),
            OnFloor = t.OnFloor,
            OnCeiling = t.OnCeiling,
            NoDrop = t.NoDrop,
            Offset = t.Offset or (t.SNPCType == WNBASE_SNPCTYPE_FLY && t.Fly_DistanceFromGround),
            Rotate = t.Rotate,
            Skins = t.Skins,
            AdminOnly = t.AdminOnly,
            SpawnFlagTbl = t.SpawnFlagTbl,
            TotalSpawnFlags = t.TotalSpawnFlags,
            OnDuplicated = t.OnDuplicated,
            BodyGroups = BodyGroups,
            StartHealth = t.StartHealth,
            Material = t.Material,
            Author=t.Author,
            IconOverride = "entities/"..cls..".png",
        }
        WNBaseSpawnMenuNPCList[cls] = WNBaseSpawnMenuTbl
    end
end

function WNBase_RegisterHandler:Reload()
    self:RegNPCs()
    self:NPCsInherit({npc_wnbase=WNBaseNPCs["npc_wnbase"]})
    self:AddNPCsToSpawnMenu()

    if SERVER && WNBCVAR.ReloadSpawnMenu:GetBool() then
        RunConsoleCommand("spawnmenu_reload")
    end
end

function WNBase_RegisterHandler:Load()
    self:RegNPCs()
    self:NPCsInherit({npc_wnbase=WNBaseNPCs["npc_wnbase"]})
    self:AddNPCsToSpawnMenu()
end

function WNBase_RegisterHandler:NetworkedReload()
    WNBase_RegisterHandler:Reload()

    net.Start("WNBaseClientReload")
    net.Broadcast()
end

if SERVER then
    concommand.Add("wnbase_reload", function(ply)
        WNBase_RegisterHandler:NetworkedReload()
        print("WNBase reloaded!")
    end)
end

WNBase_RegisterHandler:Load()

-- Organism system
if SERVER then
    -- Load tier_1 first (defines wn.send_organism)
    include("wnbase/organism/tier_1/sv_organism.lua")
    include("wnbase/organism/tier_1/sv_input.lua")
    -- Then load tier_0 (uses wn.send_organism)
    include("wnbase/organism/tier_0/sv_tier_0.lua")
    include("wnbase/organism/tier_0/sv_hitboxorgans.lua")
    include("wnbase/organism/tier_1/modules/sv_blood.lua")
    include("wnbase/organism/tier_1/modules/sv_pain.lua")
    include("wnbase/organism/tier_1/modules/sv_stamina.lua")
    include("wnbase/organism/tier_1/modules/sv_pulse.lua")
    include("wnbase/organism/tier_1/modules/sv_lungs.lua")
    include("wnbase/organism/tier_1/modules/sv_liver.lua")
    include("wnbase/organism/tier_1/modules/sv_metabolism.lua")
    include("wnbase/organism/tier_1/modules/sv_random_event.lua")
    include("wnbase/organism/tier_1/modules/sv_virus.lua")
    include("wnbase/organism/tier_1/modules_input/sv_organs.lua")
    include("wnbase/organism/tier_1/modules_input/sv_bone.lua")
    include("wnbase/organism/sv_headcrab.lua")
end

if CLIENT then
    include("wnbase/organism/tier_0/cl_tier_0.lua")
    include("wnbase/organism/tier_0/sh_hitboxorgans.lua")
    include("wnbase/organism/tier_1/cl_main.lua")
    include("wnbase/organism/tier_1/cl_statistics.lua")
    include("wnbase/organism/tier_1/modules/cl_virus.lua")
    include("wnbase/organism/tier_1/modules/particles/cl_blood.lua")
    include("wnbase/organism/tier_1/modules/particles/cl_blood2.lua")
    include("wnbase/organism/tier_1/modules/particles/cl_main.lua")
    include("wnbase/organism/tier_1/modules/particles/input/cl_input.lua")
    include("wnbase/organism/cl_headcrab.lua")
end

-- Shared organism files
include("wnbase/organism/tier_0/sh_hitboxorgans.lua")

if SERVER then
    print("WNBase autorun complete!")
end
