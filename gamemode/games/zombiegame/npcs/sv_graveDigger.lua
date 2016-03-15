local function graveDigger( pos, ang )
	local npc = ents.Create("snpc_graveDigger")
	npc:SetPos(pos or Vector(0,0,0))
	npc:SetAngles( ang or Angle( 0, 0, 0 ) )	
	npc:SetHealth(150)
	npc:Spawn()

	hook.Call("NpcSpawned", GAMEMODE, npc)

	return npc
end
classAIDirector.addGeneric( "graveDigger", graveDigger )
