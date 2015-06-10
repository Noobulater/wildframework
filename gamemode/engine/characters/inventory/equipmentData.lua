classEquipmentData = {}

function classEquipmentData.new( refOwner )
	
	local public = classItemData.new( refOwner )
	local slots = {}

	public.setReusable(true)
	public.setHotBar(true)
	
	function public.addEQSlot( slot )
		table.insert(slots, slot)
	end

	function public.setPrimaryEQSlot( slot )
		slots[1] = slot
	end

	function public.getPrimaryEQSlot( )
		return slots[1]
	end

	function public.setSecondaryEQSlot( slot )
		slots[2] = slot
	end

	function public.getSecondaryEQSlot( )
		return slots[2]
	end

	function public.getEQSlots( slot )
		return slots
	end

	function public.getEQSlot( slot )
		local returnBool = false
		for index, refSlot in pairs(slots) do
			if refSlot == slot then
				returnBool = true
			end
		end
		return returnBool
	end

	function public.removeEQSlot( slot )
		local removeIndex
		for index, refSlot in pairs(slots) do
			if refSlot == slot then
				removeIndex = index
			end
		end
		table.remove(slots, removeIndex)
	end

	function public.equip( user )
		-- This is called right before the item is moved into the slot 
		if SERVER then
			local result = user:getInventory().findItem( public )

			user:getInventory().swapSlots( -3, result )		
		end
	end
	
	function public.unEquip( user )
		-- This is called after the item has been moved out
	end

	function public.equipped( user )
		local result = user:getInventory().findItem( public )
		if result == nil then return false end
		if result < 0 then
			return true
		end
		return false
	end

	function public.use( user )
		if !public.equipped( user ) then
			public.equip( user )
		else
			local openSlot = user:getInventory().hasRoom()
			if openSlot then
				local result = user:getInventory().findItem( public )

				user:getInventory().swapSlots(openSlot, result)
			else
				user:getInventory().dropItem( nil, public )
			end
		end
	end

	function public.isEquipment()
		return true
	end

	public.setPrimaryEQSlot(-3)

	return public

end