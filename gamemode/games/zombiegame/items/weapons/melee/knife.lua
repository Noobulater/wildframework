local class = "knife"

local function generate()
	local weapon = classItemData.genItem("meleeBase")
	weapon.setClass(class)
	weapon.setName("knife")
	weapon.setModel("models/weapons/w_knife_t.mdl")
	weapon.setPrimaryEQSlot(-2)
	weapon.setDamage(9)
	weapon.setFireRate(0.2)
	weapon.setAttackRange(65)

	function weapon.paperDoll()
	    local tempData = {}
	    tempData.model = weapon.getModel()
	    tempData.bone = "ValveBiped.Bip01_L_Hand"
	    tempData.color = Color(255,255,255,255)
	    tempData.skin = 1
	    tempData.material = ""
	    tempData.pos = Vector(4,2,-5)
	    tempData.ang = Angle(0,0,90)
	    tempData.scale = Vector(1,1,1)

	    return tempData
	end


	local mode = false
	function weapon.changeMode( newMode )
		mode = newMode
	end

	function weapon.mode()
		return mode
	end

	function weapon.secondaryFire( user, swep )
		if mode then
			weapon.changeMode( false )
			weapon.setDamage(9)
			weapon.setFireRate(0.2)
			weapon.setAttackRange(65)
			user:SetNWString("weaponHoldType", "knife")	
		else
			weapon.changeMode( true )
			weapon.setFireRate( weapon.getFireRate() * 1.8 )
			weapon.setDamage(weapon.getDamage() * 0.9)
			weapon.setAttackRange(weapon.getAttackRange() * 1.5)
			user:SetNWString("weaponHoldType", "melee")		
		end
		swep.nextSFire = CurTime() + 0.2
		return false
	end

	function weapon.hitEntity(self, entity, trace )
		if self:IsPlayer() && entity:IsPlayer() && !GAMEMODE.FriendlyFire then return false end
        if math.random(1, 1/0.5) == 1 then
            entity:applyEffect("bleed")
        end
        if entity:IsPlayer() or entity:IsNPC() then
		    local visual = EffectData()
		   	if trace then
				visual:SetOrigin( trace.HitPos )
			else
				visual:SetOrigin( entity:GetPos() )
			end
			util.Effect("BloodImpact", visual ) 
		end       
	end

	function weapon.equipEffect( self )
	    self:setAttackSpeed(2.4)
	    weapon.setDamage(self:getAttackDamage())
	end
	
	return weapon
end

classItemData.register( class, generate )
