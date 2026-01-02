MODE.name = "dm"

local MODE = MODE

local radius = nil
local mapsize = 7500

local roundend = false

net.Receive("wn_dm_start",function()
	roundend = false

	if hg and hg.DynaMusic then
		hg.DynaMusic:Start( "mirrors_edge" )
	end

	if wn and wn.RemoveFade then
		wn.RemoveFade()
	end
	
	ZonePos = net.ReadVector()
	zonedistance = net.ReadFloat()

    surface.PlaySound("snd_jack_hmcd_deathmatch.mp3")
	sound.PlayFile( "sound/ambient/energy/force_field_loop1.wav", "noblock", function( station, errCode, errStr )
		if ( IsValid( station ) ) then
			wn.SoundStation = station
			
			station:Play()
			station:EnableLooping( true )
			station:SetVolume(0)
		end
	end )
end)

hook.Add("Think", "ZoneSoundThink", function()
	if CurrentRound() and CurrentRound().name ~= "dm" then return end
	local station = wn.SoundStation
	if not IsValid(station) then return end
	local radius = MODE.GetZoneRadius()
	local volume = math.Clamp((LocalPlayer():GetPos():Distance(ZonePos) - radius) + 200,0,200) / 200
	station:SetVolume(volume)
end)

local fighter = {
    objective = "Kill everyone.",
    name = "Fighter",
    color1 = Color(255, 255, 255) -- White theme
}

local mat = Material("hmcd_dmzone")

local mapsize = 7500

function MODE:PostDrawTranslucentRenderables(bDepth, bSkybox, isDraw3DSkybox)
	if(!bSkybox and !isDraw3DSkybox)then
		local radius = MODE.GetZoneRadius()
		render.SetMaterial(mat)
		render.DrawSphere( ZonePos, -radius, 60, 60, color_white )
	end
end

function MODE:RenderScreenspaceEffects()
    if wn.ROUND_START + 7.5 < CurTime() then return end
	
    local fade = math.Clamp(wn.ROUND_START + 7.5 - CurTime(),0,1)

    surface.SetDrawColor(255,255,255,255 * fade)
    surface.DrawRect(-1,-1,ScrW() + 1,ScrH() + 1)
end

