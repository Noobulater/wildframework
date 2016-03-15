
local goalClass = "lastMan"

local function generate()
	local goal = classGoal.new()
	goal.setClass(goalClass)
	goal.setName("Last Man Standing")
	goal.setDescription("The other agents need to be... eliminated. If you can manage to do this, I'll give you a reward")

	if SERVER then
		function goal.condition()
			if table.Count(player.GetAll()) > 6 then 
				return true
			end
			return false
		end

		function goal.cleanUp()
			if table.Count(util.getAlivePlayers()) then
				for index, ply in pairs(util.getAlivePlayers()) do
					if IsValid(ply) then
						goal.addWinner(ply)
					end
				end
			end
		end
	end

	return goal
end

classGoal.register( goalClass, generate )