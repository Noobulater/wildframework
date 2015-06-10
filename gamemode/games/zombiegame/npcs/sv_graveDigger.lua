local function graveDigger( pos, ang )
	local npc = ents.Create("snpc_graveDigger")
	npc:SetPos(pos)
	npc:SetAngles( ang or Angle( 0, 0, 0) )	
	npc:SetHealth(100)
	npc:Spawn()

	hook.Call("NpcSpawned", GAMEMODE, npc)

	return npc
end
classAIDirector.addGeneric( "graveDigger", graveDigger )
