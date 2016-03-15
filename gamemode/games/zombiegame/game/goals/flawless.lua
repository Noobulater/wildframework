
local goalClass = "flawless"

local function generate()
	local goal = classGoal.new()
	goal.setClass(goalClass)
	goal.setName("Flawless Victory")
	goal.setDescription("You are all my best agents, watch each other's back and complete the mission.")

	if SERVER then
		function goal.condition()
			if table.Count(player.GetAll()) >= 6 then 
				return true
			end
			return false
		end

		function goal.cleanUp()
			for index, ply in pairs(util.getAlivePlayers()) do
				if IsValid(ply) then
					goal.addWinner(ply)
				end
			end
		end
	end

	return goal
end

classGoal.register( goalClass, generate )