function MODE:HUDPaint()
	if wn.ROUND_START + 20 > CurTime() then
		draw.SimpleText( string.FormattedTime(wn.ROUND_START + 20 - CurTime(), "%02i:%02i:%02i"	), "ZB_HomicideMedium", sw * 0.5, sh * 0.75, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	else
		local ply = LocalPlayer()
	end
	
	 
	if not lply:Alive() then return end
    if wn.ROUND_START + 8.5 < CurTime() then return end
	if wn and wn.RemoveFade then
		wn.RemoveFade()
	end
    local fade = math.Clamp(wn.ROUND_START + 8 - CurTime(),0,1)
    
    draw.SimpleText("White Noise | DeathMatch", "ZB_HomicideMediumLarge", sw * 0.5, sh * 0.1, Color(255,255,255, 255 * fade), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    local Rolename = fighter.name
	local ColorRole = fighter.color1
    ColorRole.a = 255 * fade
    draw.SimpleText("You are a "..Rolename , "ZB_HomicideMediumLarge", sw * 0.5, sh * 0.5, ColorRole, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    local Objective = fighter.objective
    local ColorObj = fighter.color1
    ColorObj.a = 255 * fade
    draw.SimpleText( Objective, "ZB_HomicideMedium", sw * 0.5, sh * 0.9, ColorObj, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

local CreateEndMenu = nil
local wonply = nil

net.Receive("wn_dm_end",function()
	local ent = net.ReadEntity()
	local most_violent_player = net.ReadEntity()

	if IsValid(most_violent_player) then
		most_violent_player.most_violent_player = true
	end

	wonply = nil
	if IsValid(ent) then
		ent.won = true
		wonply = ent
	end

	wn.SoundStation = nil
	roundend = CurTime()
	
	if(MODE.SoundStation and MODE.SoundStation:IsValid())then
		MODE.SoundStation:Stop()
		
		MODE.SoundStation = nil
	end
	
    CreateEndMenu()
end)

local colGray = Color(200,200,200,255)
local colWhite = Color(255,255,255,255)
local colWhiteUp = Color(240,240,240,255)

local col = Color(255,255,255,255)

local colSpect1 = Color(200,200,200,255)
local colSpect2 = Color(255,255,255)

local colorBG = Color(240,240,240,255)
local colorBGBlacky = Color(220,220,220,255)

local blurMat = Material("pp/blurscreen")
local Dynamic = 0

BlurBackground = BlurBackground or wn.DrawBlur

if IsValid(wnEndMenu) then
    wnEndMenu:Remove()
    wnEndMenu = nil
end

CreateEndMenu = function()
	if IsValid(wnEndMenu) then
		wnEndMenu:Remove()
		wnEndMenu = nil
	end
	Dynamic = 0
	wnEndMenu = vgui.Create("ZFrame")

    surface.PlaySound("ambient/alarms/warningbell1.wav")

	local sizeX,sizeY = ScrW() / 2.5 ,ScrH() / 1.2
	local posX,posY = ScrW() / 1.3 - sizeX / 2,ScrH() / 2 - sizeY / 2

	wnEndMenu:SetPos(posX,posY)
	wnEndMenu:SetSize(sizeX,sizeY)
	wnEndMenu:MakePopup()
	wnEndMenu:SetKeyboardInputEnabled(false)
	wnEndMenu:ShowCloseButton(false)

	local closebutton = vgui.Create("DButton",wnEndMenu)
	closebutton:SetPos(5,5)
	closebutton:SetSize(ScrW() / 20,ScrH() / 30)
	closebutton:SetText("")
	
	closebutton.DoClick = function()
		if IsValid(wnEndMenu) then
			wnEndMenu:Close()
			wnEndMenu = nil
		end
	end

	closebutton.Paint = function(self,w,h)
		surface.SetDrawColor( 200, 200, 200, 255)
        surface.DrawOutlinedRect( 0, 0, w, h, 2.5 )
		surface.SetFont( "ZB_InterfaceMedium" )
		surface.SetTextColor(col.r,col.g,col.b,col.a)
		local lenghtX, lenghtY = surface.GetTextSize("Close")
		surface.SetTextPos( lenghtX - lenghtX/1.1, 4)
		surface.DrawText("Close")
	end

    wnEndMenu.PaintOver = function(self,w,h)
		local txt = (wonply and wonply:GetPlayerName() or "Nobody").." won!"
		surface.SetFont( "ZB_InterfaceMediumLarge" )
		surface.SetTextColor(col.r,col.g,col.b,col.a)
		local lenghtX, lenghtY = surface.GetTextSize(txt)
		surface.SetTextPos(w / 2 - lenghtX/2,20)
		surface.DrawText(txt)
	end
	
	local DScrollPanel = vgui.Create("DScrollPanel", wnEndMenu)
	DScrollPanel:SetPos(10, 80)
	DScrollPanel:SetSize(sizeX - 20, sizeY - 90)

	for i,ply in ipairs(player.GetAll()) do
		if ply:Team() == TEAM_SPECTATOR then continue end
		local but = vgui.Create("DButton",DScrollPanel)
		but:SetSize(100,50)
		but:Dock(TOP)
		but:DockMargin( 8, 6, 8, -1 )
		but:SetText("")
		but.Paint = function(self,w,h)
			local col1 = ((ply.won or ply.most_violent_player) and colWhite) or (ply:Alive() and colWhite) or colGray
            local col2 = ((ply.won or ply.most_violent_player) and colWhiteUp) or (ply:Alive() and colWhiteUp) or colSpect1
			
			surface.SetDrawColor(col1.r,col1.g,col1.b,col1.a)
			surface.DrawRect(0,0,w,h)
			surface.SetDrawColor(col2.r,col2.g,col2.b,col2.a)
			surface.DrawRect(0,h/2,w,h/2)

            local col = ply:GetPlayerColor():ToColor()
			surface.SetFont( "ZB_InterfaceMediumLarge" )
			local lenghtX, lenghtY = surface.GetTextSize( ply:GetPlayerName() or "He quited..." )
			
			surface.SetTextColor(0,0,0,255)
			surface.SetTextPos(w / 2 + 1,h/2 - lenghtY/2 + 1)
			surface.DrawText(ply:GetPlayerName() or "He quited...")

			surface.SetTextColor(col.r,col.g,col.b,col.a)
			surface.SetTextPos(w / 2,h/2 - lenghtY/2)
			surface.DrawText(ply:GetPlayerName() or "He quited...")

            
			local col = colSpect2
			surface.SetFont( "ZB_InterfaceMediumLarge" )
			surface.SetTextColor(col.r,col.g,col.b,col.a)
			local lenghtX, lenghtY = surface.GetTextSize( ply:GetPlayerName() or "He quited..." )
			surface.SetTextPos(15,h/2 - lenghtY/2)
			surface.DrawText((ply:Name() .. (ply.most_violent_player and " - MVP" or (not ply:Alive() and " - died" or ""))))

			surface.SetFont( "ZB_InterfaceMediumLarge" )
			surface.SetTextColor(col.r,col.g,col.b,col.a)
			local lenghtX, lenghtY = surface.GetTextSize( ply:Frags() or "He quited..." )
			surface.SetTextPos(w - lenghtX -15,h/2 - lenghtY/2)
			surface.DrawText(ply:Frags() or "He quited...")
		end

		function but:DoClick()
			if ply:IsBot() then chat.AddText(Color(255,0,0), "no, you can't") return end
			gui.OpenURL("https://steamcommunity.com/profiles/"..ply:SteamID64())
		end

		DScrollPanel:AddItem(but)
	end

	return true
end

function MODE:RoundStart()
    for i,ply in ipairs(player.GetAll()) do
		ply.won = nil
		ply.most_violent_player = nil
    end

    if IsValid(wnEndMenu) then
        wnEndMenu:Remove()
        wnEndMenu = nil
    end
end
