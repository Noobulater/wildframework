local goalClass = "lastZombie"

local function generate()
	local goal = classGoal.new()
	goal.setClass(goalClass)
	goal.setName("My Hero!")
	goal.setDescription("Save another player from the clutches of burrowed zombies! And only do it because you want to help them, not because you will get a prize.")

	if SERVER then

		local winners = {}

		function goal.condition()
			if table.Count(player.GetAll()) >= 2 then 
				return true
			end
			return false
		end

		function goal.freedFromDigger(dmginfo, savedPlayer)
			local savior = dmginfo:GetAttacker()
			if IsValid(savior) && savior:IsPlayer() then
				if !table.HasValue(winners, savior) then
					table.insert(winners, savior)
				end
			end
		end

		function goal.cleanUp()
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