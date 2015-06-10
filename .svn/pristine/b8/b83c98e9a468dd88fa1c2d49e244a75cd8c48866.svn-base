local map = "wild_acrophobia_005"

local function generate()
	world.time.pauseAt( 0.02 )

	local moveTowards = function( npcEnt )
		timer.Simple(1, function() 
		local ply = player.GetAll()[1]
		if IsValid(npcEnt) then
			local normal = (ply:GetPos() - npcEnt:GetPos()):GetNormal()
			normal.z = 0
			npcEnt:SetLastPosition(npcEnt:GetPos() + normal * 250 + Vector(0,0,5))
			npcEnt:SetSchedule(SCHED_FORCED_GO_RUN)
			npcEnt:AddRelationship("player D_HT 999")
		end
		end)
	end

	-- timer.Create("zombie1", 7, 0, function() local zamb = classAIDirector.spawnGeneric("shambler", Vector(1360,1283,165) ) zamb:setRunning(table.Random({false, true}))  end )
	-- timer.Create("zombie2", 8, 0, function() local zamb = classAIDirector.spawnGeneric("shambler", Vector(1284,-1196,165) ) zamb:setRunning(table.Random({false, true})) end )
	-- timer.Create("zombie3", 9, 0, function() local zamb = classAIDirector.spawnGeneric("shambler", Vector(-1306,-1298,165) ) zamb:setRunning(table.Random({false, true})) end )
	-- timer.Create("zombie4", 10, 0, function() local zamb = classAIDirector.spawnGeneric("shambler", Vector(-1296,1289,165) ) zamb:setRunning(table.Random({false, true})) end )
end
world.registerMap( map, generate )

concommand.Add("createHell", 
function() 
	timer.Create("zombie1", 7, 0, function() local zamb = classAIDirector.spawnGeneric("shambler", Vector(1360,1283,165) ) zamb:setRunning(table.Random({false, true}))  end )
	timer.Create("zombie2", 8, 0, function() local zamb = classAIDirector.spawnGeneric("shambler", Vector(1284,-1196,165) ) zamb:setRunning(table.Random({false, true})) end )
	timer.Create("zombie3", 9, 0, function() local zamb = classAIDirector.spawnGeneric("shambler", Vector(-1306,-1298,165) ) zamb:setRunning(table.Random({false, true})) end )
	timer.Create("zombie4", 10, 0, function() local zamb = classAIDirector.spawnGeneric("shambler", Vector(-1296,1289,165) ) zamb:setRunning(table.Random({false, true})) end )
	timer.Stop("zombie1")
	timer.Stop("zombie2")
	timer.Stop("zombie3")
	timer.Stop("zombie4")	
end	)

concommand.Add("unleashHell", function() 
	timer.Start("zombie1")
	timer.Start("zombie2")
	timer.Start("zombie3")
	timer.Start("zombie4")	
end	)

concommand.Add("leashHell", function() 
	timer.Stop("zombie1")
	timer.Stop("zombie2")
	timer.Stop("zombie3")
	timer.Stop("zombie4")	
end)