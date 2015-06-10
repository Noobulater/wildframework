local frame

local function manage() -- stands for open Character 

	if frame != nil then
		frame:Remove()
	end

	frame = vgui.Create("DFrame")
	frame:SetSize(250, 300)
	frame:SetTitle("")
	frame:MakePopup()
	frame:Center()
	frame.Paint = function()
		surface.SetDrawColor( 55, 55, 55, 220)
		surface.DrawRect( 0, 0, frame:GetWide(), frame:GetTall())
	end

	local yPos = 35

	yPos = yPos + 45

	for key, data in pairs(LocalPlayer():getCharacters()) do
		local mdl = vgui.Create("DModelPanel", frame)
		local parent = mdl:GetParent()
		mdl:SetPos(40 + 220 * (key - 1),40)
		mdl:SetSize(100, 100)
		mdl:SetModel(data.getModel() or "models/player/group01/female_03.mdl")
		mdl.DoClick = function() RunConsoleCommand("selectCharacter", key) end 

		local name = vgui.Create("DLabel", mdl)
		local parent = name:GetParent()
		name:SetSize( parent:GetWide() * 0.35, 25 )
		name:SetPos( parent:GetWide()/2 - name:GetWide()/2, 25)
		name:SetText(data.getName())
	end

end
concommand.Add("openCharacterManagement", manage)