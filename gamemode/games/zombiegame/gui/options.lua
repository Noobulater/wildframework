
if SERVER then

local function options( ply )
	ply:ConCommand("optionsMenu")
end
hook.Add("ShowTeam", "options", options)

end


if CLIENT then
	function openOptionsMenu()
		local frame = vgui.Create("DFrame")
		frame:SetTitle("Options Menu")
		frame:SetSize(140,100)
		frame:Center()
		frame:MakePopup()

		local music = vgui.Create("DButton", frame)
		music:SetSize(120,60)
		music:SetPos(10,30)
		music:SetText("Toggle Music")
		function music:DoClick() 
			if GAMEMODE.musicVolume > 0 then
				GAMEMODE.musicVolume = 0
				if getMusicPlayer() then
					getMusicPlayer().pause()
				end
			else
				GAMEMODE.musicVolume = 75
				if getMusicPlayer() then
					getMusicPlayer().play( getMusicPlayer().getCurrentPath(), getMusicPlayer().getLoop(), getMusicPlayer().getFadeOut()) 
				end
			end
		end
	end
	concommand.Add("optionsMenu", function(ply,cmd,args) openOptionsMenu() end)
end