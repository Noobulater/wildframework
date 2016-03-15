
-- The data is pretty simple
-- structured like so
-- {
-- 	model = "models/items/healthkit.mdl",
-- 	bone = "ValveBiped.Bip01_R_Hand",
-- 	color = Color(255,255,255,255),
-- 	skin = 1,
-- 	material = "",
-- 	pos = Vector(0,0,0),
-- 	abg = Angle(0,0,0),
-- 	scale = Vector(1,1,1)
-- }
if CLIENT then
local Bones = {"none","ValveBiped.Bip01_Head1",
"ValveBiped.Anim_Attachment_RH","ValveBiped.Bip01_Spine",
"ValveBiped.Bip01_Spine1","ValveBiped.Bip01_Spine2","ValveBiped.Bip01_Spine3",
"ValveBiped.Bip01_Spine4", "ValveBiped.Bip01_Pelvis","ValveBiped.Bip01_R_Hand", 
"ValveBiped.Bip01_R_Forearm", "ValveBiped.Bip01_R_Foot", "ValveBiped.Bip01_R_Thigh",
"ValveBiped.Bip01_R_Calf", "ValveBiped.Bip01_R_Shoulder", "ValveBiped.Bip01_R_Elbow", 
"ValveBiped.Bip01_L_Hand", "ValveBiped.Bip01_L_Forearm", "ValveBiped.Bip01_L_Foot", 
"ValveBiped.Bip01_L_Thigh", "ValveBiped.Bip01_L_Calf", "ValveBiped.Bip01_L_Shoulder", 
"ValveBiped.Bip01_L_Elbow",}

local holdTypes = {
	"ar2",	"camera",	"crossbow",	"duel",	"fist",	"grenade",	"knife",	
	"melee",	"melee2",	"normal",	"passive",	"physgun",	
	"pistol",	"revolver",	"rpg",	"shotgun",	"slam",	"smg",
}

local tempData = {
	model = "models/items/healthkit.mdl",
	bone = "ValveBiped.Bip01_R_Hand",
	color = Color(255,255,255,255),
	skin = 1,
	material = "",
	pos = Vector(0,0,0),
	ang = Angle(0,0,0),
	scale = Vector(1,1,1),
}

