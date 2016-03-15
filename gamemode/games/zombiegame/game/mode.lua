classMode = {}

function classMode.new()

	local public = {}
	
	local startTime = 0 
	function public.setStartTime(newStartTime)
		startTime = newStartTime
	end

	function public.getStartTime()
		return startTime
	end

	function public.initialize() -- run when the mode is created, good for initializing variables
		
	end

	function public.playerSpawn(ply)

	end

	function public.npcDeath( npc, killer, weapon )

	end
	
	function public.sustain() -- this is where you check the condition, almost like a think hook

	end

	function public.cleanUp()

	end

	if CLIENT then
		function public.paint()
			
		end
	end

	return public

end
