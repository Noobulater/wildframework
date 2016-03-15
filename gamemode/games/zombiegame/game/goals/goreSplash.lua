local goalClass = "goreSplash"

local function generate()
	local goal = classGoal.new()
	goal.setClass(goalClass)
	goal.setName("Raining Gore")
	goal.setDescription("Kill 14 zombies with one explosion")

	if SERVER then

		local winners = {}

		function goal.condition()
			return true
		end

		function goal.npcDeath( victim, killer, weapon, dmginfo )
			if dmginfo then
				if !dmginfo:IsExplosionDamage() then
					return false
				else
					print("explosionDeaath")
				end
			end
			if killer:IsPlayer() then
				if (killer.endTime or 0) < CurTime() then
					killer.endTime = CurTime() + 1
					killer.ekills = 0
				else
					killer.ekills = (killer.ekills or 0) + 1
					if killer.ekills >= 14 then
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