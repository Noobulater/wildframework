classRoundManager = {}

if SERVER then

	util.AddNetworkString( "updateGame" )	

	function networkGame( gameClass, ply )
		ply = ply or player.GetAll()
		net.Start( "updateGame" )
			net.WriteString( gameClass )
		net.Send( ply )
	end

end

if CLIENT then

	net.Receive( "updateGame", function(len)   
		local class = net.ReadString()
		if class != nil then
			getGameManager().setGame(class)
		end
	end)	

end

-- This class will basically hook everything that the gamemode determines
function classRoundManager.new()
	local public = {}

	local gameData -- this determines how everything works.

	function public.setGame(class)
		if gameData != nil then
			gameData.cleanUp()
		end

		gameData = classGame.genGame(class)
		gameData.initialize()

		if SERVER then
			networkGame(class)
		end
	end

	function public.getGame()
		return gameData
	end

	function public.initialize() -- this is the Initialize point
		-- always wait for players before the game starts
		-- public.setGame("Waiting For Players")
	end

	function public.sustainGame() -- this is where you check the condition, almost like a think hook
		if gameData != nil then
			gameData.sustain()
		end
	end
	
	function public.cleanUp()

	end

	return public
end

local GAME

function getGameManager()
	return GAME
end

function getGoalManager()
	if getGame() then
		if getGame().getGoalManager() != nil then
			return getGame().getGoalManager()
		end
		return false
	end
	return false
end

function getGame()
	if GAME != nil then
		if GAME.getGame() != nil then
			return GAME.getGame()
		end
		return false
	end
	return false
end

function getMode()
	if getGame() then
		if getGame().getMode() != nil then
			return getGame().getMode()
		end
		return false
	end
	return false
end

function getDirector()
	if getGame() then
		if getGame().getDirector() != nil then
			return getGame().getDirector()
		end
		return false
	end
	return false
end

function getDifficulty()
	if getDirector() then
		if getDirector().getDifficulty() != nil then
			return getDirector().getDifficulty()
		end
		return false
	end
	return false
end


function initializeHook()
	GAME = classRoundManager.new()
	GAME.initialize()
end
hook.Add("InitPostEntity", "gameInitialize", initializeHook)

function thinkHook()
	if GAME != nil then
		GAME.sustainGame()
	end
end
hook.Add("Think", "gamemodeThink", thinkHook)
