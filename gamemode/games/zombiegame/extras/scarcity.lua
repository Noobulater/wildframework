classScarcity = {}

classScarcity.scarcities = {}
classScarcity.scarcities[1] = { threshHold = .40 , itemList = {} } -- 60% of the time u will get a common item
classScarcity.scarcities[2] = { threshHold = .20 , itemList = {} } -- 20% of the time u will get an uncommon item
classScarcity.scarcities[3] = { threshHold = .8 , itemList = {} } -- 12% of the time u will get a scare item
classScarcity.scarcities[4] = { threshHold = .01 , itemList = {} } -- 7% of the time u will get a rare item
classScarcity.scarcities[5] = { threshHold = 0.00 , itemList = {} } -- 1% of the time u will get a unique Item

function classScarcity.addItemToCategory(category, itemClass)
	table.insert(classScarcity.scarcities[category].itemList, itemClass)
end

function classScarcity.rollItem( modifier, bonus )
	local result = math.random() * (modifier or 1) + (bonus or 0)

	--print(result)

	local category = 1
	local threshHold
	-- this needs to be sequential otherwise table sort messes it up

	for i = 1, table.Count(classScarcity.scarcities) do
		local threshHold = classScarcity.scarcities[i].threshHold
		if result < threshHold then
			category = i
		else
			break
		end
	end

	--print(category)

	if table.Count(classScarcity.scarcities[category].itemList) <= 0 then print("ERROR IN SCARCITIES, ITEMTABLE EMPTY") return 0 end

	local result = table.Random( classScarcity.scarcities[category].itemList )

	return result
end