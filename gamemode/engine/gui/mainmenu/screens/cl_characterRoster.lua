function characterRoster(parent)
	local dupe = classFillerPanel.new( parent )
	dupe:SetSize(parent:GetWide(),parent:GetTall())
	dupe.Paint = function() 
		surface.SetDrawColor(0,0,0,155)
		surface.DrawRect( 0, 0, dupe:GetWide(), dupe:GetTall() )
	end
	local characters = LocalPlayer():getData().getCharacters()

	for i = 1, GAMEMODE.MaxCharacters do 
		if i > 0 then
			local characterData = LocalPlayer():getData().getCharacter(i)

			local characterPanel = classOptionsTab.new(dupe)

			characterPanel:SetSize(dupe:GetWide()/GAMEMODE.MaxCharacters, dupe:GetTall())
			characterPanel.Paint = function() end

			if characterData != nil then
				local containerPanel = classOptionsTab.new(characterPanel)
				containerPanel:SetSize(characterPanel:GetWide() * (2/3), characterPanel:GetTall() - 100)
				containerPanel:SetPos(characterPanel:GetWide() * (1/2) - containerPanel:GetWide()/2, 0)
				function containerPanel:Paint() 
					if LocalPlayer():getCharacterIndex() == i then 
						surface.SetDrawColor(0, 255, 0, 155) 
						surface.DrawOutlinedRect( 2, 2,containerPanel:GetWide() - 4, containerPanel:GetTall() - 4)
					end 
				end
				
				local model = guiPaintCharacter(characterData, containerPanel)
				function model:DoClick()
					RunConsoleCommand("selectCharacter", i)
				end
				
				local selectButton = classOptionsTab.new(characterPanel)
				selectButton:SetText("Character Information")
				selectButton:SetSize(characterPanel:GetWide()/2 - 20, 60)
				selectButton:SetPos(5, characterPanel:GetTall() - selectButton:GetTall())
				selectButton.DoClick = function() parent.open("characterManagement", i) end

				local deleteCharacter = classOptionsTab.new(characterPanel)
				deleteCharacter:SetText("Delete Character")
				deleteCharacter:SetSize(characterPanel:GetWide()/2 - 20, 60)
				deleteCharacter:SetPos(characterPanel:GetWide()/2 + 5, characterPanel:GetTall() - deleteCharacter:GetTall())
				deleteCharacter.DoClick = function() RunConsoleCommand("deleteCharacter", i) parent.clear() end

			else
				local createButton = classOptionsTab.new(characterPanel)
				createButton:SetText("Create Character")
				createButton:SetSize(characterPanel:GetWide() - 20, 100)
				createButton:SetPos(10, characterPanel:GetTall()/2 - createButton:GetTall()/2)
				createButton.DoClick = function() RunConsoleCommand("openCharacterCreation") parent.clear() end
			end

			dupe.addItem(characterPanel)
		end
	end

	return dupe
end
classMainMenu.SCREENS["characterRoster"] = characterRoster