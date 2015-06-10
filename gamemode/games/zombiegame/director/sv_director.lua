classDirector = {}

function classDirector.new()
	local public = {}

	local difficulty = classDifficulty.genDifficulty( "easy" )

	local nextThink = 0

	function public.setDifficulty( newDifficulty )
		difficulty = newDifficulty
		SetGlobalString("difficultyName", difficulty.getName())
	end

	function public.getDifficulty()
		return difficulty
	end

	function public.think() -- all the thinking is done by the difficulties
		if nextThink != nil && nextThink >= CurTime() then 
			return 
		else 
			if difficulty then
				difficulty.think()
				if difficulty.getThinkSpeed() then
					nextThink = CurTime() + difficulty.getThinkSpeed()
				end				
			end
		end
	end

	return public
end

local function directorNpcSpawned( npc )
	if getDifficulty() then
		getDifficulty().npcSpawned( npc )
	end
end
hook.Add("NpcSpawned", "directorNpcSpawned", directorNpcSpawned)