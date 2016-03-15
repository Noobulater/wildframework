local goalClass = "golaith"

local function generate()
	local goal = classGoal.new()
	goal.setClass(goalClass)
	goal.setName("Anomaly")
	goal.setDescription("There has been a recorded anomaly in this area, take extra precautions...")

	if SERVER then
		function goal.condition()
			local map = tostring(game.GetMap()) 
			if map == "impurity_fortress_001" then
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

		function goal.initialize()
			timer.Simple(math.random(200, 400), function() 
				local golaith = ents.Create("snpc_golaith") 
				golaith:SetPos(Vector(494, -2087, -3))
				golaith:Spawn()
			end)
		end

	end

	return goal
end

classGoal.register( goalClass, generate )