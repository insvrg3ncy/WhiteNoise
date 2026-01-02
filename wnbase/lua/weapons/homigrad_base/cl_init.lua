--
include("shared.lua")
include("sh_anim.lua")
include("sh_bullet.lua")
include("sh_replicate.lua")
include("sh_holster_deploy.lua")
include("sh_reload.lua")
include("sh_spray.lua")
include("sh_worldmodel.lua")
include("sh_attachment.lua")
include("sh_fake.lua")
include("sh_ammo.lua")
include("sh_weaponsinv.lua")
include("cl_camera.lua")
include("cl_optics.lua")
include("cl_shells.lua")

matproxy.Add({
    name = "UC_ShellColor",
    init = function(self, mat, values)
        --self.envMin = values.min
        --self.envMax = values.max
        self.col = Vector()
    end,
    bind = function(self, mat, ent)
        local swent = ent
        
        if IsValid(swent) then
            local herg = color_white
            local r = 255
            local g = 255
            local b = 255
            
            if swent.GetShellColor then
                herg = swent:GetShellColor() or color_white
                r = herg.r or 255
                g = herg.g or 255
                b = herg.b or 255
            end

            self.col.x = r / 255
            self.col.y = g / 255
            self.col.z = b / 255
            mat:SetVector("$color2", self.col)
        end
    end
})