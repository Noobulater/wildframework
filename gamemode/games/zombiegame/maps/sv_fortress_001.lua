local map = "impurity_fortress_001"

local function generate()
	local count = 0
	for _, ent in pairs(ents.FindByClass("zombiespawn")) do
		if IsValid(ent) && count < 2 then
			ent:Remove()
			count = count + 1
		end
	end

	timer.Simple(3, function() 
		local spawnPoint = table.Random(ents.FindByClass("info_player_start"))

		local hiding = navmesh.Find( spawnPoint:GetPos(), 1000000, 500000, 500000)
		local hidingTable = {}

		for _, data in pairs(hiding) do 
			if data:GetHidingSpots() then
				for key, vector in pairs(data:GetHidingSpots()) do
					if spawnPoint:GetPos():Distance(vector) > 1000 then
						table.insert(hidingTable, vector)
					end
				end
			end
			if data:GetExposedSpots() then
				for key, vector in pairs(data:GetExposedSpots()) do
					if spawnPoint:GetPos():Distance(vector) > 1000 then
						table.insert(hidingTable, vector)
					end
				end
			end
		end

		for i = 1, math.random(30,50) do
			if table.Count(hidingTable) > 0 then
				local spot = util.findClearArea(table.Random(hidingTable))
				local zombie = classAIDirector.spawnGeneric("shambler")
				zombie:setRunning(math.random(0,1))
				zombie:SetPos(spot + Vector(0,0,5))
				table.RemoveByValue(hiding, spot)
			end
		end
	end)

end
world.registerMap( map, generate )

