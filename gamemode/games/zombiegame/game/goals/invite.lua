
local goalClass = "invite"

local function generate()
	local goal = classGoal.new()
	goal.setClass(goalClass)
	goal.setName("Invite another Player!")
	goal.setDescription("Your job is to get another player in this server! Do so and you will be rewarded!")

	if SERVER then
		local originalCount
		local originalPlayers
		function goal.initialize()
			originalCount = table.Count(player.GetAll())
			originalPlayers = player.GetAll()
		end

		function goal.condition()
			if table.Count(player.GetAll()) <= 2 then 
				return true
			end
			return false
		end

		function goal.cleanUp()
			if table.Count(player.GetAll()) > originalCount then
				for index, ply in pairs(originalPlayers) do
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