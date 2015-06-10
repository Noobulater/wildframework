local event = classEvent.new()

event.initialize = function( ply )
	-- local Bosses = {}
	
	-- Bosses[1] = {}
	-- Bosses[1].Class = "npc_hunter"
	-- Bosses[1].Number = math.random(1, 1)
	-- Bosses[1].MinionsNumber = math.random(1, 3)
	-- Bosses[1].HealthFactor = 1.1 --Tad too easy make it harder
	-- Bosses[1].Minions = {}
	-- --Bosses[2].Minions[1] = {Class = "npc_hunter"}
	-- Bosses[1].Minions[1] = {Class = "npc_combine_s",
	-- 	KeyValues = {additionalequipment = {"weapon_ar2", "weapon_smg1"}, NumGrenades = {Min = 0, Max = 1}, tacticalvariant = {true}}}
	-- Bosses[1].Minions[2] = {Class = "npc_combine_s",
	-- 	Skins = {1}, KeyValues = {additionalequipment = {"weapon_shotgun"}, NumGrenades = {Min = 0, Max = 1}, tacticalvariant = {true}}}
	-- Bosses[1].Minions[2] = {Class = "npc_manhack"}
	
	-- local Selection = table.Random(Bosses) 
	-- for i = 1, Selection.Number do
	-- 	-- strClass, strSquadName, intHealthFctr, strMat, tblSkins, tblKeyValues
	-- 	-- Selection.Class, Selection.Class .. CurTime(), Selection.HealthFactor, Selection.Mat, Selection.Skins, Selection.KeyValues
	-- 	local boss = classAIDirector.newNpc()
	-- 	boss.setPos(util.randRadius(ply:GetPos() + Vector(0, 0, 10), 500, 750))
	-- 	boss.setClass(Selection.Class)
	-- 	boss.setSkin()
	-- 	boss.createEnt()
	-- 	for i = 1, Selection.MinionsNumber do
	-- 		local tblMinion = table.Random(Selection.Minions)
	-- 		local npc = CreateCustomNPC(tblMinion.Class, Selection.Class .. CurTime(), tblMinion.HealthFactor, tblMinion.Mat, tblMinion.Skins, tblMinion.KeyValues)
	-- 		npc:SetPos(util.randRadius(boss:GetPos() + Vector(0, 0, 10), 75, 150))
	-- 		npc:Spawn()
	-- 		npc:Activate()
	-- 	end
	-- end
	-- strClass, strSquadName, intHealthFctr, strMat, tblSkins, tblKeyValues
	-- Selection.Class, Selection.Class .. CurTime(), Selection.HealthFactor, Selection.Mat, Selection.Skins, Selection.KeyValues
	local class = table.Random({"rebel", "combine_s", "metroPolice", "combine_elite"})
	local pos = util.randRadius(ply:GetPos() + Vector(0, 0, 10), 600, 700)
	local npc = classAIDirector.spawnGeneric( class, pos )
	local npcEnt = npc.getEnt()

	timer.Simple(1, function()  
		if IsValid(npcEnt) then
			local normal = (ply:GetPos() - npcEnt:GetPos()):GetNormal()
			normal.z = 0
			npcEnt:SetLastPosition(npcEnt:GetPos() + normal * 250 + Vector(0,0,5))
			npcEnt:SetSchedule(SCHED_FORCED_GO_RUN)
			npcEnt:AddRelationship("player D_HT 999")
		end
	end)

	local pos1 = util.randRadius(pos, 50, 150)
	local npc = classAIDirector.spawnGeneric( class, pos1 )
	local npcEnt = npc.getEnt()

	timer.Simple(1, function()  
		if IsValid(npcEnt) then
			local normal = (ply:GetPos() - npcEnt:GetPos()):GetNormal()
			normal.z = 0
			npcEnt:SetLastPosition(npcEnt:GetPos() +  normal * 250  + Vector(0,0,5))
			npcEnt:SetSchedule(SCHED_FORCED_GO_RUN)
			npcEnt:AddRelationship("player D_HT 999")
		end
	end)

	local pos2 = util.randRadius(pos, 50, 150)
	local npc = classAIDirector.spawnGeneric( class, pos2 )
	local npcEnt = npc.getEnt()

	timer.Simple(1, function()  
		if IsValid(npcEnt) then
			local normal = (ply:GetPos() - npcEnt:GetPos()):GetNormal()
			normal.z = 0
			npcEnt:SetLastPosition(npcEnt:GetPos() +  normal * 250  + Vector(0,0,5))
			npcEnt:SetSchedule(SCHED_FORCED_GO_RUN)
			npcEnt:AddRelationship("player D_HT 999")
		end
	end)

end
classEvent.add( "randomEncounter" , event )

concommand.Add("commandNPC", function(ply, cmd, args)
	for _, npcEnt in pairs(ents.FindByClass("npc_*")) do
		local normal = (ply:GetPos() - npcEnt:GetPos()):GetNormal()
		normal.z = 0
		npcEnt:SetLastPosition(npcEnt:GetPos() +  normal * 250  + Vector(0,0,5))
		npcEnt:SetSchedule(SCHED_FORCED_GO_RUN)
	end
 end)