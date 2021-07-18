
local function rl()
    sqlier.Initialize("sqlier_test", "sqlite")

    local m = sqlier.Model({
        Table = "test_items",
        Columns = {
            Name = {
                Type = sqlier.Type.String
            }
        }
    })
end

if GAMEMODE then
    rl()
end

hook.Add("Initialize", "SQLIERTEST", rl)