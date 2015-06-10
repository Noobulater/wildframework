classInventory = {}
classInventory.defaultSlots = 9

if SERVER then 

	util.AddNetworkString( "networkAddSlot" )
	util.AddNetworkString( "networkRemoveSlot" )

	util.AddNetworkString( "networkSwapSlots" )	
	util.AddNetworkString( "networkItemSlot" )

	util.AddNetworkString( "networkSlotExtras" )

	function networkRemoveSlot( uniqueID, slot, ply )
		ply = ply or player.GetAll()
		if uniqueID == nil then print("Inventory: trying to Network a slot to an invID that doesn't Exist") return false end
		net.Start( "networkRemoveSlot" )
			net.WriteUInt( uniqueID, 32 )
			net.WriteInt( slot, 6 )
		net.Send( ply )	
	end

	function networkSwapSlots( uniqueID, slotTo, slotFrom, ply )
		ply = ply or player.GetAll()

		local class = "0"

		if itemData != 0 then class = itemData.getClass() end

		net.Start( "networkSwapSlots" )
			net.WriteUInt( uniqueID, 32 )
			net.WriteInt( slotTo, 6 )
			net.WriteInt( slotFrom, 6 )	
		net.Send( ply )	
	end

	function networkItemSlot( uniqueID, slot, itemData, ply )
		ply = ply or player.GetAll()

		local class = "0"
		local extras = ""
		if itemData != 0 then class = itemData.getClass() extras = itemData.getExtras() end

		net.Start( "networkItemSlot" )
			net.WriteUInt( uniqueID or 0, 32 )
			net.WriteInt( slot, 6 )
			net.WriteString( class )	
			net.WriteString( extras )		
		net.Send( ply )	
	end

	function networkSlotExtras( uniqueID, slot, itemData, ply )
		ply = ply or player.GetAll()

		local extras = ""
		if itemData != 0 then extras = itemData.getExtras() end

		net.Start( "networkSlotExtras" )
			net.WriteUInt( uniqueID or 0, 32 )
			net.WriteInt( slot, 6 )
			net.WriteString( extras )		
		net.Send( ply )	
	end	
end
if CLIENT then

	net.Receive( "networkRemoveSlot", function(len)   
		local uniqueID = net.ReadUInt(32)
		local slot = net.ReadInt( 6 )

		local inventory = classInventoryData.get(uniqueID)

		if inventory == nil then return false end

		inventory.removeSlot( slot )		
	end)

	net.Receive( "networkSwapSlots", function(len)   
		local uniqueID = net.ReadUInt( 32 )
		local itemSlotTo = net.ReadInt( 6 )
		local itemSlotFrom = net.ReadInt( 6 )

		local inventory = classInventoryData.get(uniqueID)
		if inventory == nil then return false end
		inventory.swapSlots( itemSlotTo, itemSlotFrom )	
	end)

	net.Receive( "networkItemSlot", function(len)   
		local uniqueID = net.ReadUInt(32)
		local itemSlot = net.ReadInt( 6 )
		local item = net.ReadString( )	
		local itemExtras = net.ReadString()
		if item != "0" then
			item = classItemData.genItem( item )
			item.setExtras( itemExtras )
		else
			item = 0
		end

		if item != nil then 
			local inventory = classInventoryData.get(uniqueID)

			if inventory == nil then return false end

			inventory.setSlot( itemSlot, item )
		else
			print("item Incorrectly networked")
		end
	end)

	net.Receive( "networkSlotExtras", function(len)   
		local uniqueID = net.ReadUInt( 32 )
		local itemSlot = net.ReadInt( 6 )
		local extras = net.ReadString()

		local inventory = classInventoryData.get(uniqueID)
		if inventory == nil then return false end

		local item = inventory.getSlot(itemSlot) 
		if item != 0 then
			item.setExtras(extras)
		end
	end)	
end

