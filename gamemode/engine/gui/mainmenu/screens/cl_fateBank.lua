function fateBank(parent, key)

	local characterData = LocalPlayer():getData().getCharacter( key )

	local dupe = classFillerPanel.new( parent )
	dupe:SetSize(parent:GetWide(),parent:GetTall())
	dupe.Paint = function() 
		surface.SetDrawColor(0,0,0,155)
		surface.DrawRect( 0, 0, dupe:GetWide(), dupe:GetTall() )
	end
	local width = dupe:GetWide()

	if characterData != nil then
		width = width/2

		local permissions = {"Deposit", "Examine"}
		-- if key == LocalPlayer():getCharacterIndex() then
		-- 	permissions = nil
		-- end

		local inventoryData = characterData.getInventory()

		local inventoryPanel = vgui.Create("DPanel", dupe)
		inventoryPanel:SetSize(width, dupe:GetTall())
		inventoryPanel.Paint = function()  end
		
		local eqPanel = vgui.Create("DPanel", inventoryPanel)
		eqPanel:SetSize(225, 240)
		eqPanel:SetPos(inventoryPanel:GetWide()/2 - eqPanel:GetWide()/2,0)
		eqPanel.Paint = function() end

		guiPaintEquipment(inventoryData, eqPanel, permissions)

		local itemsPanel = vgui.Create("DPanel", inventoryPanel)
		itemsPanel:SetSize(inventoryPanel:GetWide(), inventoryPanel:GetTall() - 240)
		itemsPanel:SetPos(0,240)
		itemsPanel.Paint = function() end

		guiPaintInventory(inventoryData, itemsPanel, permissions)

		dupe.addItem(inventoryPanel)

	end

	local permissions = {"Withdraw", "Examine"}

	local inventoryData = LocalPlayer():getFate().getInventory()

	local fatePanel = vgui.Create("DPanel", dupe)
	fatePanel:SetPos(dupe:GetWide() - width, 0)
	fatePanel:SetSize(width, dupe:GetTall())
	fatePanel.Paint = function() end

	local itemsPanel = vgui.Create("DPanel", fatePanel)
	itemsPanel:SetSize(fatePanel:GetWide(), fatePanel:GetTall())
	itemsPanel:SetPos(0,0)
	itemsPanel.Paint = function() end

	guiPaintInventory(inventoryData, fatePanel, permissions)

	dupe.addItem(fatePanel)

	return dupe
end
classMainMenu.SCREENS["fateBank"] = fateBank