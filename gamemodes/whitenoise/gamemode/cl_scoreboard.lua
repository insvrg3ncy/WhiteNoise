-- White Noise - Custom Esc Menu (Scoreboard)
-- Adapted from zbattle

-- Fonts
local wn_font = ConVarExists("wn_font") and GetConVar("wn_font") or CreateClientConVar("wn_font", "Bahnschrift", true, false, "change every text font to selected because ui customization is cool")
local font = function()
    local usefont = "Bahnschrift"
    if wn_font:GetString() != "" then
        usefont = wn_font:GetString()
    end
    return usefont
end

surface.CreateFont("WN_InterfaceSmall", {
    font = font(),
    size = ScreenScale(6),
    weight = 400,
    antialias = true
})

surface.CreateFont("WN_InterfaceMedium", {
    font = font(),
    size = ScreenScale(10),
    weight = 400,
    antialias = true
})

surface.CreateFont("WN_InterfaceMediumLarge", {
    font = font(),
    size = 35,
    weight = 400,
    antialias = true
})

surface.CreateFont("WN_InterfaceLarge", {
    font = font(),
    size = ScreenScale(20),
    weight = 400,
    antialias = true
})

-- Colors (white theme)
local colGray = Color(240,240,240,255)
local colBlue = Color(240,240,240,255)
local colBlueUp = Color(250,250,250,255)
local col = Color(255,255,255,255)

local colSpect1 = Color(220,220,220,255)
local colSpect2 = Color(230,230,230,255)

local colorBG = Color(240,240,240,255)
local colorBGBlacky = Color(230,230,230,255)

-- Player info system
wn.playerInfo = wn.playerInfo or {}

local function addToPlayerInfo(ply, muted, volume)
	wn.playerInfo[ply:SteamID()] = {muted and true or false, volume}

	local json = util.TableToJSON(wn.playerInfo)
	file.Write("whitenoise_muted.txt", json)

	if file.Exists("whitenoise_muted.txt", "DATA") then
		local json = file.Read("whitenoise_muted.txt", "DATA")
		if json then
			wn.playerInfo = util.JSONToTable(json)
		end
	end
end

gameevent.Listen("player_connect")
hook.Add("player_connect", "wn_playerinfo", function(data)
	if wn.playerInfo and wn.playerInfo[data.networkid] then
		Player(data.userid):SetMuted(wn.playerInfo[data.networkid][1])
		Player(data.userid):SetVoiceVolumeScale(wn.playerInfo[data.networkid][2])
	end
end)

hook.Add("InitPostEntity", "wn_playerinfo_init", function()
	if file.Exists("whitenoise_muted.txt", "DATA") then
		local json = file.Read("whitenoise_muted.txt", "DATA")
		if json then
			wn.playerInfo = util.JSONToTable(json)
		end

		local plrs = player.GetAll()
		if wn.playerInfo then
			for i, ply in ipairs(plrs) do
				if not istable(wn.playerInfo[ply:SteamID()]) then
					local muted = wn.playerInfo[ply:SteamID()]
					wn.playerInfo[ply:SteamID()] = {}
					wn.playerInfo[ply:SteamID()][1] = muted
					wn.playerInfo[ply:SteamID()][2] = 1
				end

				if wn.playerInfo[ply:SteamID()] then
					ply:SetMuted(wn.playerInfo[ply:SteamID()][1])
					ply:SetVoiceVolumeScale(wn.playerInfo[ply:SteamID()][2])
				end
			end	
		end
	end
end)

local blur = Material("pp/blurscreen")
local wn_potatopc
wn = wn or {}
wn.DrawBlur = wn.DrawBlur or function(panel, amount, passes, alpha)
	if is3d2d then return end
	amount = amount or 5
	wn_potatopc = wn_potatopc or (ConVarExists("wn_potatopc") and GetConVar("wn_potatopc") or CreateClientConVar("wn_potatopc", "0", true, false))

	if(wn_potatopc:GetBool())then
		surface.SetDrawColor(255, 255, 255, alpha or (amount * 20))
		surface.DrawRect(0, 0, panel:GetWide(), panel:GetTall())
	else
		surface.SetMaterial(blur)
		surface.SetDrawColor(255, 255, 255, alpha or 125)
		surface.DrawRect(0, 0, panel:GetWide(), panel:GetTall())

		local x, y = panel:LocalToScreen(0, 0)

		for i = -(passes or 0.2), 1, 0.2 do
			blur:SetFloat("$blur", i * amount)
			blur:Recompute()
			
			render.UpdateScreenEffectTexture()
			surface.DrawTexturedRect(x * -1, y * -1, ScrW(), ScrH())
		end
	end
