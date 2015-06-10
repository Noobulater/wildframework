local PANEL = {}

local popupMenu

local functionality = {}
functionality["Use"] = function(slot, inventory) inventory.getSlot(slot).use( LocalPlayer() ) RunConsoleCommand("useItem", slot, inventory.getUniqueID()) end
functionality["Drop"] = function(slot, inventory) inventory.getSlot(slot).drop( LocalPlayer() ) RunConsoleCommand("dropItem", slot, inventory.getUniqueID()) end
functionality["Examine"] = function(slot, inventory) guiExamineItem(inventory.getSlot(slot)) end

functionality["Deposit"] = function(slot, inventory) RunConsoleCommand("depositItem", slot, inventory.getUniqueID()) end
functionality["Withdraw"] = function(slot, inventory) 
	if IsValid(popupMenu) then RunConsoleCommand("withdrawItem", slot, LocalPlayer():getCharacterIndex()) return  end
 	local dMenu = DermaMenu()
 	for key, charData in pairs(LocalPlayer():getCharacters()) do
 		if key > 0 then
 			dMenu:AddOption("Withdraw : " .. charData.getName(), function() RunConsoleCommand("withdrawItem", slot, key) end)
 		end
 	end
 	dMenu:Open()
end

local function openOptions(self)
	popupMenu = DermaMenu()

	local function validCheck() 
		if !IsValid(self) then popupMenu:Remove() end
	end

	for index, key in pairs(self.fPerm) do
		popupMenu:AddOption(key,
		function() 
			validCheck()
			local inventory = classInventoryData.get( self:GetInventoryID() )
			if inventory == nil then return end

			local item = inventory.getSlot(self:GetSlot())
	   	 	if item == 0 or item == nil then return end

			if LocalPlayer():Alive() && inventory.getOwner() == LocalPlayer() then	
				functionality[key](self:GetSlot(), inventory) 
			end
		end)
	end
	popupMenu:Open()
	popupMenu.Think = validCheck
end

function PANEL:Init()
	self.slot = 0
	self.inventoryID = 0 

	self.lClickF = "Use"
	self.rClickF = "Drop"
	self.fPerm = {"Use", "Drop", "Examine"}

	if self.Icon != nil then
		self.Icon:Remove()
	end
	self.Icon = vgui.Create( "ModelImage", self )
	self.Icon:SetMouseInputEnabled( false )
	self.Icon:SetKeyboardInputEnabled( false )	
	self.Icon:SetSize(self:GetWide(), self:GetTall())	

	self.button = vgui.Create( "DButton", self)
	self.button:SetSize(iconSize, iconSize)
	self.button:SetText("")
	self.button.Paint = function() 

							local inventory = classInventoryData.get( self:GetInventoryID() )
							if inventory == nil then return end

							local item = inventory.getSlot(self:GetSlot())
							if item == 0 or item == nil then return end
							
							item.paintOverHook( self ) 

						end

	self.button.OnMousePressed = function( panel, mouseCode )
		panel.clickTime = CurTime()
	end

	self.button.Think = function() 
		if self.button.clickTime != nil && CurTime() - self.button.clickTime > 0.15 then
			local mouseDown = MOUSE_RIGHT
			if input.IsMouseDown( MOUSE_LEFT ) then
				mouseDown = MOUSE_LEFT
			end
			self.button.OnMouseReleased(self.button, mouseDown)	
		end
	end

	self.button.OnMouseReleased = function( panel, mouseCode )
		if mouseCode == MOUSE_LEFT then
			if (self.button.clickTime != nil && CurTime() - self.button.clickTime > 0.15) then

			else
				self.button.DoClick(self.button)
			end
		elseif mouseCode == MOUSE_RIGHT then
			if IsValid(popupMenu) or (self.button.clickTime != nil && CurTime() - self.button.clickTime > 0.15) then
				openOptions(self)
			else
				self.button.DoRightClick(self.button)
			end
		end
		self.button.clickTime = nil
	end	

	self.button.DoClick = function() 
		self:Use()
	end	
	self.button.DoRightClick = function( panel ) 
		self:Drop()
	end			
end

function PANEL:SetInventoryID( newInventoryID )
	self.inventoryID = newInventoryID
end
function PANEL:GetInventoryID( )
	return self.inventoryID
end

function PANEL:SetSlot( newSlot )
	self.slot = newSlot
end

function PANEL:GetSlot()
	return self.slot
end

function PANEL:GetItem()
	local inventory = classInventoryData.get( self:GetInventoryID() )
	if inventory == nil then return end

	local item = inventory.getSlot(self:GetSlot())
	if item == 0 or item == nil then return end

	return item
end

function PANEL:Use()
	local inventory = classInventoryData.get( self:GetInventoryID() )
	if inventory == nil then return end

	local item = inventory.getSlot(self:GetSlot())
	if item == 0 or item == nil then return end

	if LocalPlayer():Alive() && inventory.getOwner() == LocalPlayer() then
		functionality[self.lClickF](self:GetSlot(), inventory)
	end
end

function PANEL:Drop()
	local inventory = classInventoryData.get( self:GetInventoryID() )
	if inventory == nil then return end

	local item = inventory.getSlot(self:GetSlot())
	if item == 0 or item == nil then return end

	if LocalPlayer():Alive() && inventory.getOwner() == LocalPlayer() then
	   	functionality[self.rClickF](self:GetSlot(), inventory)
	end
end

function PANEL:SetFunctionality(leftClick, rightClick, permissions)
	self.lClickF = leftClick
	self.rClickF = rightClick
	self.fPerm = permissions
end

function PANEL:Paint( w, h )
    draw.RoundedBox( 4, 0, 0, w, h, Color( 0,0,0,255 ) )
    local inventory = classInventoryData.get( self:GetInventoryID() )
    if inventory == nil then return end
    local itemData = inventory.getSlot( self:GetSlot() ) or 0 
    local size = h
    if w < h then
    	size = w
    end

    self.Icon:SetSize( size, size )    
    self.button:SetSize( size, size )
    self.Icon:SetPos(w/2 - size/2 ,h/2 - size/2)
    self.button:SetPos(w/2 - size/2 ,h/2 - size/2)

    if itemData != 0 then
    	self.Icon:SetVisible(true)
    	self.Icon:SetModel(itemData.getModel(), 0) -- model, skin, bodygroup
    	self.button:SetMouseInputEnabled( true )
		self.button:SetKeyboardInputEnabled( true )	
	else
		self.Icon:SetVisible(false)
		self.button:SetMouseInputEnabled( false )
		self.button:SetKeyboardInputEnabled( false )
    end
end

vgui.Register( "itemIcon", PANEL, "Panel" )