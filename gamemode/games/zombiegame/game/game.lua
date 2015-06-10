classGame = {}

classGame.games = {}
function classGame.register( class , genFunction )
	classGame.games[class] = genFunction
end

function classGame.genGame( class )
	return classGame.games[class]()
end


if SERVER then

	util.AddNetworkString( "updateGameStage" )	

	function networkGameStage( gameStage, ply )
		ply = ply or player.GetAll()
		net.Start( "updateGameStage" )
			net.WriteUInt( gameStage , 6 )
		net.Send( ply )
	end

end

if CLIENT then

	net.Receive( "updateGameStage", function(len)   
		local stage = net.ReadUInt( 6 )
		getGame().setStage(stage)
	end)	

end

function classGame.new()

	local public = {}

	local stage = 0 -- this is the current position in the game. 0 is default, you need to change this to change the modes but retain the same gamemode
	local modes = {}
	local goalManager
	local director 

	function public.setDirector(newDirector)
		director = newDirector
	end
	
	function public.getDirector()
		return director
	end

	function public.setGoalManager( newGoalManager )
		newGoalManager.initialize()
		goalManager = newGoalManager
	end

	function public.getGoalManager()
		return goalManager
	end

	function public.setStage(newStage)
		stage = newStage
		if public.getMode( stage ) != nil then
			public.getMode( stage ).initialize()
		end
		if SERVER then
			networkGameStage(stage)
		end
	end

	function public.getStage()
		return stage
	end

	function public.setMode(key, newMode)
		modes[key] = newMode
	end

	function public.getMode( key )
		key = key or stage
		return modes[key]
	end

	function public.initialize() -- run when the game is created, good for initializing variables
		local mode = public.getMode(stage)
		if mode != nil then
			mode.initialize()
		end
	end

	function public.playerSpawn(ply)
		local mode = public.getMode(stage)
		if mode != nil then
			mode.playerSpawn(ply)
		end
	end

	function public.sustain() -- this is where you check the condition, almost like a think hook
		local mode = public.getMode(stage)
		if mode != nil then
			mode.sustain()
		end
	end

	function public.npcDeath( victim, killer, weapon )
		local mode = public.getMode(stage)
		if mode != nil then
			mode.npcDeath( victim, killer, weapon )
		end
	end
	

	function public.cleanUp()
		for index, ply in pairs(player.GetAll()) do
			ply:SetNWBool("voteSkip", false)
		end
		if goalManager != nil then
			goalManager.cleanUp()
		end
	end

	if CLIENT then
		function public.paint()
			local mode = public.getMode(stage)
			if mode != nil then
				mode.paint()
			end
		end
	end

	return public

end


if SERVER then

	function gamePlayerSpawn(ply)
		if getGame() then
			getGame().playerSpawn(ply)
		end
	end
	hook.Add("PlayerSpawn", "gamePlayerSpawn", gamePlayerSpawn)

	function gameNpcDeath( npc, killer, weapon )
		if getGame() then
			getGame().npcDeath( npc, killer, weapon )
		end
	end
	hook.Add("NpcDeath", "gameNpcDeath", gameNpcDeath)

end


if CLIENT then

	function hudPaint()
		if getGame() then
			getGame().paint()
		end
	end
	hook.Add("HUDPaint", "gameHUDPaint", hudPaint)

end