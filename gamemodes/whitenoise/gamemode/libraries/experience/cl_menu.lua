--
wn = wn or {}

wn.Experience = wn.Experience or {}


local EXP = wn.Experience

EXP.OpenedMenu = EXP.OpenedMenu or nil

--local function BG()
--    
--end
local gradient_u = Material("vgui/gradient-u")

local blurMat = Material("pp/blurscreen")
local Dynamic = 0

BlurBackground = wn.DrawBlur

local function PaintFrame(self,w,h)
	BlurBackground(self)
    surface.SetDrawColor(155, 0, 0, 155)
    surface.SetMaterial(gradient_u)
    surface.DrawTexturedRect( 0, 0, w, h )

	surface.SetDrawColor( 255, 0, 0, 128)
    surface.DrawOutlinedRect( 0, 0, w, h, 2.5 )
end

function EXP.Menu( ply )
    if IsValid(EXP.OpenedMenu) then
        EXP.OpenedMenu:Remove()
        EXP.OpenedMenu = nil
    end

    EXP.OpenedMenu = vgui.Create( "ZFrame" )
    EXP.OpenedMenu:SetSize( ScrW()*0.2, ScrH()*0.5 )
    EXP.OpenedMenu:Center()
    EXP.OpenedMenu:MakePopup()
    EXP.OpenedMenu:SetTitle("Medal")

    EXP.OpenedMenu.Medal = vgui.Create( "WN_ExpPanel", EXP.OpenedMenu )
    local ExpPanel = EXP.OpenedMenu.Medal
    ExpPanel:Dock( FILL )
    ExpPanel:SetPlayer( ply )

    function EXP.OpenedMenu:Paint( w,h )
        PaintFrame(self,w,h)
    end
end

function EXP.OpenMenu( ply )
    net.Start("WN_XP_Get")
        net.WriteEntity( ply )
    net.SendToServer()
end

net.Receive("WN_XP_Get",function()
    local ply = net.ReadEntity()
    ply.skill = net.ReadFloat()
    ply.exp = net.ReadInt(19)
    --print(ply.exp,ply.skill)
    --EXP.Menu(ply)
end)


EXP.OpenedAccount = EXP.OpenedAccount or nil

function EXP.AccountMenu( ply )
    EXP.OpenMenu( ply )
    timer.Simple(.1,function() 
        if IsValid(EXP.OpenedAccount) then
            EXP.OpenedAccount:Remove()
            EXP.OpenedAccount = nil
        end
        
        EXP.OpenedAccount = vgui.Create("WN_AccountFrame")
        local AcMenu = EXP.OpenedAccount
        AcMenu:MakePopup()
        AcMenu:SetPlayer( ply )
        AcMenu:SetTitle( "" )
    end)
end