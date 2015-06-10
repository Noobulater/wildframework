classLighting = {}

local lightProgress = string.ToTable("abcdefghijklmnopqrstuvwxyz")

function classLighting.new()
	local public = {}

	local entity = ents.FindByClass("light_environment")[1] or nil

	if !entity then print("This map doesn't support Day/Night cylces") return false end -- the map doesn't support day/night

	local brightness = 1
	local lastbrightness = 1

	function public.setEntity(newEntity)
		entity = newEntity
	end

	function public.getEntity()
		return entity
	end

	function public.setBrightness(newBrightness)
		if newBrightness < 1 then
			brightness = math.Round(25 * newBrightness) + 1
		else
			brightness = newBrightness
		end
		public.adjustLight()
	end

	function public.getBrightness()
		return brightness
	end

	function public.darken()
		public.setBrightness( math.Clamp(brightness - 1, 0, 26) )
	end

	function public.brighten()
		public.setBrightness( math.Clamp(brightness + 1, 0, 26) )
	end

	function public.adjustLight()
		if lastbrightness == brightness then return end
		if !IsValid(entity) then return false end
		entity:Fire("SetPattern", lightProgress[brightness], 0) -- command, string input, delay
		lastbrightness = brightness
	end

	return public
end
