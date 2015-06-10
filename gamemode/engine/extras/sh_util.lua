function util.within2DBox( min, max, comparePos)
	if min.x < comparePos.x && min.y < comparePos.y && max.x > comparePos.x && max.y > comparePos.y then
		return true
	end
end

function util.randRadius(origin, min, max)
	max = max or min
	distance = math.random(min, max)
	angle = math.random(0, 360)
	return origin + Vector(math.cos(angle) * distance, math.sin(angle) * distance, 0)
end

function util.DModelPanelCenter( mdlPanel, model, distance )
	distance = distance or 1
	local entity = ents.CreateClientProp()
	entity:SetModel(model)
	entity:Spawn()

	mdlPanel:SetModel( model )	
	local center = entity:OBBCenter()
	local dist = entity:BoundingRadius() * distance

	mdlPanel:SetLookAt( center )
	mdlPanel:SetCamPos( center + Vector(dist,dist,0) )	

	entity:Remove()
end

local itemTable
local equipmentTable
local weaponTable

function util.RefreshItems()
	itemTable = {}
	equipmentTable = {}
	weaponTable = {}	
	for key, data in pairs(classItemData.items) do
		if string.gsub(key, "Base", "") == key then
			local item = data.gen()
			if item.isEquipment() then
				if item.isWeapon() then
					table.insert(weaponTable, item.getClass())
				else
					table.insert(equipmentTable, item.getClass())
				end
			else
				table.insert(itemTable, item.getClass())
			end	
		end			
	end
end

function util.combineTables( tableTo, tableFrom )
	for _,data in pairs(tableFrom) do
		table.insert(tableTo, data)
	end
end

function util.randomItems(type)
	if itemTable == nil && equipmentTable == nil && weaponTable == nil then util.RefreshItems() end
	local pool = {}
	if type == "all" then
		util.combineTables(pool, weaponTable)
		util.combineTables(pool, itemTable)
		util.combineTables(pool, equipmentTable)
	else
		if string.gsub(type, "weapon", "") != type then 
			util.combineTables(pool, weaponTable)
		end
		if string.gsub(type, "item", "") != type then 
			util.combineTables(pool, itemTable)
		end	
		if string.gsub(type, "equipment", "") != type then 
			util.combineTables(pool, equipmentTable)
		end	
	end

	return pool
end

function util.randomItem(type)
	local returnValue = table.Random(util.randomItems(type))
	return returnValue
end

function util.FindScreenCoordinates(panel)
	local parent = panel:GetParent()
	if parent && parent != vgui.GetWorldPanel() then
		local prntX, prntY = util.FindScreenCoordinates(parent)
		return xpos + prntX, ypos + prntY	
	end
	return xpos, ypos
end

function util.isActivePlayer(ply)
	if ply:Alive() && ply:GetObserverMode() == OBS_MODE_NONE then
		return true
	end	
	return false
end

function util.getAlivePlayers() 
	local returnTable = {}
	for index, ply in pairs(player.GetAll()) do
		if ply:Alive() && ply:GetObserverMode() == OBS_MODE_NONE then
			table.insert(returnTable, ply)
		end
	end
	return returnTable
end

