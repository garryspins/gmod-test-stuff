
TOOL.Name = "#tool.gay.name"
TOOL.Category = "Category"
TOOL.Desc = "#tool.gay.desc"
TOOL.Author = "Tom.bat cause hes gay"
TOOL.ConfigName = ""

if CLIENT then
    TOOL.Information = {
        {name = "left", stage = 0},
        {name = "right", stage = 0},
        {name = "reload", stage = 0}
    }

    language.Add("tool.gay.name", "Gay tool")
    language.Add("tool.gay.desc", "Gay")

    function TOOL:LeftClick(tr)
        return true
    end

    function TOOL:RightClick(tr)
        return true
    end

    function TOOL:Reload(tr)
        return true
    end

    return
end

function TOOL:LeftClick(tr)
end

function TOOL:RightClick(tr)
end

function TOOL:Reload(tr)
end