classRenderTree = {}

function classRenderTree.new( numBranches )

	numBranches = numBranches or 2

	local public = {}

	local branches = {}

	local pos = Vector( 0, 0, 0)

	function public.setPos( newPos )
		pos = newPos
	end
	
	function public.getPos()
		return pos
	end

	function public.getBranches()
		return branches
	end

	function public.addBranch( newBranchData ) 
		newBranchData = newBranchData or classRenderCluster.new()

		table.insert(branches, newBranchData)

		return newBranchData
	end

	function public.updateBranch( key, newBranchData)
		branches[key] = newBranchData
	end

	function public.removeBranch( oldKey )
		table.remove(branches, oldKey)
	end
	
	function public.isCluster()
		return false
	end

	for i = 1, numBranches do
		public.addBranch()
	end

	return public

end