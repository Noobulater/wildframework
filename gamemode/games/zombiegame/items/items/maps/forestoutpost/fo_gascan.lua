local class = "fo_gascan"

local function generate()
	local item = classItemData.new()
	item.setClass(class)
	item.setName("Metal Gas Can")
	item.setDescription("Contains gasoline")
	item.setModel("models/props_junk/metalgascan.mdl")
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