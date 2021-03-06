function GM:NetworkIDValidated(strName, strSteamID)
	-- ToDo: Load the player's saves now.
end

function forceWorldUpdate( ply )
	if world != nil then
		if world.data != nil then
			world.data.updatePlayer(ply)
			return true
		end
	end
	timer.Simple(5, function() if IsValid(ply) then forceWorldUpdate(ply) end end)
	return false
end

function GM:PlayerInitialSpawn(ply)
	-- Set to a random model for now this works.
	GAMEMODE:PlayerSetModel(ply)
	GAMEMODE:SetPlayerSpeed( ply, GAMEMODE.WalkSpeed, GAMEMODE.RunSpeed )
	timer.Simple(4, function() if IsValid(ply) then ply:setupData() ply:Load() ply:loadCharacter() if table.Count(ply:getCharacters()) < 2 then ply:ConCommand("openCharacterCreation") end end end )
	timer.Simple(3, function() if IsValid(ply) then forceWorldUpdate(ply) end end)
end

function GM:PlayerSpawn(ply)
	-- ToDo: Set player health and stuff.
	--ply:SetPos(Vector(0, 0, 15))

	ply:clearEffects()

	if ply:getData() == nil then return end

	ply:loadCharacter()

	-- ToDo: Reset the paper doll, back onto the player.
end

-- Disabled for unification purposes
--function GM:PlayerLoadout(ply)
--end

function GM:PlayerDisconnected(ply)
	-- ToDo: Tell the other clients to get rid of the old paper doll.
	ply:Save()
end

function GM:DoPlayerDeath(plyVictim, plyAttacker, dmginfo)
	plyVictim.nextSpawn = CurTime() + 3
	plyVictim:CreateRagdoll()
	getPaperdollManager().clear( plyVictim )
	-- ToDo: Attach the paper doll to the rag doll.
end

function GM:PlayerDeath(plyVictim, entWeapon, plyAttacker)
	-- ToDo: Give exp, killpts, drop loot, ect.
end

function GM:PlayerSilentDeath(ply)
	-- ToDo: Not sure
end

function GM:PlayerDeathThink(ply)
	if ply.nextSpawn < CurTime() then
		ply:Spawn()
	end
	-- ToDo: NOTHING!
end

function GM:PlayerDeathSound()
	-- The death sound is terra-bad, disable it
	return true
end

function GM:GetFallDamage(ply, nSpeed)
	return GAMEMODE.FallDamage
end

function GM:OnDamagedByExplosion(ply, dmginfo)
	-- Do nothing, the ear-ringing is irritating.
	-- ply:SetDSP(35, false)
end

function GM:PlayerShouldTakeDamage(plyVictim , entAttacker)
	-- Handle this some where else.
	if !GAMEMODE.FriendlyFire then if plyVictim:IsPlayer() && entAttacker:IsPlayer() then return false end end
	return true
end

function GM:PlayerHurt(plyVictim, entAttacker, nHealthLeft, nDamage)
	-- Deprecated: do not use for anything ever.
end

function GM:ScalePlayerDamage(ply, enmHitGroup, dmginfo)
	-- ToDo: Scale damage for skills, armor, hit group, pvp, ect.
end

function GM:AllowPlayerPickup(ply, ent)
	-- Incase a player somehow gets a hold of a physgun, only admins can pick things up.
	return true
end

function GM:CanPlayerSuicide(ply)
	return true
end

function GM:CanPlayerUnfreeze(ply, ent, phyobj)
	-- Incase a player somehow gets a hold of a physgun, only admins can unfreeze things.
	return true
end

function GM:GravGunPickupAllowed(ply, ent)
	-- There is no need for this.
	return false
end

function GM:PlayerCanHearPlayersVoice(plyOne, plyTwo)
	-- Admins always all talk
	if plyOne:IsAdmin() or (GAMEMODE.VoiceEnabled and GAMEMODE.AllTalk) then
		return true
	end
	return GAMEMODE.VoiceEnabled and plyOne:GetPos():Distance(plyTwo:GetPos()) < GAMEMODE.TalkDistance, true
end

function GM:PlayerCanSeePlayersChat(strText, bTeamOnly, plyListener, plySpeaker)
	-- Admins always all talk
	if plyListener:IsAdmin() or (GAMEMODE.ChatEnabled and GAMEMODE.AllTalk) then
		return true
	end
	return GAMEMODE.ChatEnabled and plyListener:GetPos():Distance(plySpeaker:GetPos()) < GAMEMODE.TalkDistance
end

function GM:PlayerSay(ply, strText, bPublic)
	-- Add text filtering or what have you here.
	return strText
end

function GM:PlayerCanJoinTeam(ply)
	-- There shouldn't be any team changing, but just in case, only have admins be able to.
    return true
end

function GM:PlayerCanPickupItem(ply, entItem)
	-- No need for default picking up.
	return true
end
function GM:PlayerCanPickupWeapon(ply, wepWeapon)
	-- No need for default picking up.
	return true
end

function GM:PlayerShouldAct(ply, strActName, nActID)
	-- Everyone should be able to do acts.
	return true	
end

function GM:PlayerSpray(ply)
	-- No one can spray
	return false
end

function GM:PlayerSwitchFlashlight(ply, bToggle)
	-- Only admins can use the flashlight.
	return (true or GAMEMODE.Flashlight) or not bToggle
end

function GM:PlayerUse( ply, entity )
	if !util.isActivePlayer(ply) then return false end
	if (ply.useCD or 0) >= CurTime() then return false end

	ply.useCD = CurTime() + 0.3

	if entity.useFunc != nil && (entity.cd or 0) < CurTime() then
		entity.useFunc(ply, entity)
		entity.cd = CurTime() + 1
	end
	if entity:GetClass() == "prop_door_rotating" && (entity.cd or 0) < CurTime() then
		entity:Fire("toggle", "", 0)-- OpenAwayFrom
		entity.cd = CurTime() + 1
		return false
	end

	return true
end

function GM:ShowHelp(ply)
	-- F1 was pressed
end
function GM:ShowTeam(ply)
	-- F2 was pressed
end
function GM:ShowSpare1(ply)
	-- F3 was pressed
end
function GM:ShowSpare2(ply)
	-- F4 was pressed
end