if SERVER then
	
	concommand.Add("selectCustomWeapon", function(ply,cmd,args) 
			local user = ply
			local slot = math.Round(tonumber(args[1]))

			local weapon = user:getInventory().getSlot(slot)

			user:StripWeapon(weapon.getWClass())

			user:Give(weapon.getWClass())

			user:SelectWeapon(weapon.getWClass())

			local wep = user:GetActiveWeapon()
			if !IsValid(wep) or wep:GetClass() != "weapon_loader" then print("Weapon: Player doesn't have weapon loader") return false end

			wep:SetWeapon(weapon)	

			updateActiveWeapon(slot, user)

	 end)

	concommand.Add("selectWeapon", function(ply,cmd,args) ply:SelectWeapon(args[1]) end)
end

if CLIENT then

local closeTime = 0
local closeDelay = 3
local selectedIndex = 1

local PANEL = {}

local function selectableSlots()
	local inventory = LocalPlayer():getInventory()
	if inventory == nil then return {-1} end

	local returnTable = {}
	local count = 1
	for slot, item in pairs(inventory.getItems()) do
		if item != 0 && item.getHotBar() then
			returnTable[count] = slot
			count = count + 1
		end
	end

	return returnTable
end

function PANEL:Draw()
	local inventory = LocalPlayer():getInventory()
	if inventory == nil then return false end

	local iconSize = 50 -- this is a square

	if self.items == nil then 
		self.items = {}
	end
	local count = 1
	for slot, itemData in pairs(inventory.getItems()) do
		local iconSlot = vgui.Create("itemIcon", parent)
		iconSlot:SetSize(iconSize, iconSize)
		iconSlot:SetPos(-50, -50) -- just keeps this not visible	
		iconSlot:SetInventoryID(inventory.getUniqueID())
		iconSlot:SetSlot( slot )
		iconSlot:SetKeyBoardInputEnabled(false)
		iconSlot:SetMouseInputEnabled(false)
		iconSlot.Think = function() if !self:isVisible() then iconSlot:Remove() end end

		self.items[count] = iconSlot
		count = count + 1
	end

	return true
end

function PANEL:Paint()
	if !self:isVisible() then return false end
	if !self.items then return false end

	local inventory = LocalPlayer():getInventory()
	local padding = 10
	local iconSize = 50
	local yPos = ScrH() / 8
	local xPos = ScrW() - iconSize - padding

	for index, itemPanel in pairs( self.items ) do
		if inventory.getSlot(itemPanel:GetSlot()) != 0 && itemPanel:GetItem().getHotBar() then
			if itemPanel:GetSlot() == selectableSlots()[selectedIndex] then 
				surface.SetDrawColor(0,255,0,255)
				surface.DrawOutlinedRect(xPos - 5, yPos - 5, iconSize + 10, iconSize + 10)
			end			
			itemPanel:SetPos(xPos, yPos)

			yPos = yPos + iconSize + padding
		else

		end
	end
end

local function hotbarPaint()
	PANEL:Paint()
end
hook.Add("HUDPaint", "hotbarPaint", hotbarPaint) 

function PANEL:Clear()
	return true
end

local function findEquipped()
	local weapon = LocalPlayer():GetActiveWeapon() 
	if !IsValid(weapon) then return end

	local inventory = LocalPlayer():getInventory()
	if inventory == nil then return end

	for slot, itemData in pairs(inventory.getItems()) do
		if slot < 0 && itemData != 0 then
			if itemData.isWeapon() && itemData.getWClass() == weapon:GetClass() then
				if itemData.getCustom() then
					if weapon:GetWeapon() && itemData.getClass() == weapon:GetWeapon().getClass() then
						for index, mimicSlot in pairs(selectableSlots()) do
							if mimicSlot == slot then
								selectedIndex = index
							end
						end
					end
				else
					for index, mimicSlot in pairs(selectableSlots()) do
						if mimicSlot == slot then
							selectedIndex = index
						end
					end
				end
			end
		end
	end
end

function PANEL:Open()
	if !util.isActivePlayer(LocalPlayer()) then return false end
	if !self:Draw() then return false end
	findEquipped()
	self.visible = true
	return true
end

function PANEL:isVisible()
	return self.visible
end

function PANEL:Clear()
	if self.items then
		for slot, itemPanel in pairs( self.items ) do
			itemPanel:Remove()
		end
		self.items = nil
	end
	return true
end

