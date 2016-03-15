
local difficultyClass = "Easy"

local function generate()

	local difficulty = classDifficulty.new()

	difficulty.setName("Easy")

	function difficulty.npcSpawned(npc)
		-- This is for me to scale health/damage and all dat shit
		-- I refuse to scale health/damage on easy difficulty
	end

	function difficulty.initialize()
		difficulty.startTime = CurTime()
		
		difficulty.setCampSpeed( 45 ) -- checks camping every 45 seconds 
		difficulty.setWanderSpeed( 15 )	-- checks wandering every 15
		difficulty.setWanderModifier( 20 ) -- extremely Rare
		difficulty.setStrengthSpeed( 60 ) -- updates strength every 60

		difficulty.setSpawnSpeed(1) -- one zombie a second
		difficulty.setPrizeModifier(0.35) --
		difficulty.setMaxPrizes(1) -- 
	end 

	return difficulty

end
classDifficulty.register( difficultyClass, generate )