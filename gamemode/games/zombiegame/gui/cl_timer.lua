local gradient = Material("gui/gradient")
local gradientDown = Material("gui/gradient_down")

surface.CreateFont( "zgTimerText", {
 font = "HUDNumber5",
 size = 36,
 weight = 300,
 blursize = 0,
 scanlines = 0,
 antialias = true,
 underline = false,
 italic = false,
 strikeout = false,
 symbol = false,
 rotary = false,
 shadow = false,
 additive = false,
 outline = true
} )

local endTime = 0
local lagTime = 1 -- how long to keep the timer around

function setTimer(duration)
	if duration then
		endTime = CurTime() + duration
	else
		endTime = nil
	end
end

local function timerPaint()
	if endTime + lagTime > CurTime() then
		local timeLeft = math.Clamp(endTime - CurTime(), 0, 10000)

		local xPos, yPos = ScrW()/2, 0

		local text = string.ToMinutesSeconds(timeLeft)

		local width, height = getTextSize(text, "zgTimerText")
		height = height + 5
		width = ScrW() * (1/3)

		surface.SetDrawColor(0,0,0,255)

		surface.SetMaterial( gradient )
		surface.DrawTexturedRectRotated( xPos - width/2, yPos + height/2, width, height - 1, 180)

		surface.SetMaterial( gradient )
		surface.DrawTexturedRectRotated( xPos + width/2 - 1, yPos + height/2, width, height, 0)

		paintText(text, "zgTimerText", xPos, yPos + height/2, Color(255,255,255,155), true, true)
	end
end
hook.Add("HUDPaint", "timerPaint", timerPaint)