function PANEL:Hide()
	if !self:Clear() then return false end
	self.visible = false
	return true
end

function PANEL:Think() 
	if closeTime < CurTime() then
		self:Hide()
	end
end

local function hotbarThink()
	PANEL:Think()
end
hook.Add("Think", "hotbarThink", hotbarThink) 


function PANEL:selectNext()
	local slots = selectableSlots()
end

function PANEL:selectPrev()

end

function PANEL:actionPerformed()
	closeTime = CurTime() + closeDelay
end

local function delayWeaponShot()
	local wep = LocalPlayer():GetActiveWeapon()
	if IsValid(wep) then
		local lastClip = wep:Clip1()
		wep:SetClip1(0)
		timer.Simple(0.05, function() if IsValid(wep) then wep:SetClip1(lastClip) end end )
	end
end

function PANEL:BindPress(ply, bind, pressed)
	if not IsValid(ply) then return end

	local inventory = LocalPlayer():getInventory()
	if inventory == nil then return end

	if bind == "invnext" and pressed then

		if !self:isVisible() then 
			self:Open() 
		else
			if selectedIndex + 1 > table.Count(selectableSlots()) then
				selectedIndex = 1
			else
				selectedIndex = math.Clamp(selectedIndex + 1, 1, table.Count(selectableSlots()))
			end
		end
		self:actionPerformed()
		return true
	elseif bind == "invprev" and pressed then   

		if !self:isVisible() then 
			self:Open() 
		else
			if selectedIndex - 1 < 1 then
				selectedIndex = table.Count(selectableSlots())
			else
				selectedIndex = math.Clamp(selectedIndex - 1, 1, table.Count(selectableSlots()))
			end
		end
		self:actionPerformed()
		return true
	elseif bind == "+attack" then

		if self:isVisible() then 
			local slot = selectableSlots()[selectedIndex]

			if inventory.getSlot(slot) != 0 && inventory.getSlot(slot).isWeapon() then
				if slot >= 0 then
					for index, itemPanel in pairs(self.items) do
						if itemPanel:GetSlot() == slot then
							itemPanel:Use()
							break
						end
					end
				else
					if inventory.getSlot(slot).getCustom() then
						local wep = LocalPlayer():GetActiveWeapon()
						if IsValid(wep) then
							if wep.GetWeapon == nil or wep:GetWeapon().getClass() != inventory.getSlot(slot).getClass() then
								RunConsoleCommand("selectCustomWeapon", slot)
							else
								for index, itemPanel in pairs(self.items) do
									if itemPanel:GetSlot() == slot then
										itemPanel:Use()
										break
									end
								end		
							end	
						else
							RunConsoleCommand("selectCustomWeapon", slot)			
						end
					else
						RunConsoleCommand("selectWeapon", inventory.getSlot(slot).getWClass())
					end
				end
			else
				for index, itemPanel in pairs(self.items) do
					if itemPanel:GetSlot() == slot then
						itemPanel:Use()
						break
					end
				end				
			end

			self:Hide()
			delayWeaponShot()
			return true
		end

	elseif bind == "+attack2" then
		
		if self:isVisible() then 
			local slot = selectableSlots()[selectedIndex]

			for index, itemPanel in pairs(self.items) do
				if itemPanel:GetSlot() == slot then
					if slot < 0 then
						if inventory.getSlot(slot) != 0 && inventory.getSlot(slot).isWeapon() then
							itemPanel:Use()
						end
					else
						itemPanel:Drop()
					end
					break
				end
			end		

			self:Hide()
			delayWeaponShot()
			return true
		end

	elseif string.sub(bind, 1, 4) == "slot" and pressed then

		if !self:isVisible() then 
			self:Open()
		end

		selectedIndex = math.Clamp(tonumber(string.sub(bind, 5, 5)), 1, table.Count(selectableSlots())) 
		self:actionPerformed()
		return true
	end
end

function getHotBar()
	return PANEL
end

function GM:HUDWeaponPickedUp()
	return false
end

function GM:HUDAmmoPickedUp()
	return false
end

local function hotbarBindPress( ply, bind, pressed )
	return PANEL:BindPress(ply, bind, pressed )
end
hook.Add("PlayerBindPress", "hotbarBindPress", hotbarBindPress) 

local function shouldDraw( name )
	if (name == "CHudWeaponSelection") then
		return false 
	end
end
hook.Add("HUDShouldDraw", "hotbarShouldDraw", shouldDraw) 

end