function classInventory.new( refOwner )

	local public = {}
	local uniqueID

	local inventory = {}
	local owner = refOwner or nil -- this is a backwards reference to the owner, could be player, prop or npc

	function public.setOwner( newOwner )
		if !IsValid(newOwner) then print("inventory: not a valid owner") end
		owner = newOwner
	end

	function public.getOwner()
		return owner
	end

	function public.getSlot( slot )
		return inventory[slot]
	end

	function public.setSlot( slot, itemData )
		inventory[slot] = itemData or 0
		if SERVER && owner:IsPlayer() then
			networkItemSlot( uniqueID, slot, itemData, owner )
		end
	end

	function public.removeSlot( slot )
		local itemData = public.getSlot(slot)
		if itemData != nil then
			if !public.addItem( itemData ) then
				itemData.drop( owner )
			end
		end
		table.remove( inventory, slot )
		if SERVER && owner:IsPlayer() then
			networkRemoveSlot( uniqueID, slot, owner )
		end		
	end

	function public.addSlot( )
		local slot = table.Count(inventory)
		public.setSlot( slot, 0)
	end

	function public.swapSlots( slotTo, slotFrom )
		if slotTo == slotFrom then return false end

		local swapItem = public.getSlot( slotFrom )
		local item = public.getSlot( slotTo )
		public.setSlot( slotTo, swapItem )
		public.setSlot( slotFrom, item )
		if slotTo < 0 && item != 0 && item.isWeapon() then
			item.unEquip( owner )
		end
		if slotFrom < 0 && swapItem != 0 && swapItem.isWeapon() then
			swapItem.unEquip( owner )
		end		
	end

	function public.hasRoom()
		for slot, itemData in pairs( inventory ) do
			if slot >= 0 && itemData == 0 then
				return slot
			end
		end
		return nil
	end

	function public.getItems()
		return inventory
	end

	function public.findItem( itemData )
		for key, item in pairs(inventory) do
			if item == itemData then
				return key
			end
		end
		print("Inventory: itemData was not found")
		return nil
	end

	function public.findItemClass( itemClass )
		for key, item in pairs(inventory) do
			if item != 0 && item.getClass() == itemClass then
				return key
			end
		end
		print("Inventory: itemClass was not found")
		return nil
	end

	function public.addItem( addItemData )
		local openSlot = public.hasRoom()

		if !openSlot then
			print("inventoryFull")
			return false
		end

		public.setSlot( openSlot, addItemData )	

		return true
	end

	function public.removeItem( removeSlot, removeItemData )
		if removeSlot then
			removeItemData = public.getSlot( removeSlot )
			if removeItemData != 0 then
				public.setSlot( removeSlot, 0 )		
				if removeSlot < 0 then
					removeItemData.unEquip(owner)
				end		
				return true
			end
		else
			for slot, itemData in pairs( inventory ) do
				if removeItemData != 0 && itemData == removeItemData then
					public.setSlot( slot, 0 )
					if slot < 0 then
						removeItemData.unEquip(owner)
					end	
					return true
				end
			end
		end
		return false
	end

	function public.useItem( useSlot, useItemData )
		if useSlot then
			useItemData = public.getSlot( useSlot )
			if useItemData != 0 then
				hook.Call("ItemUsed", GAMEMODE, public, public.getSlot(useSlot), owner )
				if !useItemData.getReusable() then
					public.setSlot( useSlot, 0 )	
				end			
				useItemData.use( owner )
				return true
			end
		else
			for slot, itemData in pairs( inventory ) do
				if useItemData != 0 && public.getSlot( slot ) == useItemData then
					hook.Call("ItemUsed", GAMEMODE, public, public.getSlot(slot), owner )
					if !useItemData.getReusable() then
						public.setSlot( slot, 0 )	
					end	
					useItemData.use( owner )
					return true
				end
			end
		end

		return false
	end

	function public.dropItem( dropSlot, dropItemData )
		if dropSlot then
			dropItemData = public.getSlot( dropSlot )
			if dropItemData != 0 then
				hook.Call("ItemDropped", GAMEMODE, public, public.getSlot(dropSlot) )
				public.setSlot( dropSlot, 0 )	
				dropItemData.drop( owner )
				if dropSlot < 0 then
					dropItemData.unEquip(owner)
				end

				return true
			end
		else
			for slot, itemData in pairs( inventory ) do
				if dropItemData != 0 &&  public.getSlot( slot ) == dropItemData then
					hook.Call("ItemDropped", GAMEMODE, public, public.getSlot(slot) )
					public.setSlot( slot, 0 )	
					dropItemData.drop( owner )
					if slot < 0 then
						dropItemData.unEquip(owner)
					end					
					return true
				end
			end
		end

		return false
	end

  

	function public.setUniqueID( newUniqueID )
		uniqueID = tonumber(newUniqueID)
	end
	function public.getUniqueID()
		return uniqueID
	end

	if SERVER then
		function public.toString()
			local compiledString = ""
			for slot, itemData in pairs( inventory ) do
				compiledString = compiledString .. tostring(slot) .. ":"
				if itemData != 0 && !itemData.getTemporary() then
					compiledString = compiledString .. itemData.getClass()
				else
					compiledString = compiledString .. "0"
				end
				compiledString = compiledString .. "|" -- this closes the slot off	
			end

			return compiledString
		end
		
		function public.loadFromString( compiledString )
			if compiledString == nil then print("Inventory : No String Provided to load From") return end
			compiledString = string.gsub(compiledString, 1, 1) -- the begining is always useless anyways

			local slotsTable = string.Explode("|", compiledString )

			for index, compiledSlot in pairs(slotsTable) do
				local slotData = string.Explode(":", compiledSlot )
				local slot = tonumber(slotData[1])
				local item = slotData[2]
				if slot != nil then
					local item = classItemData.genItem(item) or 0
					public.setSlot( slot, item )
				end
			end
		end

		function public.load()
			for slot, itemData in pairs( inventory ) do
				if slot < 0 && itemData != 0 then
					itemData.equip( refOwner )
				end
			end
		end
	end

	for i = 1, classInventory.defaultSlots do
		public.addSlot()
	end
	-- these are the equipment slots
	public.setSlot(-1, 0)
	public.setSlot(-2, 0)
	public.setSlot(-3, 0)

	if SERVER then
		classInventoryData.register(public)
	end

	return public

end
if SERVER then

concommand.Add("useItem", function( ply, cmd, args ) if !util.isActivePlayer(ply) then return false end ply:getInventory().useItem( math.Round(args[1] or 0) ) end )
concommand.Add("dropItem", function( ply, cmd, args ) if !util.isActivePlayer(ply) then return false end ply:getInventory().dropItem( math.Round(args[1] or 0) ) end )
//concommand.Add("attachItem", function( ply, cmd, args ) ply:getInventory().attachItem(math.Round(args[1], math.Round(args[2])) end)
end
