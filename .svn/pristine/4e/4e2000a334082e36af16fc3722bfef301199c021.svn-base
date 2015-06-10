classSkyPainter = {}

local function rgbtoFloats(color)
	return (color.r / 255) .. " " .. (color.g / 255) .. " " .. (color.b / 255)
end

local function rgbtoString(color)
	return (color.r) .. " " .. (color.g) .. " " .. (color.b)
end

local function vectorToNormals(pos)
	return (pos.x or pos.p) .. " " .. pos.y .. " " .. (pos.z or pos.r)
end

function classSkyPainter.new()
	local public = {}

	local entity = ents.FindByClass("env_skypaint")[1]

	-- local sunEnt = ents.FindByClass("env_sun")[1] or ents.Create("env_sun")
	-- sunEnt:SetKeyValue( 'material' , 'sprites/light_glow02_add_noz.vmt' )
	-- sunEnt:SetKeyValue( 'overlaymaterial' , 'sprites/light_glow02_add_noz.vmt' )
	-- sunEnt:SetKeyValue( "rendercolor", "255 255 255" );
	-- sunEnt:Spawn()
	-- sunEnt:Activate()

	local shadowEnt = ents.FindByClass("shadow_control")[1]

	local skyTopColor = Color(0, 0, 0)
	local skyBottomColor = Color(0, 0, 0)
	local starsVisible = false
	local starsScale = 2.0

	local skyDuskColor = Color(0,0,0)
	local skyDuskScale = 0.0
	local skyDuskIntensity = 0.0

	local skySunColor = Color(255, 255, 255)
	local skySunAngle = Angle(0, 0, 0)
	local skySunSize = 0.0

	function public.setEntity(newEntity)
		entity = newEntity
	end

	function public.getEntity()
		return entity
	end

	function public.setTopColor(r, g, b)
		skyTopColor = Color(r, g, b)
	end
	function public.getTopColor()
		return skyTopColor
	end

	function public.setBottomColor(r,g,b)
		skyBottomColor = Color(r,g,b)
	end
	function public.getBottomColor()
		return skyBottomColor
	end

	function public.setDuskColor(r,g,b)
		skyDuskColor = Color(r,g,b)
	end
	function public.getDuskColor()
		return skyDuskColor
	end

	function public.setDuskScale(newScale)
		skyDuskScale = newScale
	end
	function public.getDuskScale()
		return skyDuskScale
	end

	function public.setDuskIntensity(newIntensity)
		skyDuskIntensity = newIntensity
	end
	function public.getDuskIntensity()
		return skyDuskIntensity
	end
	
	function public.disableStars()
		starScale = 0.0
	end

	function public.starsVisible()
		if starScale == 0.0 then
			return false
		end
		return true
	end

	function public.setStarsScale(newScale)
		starScale = newScale
	end
	function public.getStarsScale()
		return starScale
	end

	function public.setSunColor(r,g,b)
		skySunColor = Color(r,g,b)
	end
	function public.getSunColor()
		return skySunColor
	end

	function public.setSunAngle(newSunPos)
		skySunAngle = newSunPos
	end
	function public.getSunAngle()
		return skySunAngle
	end

	function public.setSunSize(newSunSize)
		skySunSize = newSunSize
	end
	function public.getSunSize()
		return skySunSize
	end

	local function checkStars(clampedProgress)
		if clampedProgress > 0.6 then
			public.disableStars()
		else
			public.setStarsScale(1.0)
		end
	end

	local function getTopColor(brightness)
		local topColorRed = math.lerp(0, 32, brightness)
		local topColorGreen = math.lerp(0, 70, brightness)
		local topColorBlue = math.lerp(0, 143, brightness)
		return topColorRed, topColorGreen, topColorBlue
	end

	local function getBottomColor(brightness)
		local bottomColorRed = math.lerp(1, 163, brightness)
		local bottomColorGreen = math.lerp(2, 214, brightness)
		local bottomColorBlue = math.lerp(5, 255, brightness)
		return bottomColorRed, bottomColorGreen, bottomColorBlue
	end

	local function getDuskColor(duskBrightness, r, g, b)
		local duskRed = math.lerp(r, 184, duskBrightness)
		local duskGreen = math.lerp(g, 45, duskBrightness)
		local duskBlue = math.lerp(b, 13, duskBrightness)
		return duskRed, duskGreen, duskBlue
	end

	local function getSunColor(duskBrightness)
		local sunRed = math.lerp(255, 255, duskBrightness) --255
		local sunGreen = math.lerp(232, 200, duskBrightness) --236 - 36 * duskBrightness
		local sunBlue = math.lerp(178, 22, duskBrightness) --185 - 120 * duskBrightness
		return sunRed, sunGreen, sunBlue
	end	
	
	function public.paintSky(dayProgress, clampedProgress)
		local brightness = math.Round(255 * clampedProgress) -- gives a percentage of white depending on the day 
		local duskBrightness = (math.pow(math.abs(math.sin((20 * (dayProgress + 0.25)) / math.pi)), 20))

		checkStars(clampedProgress)

		public.setTopColor(getTopColor(clampedProgress))
		public.setBottomColor(getBottomColor(clampedProgress))

		public.setDuskColor(getDuskColor(duskBrightness, getBottomColor(clampedProgress)))
		public.setDuskScale(0.5 * duskBrightness) -- 0.5 is default dusk scale
		public.setDuskIntensity(duskBrightness * 0.7)

		public.setSunAngle(Angle(-360 * dayProgress, 0, 0))
		public.setSunColor(getSunColor(duskBrightness))
		public.setSunSize(math.clamp(0.12 * (1.0 - duskBrightness), 0.11))
	end

	function public.update()
		if !IsValid(entity) or !IsValid(shadowEnt) then return false end
		entity:SetKeyValue("topcolor", rgbtoFloats(skyTopColor), 0)
		entity:SetKeyValue("bottomcolor", rgbtoFloats(skyBottomColor), 0)

		entity:SetKeyValue("duskcolor", rgbtoFloats(skyDuskColor), 0)
		entity:SetKeyValue("duskscale", skyDuskScale, 0)
		entity:SetKeyValue("duskintensity", skyDuskIntensity, 0)

		--print(sunEnt)

		--sunEnt:Fire("addoutput", "pitch "..tostring(-89), 0)
		--sunEnt:Activate()

		entity:SetKeyValue("sunnormal", vectorToNormals(skySunAngle:Forward()), 0)
		entity:SetKeyValue("suncolor", rgbtoFloats(skySunColor), 0)
		entity:SetKeyValue("sunsize", skySunSize, 0)

		entity:SetKeyValue("starscale", tostring(starScale), 0)

		shadowEnt:Fire("direction", vectorToNormals(-skySunAngle:Forward()))
		local pitch = math.clamp(180 + skySunAngle.p, 60, 120)
		shadowEnt:Fire("SetAngles", vectorToNormals(Vector(pitch, 0, 20)))
		shadowEnt:Fire("SetDistance", 1000)
	end
	public.update()

	return public
end