local class = "butcherKnife"

local function generate()
	local weapon = classItemData.genItem("meleeBase")
	weapon.setClass(class)
	weapon.setName("Butcher Knife")
	weapon.setModel("models/props_lab/Cleaver.mdl")
	weapon.setFireRate(0.5)
	weapon.setDamage(15)
	weapon.setHoldType("melee")
	weapon.setPrimaryEQSlot(-2)
	weapon.setAttackRange(80)
	weapon.setPhysicsOverride(true)
	weapon.setShouldDraw(false)

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
			weapon.setDamage(15)
			weapon.setFireRate(0.5)
			weapon.setAttackRange(80)
			user:SetNWString("weaponHoldType", "melee")	
		else
			weapon.changeMode( true )
			weapon.setFireRate( weapon.getFireRate() * 1.5 )
			weapon.setDamage(weapon.getDamage() * 1.5)
			weapon.setAttackRange(weapon.getAttackRange() * 0.75)
			user:SetNWString("weaponHoldType", "melee2")		
		end
		swep.nextSFire = CurTime() + 0.2
		return false
	end

	function weapon.paperDoll( player )

		if player then
		    local tempData = {}
		    tempData.model = weapon.getModel()
		    tempData.bone = "ValveBiped.Bip01_R_Hand"
		    tempData.color = Color(255,255,255,255)
		    tempData.skin = 1
		    tempData.material = ""
		    tempData.pos = Vector(0,3,0)
		    tempData.ang = Angle(270, 165, 90)
		    tempData.scale = Vector(1,1,1)

		    return tempData
		end

	    local tempData = {}
	    tempData.model = weapon.getModel()
	    tempData.bone = "ValveBiped.Bip01_L_Hand"
	    tempData.color = Color(255,255,255,255)
	    tempData.skin = 1
	    tempData.material = ""
	    tempData.pos = Vector(0,5,2)
	    tempData.ang = Angle(0,-90,0)
	    tempData.scale = Vector(1,1,1)

	    return tempData
	end

	function weapon.deploy( user )
		if IsValid(user) then 
			getPaperdollManager().register(user, class, weapon.paperDoll( user:IsPlayer() )) 
		end
	end

	function weapon.holster( user )
		if IsValid(user) then 
			getPaperdollManager().clearTag(user, class)
		end
	end	

	function weapon.hitEntity(self, entity, trace )
		if self:IsPlayer() && entity:IsPlayer() && !GAMEMODE.FriendlyFire then return false end
	    if math.random(0,1/(0.5)) == 1 then
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
	    self:setAttackSpeed(1.7)
	    weapon.setDamage(self:getAttackDamage())
	end
	
	return weapon
end

classItemData.register( class, generate )

if SERVER then
	classScarcity.addItemToCategory(1, class)
end
