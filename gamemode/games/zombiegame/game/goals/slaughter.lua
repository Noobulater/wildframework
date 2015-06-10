local goalClass = "slaughter"

local function generate()
	local goal = classGoal.new()
	goal.setClass(goalClass)
	goal.setName("Stream of Lead")
	goal.setDescription("Kill 30 zombies in one minute without using explosives.")

	if SERVER then

		local winners = {}

		function goal.condition()
			return true
		end

		function goal.npcDeath( victim, killer, weapon, dmginfo )
			if dmginfo then
				if dmginfo:IsExplosionDamage() then
					return false
				end
			end
			if killer:IsPlayer() then
				if (killer.endTime or 0) < CurTime() then
					killer.endTime = CurTime() + 60
					killer.kills = 0
				else
					killer.kills = (killer.kills or 0) + 1
					if killer.kills >= 30 then
						goal.addWinner(killer)
						return 
					end
				end
			end
		end

		function goal.cleanUp()

		end
	end

	return goal
end

classGoal.register( goalClass, generate )