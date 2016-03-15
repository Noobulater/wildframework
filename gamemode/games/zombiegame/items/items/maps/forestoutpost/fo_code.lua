local class = "fo_code"

local function generate()
	local item = classItemData.new()
	item.setClass(class)
	item.setName("Key Pad Code")
	item.setDescription("Unlocks Access to the keypad door")
	item.setModel("models/props_lab/clipboard.mdl")
	item.setTemporary(true)
	item.setReusable(true)

	item.use = function( user ) 
				if SERVER then 
					if user:IsPlayer() then
						local trace = user:GetEyeTraceNoCursor()
						if trace.Hit then
							local keypad = table.Random(ents.FindByName("keypad"))
							if IsValid(trace.Entity) && trace.Entity == keypad then
								keypad.useFunc(user)
							end
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