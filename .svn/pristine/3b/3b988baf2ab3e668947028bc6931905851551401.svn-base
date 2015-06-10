classRenderData = {}

if SERVER then 
	util.AddNetworkString( "addEntryData" )
	util.AddNetworkString( "clearEntryData" )
	util.AddNetworkString( "removeEntryData" )
	util.AddNetworkString( "updateNetworkedEntry" )					
	function networkClearEntries( ply )
		ply = ply or player.GetAll()
		net.Start( "clearEntryData" )
		net.Send( ply )
	end
	function networkEntry( entryData, ply )
		ply = ply or player.GetAll()

		local staticNum = 0
		if entryData.getStatic() then
			staticNum = 1
		end

		net.Start( "addEntryData" )
			net.WriteString( entryData.getClass() or "prop_physics" )
			net.WriteUInt( staticNum, 2 )
			net.WriteString( entryData.getModel() or "|" )
			net.WriteUInt( entryData.getSkin(), 4 )
			net.WriteVector( entryData.getPos() )
			net.WriteAngle( entryData.getAngles() )
			net.WriteInt( entryData.getHealth() or 0, 6 )	
			net.WriteUInt( entryData.getSolidDistance() or 0, 12 )		
			net.WriteUInt( entryData.getUniqueID(), 32 )				
		net.Send( ply )	
	end
	function updateNetworkedEntry( entryData, ply )
		ply = ply or player.GetAll()
		net.Start( "updateNetworkedEntry" )
			net.WriteUInt( entryData.getUniqueID(), 32 )		
			net.WriteVector( entryData.getPos() )
			net.WriteAngle( entryData.getAngles() )	
			net.WriteUInt( entryData.getHealth() or 0, 6 )								
		net.Send( ply )	
	end

	function networkRemoveEntry( uniqueID, ply )
		ply = ply or player.GetAll()
		net.Start( "removeEntryData" )
			net.WriteUInt( uniqueID,  32 )
		net.Send( ply )	
	end	
end

if CLIENT then
	net.Receive( "addEntryData", function(len)   
		local entry = classRenderEntry.new()
		entry.setClass(net.ReadString() or "prop_physics")
		entry.setStatic(tobool(net.ReadUInt( 2 )))
		entry.setModel(net.ReadString())
		entry.setSkin(net.ReadUInt( 4 ))
		entry.setPos(net.ReadVector())
		entry.setAngles(net.ReadAngle())
		entry.setHealth(net.ReadInt( 6 ))	
		entry.setSolidDistance( net.ReadUInt( 12 ) )	
		entry.setUniqueID(net.ReadUInt( 32 ))	
		world.data.addEntry(entry)
	end)
	net.Receive( "clearEntryData", function(len)   
		world.data.clearEntries()
	end)
	net.Receive( "removeEntryData", function(len)   
		world.data.removeEntry(net.ReadUInt( 32 ))
	end)	

	net.Receive( "updateNetworkedEntry", function(len)   
		local uniqueID = net.ReadUInt( 32 )	
		local entry = world.data.getEntry(uniqueID) --classRenderEntry.new()

		if entry == nil then return end

		entry.setPos(net.ReadVector())
		entry.setAngles(net.ReadAngle())
		entry.setHealth(net.ReadInt( 6 ))	
	end)		
end

-- function determineDirection( pos )
-- 	if pos.x >= 0 && pos.y >= 0 then
-- 		return 1
-- 	end
-- 	if pos.x < 0 && pos.y >= 0 then
-- 		return 2
-- 	end	
-- 	if pos.x < 0 && pos.y < 0 then
-- 		return 3
-- 	end		
-- 	if pos.x >= 0 && pos.y < 0 then
-- 		return 4
-- 	end		
-- end

-- function determineNode( entryData, node )
-- 	local pos = entryData.getPos()
-- 	local level = node.getLevel()

-- 	local origin = 
-- end

function determineDirection(pos, comparePos)
	if pos.x >= comparePos.x && pos.y >= comparePos.y then
		return 1
	elseif pos.x < comparePos.x && pos.y >= comparePos.y then
		return 2
	elseif pos.x < comparePos.x && pos.y < comparePos.y then
		return 3
	elseif pos.x >= comparePos.x && pos.y < comparePos.y then
		return 4
	end
	print("error in determining direction")
	return 0 -- dont know what da eff happened
end
	
function determineTree( entryData, renderTree ) 
	local pos = entryData.getPos() -- this is the most important part of this process

	local comparePos = renderTree.getPos()
	local dir = determineDirection(pos, comparePos)

	local branch = renderTree.getBranches()[dir]

	if branch.isCluster() then
		branch.addData( entryData )
		if branch.numEntries() > classRenderCluster.maxEntries then
			renderTree.updateBranch(dir, branch.split( comparePos )) -- this will return a new cluster of trees
			return 
		end
	else
		-- keep going if the branch isn't a cluster
		-- just this time go one step deeper in the direction 
		determineTree(entryData, branch)
		return
	end 
end

function classRenderData.new() 

	local genNum = 0
	local public = {}

	local entries = {}
	-- Optimum is the ordered entries, built into quad trees
 	local optimum = classRenderTree.new( 4 )--classRenderNode( 0 )--

	function public.addEntry(entryData)

		determineTree( entryData, optimum )--determineNode( entryData, optimum )--

		if SERVER then
			entryData.setUniqueID( genNum ) 
			networkEntry(entryData)
			genNum = genNum + 1
		end
		entries[entryData.getUniqueID()] = entryData
	end
	
	function public.setOptimum( newOptimum ) -- please dont ever use this...
		optimum = newOptimum
	end

	function public.getOptimum()
		return optimum
	end

	function public.removeEntry( uniqueID )
		
		if entries[uniqueID] == nil then return false end

		if IsValid(entries[uniqueID].getEnt()) then
			entries[uniqueID].getEnt():Remove()
		end
		entries[uniqueID] = nil
		if SERVER then
			networkRemoveEntry( uniqueID )
		end
		return true
	end
	
	function public.getEntry( uniqueID )
		return entries[uniqueID]
	end

	function public.getEntries()
		return entries
	end

	function public.clearEntries()
		table.Empty(entries)
		if SERVER then
			networkClearEntries()
		end
	end
	if SERVER then

	function public.updatePlayer( ply, shouldClear )
		if shouldClear then
			networkClearEntries( ply )
		end
		for uniqueID, entryData in pairs(entries) do
			networkEntry(entryData)
		end
	end

	end

	return public
end

