local function zombie( pos, ang )
	local npc = classAIDirector.newNpc()
	npc.setPos(pos)
	npc.setAngles( ang or Angle( 0, 0, 0))
	npc.setClass("npc_zombie")

	local kv = {}
	npc.setKeyValues(kv)
	npc.setHealth(30)

	world.data.addEntry(npc)
	npc.createEnt()
	return npc
end
classAIDirector.addGeneric( "zombie", zombie )