local function openModelTab(parent)

	local visible = parent:Add("DPanel")
	parent:AddSheet( "Model", visible, "icon16/world.png" )

	local yPos = 10
	local padding = 10
	local buttonWidth = parent:GetWide() - 40

	local modelName = vgui.Create("DTextEntry", visible)
	modelName:SetPos(10,yPos)
	modelName:SetSize((buttonWidth)/2 - 10, 20)
	modelName:SetText(tostring(tempData.model))
	modelName:SetConVar("paperDollModel")
	function modelName:Think()
		modelName:SetValue(tempData.model)
	end

	local modelButton = vgui.Create("DButton", visible)
	modelButton:SetSize((buttonWidth)/2 - 10, 20)
	modelButton:SetPos(buttonWidth - modelButton:GetSize() ,yPos)	
	modelButton:SetText("Open Model Browser")
	function modelButton:DoClick()
		RunConsoleCommand("openModelSelector")
	end

	yPos = yPos + modelName:GetTall() + padding

	local title = vgui.Create("DLabel", visible)
	title:SetPos(10,yPos)
	title:SetSize(buttonWidth, 20)
	title:SetText("Vector(x,y,z)")
	title:SetColor(Color(0,0,0,255))

	yPos = yPos + title:GetTall() + padding

	local xSlider = vgui.Create("Slider", visible)
	xSlider:SetPos(10,yPos)
	xSlider:SetSize(buttonWidth, 20)
	xSlider:SetMin(-100)
	xSlider:SetMax(100)
	xSlider:SetDecimals(1)
	xSlider:SetValue(0)
	function xSlider:Think( self, newValue )
		tempData.pos.x = math.Round( xSlider:GetValue() )
	end

	yPos = yPos + xSlider:GetTall() + padding	

	local ySlider = vgui.Create("Slider", visible)
	ySlider:SetPos(10,yPos)
	ySlider:SetSize(buttonWidth, 20)
	ySlider:SetMin(-100)
	ySlider:SetMax(100)
	ySlider:SetDecimals(1)
	ySlider:SetValue(0)
	function ySlider:Think( self, newValue )
		tempData.pos.y = math.Round( ySlider:GetValue() )
	end

	yPos = yPos + ySlider:GetTall() + padding	

	local zSlider = vgui.Create("Slider", visible)
	zSlider:SetPos(10,yPos)
	zSlider:SetSize(buttonWidth, 20)
	zSlider:SetMin(-100)
	zSlider:SetMax(100)
	zSlider:SetDecimals(1)
	zSlider:SetValue(0)
	function zSlider:Think( self, newValue )
		tempData.pos.z = math.Round( zSlider:GetValue() )
	end

	yPos = yPos + zSlider:GetTall() + padding 

	----------
	--Angles--
	----------

	local title = vgui.Create("DLabel", visible)
	title:SetPos(10,yPos)
	title:SetSize(buttonWidth, 20)
	title:SetText("Angle(p,y,r)")
	title:SetColor(Color(0,0,0,255))

	yPos = yPos + title:GetTall() + padding

	local pSlider = vgui.Create("Slider", visible)
	pSlider:SetPos(10,yPos)
	pSlider:SetSize(buttonWidth, 20)
	pSlider:SetMin(0)
	pSlider:SetMax(360)
	pSlider:SetDecimals(1)
	pSlider:SetValue(0)
	function pSlider:Think( self, newValue )
		tempData.ang.p = math.Round( pSlider:GetValue() )
	end

	yPos = yPos + pSlider:GetTall() + padding	

	local ySlider = vgui.Create("Slider", visible)
	ySlider:SetPos(10,yPos)
	ySlider:SetSize(buttonWidth, 20)
	ySlider:SetMin(0)
	ySlider:SetMax(360)
	ySlider:SetDecimals(1)
	ySlider:SetValue(0)
	function ySlider:Think( self, newValue )
		tempData.ang.y = math.Round( ySlider:GetValue() )
	end

	yPos = yPos + ySlider:GetTall() + padding	

	local rSlider = vgui.Create("Slider", visible)
	rSlider:SetPos(10,yPos)
	rSlider:SetSize(buttonWidth, 20)
	rSlider:SetMin(0)
	rSlider:SetMax(360)
	rSlider:SetDecimals(1)
	rSlider:SetValue(0)
	function rSlider:Think( self, newValue )
		tempData.ang.r = math.Round( rSlider:GetValue() )
	end

	yPos = yPos + rSlider:GetTall() + padding		

	----------
	--Scale--
	----------

	local title = vgui.Create("DLabel", visible)
	title:SetPos(10,yPos)
	title:SetSize(buttonWidth, 20)
	title:SetText("Scale(x,y,z)")
	title:SetColor(Color(0,0,0,255))

	yPos = yPos + title:GetTall() + padding

	local xSlider = vgui.Create("Slider", visible)
	xSlider:SetPos(10,yPos)
	xSlider:SetSize(buttonWidth, 20)
	xSlider:SetMin(0)
	xSlider:SetMax(5)
	xSlider:SetDecimals(1)
	xSlider:SetValue(1)
	function xSlider:Think( self, newValue )
		tempData.scale.x = math.Round( xSlider:GetValue() )
	end

	yPos = yPos + xSlider:GetTall() + padding	

	local ySlider = vgui.Create("Slider", visible)
	ySlider:SetPos(10,yPos)
	ySlider:SetSize(buttonWidth, 20)
	ySlider:SetMin(0)
	ySlider:SetMax(5)
	ySlider:SetDecimals(1)
	ySlider:SetValue(1)
	function ySlider:Think( self, newValue )
		tempData.scale.y = math.Round( ySlider:GetValue() )
	end

	yPos = yPos + ySlider:GetTall() + padding	

	local zSlider = vgui.Create("Slider", visible)
	zSlider:SetPos(10,yPos)
	zSlider:SetSize(buttonWidth, 20)
	zSlider:SetMin(0)
	zSlider:SetMax(5)
	zSlider:SetDecimals(1)
	zSlider:SetValue(1)
	function zSlider:Think( self, newValue )
		tempData.scale.z = math.Round( zSlider:GetValue() )
	end

	yPos = yPos + zSlider:GetTall() + padding 

	------------------
	--Bone Selection--
	------------------

	local boneChoice = vgui.Create("DListView", visible)
	boneChoice:SetPos(10,yPos)
	boneChoice:SetMultiSelect(false)
	boneChoice:AddColumn("Bone")
	boneChoice:SetSize(buttonWidth, 100)	
	for index, bone in pairs(Bones) do
		local line = boneChoice:AddLine(bone)
		function line:OnSelect()
			tempData.bone = bone
		end
	end

	yPos = yPos + boneChoice:GetTall() + padding

	--------------
	--Hold Types--
	--------------

	local holdType = vgui.Create("DListView", visible)
	holdType:SetPos(10,yPos)
	holdType:SetMultiSelect(false)
	holdType:AddColumn("Hold Type")
	holdType:SetSize(buttonWidth, 100)	
	for index, hold in pairs(holdTypes) do
		local line = holdType:AddLine(hold)
		function line:OnSelect()
			LocalPlayer():GetActiveWeapon():SetWeaponHoldType(hold)
		end
	end

	yPos = yPos + holdType:GetTall() + padding

