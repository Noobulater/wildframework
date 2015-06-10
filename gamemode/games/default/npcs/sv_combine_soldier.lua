local function combineSoldier( pos, ang )
	local npc = classAIDirector.newNpc()
	npc.setPos(pos)
	npc.setAngles( ang or Angle( 0, 0, 0))
	npc.setClass("npc_combine_s")

	local kv = {additionalequipment = {"weapon_shotgun", "weapon_smg1", "weapon_ar2"}, NumGrenades = {min = 0, max = 1}, tacticalvariant = true}
	npc.setKeyValues(kv)
	npc.setHealth(30)

	world.data.addEntry(npc)
	npc.createEnt()
	return npc
end
classAIDirector.addGeneric( "combine_s", combineSoldier )
