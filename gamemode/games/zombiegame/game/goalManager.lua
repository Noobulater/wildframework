classGoalManager = {}
if SERVER then
	util.AddNetworkString( "networkGoal" )
	util.AddNetworkString( "networkGoalWinner" )

	function networkGoal( goalKey )
		if !getGoalManager() then return end
		local ply = ply or player.GetAll()

		local prizes = getGoalManager().getGoal(goalKey).getPrizes() or {}

		local prizeString = ""
		for key, prize in pairs(prizes) do
			prizeString = prizeString .. prize .. "|"
		end
		net.Start( "networkGoal" )
			net.WriteString( goalKey )
			net.WriteString( prizeString )
		net.Send( ply )	
	end

	function networkGoalWinner( goalKey, winner )
		if !getGoalManager() then return end

		local ply = ply or player.GetAll()
		net.Start( "networkGoalWinner" )
			net.WriteString( goalKey )
			net.WriteEntity( winner )
		net.Send( ply )	
	end

end
if CLIENT then

	net.Receive( "networkGoal", function(len)   
		local goalName = net.ReadString()
		local prizeString = net.ReadString()
		local manager 

		if !getGoalManager() then
			getGame().setGoalManager( classGoalManager.new() ) 
		end

	 	manager = getGoalManager()
	 	if manager.getGoal(goalName) == nil then 
	 		manager.addGoal(goalName)
	 	end
	 	if prizeString == "" then return end

	 	prizeString = string.sub(prizeString, 0, string.len(prizeString) - 1 )
	 	manager.getGoal(goalName).setPrizes(string.Explode("|", prizeString))

	end)

	net.Receive( "networkGoalWinner", function(len)   
		local goalName = net.ReadString()
		local ply = net.ReadEntity()
		local manager 

		if !getGoalManager() then
			getGame().setGoalManager( classGoalManager.new() ) 
		end

	 	manager = getGoalManager()
	 	if manager.getGoal(goalName) == nil then 
	 		manager.addGoal(goalName)
	 	end
	 	manager.getGoal(goalName).addWinner( ply )

	end)

end

function classGoalManager.new()
	local public = {}

	local goalList = {}

	function public.addGoal(key)
		local goal = classGoal.genGoal(key)
		goal.initialize()
		public.setGoal(key, goal)
	end

	function public.setGoal(key, newGoal)
		goalList[key] = newGoal
		newGoal.initialize()
		if SERVER then
			networkGoal( key )
		end		
	end

	function public.getGoal(key)
		return goalList[key]
	end

	function public.getGoal(key)
		return goalList[key]
	end

	function public.getGoals()
		return goalList
	end

	function public.removeGoal(key)
		table.remove(goalList, key)
	end

	function public.initialize()

	end

	function public.playerSpawn( ply )
		for key, goal in pairs(goalList) do
			if goal.getTracking() then
				goal.playerSpawn(ply)
			end
		end
	end
	
	function public.playerDeath( ply )
		for key, goal in pairs(goalList) do
			if goal.getTracking() then
				goal.playerDeath(ply)
			end
		end
	end
	
	function public.entityTakeDamage( entity , dmginfo )
		for key, goal in pairs(goalList) do
			if goal.getTracking() then
				goal.entityTakeDamage( entity , dmginfo )
			end
		end
	end

	function public.npcDeath( victim, killer, weapon )
		for key, goal in pairs(goalList) do
			if goal.getTracking() then
				goal.npcDeath( victim, killer, weapon )
			end
		end
	end

	function public.itemUsed( inventory, item, usedOn )
		for key, goal in pairs(goalList) do
			if goal.getTracking() then
				goal.itemUsed( inventory, item, usedOn )
			end
		end
	end
	
	function public.itemDropped( inventory, item )
		for key, goal in pairs(goalList) do
			if goal.getTracking() then
				goal.itemDropped( inventory, item )
			end
		end
	end

	function public.graveDestroyed( dmginfo )
		for key, goal in pairs(goalList) do
			if goal.getTracking() then
				goal.graveDestroyed( dmginfo )
			end
		end
	end

	function public.freedFromDigger( dmginfo, savedPlayer )
		for key, goal in pairs(goalList) do
			if goal.getTracking() then
				goal.freedFromDigger( dmginfo )
			end
		end
	end

	function public.think()
		for key, goal in pairs(goalList) do
			if goal.getTracking() then
				goal.think()
			end
		end
	end

	function public.cleanUp()
		for key, goal in pairs(goalList) do
			goal.cleanUp()
			for index, ply in pairs(goal.getWinners() or {}) do
				ply:ConCommand("showGoals")
			end
		end
	end

	return public
end

if SERVER then

	function goalPlayerSpawn(ply)
		if getGoalManager() then
			getGoalManager().playerSpawn(ply)
		end
	end
	hook.Add("PlayerSpawn", "goalPlayerSpawn", goalPlayerSpawn)

	function goalPlayerDeath(ply)
		if getGoalManager() then
			getGoalManager().playerDeath(ply)
		end
	end
	hook.Add("PlayerDeath", "goalPlayerDeath", goalPlayerDeath)

	function goalEntityTakeDamage( ent, dmginfo )
		if getGoalManager() then
			getGoalManager().entityTakeDamage( ent, dmginfo )
		end
	end
	hook.Add("EntityTakeDamage", "goalEntityTakeDamage", goalEntityTakeDamage)

	function goalNpcDeath( victim, killer, weapon )
		if getGoalManager() then
			getGoalManager().npcDeath( victim, killer, weapon )
		end
	end
	hook.Add("NpcDeath", "goalNpcDeath", goalNpcDeath)

	function goalItemUsed( inventory, item, usedOn )
		if getGoalManager() then
			getGoalManager().itemUsed( victim, killer, weapon )
		end
	end
	hook.Add("ItemUsed", "goalItemUsed", goalItemUsed)

	function goalItemDropped( inventory, item )
		if getGoalManager() then
			getGoalManager().itemDropped( victim, killer, weapon )
		end
	end
	hook.Add("ItemDropped", "goalItemDropped", goalItemDropped)

	function goalGraveDestroyed( dmginfo )
		if getGoalManager() then
			getGoalManager().graveDestroyed( dmginfo )
		end
	end
	hook.Add("GraveDestroyed", "goalGraveDestroyed", goalGraveDestroyed)

	function goalFreedFromDigger( dmginfo, savedPlayer )
		if getGoalManager() then
			getGoalManager().freedFromDigger( dmginfo, savedPlayer )
		end
	end
	hook.Add("FreedFromDigger", "goalFreedFromDigger", goalFreedFromDigger)

	function goalThink()
		if getGoalManager() then
			getGoalManager().think()
		end
	end
	hook.Add("Think", "goalThink", goalThink)

end