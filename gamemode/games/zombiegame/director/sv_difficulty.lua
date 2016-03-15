classDifficulty = {}

classDifficulty.difficulties = {}

function classDifficulty.getDifficulties()
	return classDifficulty.difficulties
end

function classDifficulty.getDifficultiesClass()
	local temp = {}
	for class, genFunc in pairs(classDifficulty.difficulties) do
		table.insert(temp, class)
	end
	return temp
end

function classDifficulty.register( class , genFunction )
	classDifficulty.difficulties[class] = genFunction
end

function classDifficulty.genDifficulty( class )
	if classDifficulty.difficulties[class] then
		return classDifficulty.difficulties[class]()
	else
		return nil
	end
end

function classDifficulty.new()

	local public = {}

	local zombies = {} 

	local name = "NODIFFICULTY"

	-- prizes
	local prizeModifier = 0
	local maxPrizes = 1

	-- spawn Rate
	local spawnSpeed = 0
	local spawnCheck = 0 

	-- player Evaluation 
	local strengthSpeed = 0
	local strengthCheck = 0
	local lastStrength = 1
	local curStrength = 1

	-- item changes
	local itemThreshHold = 0

	-- okay a little explanation, this 
	-- is compared to a random d100, basically u multiply
	-- threshold * itemModifier and check to see if the d100 is less than it
	local itemModifier = 100

	--  camping
	local campSpeed = 0 
	local campCheck = 0

	--  wandering
	local wanderSpeed = 0
	local wanderCheck = 0
	local wanderLastPos 
	local wanderThreshHold = 0 
	local wanderModifier = 100

	-- BOSS THRESHOLD
	-- yea i'll finish this at some point, have to think of some bosses first.

	function public.setName( newName )
		name = newName
	end

	function public.getName()
		return name
	end

	-- PRIZE MODIFIERS

	function public.setPrizeModifier( newPrizeModifier ) 
		prizeModifier = newPrizeModifier
	end

	function public.getPrizeModifier()
		return prizeModifier
	end

	function public.setMaxPrizes( newMaxPrizes )
		maxPrizes = newMaxPrizes
	end

	function public.getMaxPrizes()
		return maxPrizes
	end


	-- ZOMBIE SPAWNING 

	function public.setSpawnSpeed( newSpawnSpeed )
		spawnSpeed = newSpawnSpeed
	end

	function public.getSpawnSpeed()
		return spawnSpeed
	end

	function public.setSpawnCheck( newSpawnCheck )
		spawnCheck = newSpawnCheck
	end

	function public.getSpawnCheck()
		return spawnCheck
	end

	-- STRENGTH EVALUATION

	function public.setLastStrength( newLastStrength )
		lastStrength = newLastStrength
	end

	function public.getLastStrength( )
		return lastStrength
	end	

	function public.setCurStrength( newCurStrength )
		curStrength = newCurStrength
	end

	function public.getCurStrength( )
		return curStrength
	end	

	function public.setStrengthSpeed( newStrengthSpeed )
		strengthSpeed = newStrengthSpeed
	end

	function public.getStrengthSpeed( )
		return strengthSpeed
	end

	function public.setStrengthCheck( newStrengthCheck )
		strengthCheck = newStrengthCheck
	end

	function public.getStrengthCheck( )
		return strengthCheck
	end

	-- ITEM SPAWNING

	function public.setItemThreshHold( newItemThreshHold )
		itemThreshHold = newItemThreshHold
	end

	function public.getItemThreshHold( )
		return itemThreshHold
	end

	function public.setItemModifier( newItemModifier )
		itemModifier = newItemModifier
	end

	function public.getItemModifier( )
		return itemModifier
	end

	--

	--  CAMPER

	function public.setCampSpeed( newCampSpeed )
		campSpeed = newCampSpeed
	end

	function public.getCampSpeed( )
		return campSpeed
	end

	function public.setCampCheck( newCampCheck )
		campCheck = newCampCheck
	end

	function public.getCampCheck( )
		return campCheck
	end

	--  WANDERER

	function public.setWanderSpeed( newWanderSpeed )
		wanderSpeed = newWanderSpeed
	end

	function public.getWanderSpeed( )
		return wanderSpeed
	end

	function public.setWanderCheck( newWanderCheck )
		wanderCheck = newWanderCheck
	end

	function public.getWanderCheck( )
		return wanderCheck
	end


	function public.setLastWanderPos( newLastWanderPos )
		lastWanderPos = newLastWanderPos
	end

	function public.getLastWanderPos( )
		return lastWanderPos
	end

	function public.setWanderThreshHold( newWanderThreshHold )
		wanderThreshHold = newWanderThreshHold
	end

	function public.getWanderThreshHold( )
		return wanderThreshHold
	end

	function public.setWanderModifier( newWanderModifier )
		wanderModifier = newWanderModifier
	end

	function public.getWanderModifier( )
		return wanderModifier
	end

	--	
	--

	function public.determineGoals()
		local goalPool = {}

		for goalClass, genFunction in pairs(classGoal.getGoals()) do
			local goal = genFunction()
			if goal.condition() then
				table.insert(goalPool, goal)
			end
		end

		local goalCount = math.Clamp(table.Count(player.GetAll()), 1, 3)

		for i = 1, goalCount do
			local goal = table.Random(goalPool)
			local numPrizes = math.random(1,(maxPrizes or 1)) -- 3 random prizes. Choice is always a plus!
			local prizes = {}
			local prize 
			for i = 1, numPrizes do
				prize = classScarcity.rollItem( public.getPrizeModifier() + (goal.getPrizeModifier() or 0) ) -- modifier for easy mode
				if !table.HasValue(prizes, prize) then
					table.insert(prizes, prize)
				end
			end

			goal.setPrizes(prizes)
			getGoalManager().setGoal(goal.getClass(), goal)
			for index, goalData in pairs(goalPool) do
				if goalData == goal then
					table.remove(goalPool, index)
				end
			end
		end
	end

	function public.npcSpawned( npc )

	end

	function public.spawnZombie()
		-- This function corolates to the spawning zombies at ZSpawns
		-- it really shouldn't change much between games. What really should change 
		-- is the modifiers and things
		local spawns = ents.FindByClass("zombiespawn")
		if table.Count(spawns) > 0 then

			if math.random(0, 6 * table.Count(spawns)) == 0 then

				local zombie = classAIDirector.spawnGeneric("graveDigger")
				util.findHiddenSpot(zombie, util.getHidingTable())

				return 
			end

			local availibleSpawns = {}

			for _, zombieSpawn in pairs(spawns) do
				if IsValid(zombieSpawn) && zombieSpawn:getNextSpawn() < CurTime() then
					table.insert(availibleSpawns, zombieSpawn)
				end
			end
			local desiredSpawn = table.Random(availibleSpawns)
			local playerOrigin = util.getPlayersOrigin(util.getAlivePlayers())

			for _, zombieSpawn in pairs(availibleSpawns) do
				if playerOrigin:Distance(zombieSpawn:GetPos()) < playerOrigin:Distance(desiredSpawn:GetPos()) then
					desiredSpawn = zombieSpawn
				end
			end	

			if IsValid(desiredSpawn) then
				local returndPos = util.findClearArea(desiredSpawn:getClearArea())
				
				if math.random(0,100) < wanderModifier * wanderThreshHold then
					if math.random(0,3) == 0 then
						local trap = ents.Create("diggertrap")
						trap:SetPos(table.Random(util.getAlivePlayers()):GetPos())
						trap:setDiggers(0)
						trap:Spawn()
						trap:setActive(false)
						timer.Simple(math.random(5,20), function() if IsValid(trap) then trap:setActive(true) end end )
					else
						zombie = classAIDirector.spawnGeneric("weilder", returndPos )
						wanderThreshHold = wanderThreshHold * 0.5
					end
				else	
					zombie = classAIDirector.spawnGeneric("shambler", returndPos )
					zombie:setRunning(math.random(0,1))
				end

				desiredSpawn:setNextSpawn( CurTime() + desiredSpawn:getSpawnDelay() + math.random(0,1)/10 )	

				if math.random(0,100) < itemModifier * itemThreshHold then
					local item = classItemData.genItem( util.randomItem("item") )
					item.setTemporary(true)

					zombie:setItem(item)

					public.setItemThreshHold(itemThreshHold * 0.75)
				end		
			end	
		else
			local graveDiggers = table.Count(ents.FindByClass("snpc_gravedigger"))
			if math.random(0,table.Count(ents.FindByClass("snpc_gravedigger"))) == 0 then
				------------------------------------------------------
				--- IF THE MAP HAS NO ZPAWNS WE NEED SOME GRAVEDIGGERS
				------------------------------------------------------ 
				local zombie = classAIDirector.spawnGeneric("graveDigger")
				util.findHiddenSpot(zombie, util.getHidingTable())
			else
				local class = table.Random({"weilder", "shambler", "shambler", "shambler", "shambler", "digger"})

				local zombie = classAIDirector.spawnGeneric(class)
				util.findHiddenSpot(zombie, util.getHidingTable())

			end
		end
		return zombie
	end

	function public.think()
		-- don't bother thinking if everyone is dead 
		if table.Count(util.getAlivePlayers()) <= 0 then return end

		------------- STRENGTH UPDATER--------
		--- GIVES INFORMATION FOR ADJUSTING TACTICS
		------------------------------------
		if public.getStrengthSpeed() then
			if public.getStrengthCheck() <= CurTime() then

				public.setStrengthCheck(CurTime() + public.getStrengthSpeed()) 

				local playerCount = table.Count(util.getAlivePlayers())
				local maxStrength = 1 * playerCount
				local currentStrength = 0 

				for key, ply in pairs(util.getAlivePlayers()) do
					currentStrength = currentStrength + util.evaluatePlayer( ply )
				end

				local result = (currentStrength / maxStrength)

				public.setLastStrength(public.getCurStrength())
				public.setCurStrength(result)

				-- we do 1 - percent because we want to give items when players are weak
				public.setItemThreshHold(1 - result)
			end
		end	

		--------- WANDERER UPDATER--------
		--- ADJUST SPAWNING TO ACCOMADATE WEILDERS
		----------------------------------
		if public.getWanderSpeed() then
			if public.getWanderCheck() <= CurTime() then
				public.setWanderCheck(CurTime() + public.getWanderSpeed())

				local pos = util.getPlayersOrigin( util.getAlivePlayers() )

				if public.getLastWanderPos() then
					local distance = pos:Distance( public.getLastWanderPos() ) 
					if distance > 100 then
						public.setWanderThreshHold( math.Clamp(distance/100, 0, 1) )
					end
				end
				public.setLastWanderPos(pos)
			end
		end	

		local zombies = util.countAliveZombies()

		-- if zombies are maxed, no need to continue further ( max is 150 )
		if zombies >= 150 then return end
		-- If there are no zombies left we need to release whatever digger traps are the remaining

		if table.Count(ents.FindByClass("snpc_*")) <= 0 then 
			for index, ent in pairs(ents.FindByClass("diggertrap")) do
				ent:BeginBustout()
			end
		end

		local zombiesLeft = GetGlobalInt("killLimit") - GetGlobalInt("zombiesDead")
		if getGame().getClass() != "Survivor" then zombiesLeft = 100 end
		-- if there are more zombies, or equal to the # of zombies left for the kill count, 
		-- then we shouldn't spawn anything else

		if zombies >= zombiesLeft then return end

		if public.getSpawnSpeed() then
			if public.getSpawnCheck() <= CurTime() then
				public.setSpawnCheck(CurTime() + public.getSpawnSpeed())
				public.spawnZombie()
				-- keep the count updated throughout this function
				zombies = util.countAliveZombies()
			end
		end

		-------------------------------------------------------------------------
		--- PREVENTS AFKERS AND OR CAMPERS FROM SUCCEEDING ( with ease at least )
		-------------------------------------------------------------------------

		-- checking once again
		if zombies >= zombiesLeft then return end

		if public.getCampCheck() then
			if public.getCampCheck() <= CurTime() then
				util.antiCampUpdate()
				public.setCampCheck(CurTime() + public.getCampSpeed())
			else
				local campTbl = util.getCampTable()
				for key, ply in pairs(util.getAlivePlayers()) do
					if IsValid(ply) && campTbl[ply] && campTbl[ply].threshHold then
						if math.random(0,100) < 100 * campTbl[ply].threshHold then
							local trap = ents.Create("diggertrap")
							trap:SetPos(ply:GetPos())
							trap:setDiggers(math.Clamp(math.Round(4 * campTbl[ply].threshHold), 0, zombiesLeft-1))
							trap:Spawn()
							trap:setActive(true)
							-- reset the threshold to reduce digger spam
							campTbl[ply].threshHold = 0
							-- keep the count updated throughout this function
							zombies = util.countAliveZombies()							
							break
						end
					end
				end			
			end
		end
	end

	function public.initialize()
		util.clearCampTable()
	end

	return public

end