end

local function openFileTab(parent)
	------------------
	--Saving/Loading--
	------------------

	local saving = parent:Add("DPanel")
	parent:AddSheet( "Saving", saving, "icon16/box.png" )

	local yPos = 10
	local padding = 10
	local buttonWidth = parent:GetWide() - 40
	
	local loadChoice = vgui.Create("DListView", saving)
	loadChoice:SetPos(10, yPos)
	loadChoice:SetMultiSelect(false)
	loadChoice:AddColumn("Files")
	loadChoice:SetSize(buttonWidth, 170)	
	loadChoice.update = function() 
		loadChoice:Clear()

		local files, folders = file.Find( string.lower(string.gsub(GAMEMODE.Name, " ", "")) .. "/items/*", "DATA")
		for index, name in pairs(files) do
			local line = loadChoice:AddLine(name)
			function line:OnSelect()
				loadChoice.selected = name
			end
		end	
	end
	loadChoice.update()

	yPos = yPos + loadChoice:GetTall() + padding	

	local loadButton = vgui.Create("DButton", saving)
	loadButton:SetSize(buttonWidth, 20)
	loadButton:SetPos(10, yPos)	
	loadButton:SetText("Load")
	function loadButton:DoClick()
		local fileName = string.lower(string.gsub(GAMEMODE.Name, " ", "")) .. "/items/" .. loadChoice.selected

		local parsedString = file.Read(fileName, "DATA")
		local parsedTable = util.KeyValuesToTable(parsedString)
		
		tempData = {
		model = parsedTable["model"],
		bone = parsedTable["bone"],
		color = Color((parsedTable["color"].r) or 255, (parsedTable["color"].g) or 255, (parsedTable["color"].b) or 255, (parsedTable["color"].a) or 255), 
		skin = tonumber(parsedTable["skin"]),
		material = parsedTable["material"],
		pos = util.fromVectorTable(parsedTable["pos"]) or Vector(0,0,0),
		ang = util.fromAngleTable(parsedTable["ang"]) or Angle(0,0,0),
		scale = util.fromVectorTable(parsedTable["scale"]) or Vector(0,0,0),
		}
	end

	yPos = yPos + loadButton:GetTall() + padding

	local outputButton = vgui.Create("DButton", saving)
	outputButton:SetSize(buttonWidth, 20)
	outputButton:SetPos(10, yPos)	
	outputButton:SetText("Output Code")
	function outputButton:DoClick()

	end

	yPos = yPos + outputButton:GetTall() + padding	

	local outputButtonS = vgui.Create("DButton", saving)
	outputButtonS:SetSize(buttonWidth, 20)
	outputButtonS:SetPos(10, yPos)	
	outputButtonS:SetText("Output Code ( shorthand )")
	function outputButtonS:DoClick()
		
	end

	yPos = yPos + outputButtonS:GetTall() + padding	

	local itemName = vgui.Create("DTextEntry", saving)
	itemName:SetPos(10, yPos)
	itemName:SetSize(buttonWidth, 20)
	itemName:SetText("<Save Path>")

	yPos = yPos + itemName:GetTall() + padding

	local saveButton = vgui.Create("DButton", saving)
	saveButton:SetSize(buttonWidth, 20)
	saveButton:SetPos(10, yPos)
	saveButton:SetText("Save")
	function saveButton:DoClick()
		local fileName = string.lower(string.gsub(GAMEMODE.Name, " ", "")) .. "/items/"

		local saveTable = table.Copy(tempData)

		saveTable["pos"] = util.toVectorTable(saveTable["pos"])
		saveTable["ang"] = util.toAngleTable(saveTable["ang"])
		saveTable["scale"] = util.toVectorTable(saveTable["scale"])

		local saveString = util.TableToKeyValues(saveTable)

		file.CreateDir( fileName )

		fileName = fileName .. itemName:GetText() .. ".txt"

		file.Write(fileName, saveString)

		loadChoice.update()
	end

	yPos = yPos + saveButton:GetTall() + padding


	local applyButton = vgui.Create("DButton", saving)
	applyButton:SetSize(buttonWidth, 20)
	applyButton:SetPos(10, yPos)
	applyButton:SetText("Apply")
	function applyButton:DoClick()
		local dupeTable = {}
		dupeTable.pos = Vector(tempData.pos.x, tempData.pos.y, tempData.pos.z)
		dupeTable.ang = Angle(tempData.ang.p, tempData.ang.y, tempData.ang.r)
		dupeTable.scale = Vector(tempData.scale.x, tempData.scale.y, tempData.scale.z)
		dupeTable.bone = tempData.bone
		dupeTable.material = tempData.material
		dupeTable.color = tempData.color
		dupeTable.model = tempData.model

		getPaperdollManager().register( LocalPlayer(), "DEVEDIT", dupeTable )
	end

	yPos = yPos + applyButton:GetTall() + padding	
