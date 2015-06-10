classMainMenu = {}
classMainMenu.SCREENS = {}

function classMainMenu.new()
	local public = vgui.Create("DFrame")
	public:SetSize( ScrW(), ScrH() )
	public:SetTitle("")
	public:MakePopup()
	public:SetKeyboardInputEnabled(false)
	public:ShowCloseButton(false)
	public.Paint = function() end

	local titlePanel = layoutTitlePanel( public )

	local menuOptions = layoutOptionsPanel( public )

	local spaceRemaining = public:GetTall() - titlePanel:GetTall() - menuOptions:GetTall()

	local fillerPanel = vgui.Create("DPanel", public)
	fillerPanel:SetSize(public:GetWide(), spaceRemaining)
	fillerPanel:SetPos(0, titlePanel:GetTall())
	fillerPanel.Paint = function() end

	fillerPanel.child = nil

	fillerPanel.clear = function() if fillerPanel.child != nil then fillerPanel.child:Remove() fillerPanel.child = nil end end
	fillerPanel.open = function(name, argument) if classMainMenu.SCREENS[name] != nil then fillerPanel.clear() fillerPanel.child = classMainMenu.SCREENS[name](fillerPanel, argument) end end

	--menuOptions.addTab("Join Game")
	menuOptions.addTab("Manage Characters")
	menuOptions.addTab("Fate Bank")
	--menuOptions.addTab("Options")	
	menuOptions.addTab("Close Menu")

	menuOptions.getTab("Manage Characters").DoClick = function() fillerPanel.open("characterRoster") end
	menuOptions.getTab("Fate Bank").DoClick = function() fillerPanel.open("fateBank") end
	menuOptions.getTab("Close Menu").DoClick = function() if fillerPanel.child != nil then fillerPanel.clear() else RunConsoleCommand("toggleMainMenu") end end

	return public

end
local frame 
concommand.Add("toggleMainMenu", function() if IsValid(frame) then frame:Remove() else frame = classMainMenu.new() end end)

function GM:HUDDrawScoreBoard()
	return false
end

function GM:ScoreboardShow( )
	RunConsoleCommand("toggleMainMenu")
end

function GM:ScoreboardHide( )
end

local function shouldDraw( name )
	if IsValid(frame) then
		return false 
	end
end
hook.Add("HUDShouldDraw", "mainMenuEclipse", shouldDraw)