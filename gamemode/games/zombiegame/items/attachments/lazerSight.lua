local class = "lazerSight"

local function generate()
	local item = classAttachmentData.new()
	item.setClass(class)
	item.setName("Lazer Sight")
	item.setDescription("Requires a Detonator to use")
	item.setModel("models/weapons/w_c4_planted.mdl")
	item.setPrimaryEQSlot(-3)
	return item
end

--classItemData.register( class, generate )