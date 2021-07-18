
if not CLIENT then return end

CreateClientConVar("table_inspect_config_showtables", "1", true) local cvar_table = GetConVar("table_inspect_config_showtables"):GetBool() cvars.AddChangeCallback("table_inspect_config_showtables", function(_, _, new) cvar_table = tobool(new) end)
CreateClientConVar("table_inspect_config_showfuncs", "1", true) local cvar_func = GetConVar("table_inspect_config_showfuncs"):GetBool() cvars.AddChangeCallback("table_inspect_config_showfuncs", function(_, _, new) cvar_func = tobool(new) end)
CreateClientConVar("table_inspect_config_shownums", "1", true) local cvar_num = GetConVar("table_inspect_config_shownums"):GetBool() cvars.AddChangeCallback("table_inspect_config_shownums", function(_, _, new) cvar_num = tobool(new) end)
CreateClientConVar("table_inspect_config_showbools", "1", true) local cvar_bool = GetConVar("table_inspect_config_showbools"):GetBool() cvars.AddChangeCallback("table_inspect_config_showbools", function(_, _, new) cvar_bool = tobool(new) end)
CreateClientConVar("table_inspect_config_showstrings", "1", true) local cvar_string = GetConVar("table_inspect_config_showstrings"):GetBool() cvars.AddChangeCallback("table_inspect_config_showstrings", function(_, _, new) cvar_string = tobool(new) end)
CreateClientConVar("table_inspect_config_showother", "1", true) local cvar_other = GetConVar("table_inspect_config_showother"):GetBool() cvars.AddChangeCallback("table_inspect_config_showother", function(_, _, new) cvar_other = tobool(new) end)

local refresh = Material("icon16/arrow_refresh.png")
local edit = Material("icon16/wrench.png")
local f

local function MakeConfig(pnl, ref)
    local function _create(s)
        s.menu = DermaMenu(false, s)
        
        local show = s.menu:AddSubMenu("Show")
        show:AddCVar("Tables", "table_inspect_config_showtables", "1", "0", ref)
        show:AddCVar("Functions", "table_inspect_config_showfuncs", "1", "0", ref)
        show:AddCVar("Numbers", "table_inspect_config_shownums", "1", "0", ref)
        show:AddCVar("Booleans", "table_inspect_config_showbools", "1", "0", ref)
        show:AddCVar("Other Types", "table_inspect_config_showother", "1", "0", ref)
     
        local x,y = s:LocalToScreen(0, s:GetTall())
        s.menu:SetMinimumWidth(s:GetWide())
        s.menu:Open(x, y, false, s)
    end

    pnl.cfg = vgui.Create("DButton", pnl)
    pnl.cfg:Dock(TOP)
    pnl.cfg:SetTall(50)
    pnl.cfg:SetText("Config")
    pnl.cfg:SetFont("Trebuchet24")
    pnl.cfg.DoClick = function(s)
        _create(s)
    end
end

local function OpenTableInspect()
    if f then
        f:Remove()
        f = nil
        return
    end
    f = vgui.Create("DFrame")
    f:SetSize(1200, 1000)
    f:Center()
    f:MakePopup()
    f:SetTitle("Table Inspect")
    f.OnRemove = function() 
        f = nil 
        collectgarbage("collect")
    end

    f.fill = vgui.Create("DHorizontalDivider", f)
    f.fill:Dock(FILL)

    f.left = vgui.Create("DPanel", f.fill)
    f.left:DockPadding(5, 5, 5, 10)
    f.fill:SetLeft(f.left)
    f.fill:SetLeftMin(400)

    local AddTable
    local function refresh()
        if f.tree.global then
            f.tree.global:Remove()
            f.tree.global = nil

        end
        f.tree.global = f.tree:AddNode("Global Scope (_G)")
        f.tree.global.DoClick = function(s)
            AddTable(s, _G)
            s:SetExpanded(true)
        end
    end

    MakeConfig(f.left, refresh)

    f.right = vgui.Create("DPanel", f.fill)
    f.fill:SetRight(f.right)

    f.tree = vgui.Create("DTree", f.left)
    f.tree:Dock(FILL)
    f.tree:DockMargin(0, 5, 0, 0)
    f.tree:SetDrawBackground(false)

    local types
    local noop = function() end
    AddTable = function(node, tbl)
        if node.hasHadTableAdded then return end
        node.hasHadTableAdded = true
        local _add = function()
            local i = 0
            for key,val in pairs(tbl) do
                if i == 100 then
                    node.continueNode = node:AddNode("Show More...", "icon16/arrow_down.png")
                    node.continueNode.DoClick = function(s)
                        coroutine.resume(node.thread)
                    end
                    coroutine.yield()
                    i = 0
                end
                if IsValid(node.continueNode) then
                    node.continueNode:Remove()
                    node.continueNode = nil
                end

                local funcs = types[TypeID(val) or "INVALID"]
                print(key, funcs[2](), TypeID(val))
                if funcs[2]() then
                    funcs[1](node, tbl, key, val)
                    i = i + 1
                end
            end
            node.thread = nil
        end

        node.thread = coroutine.create(_add)
        coroutine.resume(node.thread)
    end

    local typeFunc = function(type, icon, canadd)
        return {function(node, tbl, key, val)
            node:AddNode(key .. " = " .. tostring(val) .. " (" .. type .. ")", icon)
            return true
        end, canadd}
    end
    types = {
        [TYPE_TABLE] = {function(node, tbl, key, val)
            local n = node:AddNode(key .. " (table)", "icon16/table.png")
            n.generated = false
            n.DoClick = function(s)
                if s.generated then return end 
                s.generated = true
                AddTable(s, val)
                s:SetExpanded(true)
            end
        end, function() return cvar_table end},
        [TYPE_BOOL] = typeFunc("bool", "icon16/bullet_blue.png", function() return cvar_bool end),
        [TYPE_NUMBER] = typeFunc("number", "icon16/calculator.png", function() return cvar_num end),
        [TYPE_STRING] = typeFunc("string", "icon16/tag_blue.png", function() return cvar_string end),
        [TYPE_FUNCTION] = typeFunc("func", "icon16/tag.png", function() return cvar_func end),
    }

    refresh()
end


concommand.Add("table_inspect", function()
    gui.HideGameUI()
    OpenTableInspect()
end )