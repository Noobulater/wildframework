classFate = {}

if SERVER then 
	util.AddNetworkString( "updateFatePoints" )
	util.AddNetworkString( "updateFateInventory" )

	function updateFatePoints( ply , newFatePoints )
		ply = ply or player.GetAll()
		net.Start( "updateFatePoints" )
			net.WriteUInt( newFatePoints , 32 )	
		net.Send( ply )	
	end

	function updateFateInventory( ply , inventoryID )
		ply = ply or player.GetAll()
		net.Start( "updateFateInventory" )
			net.WriteUInt( inventoryID , 32 )	
		net.Send( ply )	
	end	
end

if CLIENT then
	net.Receive( "updateFatePoints", function(len)   
		local fate = net.ReadUInt( 32 )
		LocalPlayer():getFate().setFatePoints( fate )		
	end)

	net.Receive( "updateFateInventory", function(len)   
		local uniqueID = net.ReadUInt( 32 )
		LocalPlayer():getFate().setInventoryID( uniqueID )		
	end)	
end

function classFate.new( refOwner ) 

	local public = {}

	local fatePoints 
	local nextPay = -1
	local owner = refOwner
	local inventoryID = nil -- This is the bank.

	function public.setOwner( newOwner )
		if !IsValid(newOwner) then print("Fate: not a valid owner") end
		owner = newOwner
	end

	function public.getOwner()
		return owner
	end

	function public.addFatePoints( newFate )
		public.setFatePoints( fatePoints + newFate )

	end

	function public.removeFatePoints( newFate )
		newFate = fatePoints - newFate 

		if newFate < 0 then newFate = 0 end

		public.setFatePoints( newFate )
	end

	function public.setFatePoints( newFate )
		fatePoints = newFate
		if SERVER then
			if refOwner:IsPlayer() then
				updateFatePoints( owner , fatePoints )
			end
		end
	end

	function public.getFatePoints()
		return fatePoints
	end

	function public.setInventoryID( newInventoryID ) 
		inventoryID = newInventoryID 
		if SERVER then
			if refOwner:IsPlayer() then
				updateFateInventory(refOwner, inventoryID)
			end
		end
	end

	function public.getInventoryID()
		return inventoryID
	end

	function public.getInventory()
		return classInventoryData.get(inventoryID)
	end

	if SERVER then
		function public.toString()
			local compiledString = public.getInventory().toString() .. "^" .. fatePoints

			return compiledString
		end
		
		function public.loadFromString( compiledString )
			if compiledString == nil then print("Fate : No String Provided to load From") return end
			local explodedString = string.Explode("^", compiledString)
			public.getInventory().loadFromString(explodedString[1])
			public.setFatePoints(tonumber(explodedString[2]))
		end
	end

	local inv = classInventory.new( refOwner )

	public.setInventoryID( inv.getUniqueID() )

	for i = 0, 11 do
		inv.addSlot() -- makes it 20 sloted
	end
	
	inv.removeSlot(-3)
	inv.removeSlot(-2)
	inv.removeSlot(-1) -- You can't equipd anythin in a fate bank... Its a bank.

	return public

end

if SERVER then
	concommand.Add("withdrawItem", 
	function(ply, cmd, args) 
		local slot = math.Round(args[1])
		
		local characterID = math.Round(args[2])

		local character = ply:getCharacter( characterID )
		local inventory = character.getInventory()

		if inventory == nil then return end
		if inventory.getOwner() != ply then return end

		local fateBank = ply:getFate().getInventory()

		local item = fateBank.getSlot(slot)

		if inventory.hasRoom() then
			inventory.addItem( item )
			fateBank.removeItem( slot )
		end
	end)
	concommand.Add("depositItem", 
	function(ply, cmd, args) 
		local slot = math.Round(args[1])
		local inventoryID = math.Round(args[2])
		local inventory = classInventoryData.get(inventoryID)

		if inventory == nil then return end
		if inventory.getOwner() != ply then return end

		local item = inventory.getSlot(slot)

		local fateBank = ply:getFate().getInventory()

		if fateBank.hasRoom() then
			fateBank.addItem( item )
			inventory.removeItem( slot )
		end

	end)
end