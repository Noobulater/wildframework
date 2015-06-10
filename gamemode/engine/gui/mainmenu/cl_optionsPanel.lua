classOptionsPanel = {}

function classOptionsPanel.new( parent )
	local public = vgui.Create("DPanel", parent)

	local tabs = {}

	function public.addTab( tabName )
		local tab = classOptionsTab.new( public )
		tab:SetText(tabName)
		tab:SetSize( 120, 30 )
		
		table.insert(tabs, tab)
		public.reposition()
	end
	
	function public.getTab( tabName )
		for key, tab in pairs(tabs) do
			if tab:GetText() == tabName then
				return tab
			end
		end
	end

	function public.removeTab( tabName )
		for key, tab in pairs(tabs) do
			if tab:GetText() == tabName then
				tab:Remove()
			end
		end
		public.reposition()
	end

	function public.reposition()
		local width = public:GetWide() / table.Count(tabs)
		local xOffset = (public:GetWide()/2) / table.Count(tabs)
		for key, tab in pairs(tabs) do
			tab:SetSize(public:GetWide() / (table.Count(tabs) + 1), public:GetTall() / 2)
			tab:SetPos(xOffset + width * (key - 1) - tab:GetWide() / 2, public:GetTall() / 2 - tab:GetTall() / 2)
		end
	end

	return public
end

function layoutOptionsPanel(parent)

	local menuOptions = classOptionsPanel.new(parent)
	menuOptions:SetSize( parent:GetWide(), parent:GetTall() * (1/6) )
	menuOptions:SetPos( 0, parent:GetTall() - menuOptions:GetTall() )	
	menuOptions.Paint = function() 
		surface.SetDrawColor(0,0,0,155)
		surface.DrawRect( 0, 0, menuOptions:GetWide(), menuOptions:GetTall() )
	end

	return menuOptions
end

