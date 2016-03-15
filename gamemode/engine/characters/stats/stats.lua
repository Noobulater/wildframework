-- This class holds values in a way that you can
-- hook a function to when the value changes.
if SERVER then
	util.AddNetworkString( "networkStat" )

	function networkStat( ply, charNum, statName, statValue )
		ply = ply or player.GetAll()

		net.Start( "networkStat" )
			net.WriteUInt( charNum, 6 )	
			net.WriteString(statName)
			net.WriteString(statValue)
		net.Send( ply )	
	end
end

if CLIENT then
	net.Receive( "networkStat", function(len)   
		local charNum = net.ReadUInt( 6 )
		local char = LocalPlayer():getCharacter(charNum)
		local stats = char.getStats()

		local statName = net.ReadString()
		local statValue = net.ReadString()

		stats.setStatValue(statName, statValue)
	end)
end
classStats = {}

function classStats.new(refOwner)
	local public = {}
	local allStats = {}
	
	-- Need in referencing which character this affects (Can be used without a character just no effects, merely a table).
	local owner = refOwner
	
	-- Stats owner
	function public.setOwner(newOwner)
		owner = newOwner or nil
	end
	function public.getOwner()
		return owner
	end
	
	-- Stat Tables
	function public.getStatsTable()
		return allStats
	end

	function public.setStatTable(newStat, newValue, funcChange)
		allStats[newStat] = {value = newValue or 0, onChange = funcChange}
	end
	
	function public.getStatTable(newStat)
		return allStats[newStat]
	end

	-- Stat hooks
	function public.addStatValueHook(refStat, targetValue, funcHook)
		allStats[newStat].valueHooks = allStats[newStat].valueHooks or {}
		allStats[newStat].valueHooks[targetValue] = allStats[newStat].valueHooks[targetValue] or {}
		table.insert(allStats[newStat].valueHooks[targetValue], funcHook)
	end

	-- Stat Values / Modification
	function public.setStatValue(refStat, newValue)
		if allStats[refStat] == nil then
			allStats[refStat] = {value = nil, onChange = nil}
		end
		local statTable = allStats[refStat]
		local oldValue = statTable.value
		statTable.value = newValue or oldValue

		if type(statTable.onChange) == "function" then
			statTable.onChange(owner, newValue, oldValue)
		end
		if allStats[refStat].valueHooks and allStats[refStat].valueHooks[newValue] then
			for _, funcHook in pairs(allStats[refStat].valueHooks[newValue]) do
				if type(funcHook) == "function" then
					funcHook(owner, newValue, oldValue)
				end
			end
		end
	end
	function public.addStatValue(refStat, addValue)
		public.setStatValue(refStat, allStats[refStat].value + addValue)
	end
	
	function public.getStatValue(newStat)
		if allStats[newStat] ~= nil then
			return allStats[newStat].value
		end
	end

	-- Stat Management 
	function public.removeStatTable(refStat)
		table.remove(allStats, refStat)
	end
	
	public.setStatValue("strength", 30)
	public.setStatValue("luck", 30)
	public.setStatValue("agility", 30)
	public.setStatValue("fellowship", 30)

	return public 
end