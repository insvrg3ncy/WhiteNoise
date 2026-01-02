--
local PANEL = {}

local blurMat = Material("pp/blurscreen")
local Dynamic = 0

BlurBackground = wn.DrawBlur

function PANEL:Paint( w, h )

    local text = "Time to Rock The Vote"

	BlurBackground(self)

	surface.SetFont( "WN_InterfaceMediumLarge" )
	surface.SetTextColor( color_white )
	local lenghtX, lenghtY = surface.GetTextSize( text )
	surface.SetTextPos( w / 2 - lenghtX/2,20 )
	surface.DrawText( text )

	surface.SetDrawColor( 255, 0, 0, 128)
    surface.DrawOutlinedRect( 0, 0, w, h, 2.5 )

end

vgui.Register( "WN_RTVMenu", PANEL, "ZFrame")