local gameClass = "Survivor"

local function createGearUpMode()
	local mode = classMode.new()
	local timeToWait = 120
	mode.initialize = function()
		GAMEMODE.CanSkip = true
		GAMEMODE.UnlimitedAmmo = true

		if SERVER then
			local musicPath = randomPrepareMusic()
			for key, ply in pairs(player.GetAll()) do
				ply:SendLua("setTimer("..timeToWait..")")
				ply:PlayMusic(musicPath, true, true)
				ply:Spawn()	
			end
			mode.endTime = CurTime() + timeToWait

			getGame().setDirector(classDirector.new())

			timer.Simple(1, function() getDifficulty().determineGoals() end)
		end
	end

	mode.playerSpawn = function(ply)
		if SERVER then
			ply:SendLua("setTimer("..timeToWait..")")
		end
	end

	mode.sustain = function()
		if SERVER then
			if mode.endTime < CurTime() then
				mode.cleanUp()
			else
				timeToWait = math.Round(mode.endTime - CurTime())
			end
		end
	end

	mode.cleanUp = function()
		if SERVER then
			getGame().setStage(getGame().getStage() + 1)
		end
	end

	if CLIENT then
		mode.paint = function()
			paintText("Gather your Weapons", "zgEffectText", ScrW()/2, 50, Color(255,255,255,155), true, true)
			paintText("Remember Reloads are Free :D", "zgEffectText", ScrW()/2, 70, Color(255,255,255,155), true, true)
		end
	end
	return mode 
end

local function findOpenSpot(spawnsTable)
	spawnsTable = spawnsTable or ents.FindByClass("playerSpawn")
	local point = table.Random(spawnsTable)
	if IsValid(point) then
		for _,ent in pairs(ents.FindInSphere(point:GetPos(), 30)) do
			if ent:IsPlayer() then
				table.remove(spawnsTable, point)
				return findOpenSpot(spawnsTable)
			end
		end
		return point:GetPos()
	end
	print("No Safe Spawn Point Was Found")
	return false
end

local function createPrepareMode()
	local mode = classMode.new()
	local timeToWait = 120

	mode.initialize = function()
		GAMEMODE.CanSkip = true
		GAMEMODE.UnlimitedAmmo = false
		if SERVER then
			for key, ply in pairs(player.GetAll()) do
				local finalPos = findOpenSpot()
				if finalPos then
					ply:SetPos(finalPos)
				end
				ply:SetLocalVelocity(Vector(0,0,0))
				ply:SendLua("setTimer("..timeToWait..")")
			end
			mode.endTime = CurTime() + timeToWait
		end
	end

	mode.playerSpawn = function(ply)
		if SERVER then
			ply:Spectate(OBS_MODE_NONE)
			local finalPos = findOpenSpot()
			if finalPos then
				ply:SetPos(finalPos)
			end
			ply:SendLua("setTimer("..timeToWait..")")
		end
	end

	mode.sustain = function()
		if SERVER then
			if mode.endTime != nil then
				if mode.endTime < CurTime() then
					mode.cleanUp()
				else
					timeToWait = math.Round(mode.endTime - CurTime())
				end
			else
				mode.cleanUp()
			end
		end
	end

	mode.cleanUp = function()
		if SERVER then
			getGame().setStage(getGame().getStage() + 1)
		end
	end

	if CLIENT then
		mode.paint = function()
			paintText("Prepare For Battle", "zgEffectText", ScrW()/2, 50, Color(255,255,255,155), true, true)
		end
	end
	return mode 
end

