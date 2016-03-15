local goalClass = "lastZombie"

local function generate()
	local goal = classGoal.new()
	goal.setClass(goalClass)
	goal.setName("Executioner")
	goal.setDescription("Kill the last zombie standing, watch out for snipers")

	if SERVER then

		local winners = {}

		function goal.condition()
			if table.Count(player.GetAll()) >= 2 then 
				return true
			end
			return false
		end

		function goal.npcDeath( victim, killer, weapon )
			if table.Count(goal.getWinners() or {}) > 0 then return end
			if getGame().getStage() < 2 then return end
			if GetGlobalInt("zombiesDead") + 1 >= GetGlobalInt("killLimit") then
				if killer:IsPlayer() then
					goal.addWinner( killer )
				end
			end
		end

		function goal.cleanUp()

		end
	end

	return goal
end

classGoal.register( goalClass, generate )