local gameClass = "Waiting For Players"

local function createWaitMode()
	local mode = classMode.new()
	local timeToWait = 60
	mode.initialize = function()
		GAMEMODE.CanSkip = true
		if SERVER then
			for key, ply in pairs(player.GetAll()) do
				ply:SendLua("setTimer("..timeToWait..")")
			end
			mode.endTime = CurTime() + timeToWait
		end
	end

	mode.playerSpawn = function(ply)
		if SERVER then
			ply:SendLua("setTimer("..timeToWait..")")
			ply:Spectate(OBS_MODE_ROAMING)
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
			if table.Count(player.GetAll()) > 0 then
				for key, ply in pairs(player.GetAll()) do
					ply:Spectate(OBS_MODE_NONE)
				end

				local fileName = string.lower(string.gsub(GAMEMODE.Name, " ", "")) .. "/nextcfg/mode.txt"
				local content = file.Read(fileName)

				if content then
					getGameManager().setGame(content)
				else
					getGameManager().setGame("Survive")
				end
			else
				getGameManager().setGame("Waiting For Players")
			end
		end
	end

	if CLIENT then
		mode.paint = function()
			paintText("Waiting For Players", "zgEffectText", ScrW()/2, 50, Color(255,255,255,155), true, true)
		end
	end
	return mode 
end

local function generate()
	local gameData = classGame.new()

	gameData.setClass(gameClass)

	local waitMode = createWaitMode()

	gameData.setMode(0, waitMode)

	return gameData
end

classGame.register( gameClass, generate )