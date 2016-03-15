if SERVER then
	function outcomeScreen( ply )
		ply:ConCommand("openOutcomeScreen")
	end
	hook.Add("ShowSpare1", "outcomeScreen", outcomeScreen)

	concommand.Add("claimReward", function(ply, cmd, args)
			if ply.canRollReward then
				local reward = classScarcity.rollItem( 0 )

				ply:SetNWString("rewardItem", reward)
				timer.Simple(6, function()
					local item = classItemData.genItem(reward)
					ply:ChatPrint("Congratulations, you have won a ".. item.getName() .. " for being victorious")
					if !ply:getInventory().addItem( item ) then
						if !ply:getFate().getInventory().addItem( item ) then
							ply:ChatPrint("your fatebank is full, looks like no reward for you!")
						else
							ply:ChatPrint("because your inventory is full, it was sent to your fate bank")
						end
					end	
				end)
				ply.canRollReward = false
			end
	 end)
else


local function loadPerformance( parent )
	local rollButton

	function parent:Paint()
		surface.SetDrawColor(55,55,55,70)
		surface.DrawRect(0,0,self:GetWide(), self:GetTall())

		surface.SetDrawColor(0,0,0,70)
		surface.DrawRect(1,1,self:GetWide()-2, self:GetTall()-2)

		-- paintText("Mission De-brief", "zgEffectText", self:GetWide()/2, 20, Color(255,255,255,255), true, true)

		-- local yPos = 50 

		-- paintText("Zombies Killed : ", "zgEffectText", 20, yPos, Color(255,255,255,255), false, true)
		-- yPos = yPos + 20 
		-- paintText("Agents Lost : ", "zgEffectText", 20, yPos, Color(255,255,255,255), false, true)
		-- yPos = yPos + 20 
		-- paintText("Objective Achieved : ", "zgEffectText", 20, yPos, Color(255,255,255,255), false, true)
		-- yPos = yPos + 20 
		-- paintText("Cures Used : ", "zgEffectText", 20, yPos, Color(255,255,255,255), false, true)
		-- yPos = yPos + 20 
		-- paintText("Ammunition Used : ", "zgEffectText", 20, yPos, Color(255,255,255,255), false, true)
		-- yPos = yPos + 20 
		-- paintText("Threats Eliminated : ", "zgEffectText", 20, yPos, Color(255,255,255,255), false, true)
		-- yPos = yPos + 20 
		-- paintText("Survivors Rescued : ", "zgEffectText", 20, yPos, Color(255,255,255,255), false, true)
		-- yPos = yPos + 20 
		if GetGlobalString("victory") == "" then 
		elseif GetGlobalString("victory") == "Defeat" then
			paintText("You've failed, succeed in your mission if you want a reward", "zgEffectText", self:GetWide()/2, self:GetTall()/2, Color(255,255,255,255), true, true)
		elseif GetGlobalString("victory") == "Victory" then
			if !IsValid(rollButton) then
				rollButton = vgui.Create("DModelPanel", self)
				if self:GetWide() > self:GetTall() then
					rollButton:SetSize( self:GetTall() - 10, self:GetTall() - 10 )
				else
					rollButton:SetSize( self:GetWide() - 10, self:GetWide() - 10 )
				end
				rollButton:SetPos(self:GetWide()/2 - rollButton:GetWide()/2, self:GetTall()/2 - rollButton:GetTall()/2)
				local nextChange = 0
				local nextTime = 1
				if LocalPlayer():GetNWString("rewardItem") == "" then
					function rollButton:Think()
						if nextChange < CurTime() then
							util.DModelPanelCenter(rollButton, classItemData.getTemplate(util.randomItem("weapon")).getModel()) 
							nextChange = CurTime() + nextTime
						end
					end
					function rollButton:PaintOver()
						paintText("Click To Claim Prize", "zgEffectText", self:GetWide()/2, self:GetTall()/2, Color(255,255,255,255), true, true)
					end

					function rollButton:DoClick()
						nextTime = 0.001
						nextChange = 0
						RunConsoleCommand("claimReward")
						function rollButton:PaintOver() end
						function rollButton:Think()
							if nextChange < CurTime() then
								util.DModelPanelCenter(rollButton, classItemData.getTemplate(util.randomItem("weapon")).getModel())
								nextTime = math.pow(nextTime, 0.97)
								if nextTime > 0.2 then
									nextTime = nextTime + 0.1
								end
								if nextTime > 0.8 then
									nextChange = CurTime() + 100
									util.DModelPanelCenter(rollButton, classItemData.getTemplate(LocalPlayer():GetNWString("rewardItem")).getModel())
									function rollButton:PaintOver() 
										paintText(classItemData.getTemplate(LocalPlayer():GetNWString("rewardItem")).getName(), "zgEffectText", self:GetWide()/2, self:GetTall()/2, Color(255,255,255,255), true, true)
									end
								else
									nextChange = CurTime() + nextTime
								end
							end
						end
					end
				else					
					util.DModelPanelCenter(rollButton, classItemData.getTemplate(LocalPlayer():GetNWString("rewardItem")).getModel()) 
					function rollButton:PaintOver() 
						paintText(classItemData.getTemplate(LocalPlayer():GetNWString("rewardItem")).getName(), "zgEffectText", self:GetWide()/2, self:GetTall()/2, Color(255,255,255,255), true, true)
					end					
				end
			end
		end		
	end
