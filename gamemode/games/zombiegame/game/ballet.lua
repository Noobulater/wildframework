classBallet = {}

if SERVER then

	util.AddNetworkString( "updateBallet" )	

	function networkBallet( key, map, mode, difficulty, ply )
		ply = ply or player.GetAll()
		net.Start( "updateBallet" )
			net.WriteUInt( key , 6 )
			net.WriteString( map )
			net.WriteString( mode )
			net.WriteString( difficulty )
		net.Send( ply )
	end

end

if CLIENT then

	net.Receive( "updateBallet", function(len)   
		local key = net.ReadUInt(6)
		local map = net.ReadString()
		local mode = net.ReadString()
		local difficulty = net.ReadString()

		getBallet().setBallet(key, map, mode, difficulty)
	end)	

end

function classBallet.new()
	local public = {}

	local ballet = {}
	if SERVER then
		function public.genMapList()
			local temp = {}
			for mapName, exceptions in pairs(getMapList()) do
				if game.GetMap() != mapName then
					local insertValue = {map = mapName, mode = "Survive"}
					for i = 1, table.Count(classDifficulty.getDifficultiesClass()) do	
						insertValue.difficulty = classDifficulty.getDifficultiesClass()[i]
						table.insert(temp, table.Copy(insertValue))
					end
					
					for key, modeName in pairs(exceptions.modes or {}) do
						insertValue =  {map = mapName, mode = modeName}
						for i = 1, table.Count(classDifficulty.getDifficultiesClass()) do	
							insertValue.difficulty = classDifficulty.getDifficultiesClass()[i]
							table.insert(temp, table.Copy(insertValue))
						end
					end
				end
			end

			for i = 1, 3 do 
				local selection = table.Random(temp)
				table.RemoveByValue(temp, selection)
				public.setBallet( i, selection.map, selection.mode, selection.difficulty )
			end
			
		end
	end

	function public.setBallet( key, mapName, modeName, difficultyName )
		ballet[key] = {map = mapName, mode = modeName, difficulty = difficultyName}
		if SERVER then
			networkBallet( key, mapName, modeName, difficultyName )
		end
	end

	function public.getBallet()
		return ballet
	end

	function public.castVote( ply, vote )
		if !ballet[vote].votes then
			ballet[vote].votes = {}
		end
		table.insert(ballet[vote].votes, ply)
	end

	function public.decideVoting()
		local leadVotes = 0
		local leadingKey  
		PrintTable(ballet)
		for key, data in pairs(ballet) do
			if table.Count(data.votes or {}) > leadVotes then
				leadVotes = table.Count(data.votes)
				leadingKey = key
			end
		end	
		for key, data in pairs(ballet) do
			if table.Count(data.votes or {}) < leadVotes then
				table.RemoveByValue(ballet, data)
			end
		end

		local winner = table.Random(ballet)

		local directory = string.lower(string.gsub(GAMEMODE.Name, " ", "")) .. "/nextcfg/"

		if !file.Exists( directory , "DATA" ) then
			file.CreateDir(directory)
		end
		file.Write(directory.."difficulty.txt", winner.difficulty)
		file.Write(directory.."mode.txt", winner.mode)
		file.Write(directory.."nextmap.txt", winner.map)
	end


	return public
end

local votingManager = classBallet.new()

function getBallet()
	return votingManager
end

concommand.Add("balletVote", function( ply, cmd, args ) local key = math.Round(tonumber(args[1])) getBallet().castVote(ply, key) end )