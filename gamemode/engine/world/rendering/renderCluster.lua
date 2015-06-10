classRenderCluster = {}
classRenderCluster.maxEntries = 100 -- default maxes at 100 entries before reworking

function classRenderCluster.new( data )

	local public = {}

	local data = {}

	function public.split( parentPos )

		local tempData = table.Copy(data)
		public.clearData()

		local newTree = classRenderTree.new( 4 )

		local offset = nil
		local pos
		local dir
		local branch

		local furthestPos = tempData[1].getPos()

		for key, entryData in pairs(tempData) do

			pos = entryData.getPos() 

			if parentPos:Distance(pos) > parentPos:Distance(furthestPos) then
				furthestPos = pos
			end
		end
		-- BE VERY CAREFUL, THIS NEEDS TO BE ON THE GROUND LEVEL
		-- OTHERWISE YOUR TREE WILL BECOME THREE DIMENSIONAL, ONLY UNCONTROLABLE

		furthestPos.z = parentPos.z
		local halfDist = parentPos:Distance(furthestPos)/2 -- I think this is faster than using the math distance with the 2d vectors
		-- This determines the direction of the offset
		-- we still need to proceed in the corrected direction, otherwise there are overlappign tables
		local offX, offY = halfDist, halfDist

		if furthestPos.x < parentPos.x then
			offX = -offX
		end

		if furthestPos.y < parentPos.y then
			offY = -offY
		end

		local newCenter = parentPos + Vector(offX, offY, 0) -- By keeping both of these the same value, it'll always be somewhat square
		newTree.setPos( newCenter )

		for key, entryData in pairs(tempData) do
			determineTree( entryData, newTree )
		end

		return newTree
	end

	function public.setData( newData )
		data = newData
	end

	function public.getData( newData )
		return data
	end

	function public.clearData()
		table.Empty(data)
	end

	function public.addData( newData )
		table.insert(data, newData)
	end

	function public.removeData( oldKey )
		table.remove(data, oldKey)
	end

	function public.numEntries()
		return table.Count(data)
	end

	function public.isCluster()
		return true
	end

	return public

end