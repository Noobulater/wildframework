--
local PMETA = FindMetaTable("Player")
if SERVER then
util.AddNetworkString( "networkChat" )

function networkChat( ply, speaker, text, teamChat )
	local ply = ply or player.GetAll()	

	if teamChat then teamChat = 1 else teamChat = 0 end
	net.Start( "networkChat" )
		net.WriteEntity(speaker)
		net.WriteString(text)
		net.WriteUInt(teamChat, 2)	
	net.Send( ply )
end


function PMETA:ChatPrint(text)
	networkChat(self, nil, text, false)
end

-- function GM:PlayerSay( speaker, text, teamChat )
-- 	-- for index, ply in pairs(player.GetAll()) do
-- 	-- 	if ply != speaker then
-- 	-- 		if !teamChat or (ply:Team() == speaker:Team()) then
-- 	-- 			networkChat( ply, speaker, text, teamChat )
-- 	-- 		end
-- 	-- 	end
-- 	-- end
-- 	return nil
-- end

end

if CLIENT then

function PMETA:ChatPrint(text)
	GAMEMODE:OnPlayerChat( nil, text, false, true )
end

net.Receive( "networkChat", function(len)  
	local speaker = net.ReadEntity()
	local text = net.ReadString()
	local teamChat = net.ReadUInt(2)

	if teamChat == 0 then teamChat = false else teamChat = true end
	if IsValid(speaker) && speaker:IsPlayer() then
		GAMEMODE:OnPlayerChat( speaker, text, teamChat, speaker:Alive() )
	else
		GAMEMODE:OnPlayerChat( nil, text, teamChat, true )
	end
end)


local gradient = Material("gui/gradient_up")

surface.CreateFont( "wildChatText", {
 font = "HUDNumber1",
 size = 14,
 weight = 600,
 blursize = 0,
 scanlines = 0,
 antialias = false,
 underline = false,
 italic = false,
 strikeout = false,
 symbol = false,
 rotary = false,
 shadow = false,
 additive = false,
 outline = true
} )


function getTextSize(text, font)
	surface.SetFont(font or "Arial")
	return surface.GetTextSize(text)
end

function paintText(text, font, xPos, yPos, col, centerX, centerY)
	surface.SetTextColor(col or Color(255,255,255,255))
	surface.SetFont(font or "Arial")
	local wide, tall = surface.GetTextSize(text)
	if centerX then
		xPos = xPos - wide/2
	end
	if centerY then
		yPos = yPos - tall/2
	end
	surface.SetTextPos(xPos, yPos)
	surface.DrawText(text or "No Text Assigned")
	return wide, tall
end