local function createCombatMode()
	local mode = classMode.new()
	local noRespawns = {}

	mode.initialize = function()
		GAMEMODE.CanSkip = false
		if SERVER then
			local zombiesToKill = table.Count(player.GetAll()) * 100
			local musicPath = randomCombatMusic()

			for key, ply in pairs(player.GetAll()) do
				ply:SendLua("setTimer(0)")
				ply:PlayMusic(musicPath, true, true)
				table.insert(noRespawns, ply)
			end	

			SetGlobalInt("killLimit", zombiesToKill)			
		end
	end

	mode.playerSpawn = function(ply)
		if table.HasValue(noRespawns, ply) then
			ply:StripWeapons()
			ply:StripAmmo()
			ply:Spectate(OBS_MODE_ROAMING)
		else
			ply:Spectate(OBS_MODE_NONE)
			local finalPos = findOpenSpot()
			if finalPos then
				ply:SetPos(finalPos)
			end
		end
	end

	mode.npcDeath = function( npc, killer, weapon )
		SetGlobalInt("zombiesDead", (GetGlobalInt("zombiesDead") or 0) + 1)
	end

	mode.sustain = function()
		if SERVER then
			if getGame().getDirector() != nil then
				getGame().getDirector().think()
			end
			if (GetGlobalInt("zombiesDead") or 0) >= (GetGlobalInt("killLimit") or 1) then
				mode.cleanUp()
			end
			for index, ply in pairs(player.GetAll()) do
				if ply:GetObserverMode() == OBS_MODE_NONE then
					return
				end
			end		
			mode.cleanUp()
		end
	end

	mode.cleanUp = function()
		if SERVER then
			getGame().setStage(getGame().getStage() + 1)
		end
	end

	if CLIENT then
		mode.paint = function()
			paintText("Survive!", "zgEffectText", ScrW()/2, 25, Color(255,255,255,155), true, true)

			paintText("Zombies Killed", "zgEffectText", ScrW()/2, ScrH() * (1/10), Color(255,0,0,255), true, true)
			paintText( (GetGlobalInt("zombiesDead") or 0) .." / " .. GetGlobalInt("killLimit"), "zgEffectText", ScrW()/2, ScrH() * (1/10) + 25, Color(255,0,0,255), true, true)
		end
	end
	return mode 
end

local function createGameOverMode()
	local mode = classMode.new()
	local timeToWait = 30
	mode.initialize = function()
		if SERVER then
			getGoalManager().cleanUp()
			for key, ply in pairs(player.GetAll()) do
				ply:SendLua("setTimer("..timeToWait..")")
			end
			mode.endTime = CurTime() + timeToWait
		end
	end

	mode.playerSpawn = function(ply)
		if SERVER then
			ply:SendLua("setTimer("..timeToWait..")")
		end
	end

	mode.sustain = function()
		if SERVER then
			if mode.endTime != nil then
				if mode.endTime < CurTime() then
					mode.cleanUp()
				else
					timeToWait = math.Round(mode.endTime - CurTime())
				end
			end
		end
	end

	mode.cleanUp = function()
		if SERVER then
			for key, ply in pairs(player.GetAll()) do
				ply:Save()
			end
			timer.Simple(1, function() RunConsoleCommand("changelevel", tostring(game.GetMap())) end)
		end
	end

	if CLIENT then
		mode.paint = function()
			paintText("Reflect on How You Could've Done Better", "zgEffectText", ScrW()/2, 50, Color(255,255,255,155), true, true)
		end
	end
	return mode 
end

local function generate()
	local gameData = classGame.new()

	local gearUpMode = createGearUpMode()
	local prepareMode = createPrepareMode()
	local combatMode = createCombatMode()
	local gameOverMode = createGameOverMode()

	gameData.setMode(0, gearUpMode)
	gameData.setMode(1, prepareMode)
	gameData.setMode(2, combatMode)
	gameData.setMode(3, gameOverMode)

	function gameData.initialize() -- run when the game is created, good for initializing variables
		getGame().setGoalManager(classGoalManager.new())
		local mode = gameData.getMode(gameData.getStage())
		if mode != nil then
			mode.initialize()
		end
	end

	return gameData
end

classGame.register( gameClass, generate )