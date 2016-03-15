local function digger( pos, ang )
	local npc = ents.Create("snpc_shambler")
	npc:SetPos(pos or Vector(0,0,0))
	npc:SetAngles( ang or Angle( 0, 0, 0 ) )	
    npc:SetModel("models/Zombie/fast.mdl")
    npc:setAttackAnims({"Melee"})
    npc:setAttackSpeed(1)
    npc:setRunSpeed(300)
    npc:setRunning(true)
	npc:SetHealth(60)
	npc:Spawn()

	hook.Call("NpcSpawned", GAMEMODE, npc)
	
	return npc
end
classAIDirector.addGeneric( "digger", digger )