end

local function openPaperDollEditor()
	local frame = vgui.Create("DFrame")
	frame:SetSize(400,700)
	frame:SetTitle("Item Editor")
	frame:MakePopup()
	frame:SetPos( ScrW() - 420, 10 )

	local propertySheet = vgui.Create("DPropertySheet", frame)
	local parent = propertySheet:GetParent()
	propertySheet:SetSize(parent:GetWide() - 20, parent:GetTall() - 35 )
	propertySheet:SetPos(10, 25)

	openModelTab(propertySheet)

	openFileTab(propertySheet)

end
concommand.Add("openPaperDollEditor", openPaperDollEditor)

concommand.Add("paperDollModel", function(ply, cmd, args) tempData.model = tostring(args[1]) print(tempData.model) end)

local function selectModel()
	local frame = vgui.Create("DFrame")
	frame:SetSize( 500, 200 )
	frame:SetPos( 20, 10 )
	frame:SetTitle("Select A Model")
	frame:MakePopup()

	local sPanel = vgui.Create("DPanelSelect", frame)
	sPanel:SetSize(250, 170)
	sPanel:SetPos(230, 25)

	local boneChoice = vgui.Create("DListView", frame)
	boneChoice:SetPos(10,25)
	boneChoice:SetMultiSelect(false)
	boneChoice:AddColumn("SpawnLists")
	boneChoice:SetSize(200, 170)	

	local files, folders = file.Find( 'settings/spawnlist/default/*', "GAME")
	for index, name in pairs(files) do
		local line = boneChoice:AddLine(name)
		function line:OnSelect()
			sPanel:Clear()
			local read = file.Read("settings/spawnlist/default/"..name, "GAME")
			if read then 
				local modelTable = util.KeyValuesToTable(read) 
				if modelTable != nil && modelTable['contents'] != nil then
					for name, modelData in pairs( modelTable['contents'] ) do

						local icon = vgui.Create( "SpawnIcon" )
						icon:SetModel( modelData['model'] )
						icon:SetSize( 32, 32 )
						icon:SetTooltip( modelData['model'] )

						sPanel:AddPanel( icon, { paperDollModel = modelData['model'] } )

					end					
				end	
			end
		end
	end	

end
concommand.Add("openModelSelector", selectModel)

-- local tempEnt = nil 

-- local function paperDoll()
-- 	if !IsValid(tempEnt) then
-- 		tempEnt = ents.CreateClientProp()
-- 	end
-- 	local bone = tempData.bone
-- 	local pos
-- 	local ang

-- 	if bone == "none" then 
-- 		pos = LocalPlayer():GetPos() 
-- 		ang = LocalPlayer():GetAngles() 
-- 	else
-- 		bone = LocalPlayer():LookupBone(tempData.bone)
-- 		pos,ang = LocalPlayer():GetBonePosition( bone or "ValveBiped.Bip01_R_Hand" )
-- 	end

-- 	tempEnt:SetAngles(ang)
-- 	tempEnt:SetAngles(tempEnt:LocalToWorldAngles(tempData.ang or Angle(0,0,0)))
-- 	tempEnt:SetPos(pos)
--  	tempEnt:SetPos(tempEnt:LocalToWorld(tempData.pos or Vector(0,0,0)))
-- 	tempEnt:SetModel(tempData.model)

-- 	if tempData.scale != Vector(1,1,1) then
-- 		local mat = Matrix()
-- 		mat:Scale( tempData.scale )
-- 		tempEnt:EnableMatrix( "RenderMultiply", mat )
-- 	end

-- 	tempEnt:SetColor(tempData.color)
-- 	tempEnt:SetMaterial(tempData.material)
	
-- 	if DEV_Model_Manager_List != nil && DEV_Model_Manager_List:IsValid() && tempData.Override != nil then
-- 		tempEnt:SetColor(tempData.override)
-- 	end
-- end
-- hook.Add("CalcView", "paperDollHook", paperDoll)

end