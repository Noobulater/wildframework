classPaperdoll = {}

function classPaperdoll.new()
	local public = {}

	local managed = {}

	function public.getEntities()
		return managed
	end

	function public.register( entity, itemClass )
		local item = classItemData.getTemplate(itemClass)
		if item.paperDoll == nil then print("paperdoll : item doesn't have paperDoll data") return false end
		if managed[entity] != nil then
			table.insert(managed[entity], item.paperDoll( entity ) )
		else
			managed[entity] = { item.paperDoll( entity ) }
		end
	end

	return public
end

local pdManager = classPaperdoll.new()

function getPaperdollManager()
	return pdManager
end

local function paperDoll()
	local data = pdManager.getEntities()
	for entity, paperData in pairs(data) do
		if IsValid(entity) then
			for index, entity in pairs(paperData) do
				
			end
		end
	end

end

hook.Add("CalcView", "paperDoll", paperDoll)