local function createChatBox()
	local public = vgui.Create("DPanel")

	local xPos, yPos = 10, ScrH() * (4/8)
	local width, height = ScrW() * (1/3), ScrH() * (1/4)

	public:SetSize(width, height)
	public:SetPos(xPos, yPos)

	function public:Paint()
		if public.hide then return false end
		surface.SetDrawColor(0,0,0,155)
		surface.DrawRect( 0, 0, width,  height )
		surface.DrawOutlinedRect( 0, 0, width,  height )
			
		surface.SetDrawColor(0,0,0,155)
		surface.SetMaterial( gradient )
		surface.DrawTexturedRect( 0, 0, width,  height )
	end

	local chatHistory = vgui.Create("chatHistory", public)
	local parent = chatHistory:GetParent()
	chatHistory:SetPos(5, 25)
	chatHistory:SetSize(parent:GetWide() - 10, parent:GetTall() - 55)

	function chatHistory:Paint()
		if public.hide then return false end
		surface.SetDrawColor(25,25,25,225)
		surface.DrawRect( 0, 0, width - 10, height - 55)
		surface.DrawOutlinedRect( 0, 0, width - 10,  height - 55 )

		surface.SetDrawColor(0,0,0,155)
		surface.SetMaterial( gradient )
		surface.DrawTexturedRect( 0, 0, width - 10,  height - 55 )
	end

	local chatEntry = vgui.Create("DTextEntry", public)
	local parent = chatEntry:GetParent()
	chatEntry:SetPos(5, parent:GetTall() - 25)
	chatEntry:SetSize(parent:GetWide() - 10, 20)

	local blink = 1
	local nextBlink = 0

	function chatEntry:Paint()
		if public.hide then return false end
		surface.SetDrawColor(25,25,25,225)
		surface.DrawRect( 0, 0, width - 10,  20 )
		surface.DrawOutlinedRect( 0, 0, width - 10,  20 )

		surface.SetDrawColor(0,0,0,155)
		surface.SetMaterial( gradient )
		surface.DrawTexturedRect( 0, 0, width - 10,  20 )

		local xPos, yPos = 5, chatEntry:GetTall()/2
		local wide, tall = getTextSize(chatEntry:GetText(), "wildChatText")
		local xOffset, yOffset = 0, 0 
		if public:getTeamSay() then
			xOffset, yOffset = getTextSize("(TEAM) ", "wildChatText")
			yOffset = 0
		end

		if xOffset + wide > chatEntry:GetWide() - 5 then
			xPos = (chatEntry:GetWide() - 5) - wide
		end

		if public:getTeamSay() then
			paintText("(TEAM) ", "wildChatText", xPos, yPos, Color(0, 255, 0, 255), false, true )
		end

		paintText(chatEntry:GetText(), "wildChatText", xPos + xOffset, yPos + yOffset, nil, false, true )

		if nextBlink < CurTime() then
			if CurTime() - nextBlink < blink then
				paintText("|", "wildChatText", xPos + xOffset + wide, yPos + yOffset, nil, false, true )
			else
				nextBlink = CurTime() + blink
			end
		end
	end

	public.teamSay = teamSay

	function public:getChatEntry()
		return chatEntry
	end

	function public:getChatHistory()
		return chatHistory
	end

	function public:setTeamSay( newTeamSay )
		teamSay = newTeamSay
	end

	function public:getTeamSay()
		return teamSay
	end

	function public:Hide()
		public:SetKeyBoardInputEnabled(false)
		public:SetMouseInputEnabled(false)
		chatHistory:SetKeyBoardInputEnabled(false)
		chatHistory:SetMouseInputEnabled(false)
		chatEntry:SetKeyBoardInputEnabled(false)
		chatEntry:SetMouseInputEnabled(false)
		public.hide = true
	end
	
	function public:isHiding() 
		return public.hide
	end

	function public:Show()
		public:SetKeyBoardInputEnabled(true)
		public:SetMouseInputEnabled(true)
		chatHistory:SetKeyBoardInputEnabled(true)
		chatHistory:SetMouseInputEnabled(true)
		chatEntry:SetKeyBoardInputEnabled(true)
		chatEntry:SetMouseInputEnabled(true)		
		public.hide = false
	end
	return public
end

local chatBox 
function openChatBox( teamSay )
	if IsValid(chatBox) then
		chatBox:Show()
		chatBox:setTeamSay(teamSay)
	else
		chatBox = createChatBox()
	end
end

function GM:StartChat(teamSay)
	openChatBox( teamSay )
	return true 
end

function GM:OnPlayerChat( ply, strText, bTeamOnly, bPlayerIsDead )
 
	-- I've made this all look more complicated than it is. Here's the easy version
	-- chat.AddText( ply:GetName(), Color( 255, 255, 255 ), ": ", strText )
 
	local tab = {}
 
	if ( IsValid( ply ) ) then

		if ( bPlayerIsDead ) then
			table.insert( tab, Color( 255, 30, 40 ) )
			table.insert( tab, "*DEAD* " )
		end
	 
		if ( bTeamOnly ) then
			table.insert( tab, Color( 30, 160, 40 ) )
			table.insert( tab, "(TEAM) " )
		end

		table.insert( tab, Color(125,170,30,255) )
		table.insert( tab, ply:GetName() )

		table.insert( tab, Color( 255, 255, 255 ) )
		table.insert( tab, ": "..strText )

	else
		table.insert( tab, Color( 155, 155, 155 ) )			
		table.insert( tab, "Console" )

		table.insert( tab, Color( 155, 155, 155 ) )
		table.insert( tab, ": "..strText )		
	end
  
	chat.AddText( unpack(tab) )
 
	-- fuck all that ^ thats just for console prints

	if IsValid(chatBox) then
		local chatHistory = chatBox:getChatHistory()

		local chatEntry = vgui.Create("chatLine", chatBox)
		local parent = chatEntry:GetParent()
		chatEntry:SetPos(5, parent:GetTall() - 25)
		chatEntry:SetSize(parent:GetWide() - 10, 20)
		chatEntry:SetText(tab)

		chatHistory:AddLine(chatEntry)
	end

	return true
 
end

function GM:ChatTextChanged( text )
	if IsValid(chatBox) then
		local entry = chatBox:getChatEntry()
		entry:SetText(text)
	end
end

function GM:FinishChat()
 
 	if IsValid(chatBox) then
		chatBox:Hide()
	end

end

function chatBoxInitHook()
	chatBox = createChatBox()
	chatBox:Hide()
end
hook.Add("InitPostEntity", "chatBoxInitHook", chatBoxInitHook)

function getChatBox()
	return chatBox
end

end