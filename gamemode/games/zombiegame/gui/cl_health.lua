local ekgFine = Material("re2_ekg/fine01")  
local ekgOkay = Material("re2_ekg/fine_yellow01")  
local ekgCaution = Material("re2_ekg/caution03")  
local ekgDanger = Material("re2_ekg/danger02")  

local function evaluateHealth( entity )
	local Hp = entity:Health()
	local status = "Fine"
	local col = Color(0,255,0,155)
	local ekgText = ekgFine

	if Hp >= 75 then
		status = "Fine"
		col = Color(0,155,0,155)
		ekgText = ekgFine
	elseif Hp >= 51 and Hp <= 74 then
		status = "Fine"
		ekgText = ekgOkay
		col = Color(155,155,0,155)
	elseif Hp >= 20 and Hp <= 50 then
		status = "Caution"
		ekgText = ekgCaution
		col = Color(155,100,0,155)
	elseif Hp <= 19 then
		status = "Danger"
		ekgText = ekgDanger  
		col = Color(155,0,0,155)
	else
		status = "Dead"
		ekgText = ekgDanger
		col = Color(0,0,0,155)
	end
	return status, col, ekgText
end

local function drawLocalPlayerHealth()
	if !LocalPlayer():Alive() then return end 
	if LocalPlayer():GetObserverMode() != OBS_MODE_NONE then return end
	
	local text, drawColor, texture = evaluateHealth( LocalPlayer() )

	local xPos = 0
	local yPos = ScrH() - 64

	surface.SetDrawColor( drawColor ) 
	surface.DrawRect( xPos, yPos, 128, 64 ) 	

	surface.SetDrawColor( Color(0,0,0,155)) 

	surface.DrawOutlinedRect( xPos, yPos, 128, 64 )

	surface.DrawLine( xPos, yPos + 64 * (1/4), xPos + 128, yPos + 64 * (1/4) ) 
	surface.DrawLine( xPos, yPos + 64 * (2/4), xPos + 128, yPos + 64 * (2/4) )
	surface.DrawLine( xPos, yPos + 64 * (3/4), xPos + 128, yPos + 64 * (3/4) )

	surface.SetDrawColor( Color(0,155,0,155) ) 
	surface.SetMaterial( texture )
	surface.DrawTexturedRect( xPos, yPos, 128, 64 ) 

	draw.SimpleText("Condition: " .. text,"DefaultFixedDropShadow",xPos + 128/2, yPos - 15,Color(255,255,255),1,0)
end

local function drawEntityHealth( entity )
	if entity:IsPlayer() && !entity:Alive() then return end
	local text, drawColor, texture = evaluateHealth( entity )
	local distance = entity:GetPos():Distance(LocalPlayer():GetPos())
	drawColor.a = math.Clamp(30 * (1-(distance/300)),0,30)

	local xPos, yPos = entity:GetPos():ToScreen()["x"], entity:GetPos():ToScreen()["y"] + 30
	local width, height = 32, 16

	surface.SetDrawColor( drawColor ) 
	surface.DrawRect( xPos - width/2, yPos - height/2, width, height )
	surface.DrawOutlinedRect( xPos - width/2, yPos - height/2, width, height )

	surface.SetDrawColor( Color(0,0,0,155) ) 
	surface.SetMaterial( texture )
	surface.DrawTexturedRect( xPos - width/2, yPos - height/2, width, height ) 
end

surface.CreateFont( "zgNameText", {
 font = "HUDNumber1",
 size = 12,
 weight = 500,
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


local function drawEntityName( entity )
	local name = entity:GetNWString("charName")
	--if LocalPlayer():IsAdmin() && entity:IsPlayer() then
		local xPos, yPos = entity:GetPos():ToScreen()["x"], entity:GetPos():ToScreen()["y"] - 60
		local width, height = 32, 16

		paintText(entity:Name(), "zgNameText", xPos, yPos, Color(155,155,0,155), true, true)
	--end

	if name == nil then return false end

	local xPos, yPos = entity:GetPos():ToScreen()["x"], entity:GetPos():ToScreen()["y"] - 50
	local width, height = 32, 16

	paintText(name, "zgNameText", xPos, yPos, Color(255,255,255,155), true, true)

end
 
local function drawPlayerHealth()
	for key, ply in pairs(util.getAlivePlayers()) do
		if ply != LocalPlayer() && ply:GetPos():Distance( LocalPlayer():GetPos() ) < GAMEMODE.RenderDistance then
			drawEntityHealth( ply )
		end
	end
end

local function drawPlayerNames()
	for key, ply in pairs(player.GetAll()) do
		if ply != LocalPlayer() && ply:GetPos():Distance( LocalPlayer():GetPos() ) < GAMEMODE.RenderDistance then
			drawEntityName(ply)
		end
	end
end

local function drawNpcHealth()
	for key, zombie in pairs(ents.FindByClass("snpc_*")) do
		if zombie:GetPos():Distance( LocalPlayer():GetPos() ) < GAMEMODE.RenderDistance then
			drawEntityHealth( zombie )
		end
	end
end

function GM:HUDDrawTargetID()
     return false
end

local function healthPaint()

	drawLocalPlayerHealth()
	drawPlayerHealth()
	drawPlayerNames()
	--drawNpcHealth()
	
end
hook.Add("HUDPaint", "healthPaint", healthPaint)

local function shouldDraw( name )
	if (name == "CHudHealth") then
		return false 
	end
end
hook.Add("HUDShouldDraw", "ekgShouldDraw", shouldDraw)