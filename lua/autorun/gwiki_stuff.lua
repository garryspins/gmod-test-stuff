
local fonts = {
    "DebugFixed",
    "DebugFixedSmall",
    "DefaultFixedOutline",
    "MenuItem",
    "Default",
    "TabLarge",
    "DefaultBold",
    "DefaultUnderline",
    "DefaultSmall",
    "DefaultSmallDropShadow",
    "DefaultVerySmall",
    "DefaultLarge",
    "UiBold",
    "MenuLarge",
    "ConsoleText",
    "Marlett",
    "Trebuchet18",
    "Trebuchet19",
    "Trebuchet20",
    "Trebuchet22",
    "Trebuchet24",
    "HUDNumber",
    "HUDNumber1",
    "HUDNumber2",
    "HUDNumber3",
    "HUDNumber4",
    "HUDNumber5",
    "HudHintTextLarge",
    "HudHintTextSmall",
    "CenterPrintText",
    "HudSelectionText",
    "DefaultFixed",
    "DefaultFixedDropShadow",
    "CloseCaption_Normal",
    "CloseCaption_Bold",
    "CloseCaption_BoldItalic",
    "TitleFont",
    "TitleFont2",
    "ChatFont",
    "TargetID",
    "TargetIDSmall",
    "HL2MPTypeDeath",
    "BudgetLabel"
}

concommand.Add("gwiki_fonts", function()
    for _,v in ipairs(fonts) do
        print(v)
    end
end )