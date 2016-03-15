classGoal = {}
classGoal.goals = {}

function classGoal.register( class , genFunction )
	classGoal.goals[class] = genFunction
end

function classGoal.getGoals()
	return classGoal.goals
end

function classGoal.genGoal( class )
	return classGoal.goals[class]()
end

function classGoal.new()
	local public = {}

	local class
	local name
	local description
	local tracking = true
	local winners
	local prizes
	local prizeModifier
	
	function public.setClass( newClass )
		class = newClass
	end
	
	function public.getClass()
		return class
	end

	function public.setName( newName )
		name = newName
	end

	function public.getName()
		return name
	end

	function public.setDescription( newDescription )
		description = newDescription
	end

	function public.getDescription()
		return description
	end

	function public.setTracking( newTracking )
		tracking = newTracking
	end
	
	function public.getTracking()
		return tracking
	end

	function public.addWinner( newWinner )
		winners = winners or {}
		if !table.HasValue(winners, newWinner) then
			table.insert(winners, newWinner)
			if SERVER then
				networkGoalWinner( class, newWinner )
			end
		end
	end

	function public.setWinners( newWinner )
		winners = newWinner
	end

	function public.getWinners()
		return winners
	end

	function public.setPrizes( newPrizes )
		prizes = newPrizes
	end
	
	function public.getPrizes()
		return prizes
	end

	function public.setPrizeModifier( newPrizeModifier ) 
		prizeModifier = newPrizeModifier
	end

	function public.getPrizeModifier()
		return prizeModifier
	end

	function public.initialize()

	end

	function public.condition() -- Use this to give a condition to make this selectable.
		return true
	end

	function public.playerSpawn( ply )

	end
	
	function public.playerDeath( ply )

	end
	
	function public.entityTakeDamage( entity , dmginfo )

	end

	function public.npcDeath( victim, killer, weapon )

	end

	function public.itemUsed( inventory, item, usedOn )

	end
	
	function public.itemDropped( inventory, item )

	end

	function public.graveDestroyed( dmginfo )

	end

	function public.freedFromDigger( dmginfo, savedPlayer )

	end

	function public.think()

	end

	function public.cleanUp()

	end

	return public
end

