-- -- env_projectedtexture

-- local projtex

-- local dist = 7000
-- local sunNormal = Vector(0.5, 0.5, 1.0)
-- local sunPos = sunNormal * dist

-- local function sunInit()
-- 	projtex = ents.Create("env_projectedtexture")

-- 	-- The local positions are the offsets from parent..
-- 	projtex:SetPos(sunPos)
-- 	projtex:SetAngles((Vector(0, 0, 0) - projtex:GetPos()):Angle())

-- 	-- Looks like only one flashlight can have shadows enabled!
-- 	projtex:SetKeyValue("enableshadows", 1)
-- 	projtex:SetKeyValue("farz", dist + 10000)
-- 	projtex:SetKeyValue("nearz", dist - 2000)
-- 	projtex:SetKeyValue("lightfov", 70)
-- 	projtex:SetKeyValue("shadowquality", 1)
-- 	projtex:SetKeyValue("ambient", 0)

-- 	PrintTable(projtex:GetKeyValues())

-- 	local c = Color(255, 255, 255)
-- 	projtex:SetKeyValue("lightcolor", Format("%i %i %i 255", c.r * 1, c.g * 1, c.b * 1))

-- 	projtex:Spawn()

-- 	projtex:Input("LightWorld", "false")
-- 	projtex:Input("SpotlightTexture", NULL, NULL, "effects/flashlight/square")
-- 	-- projtex:Input("SpotlightTexture", NULL, NULL, "Lights/White")
-- end
-- hook.Add("InitPostEntity", "InitPostEntitySUN", sunInit)

-- local coutn = 100
-- local function sunThink()
-- 	-- local allplys = player.GetAll()
-- 	-- local validPly
-- 	-- for _, ply in pairs(allplys) do
-- 	-- 	if IsValid(ply) then
-- 	-- 		validPly = ply
-- 	-- 		break
-- 	-- 	end
-- 	-- end

-- 	-- if IsValid(projtex) and IsValid(validPly) then
-- 	-- 	print(math.cos(CurTime() * 1) * 1000)
-- 	-- 	projtex:SetPos(validPly:GetPos() + sunPos + Vector(0, 0, math.cos(CurTime() * 1) * 1000))
-- 	-- end
-- 	if world and world.skyPainter then
-- 		local norm = world.skyPainter.getSunAngle():Forward()

-- 		if world.time.getDayProgress() > 0.5 then
-- 			projtex:SetKeyValue("lightcolor", 0 .. " " .. 0 .. " " .. 0 .. " 255")
-- 		else
-- 			projtex:SetKeyValue("lightcolor", 1 .. " " .. 1 .. " " .. 1 .. " 0")
-- 		end
-- 		projtex:SetPos(norm * dist)
-- 		projtex:SetAngles((Vector(0, 0, 0) - projtex:GetPos()):Angle())
-- 	end
-- end
-- hook.Add("Think", "virus_sun_think", sunThink)