end	

local function loadStatus( parent, ply )

	local plyPanel = vgui.Create("DPanel", parent)
	plyPanel:SetSize( parent:GetWide() - 10, 55 )

	function plyPanel:Paint()
		surface.SetDrawColor(55,55,55,70)
		surface.DrawRect(0,0,self:GetWide(), self:GetTall())

		surface.SetDrawColor(0,0,0,70)
		surface.DrawRect(1,1,self:GetWide()-2, self:GetTall()-2)

		paintText("Agent : "..ply:GetNWString("charName"), "zgEffectText", self:GetWide()/4, 15, Color(255,255,255,255), false, true)

		paintText("Status : ", "zgEffectText", self:GetWide()/4, 40, Color(255,255,255,255), false, true)
		if util.isActivePlayer(ply) then
			paintText("Alive", "zgEffectText", self:GetWide()/2, 40, Color(55,255,55,255), false, true)
		else
			paintText("Killed In Action", "zgEffectText", self:GetWide()/2, 40, Color(255,55,55,255), false, true)
		end
	end	

	local background = vgui.Create("AvatarImage", plyPanel)
	local parent = background:GetParent()
	background:SetPlayer(ply)
	background:SetSize(50, 50)
	background:SetPos(2.5, 2.5)

	return plyPanel
end

local function loadOtherStats(parent)
	local xPos = 5
	local yPos = 10
	for key, ply in pairs(player.GetAll()) do
		local plyPanel = loadStatus(parent, ply)
		plyPanel:SetPos(xPos,yPos)
	end
end

