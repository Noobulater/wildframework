classTime = {}

function classTime.new()
	local public = {}

	local currentTime = 0
	local dayLength = 260 -- Time scales [seconds]
	local delay = 1.0 -- thinks once per second
	local nextThink = 0 -- nextTime to think at
	local paused  -- stops thinking

	function public.setCurrentTime(newTime)
		if newTime < 1 then 
			currentTime = dayLength * newTime
		else
			currentTime = math.Clamp(newTime, 0, dayLength)
		end
	end

	function public.getCurrentTime()
		return currentTime
	end

	function public.setDayLength(newLength)
		dayLength = newLength
	end

	function public.getDayLength()
		return dayLength
	end

	function public.getDayProgress()
		return paused or ((CurTime() / dayLength) % 1) -- currentTime / dayLength
	end

	function public.pauseAt(newTime)
		public.setCurrentTime(newTime)
		paused = (currentTime / dayLength)
	end

	function public.pause()
		paused = ((CurTime() / dayLength) % 1)
	end
	
	function public.unPause() 
		paused = nil
	end

	return public
end