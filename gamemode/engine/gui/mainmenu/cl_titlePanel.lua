surface.CreateFont( "weTitle", {
 font = "HUDNumber5",
 size = 64,
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

surface.CreateFont( "weTitleDesc", {
 font = "HUDNumber5",
 size = 24,
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

surface.CreateFont( "weTribute", {
 font = "HUDNumber5",
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

function layoutTitlePanel(parent)

	local titlePanel = vgui.Create("DPanel", parent)
	titlePanel:SetPos(0, 0)
	titlePanel:SetSize( parent:GetWide(), parent:GetTall() * (1/4) )
	titlePanel.Paint = function() 
		surface.SetDrawColor(0,0,0,155)
		surface.DrawRect( 0, 0, titlePanel:GetWide(), titlePanel:GetTall() )
	end

	local title = vgui.Create("DLabel", titlePanel)
	local parent = title:GetParent()
	title:SetText(GAMEMODE.Name)
	title:SetFont("weTitle")
	title:SetPos( 30, 30 )
	title:SizeToContents()

	local desc = vgui.Create("DLabel", titlePanel)
	local parent = desc:GetParent()
	desc:SetText("Created By : " .. GAMEMODE.Author)
	desc:SetFont("weTitleDesc")
	desc:SetPos( 60, 30 + title:GetTall() )
	desc:SizeToContents()

	local tribute = vgui.Create("DLabel", titlePanel)
	local parent = tribute:GetParent()
	tribute:SetText("wild engine ".. GAMEMODE.Version)
	tribute:SetFont("weTribute")
	tribute:SizeToContents()
	tribute:SetPos( parent:GetWide() - tribute:GetWide() - 5, parent:GetTall() - tribute:GetTall() - 5  )

	return titlePanel
end