local victoryFrame
function openOutcomeScreen()
	if !IsValid(victoryFrame) then
		victoryFrame = vgui.Create("DFrame")
		victoryFrame:SetSize(ScrW(), ScrH())
		victoryFrame:SetTitle("")
		victoryFrame:MakePopup()
		function victoryFrame:Paint()
			Derma_DrawBackgroundBlur( vgui.GetWorldPanel(), victoryFrame.m_fCreateTime )
		end

		local outcomePanel = vgui.Create("DPanel", victoryFrame)
		outcomePanel:SetSize(outcomePanel:GetParent():GetWide()/4, outcomePanel:GetParent():GetTall()/8)
		outcomePanel:SetPos(outcomePanel:GetParent():GetWide()/2 - outcomePanel:GetWide()/2, 40)
		function outcomePanel:Paint()
			if GetGlobalString("victory") == "" then
				paintText("Mission Pending...", "zgTimerText", self:GetWide()/2, 20, Color(255,255,55,255), true, true)
			else
				if GetGlobalString("victory") == "Victory" then
					paintText("Victory!", "zgTimerText", self:GetWide()/2, 20, Color(55,255,55,255), true, true)
				elseif GetGlobalString("victory") == "Defeat" then
					paintText("Defeat!", "zgTimerText", self:GetWide()/2, 20, Color(255,55,55,255), true, true)
				end
			end
		end

		-- mission Stats panel
		local mSPanel = vgui.Create("DPanel", victoryFrame)
		mSPanel:SetSize( mSPanel:GetParent():GetWide()/4 - 20, mSPanel:GetParent():GetTall()/2 - 20)
		mSPanel:SetPos( 20, mSPanel:GetParent():GetTall()/8 )

		loadPerformance( mSPanel )

		local x,y = util.findEndPositions(mSPanel)
		-- personal Stats Panel
		local pSPanel = vgui.Create("DPanel", victoryFrame)
		pSPanel:SetSize( pSPanel:GetParent():GetWide()/2 - 40, pSPanel:GetParent():GetTall()/2 - 20)
		pSPanel:SetPos( x + 20, pSPanel:GetParent():GetTall()/8 )
		openGoalsMenu(pSPanel)
		function pSPanel:Paint()
			surface.SetDrawColor(55,55,55,70)
			surface.DrawRect(0,0,self:GetWide(), self:GetTall())

			surface.SetDrawColor(0,0,0,70)
			surface.DrawRect(1,1,self:GetWide()-2, self:GetTall()-2)
		end

		local x,y = util.findEndPositions(pSPanel)

		-- others Stats
		local oSPanel = vgui.Create("DPanel", victoryFrame)
		oSPanel:SetSize( oSPanel:GetParent():GetWide()/4 - 20, oSPanel:GetParent():GetTall()/2 - 20)
		oSPanel:SetPos( x + 20, oSPanel:GetParent():GetTall()/8 )
		function oSPanel:Paint()
			surface.SetDrawColor(55,55,55,70)
			surface.DrawRect(0,0,self:GetWide(), self:GetTall())

			surface.SetDrawColor(0,0,0,70)
			surface.DrawRect(1,1,self:GetWide()-2, self:GetTall()-2)
		end

		loadOtherStats( oSPanel )

		local missionLabelPanel = vgui.Create("DPanel", victoryFrame)
		missionLabelPanel:SetSize(missionLabelPanel:GetParent():GetWide()/4, missionLabelPanel:GetParent():GetTall() * (2/3) - (y + 10)  )
		missionLabelPanel:SetPos(missionLabelPanel:GetParent():GetWide()/2 - missionLabelPanel:GetWide()/2, y + 10)
		function missionLabelPanel:Paint()
			paintText("Next Mission Deployment", "zgEffectText", self:GetWide()/2, self:GetTall()/2, Color(255,255,255,255), true, true)
		end

		local nextMissionPanel = vgui.Create("DPanel", victoryFrame)
		nextMissionPanel:SetSize( nextMissionPanel:GetParent():GetWide() - 40, nextMissionPanel:GetParent():GetTall()/3 - 20)
		nextMissionPanel:SetPos( 20, nextMissionPanel:GetParent():GetTall() * (2/3) + 10)
		function nextMissionPanel:Paint()
			surface.SetDrawColor(55,55,55,70)
			surface.DrawRect(0,0,self:GetWide(), self:GetTall())

			surface.SetDrawColor(0,0,0,70)
			surface.DrawRect(1,1,self:GetWide()-2, self:GetTall()-2)
		end


		local availibleMissions = getBallet().getBallet()

		local xPos = nextMissionPanel:GetWide()/6
		local yPos = nextMissionPanel:GetTall()/2

		local selectedKey

		for key, data in pairs(availibleMissions) do
			local missionButton = vgui.Create("DImageButton", nextMissionPanel)
			missionButton:SetSize(nextMissionPanel:GetTall()-20, (nextMissionPanel:GetTall()-20)*(3/4))
			missionButton:SetPos(xPos - missionButton:GetWide()/2, yPos - missionButton:GetTall()/2)
			missionButton:SetImage("maps/"..data.map)
			function missionButton:DoClick()
				selectedKey = key
				RunConsoleCommand("balletVote", tostring(key))
			end
			function missionButton:PaintOver()
				paintText("Objective : " .. data.mode , "zgEffectText", self:GetWide()/2, 25, Color(255,255,255,255), true, true)
				local diffColor = Color(255,55,55,255)
				if data.difficulty == "Moderate" then
					diffColor = Color(255,255,255,255)
				elseif data.difficulty == "Easy" then
					diffColor = Color(55,255,55,255)
				end
				paintText(data.difficulty , "zgEffectText", self:GetWide()/2, self:GetTall() - 25, diffColor, true, true)
				if selectedKey == key then
					surface.SetDrawColor(diffColor.r, diffColor.g, diffColor.b, 255)
				else
					surface.SetDrawColor( 0, 0, 0, 255 )
				end
				surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
			end

			xPos = xPos + missionButton:GetWide() + nextMissionPanel:GetWide()/6
		end

	end
end
concommand.Add("openOutcomeScreen", function(ply,cmd,args) openOutcomeScreen() end)

end