classOptionsTab = {}

local gradient = Material("gui/gradient_up")

surface.CreateFont( "weTabText", {
 font = "HUDNumber5",
 size = 16,
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

function classOptionsTab.new( parent )
	local public = vgui.Create("DButton", parent)
	public:SetText("")
	
	local text = ""

	function public:SetText( newText )
		text = newText
	end

	function public:GetText( )
		return text
	end

	local col = Color(55,55,55,155)

	public.OnCursorEntered = function() col = Color(255,0,0,155) end
	public.OnCursorExited = function() col = Color(55,55,55,155) end

	public.Paint = function()
		surface.SetFont("weTabText")
		local x,y = surface.GetTextSize(public:GetText())

		draw.RoundedBox( 4, 0, 0, public:GetWide(), public:GetTall(), col )

		surface.SetDrawColor( math.Clamp(col.r - 25, 0, 255), math.Clamp(col.g - 25, 0, 255), math.Clamp(col.b - 25, 0, 255), col.a )

		surface.SetMaterial( gradient )
		surface.DrawTexturedRect( 0, 0, public:GetWide(), public:GetTall())


		draw.DrawText( public:GetText(), "weTabText",  public:GetWide() / 2 , public:GetTall() / 2 - y/2, Color(255,255,255,255), TEXT_ALIGN_CENTER )

	end

	return public
end