local class = "medkit"

local function generate()
	local weapon = classItemData.genItem("meleeBase")
	weapon.setClass(class)
	weapon.setName("Medkit")
	weapon.setModel("models/w_models/weapons/w_eq_medkit.mdl")
	weapon.setFireRate(0.5)
	weapon.setDamage(15)
	weapon.setHoldType("slam")
	weapon.setPrimaryEQSlot(-2)
	weapon.setAttackRange(80)
	weapon.setShouldDraw(false)
	
	function weapon.paperDoll( player )
	    local tempData = {}
	    tempData.model = weapon.getModel()
	    tempData.bone = "ValveBiped.Bip01_R_Hand"
	    tempData.color = Color(255,255,255,255)
	    tempData.skin = 1
	    tempData.material = ""
	    tempData.pos = Vector(-2.5,0,-7.5)
	    tempData.ang = Angle(260, 0, 0)
		tempData.scale = Vector(1,1,1)

		return tempData
	end

	function weapon.deploy( user )
		if IsValid(user) then 
			getPaperdollManager().register(user, "weapon", weapon.paperDoll( user:IsPlayer() )) 
		end
	end

	function weapon.holster( user )
		if IsValid(user) then 
			getPaperdollManager().clearTag(user, "weapon")
		end
	end	

	function weapon.hitPlayer(self, entity)
	    if math.random(0,1/(0.5)) == 1 then
	        entity:applyEffect("poison")
	    end
	end

	function weapon.equipEffect( self )
	    self:setAttackSpeed(1.7)
	    weapon.setDamage(self:getAttackDamage())
	end

	function weapon.secondaryFire( self, wep )
		return false
	end

	weapon.setExtras( "8" ) -- Default holds 8 rounds
	if CLIENT then
		weapon.paintOverHook = function( panel )
			local healsLeft = tostring(weapon.getExtras()) or 0
			local x, y = panel:GetWide(), panel:GetTall()
			paintText("x" .. healsLeft, "zgEffectText", 2, y - 10, nil, false, true)
		end
	end	

	return weapon
end

-- classItemData.register( class, generate )

-- if SERVER then
-- 	classScarcity.addItemToCategory(1, class)
-- end
