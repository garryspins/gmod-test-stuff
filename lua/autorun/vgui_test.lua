
local draw = draw
local surface = surface

local sidebar = Color(22, 22, 22)
local bg = Color(8, 8, 8)

local PANEL = {}
PANEL.Base = "DPanel"

function PANEL:OnMousePressed()
    self:Remove()
end

function PANEL:Paint(w, h)
    -- surface.SetDrawColor(55, 55, 55)
    draw.RoundedBoxEx(8, 0, 0, 200, h, sidebar, true, false, true)
    draw.RoundedBoxEx(8, 200, 0, w-200, h, bg, false, true, false, true)
end

concommand.Add("neb_testframe", function()
    local pnl = vgui.CreateFromTable(PANEL)
    pnl:SetSize(650, 600)
    pnl:Center()
    pnl:MakePopup()
end )