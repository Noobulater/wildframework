local frame

function GM:OnContextMenuOpen( )
	invOpen()
end

function GM:OnContextMenuClose( )
	if frame != nil then
		frame:Remove()
	end
end

function invOpen( inventoryData )

	if frame != nil then
		frame:Remove()
	end

	frame = vgui.Create("DFrame")
	frame:SetSize(450, 270)
	frame:Center()
	frame:SetTitle("")
	frame:MakePopup()
	frame.Paint = function()
		surface.SetDrawColor( 55, 55, 55, 155)
		surface.DrawRect( 0, 0, frame:GetWide(), frame:GetTall())
	end

	local inventoryData = LocalPlayer():getInventory()

	local eqPanel = vgui.Create("DPanel", frame)
	eqPanel:SetSize(frame:GetWide() / 2, frame:GetTall() - 30) 
	eqPanel:SetPos(0, 30)
	eqPanel.Paint = function() end 

	local invPanel = vgui.Create("DPanel", frame)
	invPanel:SetSize(frame:GetWide() / 2, frame:GetTall() - 50) 
	invPanel:SetPos(frame:GetWide() / 2, 50)
	invPanel.Paint = function() end 

	guiPaintEquipment(inventoryData, eqPanel)
	guiPaintInventory(inventoryData, invPanel)

end
concommand.Add("openInventory", invOpen)

function guiPaintEquipment(inventoryData, parent, permissions ) -- permissions in order {leftClic, rightClick, extra, extra}
	if inventoryData == nil then return false end

	local xPos = 10
	local yPos = 10
	local maxX = parent:GetWide() - 20
	local padding = 10

	primaryWeapon = vgui.Create("itemIcon", parent)
	primaryWeapon:SetPos(xPos, yPos)
	primaryWeapon:SetSize(200, 100)
	primaryWeapon:SetInventoryID(inventoryData.getUniqueID())
	primaryWeapon:SetSlot( -1 )

	if permissions then
		primaryWeapon:SetFunctionality(permissions[1], permissions[2], permissions)
	end

	yPos = yPos + primaryWeapon:GetTall() + padding

	secondaryWeapon = vgui.Create("itemIcon", parent)
	secondaryWeapon:SetPos(xPos, yPos)
	secondaryWeapon:SetSize(95, 100)
	secondaryWeapon:SetInventoryID(inventoryData.getUniqueID())
	secondaryWeapon:SetSlot( -2 )

	if permissions then
		secondaryWeapon:SetFunctionality(permissions[1], permissions[2], permissions)
	end

	xPos = xPos + secondaryWeapon:GetWide() + padding

	gearSlot = vgui.Create("itemIcon", parent)
	gearSlot:SetPos(xPos, yPos)
	gearSlot:SetSize(95, 100)
	gearSlot:SetInventoryID(inventoryData.getUniqueID())
	gearSlot:SetSlot(-3)

	if permissions then
		gearSlot:SetFunctionality(permissions[1], permissions[2], permissions)
	end

end

function guiPaintInventory(inventoryData, parent, permissions ) -- permissions in order {leftClic, rightClick, extra, extra}

	if inventoryData == nil then return false end

	local iconSize = 50 -- this is a square

	local xPos = 10
	local yPos = 10
	local maxX = parent:GetWide() - 10
	local padding = 10

	for slot, itemData in pairs(inventoryData.getItems()) do
		if slot >= 0 then -- dont render equipped stuff
			iconSlot = vgui.Create("itemIcon", parent)
			iconSlot:SetSize(iconSize, iconSize)
			iconSlot:SetPos(xPos, yPos)	
			iconSlot:SetInventoryID(inventoryData.getUniqueID())
			iconSlot:SetSlot( slot )
			if permissions then
				iconSlot:SetFunctionality(permissions[1], permissions[2], permissions)
			end

			xPos = xPos + iconSize + padding
			if xPos + iconSize >= maxX then
				xPos = 10
				yPos = yPos + iconSize + padding
			end
		end
	end
end

function guiExamineItem(itemData, parent)
	local examineFrame = vgui.Create("DFrame")
	examineFrame:SetSize(550, 300)
	examineFrame:Center()
	examineFrame:SetTitle(itemData.getName())
	examineFrame:MakePopup()
	examineFrame.Paint = function()
		surface.SetDrawColor( 55, 55, 55, 155)
		surface.DrawRect( 0, 0, examineFrame:GetWide(), examineFrame:GetTall())
	end

	local size = math.Clamp(examineFrame:GetWide()/2 - 20, 0, examineFrame:GetTall() - 50)

	local background = vgui.Create("DPanel", examineFrame)
	local parent = background:GetParent()

	background:SetSize(size, size) 
	background:SetPos(10,parent:GetTall()/2 - background:GetTall() / 2 )
	background.Paint = function()
			surface.SetDrawColor( 0, 0, 0, 255)
			surface.DrawRect( 0, 0, background:GetWide(), background:GetTall())
	end

	local mdl = vgui.Create("DModelPanel", background)
	local parent = mdl:GetParent()
	mdl:SetPos(0,0)
	mdl:SetSize(parent:GetWide(), parent:GetTall())
	util.DModelPanelCenter(mdl, itemData.getModel())

	local statsPanel = vgui.Create("DListView", examineFrame)
	local parent = statsPanel:GetParent()
	statsPanel:SetSize(size, size) 
	statsPanel:SetPos(parent:GetWide() - 10 - statsPanel:GetWide(),parent:GetTall()/2 - statsPanel:GetTall() / 2 )

	statsPanel:AddColumn("Item Information")
	if itemData.getName() != nil then
		statsPanel:AddLine("Name : " .. itemData.getName())
	end
	if itemData.getDescription() != nil then
		statsPanel:AddLine("Description : " .. itemData.getDescription())
	end

	if itemData.getReusable() != nil then
		local value = "No"
		if itemData.getReusable() then
			value = "Yes"
		end		
		statsPanel:AddLine("Reusable : " .. value )
	end

	if itemData.isWeapon() then
		local stat = itemData.getDamage()
		if stat != nil then
			statsPanel:AddLine("Damage : " .. stat .. " per shot")
		end
		local stat = itemData.getFireRate()		
		if stat != nil then
			statsPanel:AddLine("Rate of Fire : " .. math.Round(1/stat) .. " shots per second")
		end	
		local stat = itemData.getClipSize()	
		if stat != nil then
			statsPanel:AddLine("Clip Size : " .. stat )
		end		
		local stat = itemData.getReloadTime()	
		if stat != nil then
			statsPanel:AddLine("Approximate Reload Time : " .. stat .. " seconds" )
		end			
		local stat = itemData.getAmmoType()	
		if stat != nil then
			statsPanel:AddLine("Ammo Type : " .. stat  )
		end	
		local stat = itemData.getAutomatic()	
		if stat != nil then

			local value = "No"
			if stat then
				value = "Yes"
			end		

			statsPanel:AddLine("Automatic : " .. value  )
		end										
	end
	return examineFrame
end