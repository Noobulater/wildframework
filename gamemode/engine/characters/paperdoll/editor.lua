
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

	local visible = propertySheet:Add("DPanel")
	propertySheet:AddSheet( "Model", visible, "icon16/user.png" )

	local parent = propertySheet

	local yPos = 10
	local padding = 10

	local modelName = vgui.Create("DTextEntry", visible)
	modelName:SetPos(10,yPos)
	modelName:SetSize((parent:GetWide() - 40)/2 - 10, 20)
	modelName:SetText(tostring(tempData.model))
	modelName:SetConVar("paperDollModel")
	function modelName:Think()
		modelName:SetValue(tempData.model)
	end

	local modelButton = vgui.Create("DButton", visible)
	modelButton:SetSize((parent:GetWide() - 40)/2 - 10, 20)
	modelButton:SetPos(parent:GetWide() - 40 - modelButton:GetSize() ,yPos)
	modelButton:SetText("Open Model Browser")
	function modelButton:DoClick()
		RunConsoleCommand("openModelSelector")
	end

	yPos = yPos + modelName:GetTall() + padding

	local title = vgui.Create("DLabel", visible)
	title:SetPos(10,yPos)
	title:SetSize(parent:GetWide() - 40, 20)
	title:SetText("Vector(x,y,z)")
	title:SetColor(Color(0,0,0,255))

	yPos = yPos + title:GetTall() + padding

	local xSlider = vgui.Create("Slider", visible)
	xSlider:SetPos(10,yPos)
	xSlider:SetSize(parent:GetWide() - 40, 20)
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
	ySlider:SetSize(parent:GetWide() - 40, 20)
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
	zSlider:SetSize(parent:GetWide() - 40, 20)
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
	title:SetSize(parent:GetWide() - 40, 20)
	title:SetText("Angle(p,y,r)")
	title:SetColor(Color(0,0,0,255))

	yPos = yPos + title:GetTall() + padding

	local pSlider = vgui.Create("Slider", visible)
	pSlider:SetPos(10,yPos)
	pSlider:SetSize(parent:GetWide() - 40, 20)
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
	ySlider:SetSize(parent:GetWide() - 40, 20)
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
	rSlider:SetSize(parent:GetWide() - 40, 20)
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
	title:SetSize(parent:GetWide() - 40, 20)
	title:SetText("Scale(x,y,z)")
	title:SetColor(Color(0,0,0,255))

	yPos = yPos + title:GetTall() + padding

	local xSlider = vgui.Create("Slider", visible)
	xSlider:SetPos(10,yPos)
	xSlider:SetSize(parent:GetWide() - 40, 20)
	xSlider:SetMin(-100)
	xSlider:SetMax(100)
	xSlider:SetDecimals(1)
	xSlider:SetValue(1)
	function xSlider:Think( self, newValue )
		tempData.scale.x = math.Round( xSlider:GetValue() )
	end

	yPos = yPos + xSlider:GetTall() + padding

	local ySlider = vgui.Create("Slider", visible)
	ySlider:SetPos(10,yPos)
	ySlider:SetSize(parent:GetWide() - 40, 20)
	ySlider:SetMin(-100)
	ySlider:SetMax(100)
	ySlider:SetDecimals(1)
	ySlider:SetValue(1)
	function ySlider:Think( self, newValue )
		tempData.scale.y = math.Round( ySlider:GetValue() )
	end

	yPos = yPos + ySlider:GetTall() + padding

	local zSlider = vgui.Create("Slider", visible)
	zSlider:SetPos(10,yPos)
	zSlider:SetSize(parent:GetWide() - 40, 20)
	zSlider:SetMin(-100)
	zSlider:SetMax(100)
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
	boneChoice:SetSize(parent:GetWide() - 40, 100)
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
	holdType:SetSize(parent:GetWide() - 40, 100)
	for index, hold in pairs(holdTypes) do
		local line = holdType:AddLine(hold)
		function line:OnSelect()
			LocalPlayer():GetActiveWeapon():SetWeaponHoldType(hold)
		end
	end

	yPos = yPos + holdType:GetTall() + padding


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

	local files, folders = file.Find( 'settings/spawnlist/*', "GAME")
	for index, name in pairs(files) do
		local line = boneChoice:AddLine(name)
		function line:OnSelect()
			sPanel:Clear()
			local read = file.Read("settings/spawnlist/"..name, "GAME")
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
--[[
local tempEnt = nil

local function paperDoll()
	if !IsValid(tempEnt) then
		tempEnt = ents.CreateClientProp()
	end
	local bone = tempData.bone
	local pos
	local ang

	if bone == "none" then
		pos = LocalPlayer():GetPos()
		ang = LocalPlayer():GetAngles()
	else
		bone = LocalPlayer():LookupBone(tempData.bone)
		pos,ang = LocalPlayer():GetBonePosition( bone )
	end



	tempEnt:SetAngles(ang)
	tempEnt:SetAngles(tempEnt:LocalToWorldAngles(tempData.ang or Angle(0,0,0)))
	tempEnt:SetPos(pos)
 	tempEnt:SetPos(tempEnt:LocalToWorld(tempData.pos or Vector(0,0,0)))
	tempEnt:SetModel(tempData.model)
	tempEnt:SetModelScale(tempData.scale.x, tempData.scale.y, tempData.scale.z )
	tempEnt:SetColor(tempData.color)
	tempEnt:SetMaterial(tempData.material)

	-- if DEV_Model_Manager_List != nil && DEV_Model_Manager_List:IsValid() && tempData.Override != nil then
	-- 	tempEnt:SetColor(tempData.override)
	-- end
end
hook.Add("CalcView", "paperDollHook", paperDoll)
]]--
end
