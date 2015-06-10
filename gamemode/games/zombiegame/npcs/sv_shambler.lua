local function shambler( pos, ang )
	local npc = ents.Create("snpc_shambler")
	npc:SetPos(pos)
	npc:SetAngles( ang or Angle( 0, 0, 0) )	

    local ZombieModels = {
        "models/nmr_zombie/berny.mdl",
        "models/nmr_zombie/casual_02.mdl",
        "models/nmr_zombie/herby.mdl",
        "models/nmr_zombie/jogger.mdl",
        "models/nmr_zombie/julie.mdl",
        "models/nmr_zombie/toby.mdl",
    }
   	npc:SetModel(table.Random(ZombieModels))

	npc:SetHealth(20)
	npc:Spawn()

    hook.Call("NpcSpawned", GAMEMODE, npc)
    
	return npc
end
classAIDirector.addGeneric( "shambler", shambler )