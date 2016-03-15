classDirector = {}

function classDirector.new()
	local public = {}

	local active = false

	local fileName = string.lower(string.gsub(GAMEMODE.Name, " ", "")) .. "/nextcfg/difficulty.txt"
	local content = file.Read(fileName)
	if !content then content = table.Random(classDifficulty.getDifficultiesClass()) end

	local difficulty = classDifficulty.genDifficulty( content )

	local nextThink = 0

	function public.setDifficulty( newDifficulty )
		difficulty = newDifficulty
		SetGlobalString("difficultyName", difficulty.getName())
	end

	function public.getDifficulty()
		return difficulty
	end

	function public.setActive(newActive)
		active = newActive
	end

	function public.getActive()
		return active
	end

	function public.think() -- all the thinking is done by the difficulties, I REALLY SHOULD REMOVE this director
		if difficulty then
			difficulty.think()
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
