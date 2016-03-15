
local goalClass = "gravekiller"

local function generate()
	local goal = classGoal.new()
	goal.setClass(goalClass)
	goal.setName("Death deserves only death!")
	goal.setDescription("Destroy the most amount of graves placed by the zombies! Killing the zombies with the graves counts double!")

	if SERVER then
		function goal.condition()
			if table.Count(player.GetAll()) > 3 then 
				return true
			end
			return false
		end

		function goal.graveDestroyed( dmginfo )
			local attacker = dmginfo:GetAttacker()
			if IsValid(attacker) then
				if attacker:IsPlayer() then
					attacker.gravesDestroyed = (attacker.gravesDestroyed or 0) + 1
				end
			end
		end

		function goal.npcDeath( victim, killer, weapon )
			if IsValid(killer) && string.lower(victim:GetClass()) == "snpc_gravedigger" then
				if killer:IsPlayer() then
					killer.gravesDestroyed = (killer.gravesDestroyed or 0) + 2
				end
			end
		end

		function goal.cleanUp()
			local leadingCount = 1
			for index, ply in pairs(player.GetAll()) do 
				if (ply.gravesDestroyed or 0) > leadingCount then
					leadingCount = ply.gravesDestroyed
				end
			end
			local winners = {}
			for index, ply in pairs(player.GetAll()) do 
				if (ply.gravesDestroyed or 0) >= leadingCount then
					table.insert(winners, ply)
				end
			end
			for index, ply in pairs(winners) do
				if IsValid(ply) then
					goal.addWinner(ply)
				end
			end
		end
	end

	return goal
end

classGoal.register( goalClass, generate )