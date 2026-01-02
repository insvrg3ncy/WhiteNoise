MODE.name = "scrappers"

local MODE = MODE

surface.CreateFont("WN_ScrappersSmall", {
    font = "Bahnschrift",
    size = ScreenScale(4),
    extended = true,
    weight = 400,
    antialias = true
})

surface.CreateFont("WN_ScrappersMedium", {
    font = "Bahnschrift",
    size = ScreenScale(10),
    extended = true,
    weight = 400,
    antialias = true
})

surface.CreateFont("WN_ScrappersMediumLarge", {
    font = "Bahnschrift",
    size = ScreenScale(20),
    extended = true,
    weight = 400,
    antialias = true
})

surface.CreateFont("WN_ScrappersLarge", {
    font = "Bahnschrift",
    size = ScreenScale(30),
    extended = true,
    weight = 400,
    antialias = true
})

surface.CreateFont("WN_ScrappersHumongous", {
    font = "Bahnschrift",
    size = 255,
    extended = true,
    weight = 400,
    antialias = true
})

wn.ScrappersScrambledList = wn.ScrappersScrambledList or {}
wn.ScrappersInventory = wn.ScrappersInventory or {}
wn.ScrappersRaidInventory = wn.ScrappersRaidInventory or {}
wn.ScrappersLobbyTime = wn.ScrappersLobbyTime or 0

net.Receive("zb_Scrappers_SendShop", function()
    wn.ScrappersScrambledList = net.ReadTable()

    if IsValid(wn.ScrappersShop) then return end

    vgui.Create("WN_ScrappersShop")
end)

function MODE:OnGlobalVarSet(key, value)
    if key == "Scrappers_LobbyEnd" then
        wn.ScrappersLobbyTime = value

        if IsValid(wn.ScrappersShop) then
            wn.ScrappersShop.time = value
        end
    end
end

local RaidMoneyFlash = 0

function MODE:OnLocalVarSet(key, var)
    if key == "zb_Scrappers_Inventory" then
        wn.ScrappersInventory = var
    elseif key == "zb_Scrappers_RaidInventory" then
        wn.ScrappersRaidInventory = var
    end
end

function MODE:OnNetVarSet(index, key, var)
    if Entity(index) == LocalPlayer() then
        if key == "zb_Scrappers_RaidMoney" then
            RaidMoneyFlash = 255
        end
    end
end

net.Receive("zb_Scrappers_BoughtUpdate", function()
    local tab = net.ReadString()
    local pos = net.ReadUInt(16)

    wn.ScrappersScrambledList[tab][pos].Bought = true

    if wn.ScrappersScrambledList[tab][pos].BuyingOut then
        wn.ScrappersScrambledList[tab][pos].BuyingOut = nil
    end
end)

net.Receive("zb_Scrappers_BuyingItem", function()
    local tab = net.ReadString()
    local pos = net.ReadUInt(16)
    local time = net.ReadFloat()

    local AuctionPrice = net.ReadUInt(32)

    wn.ScrappersScrambledList[tab][pos].BuyingOut = time
    if wn.ScrappersScrambledList[tab][pos].MeBuying and (wn.ScrappersScrambledList[tab][pos].AuctionPrice and AuctionPrice > wn.ScrappersScrambledList[tab][pos].AuctionPrice) then
        wn.ScrappersScrambledList[tab][pos].MeBuying = nil
    end

    wn.ScrappersScrambledList[tab][pos].AuctionPrice = AuctionPrice
end)

net.Receive("zb_CreateShopMenu", function()
    vgui.Create("WN_ScrappersShop")
end)

net.Receive("zb_RemoveShopMenu", function()
    if IsValid(wn.ScrappersShop) then
        wn.ScrappersShop:Close()
    end
end)

function MODE:RoundStart()
end

local ExtractionColor = Color(239, 255, 19)
local UpVector = Vector(0, 0, 80)

function MODE:PostDrawTranslucentRenderables(depth, skybox, skybox2)
    for k, v in ipairs(wn.ClPoints["SCRAPPERS_EXTRACTION"] or {}) do
        local angle = (v.pos - LocalPlayer():GetPos()):Angle()
        
        angle = Angle(0, angle.y, 0)

        angle:RotateAroundAxis( angle:Up(), -90 )
        angle:RotateAroundAxis( angle:Forward(), 90 )

        cam.Start3D2D( v.pos + UpVector, angle, 0.05 )
            draw.SimpleText("[Экстракция]", "WN_ScrappersHumongous", 10, 10, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText("[Экстракция]", "WN_ScrappersHumongous", 0, 0, ExtractionColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        cam.End3D2D()
    end
end

local red = Color(239, 47, 47)

local LastExtractionCheck = 0
local LastExtract = false

function MODE:HUDPaint()
    local extraction = GetNetVar("zb_Scrappers_Extraction")

    if extraction and extraction >= CurTime() then
        if extraction - CurTime() <= 60 then
            draw.SimpleText(string.FormattedTime( extraction - CurTime(), "%02i:%02i" ), "WN_ScrappersMedium", sw * 0.5 + ScreenScale(0.75), sh * 0.97 + ScreenScale(0.75) + math.sin(CurTime() * 5) * ScreenScale(3), color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText(string.FormattedTime( extraction - CurTime(), "%02i:%02i" ), "WN_ScrappersMedium", sw * 0.5, sh * 0.97 + math.sin(CurTime() * 5) * ScreenScale(3), red, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        else
            draw.SimpleText(string.FormattedTime( extraction - CurTime(), "%02i:%02i" ), "WN_ScrappersMedium", sw * 0.5 + ScreenScale(0.75), sh * 0.97 + ScreenScale(0.75), color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText(string.FormattedTime( extraction - CurTime(), "%02i:%02i" ), "WN_ScrappersMedium", sw * 0.5, sh * 0.97, ExtractionColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        if extraction - CurTime() <= 60 and LastExtractionCheck < CurTime() then

            LastExtract = false

            for k, v in ipairs(wn.ClPoints["SCRAPPERS_EXTRACTION"] or {}) do
                if (LocalPlayer():GetPos() - v.pos):LengthSqr() <= 40000 then
                    LastExtract = true
                end
            end

            LastExtractionCheck = CurTime() + 0.5
        end

        if extraction - CurTime() <= 60 and LastExtract then
            draw.SimpleText("В зоне экстракции", "WN_ScrappersMedium", sw * 0.01 + ScreenScale(0.75), sh * 0.97 + ScreenScale(0.75), color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText("В зоне экстракции", "WN_ScrappersMedium", sw * 0.01, sh * 0.97, ExtractionColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
    end

    local raidmoney = LocalPlayer():GetLocalVar("zb_Scrappers_RaidMoney")

    if raidmoney then
        RaidMoneyFlash = math.Approach(RaidMoneyFlash, 0, FrameTime() * 100)

        local moneyred = (moneyred == 0 and moneyred) or Color(239 + RaidMoneyFlash, 47 + RaidMoneyFlash, 47 + RaidMoneyFlash)

        draw.SimpleText("$" .. raidmoney, "WN_ScrappersMedium", sw * 0.99 + ScreenScale(0.75), sh * 0.97 + ScreenScale(0.75), color_black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        draw.SimpleText("$" .. raidmoney, "WN_ScrappersMedium", sw * 0.99, sh * 0.97, moneyred, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    end
end