if SERVER then
    CreateConVar("wn_dev", 0, FCVAR_ARCHIVE)
end

if (CLIENT) then
    --sw и sh как глобальные переменные
    sw, sh = ScrW(), ScrH()

    hook.Add( "OnScreenSizeChanged", "sw_sh_globals", function()
        sw, sh = ScrW(), ScrH()
    end)

    --светящийся текст

    local old = surface.CreateFont
    local cache = {}

    function surface.CreateFont(name, info)
        cache[name] = info

        old(name, info)
    end

    function WN_GetFontTable(name)
        return cache[name]
    end

    local header = "glow_text_"
    surface.madefonts = surface.madefonts or {}
    local made = surface.madefonts

    function draw.GlowingText(text, font, x, y, col, colglow, colglow2, align )
        align = align or TEXT_ALIGN_LEFT

        local bfont1 = header .. font
        local bfont2 = header .. font .. "2"

        if !made[font] then
            local fontdata = WN_GetFontTable(font)

            fontdata.blursize = 4
            surface.CreateFont(bfont1, fontdata)
            fontdata.blursize = 20
            surface.CreateFont(bfont2, fontdata)
            made[font] = true
        end

        draw.SimpleText( text, bfont1, x, y, colglow or ColorAlpha(col,150), align, align)
        draw.SimpleText( text, bfont2, x, y, colglow2 or colglow and ColorAlpha(colglow,50) or ColorAlpha(col, 50), align, align)
        draw.SimpleText( text, font, x, y, col, align, align)
    end
end

