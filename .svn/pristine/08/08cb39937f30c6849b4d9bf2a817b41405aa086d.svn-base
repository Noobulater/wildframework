-- This class holds values in a way that you can
-- hook a function to when the value changes.
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
	
	return public 
end