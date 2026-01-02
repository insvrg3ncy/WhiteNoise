if CLIENT then
    if not vgui.GetControlTable("ZFrame") then
        local PANEL = {}
        vgui.Register("ZFrame", PANEL, "DFrame")
    end
end


