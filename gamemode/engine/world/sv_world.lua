world = {}
world.maps = {}

local function worldThink()
	if world.light && world.time then 
		
		local dayProgress = world.time.getDayProgress()

		local progress = math.sin(dayProgress * 2 * math.pi)

		local clampHeight = 0.5
		local clampedProgress = math.clamp(progress, 0, clampHeight) / clampHeight -- this needs to be adjusted so it is brightest at noon

		world.skyPainter.paintSky(dayProgress, clampedProgress)
		world.skyPainter.update()

		world.light.setBrightness(clampedProgress - 0.001)
		
	end
end


function world.registerMap( mapName, genFunc )
	world.maps[mapName] = genFunc
end

function world.loadMap( mapName )
	if world.maps[mapName] == nil then return end
	world.maps[mapName]()
end


function world.initialize()
	world.light = classLighting.new()
	world.skyPainter = classSkyPainter.new()

	world.time = classTime.new() -- Sets the world time to the time Object

	world.think = worldThink

	world.data = classRenderData.new()

	world.loadMap( game.GetMap() )
end
concommand.Add("reloadworld", world.initialize)

