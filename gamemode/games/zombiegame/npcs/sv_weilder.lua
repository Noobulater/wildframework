local function weilder( pos, ang )
	local npc = ents.Create("snpc_weilder")
	npc:SetPos(pos or Vector(0,0,0))
	npc:SetAngles( ang or Angle( 0, 0, 0 ) )	
	npc:SetHealth(120)
	npc:Spawn()

	hook.Call("NpcSpawned", GAMEMODE, npc)

	return npc
end
classAIDirector.addGeneric( "weilder", weilder )
