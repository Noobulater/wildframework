if SERVER then

concommand.Add("claimPrize", function(ply,cmd,args) 
	local goalName = args[1] 
	local prize = args[2] 

	local manager = getGoalManager()
	if !manager then return end

	local goal = manager.getGoal(goalName)
	local removePlayer 
	for index, winner in pairs(goal.getWinners()) do
		if IsValid(ply) && table.HasValue( goal.getPrizes(), prize ) && winner == ply then
			local item = classItemData.genItem(prize)
			ply:ChatPrint("Congratulations, you have won a ".. item.getName())
			if !ply:getInventory().addItem( item ) then
				if !ply:getFate().getInventory().addItem( item ) then
					ply:ChatPrint("your fatebank is full, looks like no reward for you!")
				else
					ply:ChatPrint("because your inventory is full, it was sent to your fate bank")
				end
			end			
			removePlayer = ply
			break
		end
	end
	if removePlayer != nil then
		local winners = goal.getWinners()
		for index, winner in pairs(winners) do
			if winner == removePlayer then
				table.remove(winners, index)
			end
		end
		goal.setWinners(winners)
	end
end)

end

if CLIENT then

surface.CreateFont( "zgGoalTitle", {
 font = "HUDNumber1",
 size = 16,
 weight = 600,
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
 outline = false
} )

surface.CreateFont( "zgRewardText", {
 font = "UIBold",
 size = 12,
 weight = 200,
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


local goalsMenu 

function openGoalsMenu(parentPanel)
	if !getGoalManager() then return end
	local goals = getGoalManager().getGoals()
	local numGoals = (table.Count(goals) or 0)

	local yPos = 0 
	local xPos = 5
	for key, data in pairs(goals) do
		local goalPanel = vgui.Create("DPanel", parentPanel)
		local parent = goalPanel:GetParent()

		goalPanel:SetSize(parent:GetWide(), math.Clamp(parent:GetTall() / numGoals, 50, 75))
		goalPanel:SetPos(0, yPos)

		local title = vgui.Create("DLabel", goalPanel)
		local parent = title:GetParent()
		title:SetText(data.getName())
		title:SetFont("zgGoalTitle")
		title:SetPos(10, 10)
		title:SetTextColor( Color(0,0,0,255) )
		title:SizeToContents()

		if data.getWinners() == nil or table.Count(data.getWinners()) <= 0 then
			local description = vgui.Create("DLabel", goalPanel)
			local parent = description:GetParent()
			description:SetText(data.getDescription())
			description:SetTextColor( Color(0,0,0,255) )
			description:SetPos(20, 25)
			description:SetWrap(true)
			description:SetSize(goalPanel:GetWide()/2 - 20, goalPanel:GetTall() - 40)
		else
			title:SetText(title:GetText() .. "(Winners Below!)")
			title:SetTextColor( Color(0,255,0,255) )
			title:SizeToContents()
		end	

		xPos = 5	

		if data.getPrizes() then
			for index, prize in pairs(data.getPrizes()) do
				if prize != nil then
					local item = classItemData.genItem(prize)

					local background = vgui.Create("DPanel", goalPanel)
					local parent = background:GetParent()

					background:SetSize(parent:GetTall() - 10, parent:GetTall() - 10)
					background:SetPos(parent:GetWide() - background:GetWide() - 5 - xPos,5)
					background.Paint = function()
							-- surface.SetDrawColor( 0, 0, 0, 255)
							-- surface.DrawRect( 0, 0, background:GetWide(), background:GetTall())
							if background.color then
								surface.SetDrawColor( background.color.r, background.color.g,  background.color.b,  background.color.a )
								surface.DrawOutlinedRect(2, 2, background:GetWide() - 4, background:GetTall() - 4)
							end
					end

					local mdl = vgui.Create("DModelPanel", background)
					local parent = mdl:GetParent()
					mdl:SetSize(parent:GetWide(), parent:GetTall())
					mdl:SetPos(0,0)
					util.DModelPanelCenter(mdl, item.getModel())
					function mdl:PaintOver()
						paintText(item.getName(), "zgRewardText", self:GetWide()/2, self:GetTall()/2, Color(255,255,255,255), true, true)
						for index, ply in pairs(data.getWinners() or {}) do
							if ply == LocalPlayer() then 
								paintText("Click To Claim", "zgRewardText", mdl:GetWide()/2, 20, nil, true, true)
							end
						end
					end

					mdl.DoClick = function() 
						for index, ply in pairs(data.getWinners() or {}) do
							if ply == LocalPlayer() then 
								 	local dMenu = DermaMenu()
							 		dMenu:AddOption("Claim Prize", function() 
								 		RunConsoleCommand("claimPrize", data.getClass(), prize) 
								 		if !data.claimed then
								 			background.color = Color(0,255,0,255) 
								 		end
								 	data.claimed = true
							 	end)
							 	dMenu:Open()
							 	dMenu.Think = function() if !IsValid(goalsMenu) then dMenu:Remove() end end
								return
							end
						end
					end

					xPos = xPos + background:GetWide() + 5
				end
			end
		end

		xPos = 5

		for index, ply in pairs(data.getWinners() or {}) do
			if IsValid(ply) then
				local background = vgui.Create("AvatarImage", goalPanel)
				local parent = background:GetParent()
				background:SetPlayer(ply)
				background:SetSize((parent:GetTall() - 10)/2, (parent:GetTall() - 10)/2)
				background:SetPos( 5 + xPos ,5 + background:GetTall()/2)

				xPos = xPos + background:GetWide() + 5
			end
		end
		yPos = yPos + goalPanel:GetTall()
	end

	return parentPanel
end

concommand.Add("showGoals", openGoalsMenu)


end