end

BlurBackground = wn.DrawBlur

wn.muteall = false
wn.mutespect = false

local function OpenPlayerSoundSettings(selfa, ply)
	local Menu = DermaMenu()
	
	if not wn.playerInfo[ply:SteamID()] or not istable(wn.playerInfo[ply:SteamID()]) then addToPlayerInfo(ply, false, 1) end

	local mute = Menu:AddOption( "Mute", function(self)
		if wn.muteall || wn.mutespect then return end
		
		self:SetChecked(not ply:IsMuted())
		ply:SetMuted( not ply:IsMuted() )
		selfa:SetImage(not ply:IsMuted() && "icon16/sound.png" || "icon16/sound_mute.png")
		addToPlayerInfo(ply, ply:IsMuted(), wn.playerInfo[ply:SteamID()][2])
	end ) -- get your stupid one line ass outta here

	mute:SetIsCheckable( true )
	mute:SetChecked( ply:IsMuted() )
	local volumeSlider = vgui.Create("DSlider", Menu)
	volumeSlider:SetLockY( 0.5 )
	volumeSlider:SetTrapInside( true )
	volumeSlider:SetSlideX(wn.playerInfo[ply:SteamID()][2]) 
	volumeSlider.OnValueChanged = function(self, x, y)
		if not IsValid(ply) then return end
		if wn.muteall or (wn.mutespect and not ply:Alive()) then return end
		wn.playerInfo[ply:SteamID()][2] = x
		ply:SetVoiceVolumeScale(wn.playerInfo[ply:SteamID()][2])
		addToPlayerInfo(ply, ply:IsMuted(), wn.playerInfo[ply:SteamID()][2])
	end

	function volumeSlider:Paint(w,h)
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0 ) )
		draw.RoundedBox( 0, 0, 0, w*self:GetSlideX(), h, Color( 255, 0, 0 ) )
		draw.DrawText( ( math.Round( 100*self:GetSlideX(), 0 ) ).."%", "DermaDefault", w/2, h/4, color_white, TEXT_ALIGN_CENTER )
	end
	function volumeSlider.Knob.Paint(self) end

	Menu:AddPanel(volumeSlider)
	Menu:Open()
end



hook.Add("Player Getup", "nomorespect", function(ply)
	if not wn.mutespect then return end

	//ply:SetMuted(ply.oldmutedspect)
	ply:SetVoiceVolumeScale(!wn.muteall and (wn.playerInfo[ply:SteamID()] and wn.playerInfo[ply:SteamID()][2] or 1) or 0)
	//ply.oldmutedspect = nil

	//if IsValid(ply.soundButton) then
		//ply.soundButton:SetImage(not ply:IsMuted() && "icon16/sound.png" || "icon16/sound_mute.png")
	//end
end)

hook.Add("Player Death", "isspect", function(ply)
	if not wn.mutespect then return end

	//ply.oldmutedspect = ply:IsMuted()
	//ply:SetMuted(wn.mutespect)
	ply:SetVoiceVolumeScale(0)

	//if IsValid(ply.soundButton) then
		//ply.soundButton:SetImage(not ply:IsMuted() && "icon16/sound.png" || "icon16/sound_mute.png")
	//end
end)



