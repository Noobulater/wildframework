local class = "fo_radio"

local function generate()
	local item = classItemData.new()
	item.setClass(class)
	item.setName("Radio")
	item.setDescription("It works... I just have to find a place to set it up")
	item.setModel("models/props_lab/citizenradio.mdl")
	item.setTemporary(true)
	item.setReusable(true)

	item.use = function( user ) 
				if SERVER then 
					if user:IsPlayer() then
						local trace = user:GetEyeTraceNoCursor()
						if trace.Hit then
							-- local keypad = table.Random(ents.FindByName("keypad"))
							-- if IsValid(trace.Entity) && trace.Entity == keypad then
							-- 	keypad.useFunc(user)
							-- end
						end
					end 
				end 
			end 

	function item.isItem()
		return false
	end

	return item
end

classItemData.register( class, generate )