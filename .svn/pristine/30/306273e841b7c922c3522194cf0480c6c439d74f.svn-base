classInventoryData = {}

if SERVER then 
	util.AddNetworkString( "networkInventory" )
			
	function networkInventory( inv, ply )
		ply = ply or player.GetAll()	
		net.Start( "networkInventory" )
			net.WriteUInt(inv.getUniqueID(), 32)
			net.WriteEntity(inv.getOwner())	
		net.Send( ply )
	end
end

if CLIENT then
	net.Receive( "networkInventory", function(len)  
		local uniqueID = net.ReadUInt( 32 ) 

		if uniqueID == 0 then return false end 

		local owner = net.ReadEntity()		

		local inventory = classInventory.new( owner )
		classInventoryData.set(uniqueID, inventory)
	end)
end

function classInventoryData.initialize()
	classInventoryData.genNum = 1 -- never start at 0.
	classInventoryData.data = {}
end

function classInventoryData.get( key )
	if classInventoryData.data == nil then classInventoryData.initialize() end
	return classInventoryData.data[key]
end

function classInventoryData.set( key, inventory )
	if classInventoryData.data == nil then classInventoryData.initialize() end
	inventory.setUniqueID(key)
	classInventoryData.data[key] = inventory
end

function classInventoryData.register( inventory )
	if classInventoryData.data == nil then classInventoryData.initialize() end
	if SERVER then
		local key = classInventoryData.genNum
		classInventoryData.set(key, inventory)

		if IsValid(inventory.getOwner()) && inventory.getOwner():IsPlayer() then
			networkInventory( inventory, inventory.getOwner() )
		end
		classInventoryData.genNum = classInventoryData.genNum + 1	
	end

	return classInventoryData.data[key]
end