function GM:ScoreboardShow()
	if IsValid(scoreBoardMenu) then
		scoreBoardMenu:Remove()
		scoreBoardMenu = nil
	end
	Dynamic = 0
	scoreBoardMenu = vgui.Create("ZFrame")

	local sizeX,sizeY = ScrW() / 1.3 ,ScrH() / 1.2
	local posX,posY = ScrW() / 2 - sizeX / 2,ScrH() / 2 - sizeY / 2

	scoreBoardMenu:SetPos(posX,posY)
	scoreBoardMenu:SetSize(sizeX,sizeY)
	scoreBoardMenu:MakePopup()
	scoreBoardMenu:SetKeyboardInputEnabled( false )
	scoreBoardMenu:ShowCloseButton( false )

	local muteallbut = vgui.Create("DButton", scoreBoardMenu)
	local w, h = ScreenScale(30),ScreenScale(6)
	muteallbut:SetPos(ScreenScale(60),scoreBoardMenu:GetTall() - h * 1.5)
	muteallbut:SetSize(w, h)
	muteallbut:SetText("Mute all")
	
	muteallbut.Paint = function(self,w,h)
		surface.SetDrawColor( not wn.muteall and 255 or 200, not wn.muteall and 255 or 200, not wn.muteall and 255 or 200, 200)
        surface.DrawOutlinedRect( 0, 0, w, h, 2.5 )
	end

	muteallbut.DoClick = function(self,w,h)
		wn.muteall = not wn.muteall
		
		for i,ply in ipairs(player.GetAll()) do
			if wn.muteall then
				//ply.oldmutedspect = ply:IsMuted()

				ply:SetVoiceVolumeScale(0)
				//if IsValid(ply.soundButton) then
					//ply.soundButton:SetImage(not ply:IsMuted() && "icon16/sound.png" || "icon16/sound_mute.png")
				//end
			else
				ply:SetVoiceVolumeScale((!wn.mutespect or ply:Alive()) and (wn.playerInfo[ply:SteamID()] and wn.playerInfo[ply:SteamID()][2] or 1) or 0)
				//ply:SetMuted(ply.oldmuted)
				//if IsValid(ply.soundButton) then
					//ply.soundButton:SetImage(not ply:IsMuted() && "icon16/sound.png" || "icon16/sound_mute.png")
				//end
				//ply.oldmuted = nil
			end
		end 
	end

	local mutespectbut = vgui.Create("DButton", scoreBoardMenu)
	local w, h = ScreenScale(30),ScreenScale(6)
	mutespectbut:SetPos(ScreenScale(60 + 35),scoreBoardMenu:GetTall() - h * 1.5)
	mutespectbut:SetSize(w, h)
	mutespectbut:SetText("Mute spectators")
	
	mutespectbut.Paint = function(self,w,h)
		surface.SetDrawColor( not wn.mutespect and 255 or 200, not wn.mutespect and 255 or 200, not wn.mutespect and 255 or 200, 200)
        surface.DrawOutlinedRect( 0, 0, w, h, 2.5 )
	end

	mutespectbut.DoClick = function(self,w,h)
		wn.mutespect = not wn.mutespect
		
		for i,ply in ipairs(player.GetAll()) do
			if ply:Alive() then continue end

			if wn.mutespect then
				ply:SetVoiceVolumeScale(0)
				//ply.oldmutedspect = ply:IsMuted()

				//ply:SetMuted(true)
				//if IsValid(ply.soundButton) then
					//ply.soundButton:SetImage(not ply:IsMuted() && "icon16/sound.png" || "icon16/sound_mute.png")
				//end
			else
				ply:SetVoiceVolumeScale(!wn.muteall and (wn.playerInfo[ply:SteamID()] and wn.playerInfo[ply:SteamID()][2] or 1) or 0)
				//ply:SetMuted(ply.oldmutedspect)
				//if IsValid(ply.soundButton) then
					//ply.soundButton:SetImage(not ply:IsMuted() && "icon16/sound.png" || "icon16/sound_mute.png")
				//end
				//ply.oldmutedspect = nil
			end
		end 
	end

	local ServerName = "White Noise Server СИСЬКИ 18+ | !VIPTEST | ПАУТИНКА"
	local tick
	scoreBoardMenu.PaintOver = function(self,w,h)
		surface.SetDrawColor( 255, 255, 255, 200)
        surface.DrawOutlinedRect( 0, 0, w, h, 2.5 )

		surface.SetFont( "WN_InterfaceLarge" )
		surface.SetTextColor(col.r,col.g,col.b,col.a)
		local lenghtX, lenghtY = surface.GetTextSize(ServerName)
		surface.SetTextPos(w / 2 - lenghtX/2,10)
		surface.DrawText(ServerName)

		surface.SetFont( "WN_InterfaceSmall" )
		surface.SetTextColor(col.r,col.g,col.b,col.a*0.1)
		local txt = "White Noise version: "..wn.Version
		local lenghtX, lenghtY = surface.GetTextSize(txt)
		surface.SetTextPos(w*0.01,h - lenghtY - h*0.01)
		surface.DrawText(txt)

		surface.SetFont( "WN_InterfaceMediumLarge" )
		surface.SetTextColor(col.r,col.g,col.b,col.a)
		local lenghtX, lenghtY = surface.GetTextSize("Players:")
		surface.SetTextPos(w / 4 - lenghtX/2,ScreenScale(25))
		surface.DrawText("Players:")

		surface.SetFont( "WN_InterfaceMediumLarge" )
		surface.SetTextColor(col.r,col.g,col.b,col.a)
		local lenghtX, lenghtY = surface.GetTextSize("Spectators:")
		surface.SetTextPos(w * 0.75 - lenghtX/2,ScreenScale(25))
		surface.DrawText("Spectators:")
		tick = math.Round(Lerp(0.025, tick or math.Round(1 / engine.ServerFrameTime(),1), math.Round(1 / engine.ServerFrameTime(),1)),1)
		local txt = "Server Tick: " .. tick
		local lenghtX, lenghtY = surface.GetTextSize(txt)
		surface.SetTextPos(w * 0.5 - lenghtX/2,ScreenScale(25))
		surface.DrawText(txt)
	end
	-- TEAMSELECTION
	if LocalPlayer():Team() ~= TEAM_SPECTATOR then
		local SPECTATE = vgui.Create("DButton",scoreBoardMenu)
		SPECTATE:SetPos(sizeX * 0.925,sizeY * 0.095)
		SPECTATE:SetSize(ScrW() / 20,ScrH() / 30)
		SPECTATE:SetText("")
		
		SPECTATE.DoClick = function()
			net.Start("SpectatorMode")
				net.WriteBool(true)
			net.SendToServer()
			scoreBoardMenu:Remove()
			scoreBoardMenu = nil
		end

		SPECTATE.Paint = function(self,w,h)
			surface.SetDrawColor( 255, 255, 255, 200)
			surface.DrawOutlinedRect( 0, 0, w, h, 2.5 )
			surface.SetFont( "WN_InterfaceMedium" )
			surface.SetTextColor(col.r,col.g,col.b,col.a)
			local lenghtX, lenghtY = surface.GetTextSize("Spectate")
			surface.SetTextPos( w/2 - lenghtX/2, h/2 - lenghtY/2)
			surface.DrawText("Spectate")
		end
	end

	if LocalPlayer():Team() == TEAM_SPECTATOR then
		local PLAYING = vgui.Create("DButton",scoreBoardMenu)
		PLAYING:SetPos(sizeX * 0.010,sizeY * 0.095)
		PLAYING:SetSize(ScrW() / 20,ScrH() / 30)
		PLAYING:SetText("")
		
		PLAYING.DoClick = function()
			net.Start("SpectatorMode")
				net.WriteBool(false)
			net.SendToServer()
			scoreBoardMenu:Remove()
			scoreBoardMenu = nil
		end

		PLAYING.Paint = function(self,w,h)
			surface.SetDrawColor( 255, 255, 255, 200)
			surface.DrawOutlinedRect( 0, 0, w, h, 2.5 )
			surface.SetFont( "WN_InterfaceMedium" )
			surface.SetTextColor(col.r,col.g,col.b,col.a)
			local lenghtX, lenghtY = surface.GetTextSize("Join")
			surface.SetTextPos( w/2 - lenghtX/2, h/2 - lenghtY/2)
			surface.DrawText("Join")
		end
	end

	--без матов

	local DScrollPanel = vgui.Create("DScrollPanel", scoreBoardMenu)
	DScrollPanel:SetPos(10, ScreenScaleH(58))
	DScrollPanel:SetSize(sizeX/2 - 10, sizeY - ScreenScaleH(72))
	function DScrollPanel:Paint( w, h )
		wn.DrawBlur(self)

		surface.SetDrawColor( 255, 255, 255, 200)
        surface.DrawOutlinedRect( 0, 0, w, h, 2.5 )
	end

	for i, ply in ipairs(player.GetAll()) do
		if ply:Team() == TEAM_SPECTATOR then continue end
		
		local but = vgui.Create("DButton", DScrollPanel)
		but:SetSize(100, ScreenScaleH(22))
		but:Dock(TOP)
		but:DockMargin(8, 6, 8, -1)
		but:SetText("")
		
		local soundButton = vgui.Create("DImageButton", but)
		soundButton:Dock(RIGHT)
		soundButton:SetSize( 30, 0 )
		soundButton:DockMargin(5,10,45,10)
		
		soundButton:SetImage(not ply:IsMuted() && "icon16/sound.png" || "icon16/sound_mute.png") 
		soundButton.DoClick = function(self)
			OpenPlayerSoundSettings(self, ply) 
		end
		ply.soundButton = soundButton
	
		but.Paint = function(self, w, h)
			if not IsValid(ply) then return end
			surface.SetDrawColor(colBlueUp.r, colBlueUp.g, colBlueUp.b, colBlueUp.a)
			surface.DrawRect(0, 0, w, h)
			surface.SetDrawColor(colBlue.r, colBlue.g, colBlue.b, colBlue.a)
			surface.DrawRect(0, h / 2, w, h / 2)
	
			surface.SetFont("WN_InterfaceMediumLarge")
			surface.SetTextColor(col.r, col.g, col.b, col.a)
			local lenghtX, lenghtY = surface.GetTextSize(ply:Name() or "He quited...")
			surface.SetTextPos(15, h / 2 - lenghtY / 2)
			surface.DrawText(ply:Name() or "He quited...")
	
			surface.SetFont("WN_InterfaceMediumLarge")
			surface.SetTextColor(col.r, col.g, col.b, col.a)
			local lenghtX, lenghtY = surface.GetTextSize(ply:Ping() or "He quited...")
			surface.SetTextPos(w - lenghtX - 15, h / 2 - lenghtY / 2)
			surface.DrawText(ply:Ping() or "He quited...")
		end

		function but:DoClick()
			if ply:IsBot() then chat.AddText(Color(255,0,0), "no, you can't") return end
			gui.OpenURL("https://steamcommunity.com/profiles/"..ply:SteamID64())
		end

		function but:DoRightClick()
			--if ply:IsBot() then chat.AddText(Color(255,0,0), "no, you can't") return end
			local Menu = DermaMenu()
			Menu:AddOption( "Account", function(self)
				wn.Experience.AccountMenu( ply )
			end)
			Menu:AddOption( "Medal", function(self) 
				wn.Experience.OpenMenu(ply)
				timer.Simple( .1, function()
					wn.Experience.Menu(ply)
				end)
			end) 

			Menu:Open()
		end
	
		DScrollPanel:AddItem(but)
	end
	-- SPECTATORS
	local DScrollPanel = vgui.Create("DScrollPanel", scoreBoardMenu)
	DScrollPanel:SetPos(sizeX/2 + 5, ScreenScaleH(58))
	DScrollPanel:SetSize(sizeX/2 - 15, sizeY - ScreenScaleH(72))
	function DScrollPanel:Paint( w, h )
		wn.DrawBlur(self)

		surface.SetDrawColor( 255, 255, 255, 200)
        surface.DrawOutlinedRect( 0, 0, w, h, 2.5 )
	end

	for i,ply in ipairs(player.GetAll()) do
		if ply:Team() ~= TEAM_SPECTATOR then continue end
		local but = vgui.Create("DButton",DScrollPanel)
		but:SetSize(100,ScreenScaleH(22))
		but:Dock(TOP)
		but:DockMargin( 8, 6, 8, -1 )
		but:SetText("")

		local soundButton = vgui.Create("DImageButton", but)
		soundButton:Dock(RIGHT)
		soundButton:SetSize( 30, 0 )
		soundButton:DockMargin(5,10,45,10)
		
		soundButton:SetImage(not ply:IsMuted() && "icon16/sound.png" || "icon16/sound_mute.png") 
		soundButton.DoClick = function(self)
			OpenPlayerSoundSettings(self, ply)
		end
		ply.soundButton = soundButton

		but.Paint = function(self,w,h)
			if not IsValid(ply) then return end
			surface.SetDrawColor(colSpect2.r,colSpect2.g,colSpect2.b,colSpect2.a)
			surface.DrawRect(0,0,w,h)
			surface.SetDrawColor(colSpect1.r,colSpect1.g,colSpect1.b,colSpect1.a)
			surface.DrawRect(0,h/2,w,h/2)

			surface.SetFont( "WN_InterfaceMediumLarge" )
			surface.SetTextColor(col.r,col.g,col.b,col.a)
			local lenghtX, lenghtY = surface.GetTextSize( ply:Name() or "He quited..." )
			surface.SetTextPos(15,h/2 - lenghtY/2)
			surface.DrawText(ply:Name() or "He quited...")

			surface.SetFont( "WN_InterfaceMediumLarge" )
			surface.SetTextColor(col.r,col.g,col.b,col.a)
			local lenghtX, lenghtY = surface.GetTextSize( ply:Ping() or "He quited..." )
			surface.SetTextPos(w - lenghtX -15,h/2 - lenghtY/2)
			surface.DrawText(ply:Ping() or "He quited...")
		end

		function but:DoClick()
			if ply:IsBot() then chat.AddText(Color(255,0,0), "no, you can't") return end
			gui.OpenURL("https://steamcommunity.com/profiles/"..ply:SteamID64())
		end

		function but:DoRightClick()
			--if ply:IsBot() then chat.AddText(Color(255,0,0), "no, you can't") return end
			local Menu = DermaMenu()
			Menu:AddOption( "Account", function(self)
				wn.Experience.AccountMenu( ply )
			end)
			Menu:AddOption( "Medal", function(self) 
				wn.Experience.OpenMenu(ply)
				timer.Simple( .1, function()
					wn.Experience.Menu(ply)
				end)
			end) 

			Menu:Open()
		end

		DScrollPanel:AddItem(but)
	end

	return true
end

