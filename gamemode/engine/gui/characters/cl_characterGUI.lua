local mdls = GM.PlayerModels


local frame

local function setModel() end

local function selectModel( name )
	if IsValid(frame) then
		frame:Remove()
	end

	frame = vgui.Create("DFrame")
	frame:SetSize(450, 250)
	frame:SetTitle("Character Creation - Select Model")
	frame:MakePopup()
	frame:Center()
	frame:RequestFocus()
	frame.Paint = function()
		surface.SetDrawColor(55, 55, 55, 155)
		surface.DrawRect( 0, 0, frame:GetWide(), frame:GetTall())
	end

	local model = table.Random(mdls)

	local mdl = vgui.Create("DModelPanel", frame)
	local parent = mdl:GetParent()
	local size = parent:GetWide()
	if parent:GetTall() < parent:GetWide() then
		size = parent:GetTall()
	end

	mdl:SetSize(size * 0.8, size * 0.8)
	mdl:SetPos(frame:GetWide() - mdl:GetWide() - 20, frame:GetTall()/2 - mdl:GetTall()/2 - 25)
	mdl:SetModel(model)
	for name, modelPath in pairs(mdls) do
		if modelPath == model then
			mdl.name = name
			break
		end 
	end

	local sheet = vgui.Create("DPropertySheet", frame)
	sheet:SetPos(10, 30)
	sheet:SetSize(frame:GetWide()/2, frame:GetTall() - 75)

	local panelSelect = sheet:Add("DPanelSelect")

	for name, model in pairs( mdls ) do

		local icon = vgui.Create( "SpawnIcon" )
		icon:SetModel( model )
		icon:SetSize( 32, 32 )
		icon:SetTooltip( name )

		panelSelect:AddPanel( icon, { char_playermodel = name } )

	end

	sheet:AddSheet( "Model", panelSelect, "icon16/user.png" )

	function setModel( name ) 
		if IsValid(mdl) then
			mdl:SetModel(mdls[name])
			mdl.name = name
		end
	end

	local back = vgui.Create("DButton", frame)
	local parent = back:GetParent()
	back:SetSize( (parent:GetWide() * 0.9)/2 - 5, 25 )
	back:SetPos( parent:GetWide()/2 - back:GetWide() - 5, parent:GetTall() - 35)
	back:SetText("Back")
	function back:DoClick() 
		RunConsoleCommand("openCharacterCreation")
	end

	local next = vgui.Create("DButton", frame)
	local parent = next:GetParent()
	next:SetSize( (parent:GetWide() * 0.9)/2 - 5, 25 )
	next:SetPos( parent:GetWide() - next:GetWide() - 10 , parent:GetTall() - 35)
	next:SetText("Finish")
	function next:DoClick() 
		RunConsoleCommand("createCharacter", name, mdl.name) 
		frame:Remove()
	end

end
concommand.Add("char_playermodel", function(ply, cmd, args) setModel(args[1]) end)
	--next.DoClick = function()  end

local function selectName()
	if IsValid(frame) then
		frame:Remove()
	end

	frame = vgui.Create("DFrame")
	frame:SetSize(250, 100)
	frame:SetTitle("Character Creation - Enter Name")
	frame:MakePopup()
	frame:Center()
	frame:RequestFocus()
	frame.Paint = function()
		surface.SetDrawColor( 55, 55, 55, 155)
		surface.DrawRect( 0, 0, frame:GetWide(), frame:GetTall())
	end

	-- local model = table.Random(mdls)
	-- print(model)

	-- local mdl = vgui.Create("DModelPanel", frame)
	-- local parent = mdl:GetParent()
	-- mdl:SetPos(40,40)
	-- mdl:SetSize(parent:GetWide() - 80, parent:GetWide() - 80)
	-- mdl:SetModel(model)

	local name = vgui.Create("DTextEntry", frame)
	local parent = name:GetParent()
	name:SetSize( parent:GetWide() * 0.9, 25 )
	name:SetPos( parent:GetWide()/2 - name:GetWide()/2, 30)
	name:SetText("Enter Character Name")

	-- local back = vgui.Create("DButton", frame)
	-- local parent = back:GetParent()
	-- back:SetSize( (parent:GetWide() * 0.9)/2 - 5, 25 )
	-- back:SetPos( parent:GetWide()/2 - back:GetWide() - 5, parent:GetTall() - 35)
	-- back:SetText("Back")
	-- function back:DoClick() 
	-- 	frame:Remove()
	-- end

	local next = vgui.Create("DButton", frame)
	local parent = next:GetParent()
	next:SetSize( parent:GetWide() * 0.9, 25 )
	next:SetPos( parent:GetWide()/2 - next:GetWide()/2 , parent:GetTall() - 35)
	next:SetText("Next")
	function next:DoClick() 
		if name:GetText() != "" && name:GetText() != "Enter Character Name" then
			selectModel(name:GetText())
		else
			LocalPlayer():ChatPrint("You can't have those as a name!")
		end
	end

end

concommand.Add("openCharacterCreation", selectName)

surface.CreateFont( "weCharacterName", {
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

function guiPaintCharacter( characterData, parent )
	if characterData == nil then print("cl_CharacterGUI.lua : Character Doesn't Exist") return false end

	local mdl = vgui.Create("DModelPanel", parent)
	mdl:SetPos(40,40)
	mdl:SetSize(parent:GetWide() - 80, parent:GetWide() - 80)
	mdl:SetModel(characterData.getModel())

	local name = vgui.Create("DLabel", parent)
	name:SetFont("weCharacterName")	
	name:SetText(characterData.getName())
	name:SizeToContents()
	name:SetPos( parent:GetWide()/2 - name:GetWide()/2, 25)

	return mdl
end
