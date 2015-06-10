local function combineElite( pos, ang )
	local npc = classAIDirector.newNpc()
	npc.setPos(pos)
	npc.setAngles( ang or Angle( 0, 0, 0))
	npc.setClass("npc_metropolice")

	local kv = {additionalequipment = {"weapon_smg1", "weapon_stunstick"}, tacticalvariant = true}
	npc.setKeyValues(kv)
	npc.setHealth(40)

	world.data.addEntry(npc)
	npc.createEnt()
	return npc
end
classAIDirector.addGeneric( "combine_elite", combineElite )