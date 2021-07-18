if not CLIENT then return end

local f 
concommand.Add("pixel_uitest", function()
	if f then 
		f:Remove()
		f = nil
	end
	f = vgui.Create("PIXEL.Frame")
	f:SetSize(500, 600)
	f:Center()
	f:MakePopup()

	f.table = vgui.Create("PIXEL.Table", f)
	f.table:Dock(FILL)
end )

