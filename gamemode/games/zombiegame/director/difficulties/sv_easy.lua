
local difficultyClass = "easy"

local function generate()

	local difficulty = classDifficulty.new()

	difficulty.setName("Easy")

	function difficulty.determineGoals()
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
			local prizes = util.randomItems("weapon")
			local numPrizes = math.random(1,3)

			for i = 1, table.Count(prizes) - numPrizes do
				local random = table.Random(prizes)
				for index, prize in pairs(prizes) do
					if prize == random then
						table.remove(prizes, index)
						break
					end
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

	function difficulty.evaluatePlayers() -- haven't figured out how to use this yet
		local totalScore = 0
		for key, ply in pairs(player.GetAll()) do
			if util.isActivePlayer(ply) then
				totalScore = totalScore + ply:Health()

				if ply:hasEffect("infection") then
					totalScore = totalScore - 50
				end

				if ply:hasEffect("crippled") then
					totalScore = totalScore - 25
				end

				local inventory = ply:getInventory()
				if inventory == nil then break end

				for slot, itemData in pairs(inventory.getItems()) do
					if itemData != 0 then 
						if itemData.getClass() == "medvial" then 
							totalScore = totalScore + 100
						elseif itemData.getClass() == "cure" then 
							totalScore = totalScore + 50
						elseif itemData.getClass() == "automaticAmmo" then
							totalScore = totalScore + 10
						elseif itemData.getClass() == "magnumAmmo" then
							totalScore = totalScore + 10
						elseif itemData.getClass() == "pistolAmmo" then
							totalScore = totalScore + 10
						elseif itemData.getClass() == "rifleAmmo" then
							totalScore = totalScore + 10
						elseif itemData.getClass() == "shotgunAmmo" then																
							totalScore = totalScore + 10
						end
					end
				end
			else
				totalScore = totalScore - 150
			end
		end

		return totalScore
	end

	function difficulty.spawnZombie()
		if table.Count(ents.FindByClass("snpc_*")) >= 150 then return end
		if table.Count(ents.FindByClass("snpc_*")) <= 0 then 
			for index, ent in pairs(ents.FindByClass("diggerTrap")) do
				if !ent:IsBusting() then
					ent:BeginBustout()
				end
			end
		end

		local spawns = ents.FindByClass("zombieSpawn")

		local zombies = util.countAliveZombies()
		local zombiesLeft = GetGlobalInt("killLimit") - GetGlobalInt("zombiesDead")

		if zombies >= zombiesLeft then return end

		if math.random(0, 60) == 0 then
			local spawnPoint = table.Random(spawns)
			local returndPos = findClearArea( spawnPoint:GetPos() )
					
			local zombie = classAIDirector.spawnGeneric("graveDigger", returndPos )	
			return 
		end
		if math.random(0,45) == 0 then
			local positionTable = {}
			for index, ply in pairs(util.getAlivePlayers()) do
				if ply:OnGround() then
					table.insert(positionTable, ply:GetPos())
				end
			end
			local position = table.Random(positionTable)

			local trap = ents.Create("diggerTrap") 
			trap:SetPos(position) 

			local diggers = math.random(0,4)
			trap:setDiggers(math.Clamp(diggers, 0, zombiesLeft - 1)) 
			print(trap:getDiggers())
			trap:setActive(false)			
			trap:Spawn() 

			timer.Simple(60, function() trap:setActive(true) end)
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
			local returndPos = findClearArea( desiredSpawn:GetPos() )
					
			local zombie = classAIDirector.spawnGeneric("shambler", returndPos )
			zombie:setRunning(math.random(0,1))
			desiredSpawn:setNextSpawn( CurTime() + desiredSpawn:getSpawnDelay() + math.random(0,1)/10 )			
		end		
	end

	function difficulty.think()
		difficulty.spawnZombie()
	end

	function difficulty.npcSpawned(npc)
		-- THis is for me to scale health/damage and all dat shit
	end

	return difficulty

end
classDifficulty.register( difficultyClass, generate )