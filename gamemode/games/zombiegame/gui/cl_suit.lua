-- surface.CreateFont( "zgSuitText", {
--  font = "HUDNumber1",
--  size = ScreenScale(6),
--  weight = 500,
--  blursize = 0,
--  scanlines = 0,
--  antialias = true,
--  underline = false,
--  italic = false,
--  strikeout = false,
--  symbol = false,
--  rotary = false,
--  shadow = false,
--  additive = false,
--  outline = true
-- } )

-- surface.CreateFont( "zgSuitTitle", {
--  font = "HUDNumber1",
--  size = ScreenScale(8),
--  weight = 500,
--  blursize = 0,
--  scanlines = 0,
--  antialias = true,
--  underline = false,
--  italic = false,
--  strikeout = false,
--  symbol = false,
--  rotary = false,
--  shadow = false,
--  additive = false,
--  outline = true
-- } )

-- local suitSystems = {}
-- suitSystems["V.O.X"] = "Okay"
-- suitSystems["M.S.U"] = "Okay"
-- suitSystems["H.U.D"] = "Okay"

-- local function suitPaint()
-- 	if LocalPlayer():Alive() && LocalPlayer():GetObserverMode() == OBS_MODE_NONE then
-- 		local width, height = 0,0
-- 		local xPos, yPos = 10, ScrH() * (3/4) + 5

-- 		for name, status in pairs(suitSystems) do
-- 			wide, tall = getTextSize(name .. " : " .. status, "zgSuitText")
-- 			if xPos + wide > width then
-- 				width = xPos + wide
-- 			end
-- 			height = height + tall
-- 		end	

-- 		xPos, yPos = 10, ScrH() * (3/4) + 5

-- 		width = width + 10
-- 		height = height + 40

-- 		surface.SetDrawColor(0,0,0,155)
-- 		surface.DrawRect( xPos, yPos, width, height )
-- 		surface.DrawOutlinedRect( xPos, yPos, width, height )

-- 		paintText("Suit Systems", "zgSuitTitle", xPos + width/2, yPos + 5, nil, true, false)

-- 		local wide, tall = 0,0
-- 		xPos = xPos + 10
-- 		yPos = yPos + 30
-- 		-- Actually draw the text now
-- 		for name, status in pairs(suitSystems) do
-- 			wide, tall = paintText(name .. " : ", "zgSuitText", xPos, yPos, nil, false, false)
-- 			paintText(status, "zgSuitText", xPos + wide, yPos, Color(0,255,0), false, false)
-- 			yPos = yPos + tall
-- 		end
-- 	end
-- end
-- hook.Add("HUDPaint", "suitPaint", suitPaint)