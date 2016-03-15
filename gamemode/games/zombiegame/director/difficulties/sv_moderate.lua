
local difficultyClass = "Moderate"

local function generate()

	local difficulty = classDifficulty.new()

	difficulty.setName("Moderate")

	function difficulty.npcSpawned(npc)
		-- This is for me to scale health/damage and all dat shit
		npc:setAttackSpeed( npc:getAttackSpeed() * 1.5 )
	end

	function difficulty.initialize()
		difficulty.startTime = CurTime()
		
		difficulty.setCampSpeed( 30 ) -- checks camping every 30 seconds 
		difficulty.setWanderSpeed( 15 )	-- checks wandering every 15
		difficulty.setWanderModifier( 40 ) -- Reliable
		difficulty.setItemModifier( 80 ) -- Items become slightly rarer
		difficulty.setStrengthSpeed( 60 ) -- updates strength every 60

		difficulty.setPrizeModifier(0.15)
		difficulty.setMaxPrizes(1)

		difficulty.setSpawnSpeed(0.9) -- Increase the spawn rate a bit
	end 

	return difficulty

end
classDifficulty.register( difficultyClass, generate )