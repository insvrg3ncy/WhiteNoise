wn = wn or {}
include("shared.lua")
include("loader.lua")

if not ConVarExists("wn_newspectate") then
    CreateClientConVar("wn_newspectate", "1", true, false, "Enables smooth spectator camera transitions", 0, 1)
end

function CurrentRound()
	return wn.modes[wn.CROUND]
end

wn.ROUND_STATE = 0
--0 = players can join, 1 = round is active, 2 = endround
local vecZero = Vector(0.2, 0.2, 0.2)
local vecFull = Vector(1, 1, 1)
spect,prevspect,viewmode = nil,nil,1
local hullscale = Vector(0,0,0)
net.Receive("Player_Spect", function(len)
	spect = net.ReadEntity()
	prevspect = net.ReadEntity()
	viewmode = net.ReadInt(4)

	timer.Simple(0.1,function()
		LocalPlayer():BoneScaleChange()
		LocalPlayer():SetHull(-hullscale,hullscale)
		LocalPlayer():SetHullDuck(-hullscale,hullscale)

		if viewmode == 3 then
			LocalPlayer():SetMoveType(MOVETYPE_NOCLIP)
		end
	end)
end)

wn.ROUND_TIME = wn.ROUND_TIME or 400
wn.ROUND_START = wn.ROUND_START or CurTime()
wn.ROUND_BEGIN = wn.ROUND_BEGIN or CurTime() + 5

net.Receive("updtime",function()
	local time = net.ReadFloat()
	local time2 = net.ReadFloat()
	local time3 = net.ReadFloat()

	wn.ROUND_TIME = time
	wn.ROUND_START = time2
	wn.ROUND_BEGIN = time3
end)

local keydownattack
local keydownattack2

hook.Add("Think", "wn_spectate_think", function()
	local ply = LocalPlayer()
	if not IsValid(ply) then return end
	
	if ply:GetNWBool("Spectating", false) then
		if input.IsKeyDown(KEY_ATTACK) and not keydownattack then
			keydownattack = true
			ply:Spectate(OBS_MODE_IN_EYE)
		elseif not input.IsKeyDown(KEY_ATTACK) then
			keydownattack = false
		end
		
		if input.IsKeyDown(KEY_ATTACK2) and not keydownattack2 then
			keydownattack2 = true
			ply:Spectate(OBS_MODE_CHASE)
		elseif not input.IsKeyDown(KEY_ATTACK2) then
			keydownattack2 = false
		end
	end
end)

function GM:HUDPaint()
	-- White Noise HUD
	local ply = LocalPlayer()
	if not IsValid(ply) then return end
	
	-- Draw white-themed HUD elements
	draw.SimpleText("WHITE NOISE", "DermaLarge", ScrW() * 0.5, 10, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
end

function GM:HUDShouldDraw(name)
	if name == "CHudHealth" or name == "CHudBattery" then
		return false
	end
	return true
end

function GM:OnPlayerChat(ply, text, teamchat, dead)
	local col = team.GetColor(ply:Team())
	if dead then
		col = Color(200, 200, 200)
	end
	
	chat.AddText(col, ply:Nick(), Color(255, 255, 255), ": ", Color(255, 255, 255), text)
	return true
end

-- Scoreboard (Esc menu) is in cl_scoreboard.lua
include("cl_scoreboard.lua")
