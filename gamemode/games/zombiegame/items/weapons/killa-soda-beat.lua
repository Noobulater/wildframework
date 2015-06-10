local class = "killa-soda-beat"

local function generate()
	local weapon = classWeaponData.new()
	weapon.setClass(class)
	weapon.setName("killa-soda-beat")
	weapon.setDescription("This is killabeat's awesome gun!")
	weapon.setFireSound("physics/plastic/plastic_barrel_impact_bullet3.wav")	
	weapon.setFireRate( .1 )
	weapon.setDamage(10)
	weapon.setAccuracy(10)
	weapon.setClipSize(30)
	weapon.setHoldType("pistol")
	weapon.setAmmoType("AR2")
	weapon.setModel("models/weapons/w_IRifle.mdl")
	weapon.setAutomatic( true )


	weapon.primaryFire = function( user, swep )
		if SERVER then
			local attachment = swep:LookupAttachment("muzzle")
			local pos = swep:GetAttachment(attachment)["Pos"]
			local ang = swep:GetAttachment(attachment)["Ang"]

			local entity = ents.Create("killabomb")
			entity:SetPos(pos)
			entity:SetAngles(ang + Angle(0, 90, 0))
			entity:Spawn()
			
			entity:SetOwner(user)
			--entity:EnableCustomCollisions(true)
			local phys = entity:GetPhysicsObject()

			if IsValid(phys) then
				phys:ApplyForceCenter( user:GetAngles():Forward() * 5000)
			end

			sound.Play((weapon.getFireSound() or swep.Primary.Sound), user:GetPos() + Vector(0,0,30), 75, 100, 1 )
			timer.Simple(5, function() if IsValid(entity) then entity:Remove() end end)
		end
		return false
	end	

	weapon.callBack = function( ply, tr, dmgInfo )  
		local visual = EffectData()
		visual:SetOrigin( tr.HitPos )
		util.Effect("AR2Impact", visual )
	end

	return weapon
end

--classItemData.register( class, generate )