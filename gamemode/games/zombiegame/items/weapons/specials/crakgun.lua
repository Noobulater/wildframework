local class = "crakgun"

local function generate()
	local weapon = classItemData.genItem("projectileBase")
	weapon.setClass(class)
	weapon.setName("Crakgun")
	weapon.setDescription("This is a crakgun")
	weapon.setFireSound("weapons/crakgun/fire1.wav")	
	weapon.setFireRate( .2 )
	weapon.setAutomatic(true)
	weapon.setDamage(25)
	weapon.setAccuracy(.02)
	weapon.setClipSize(30)
	weapon.setHoldType("ar2")
	weapon.setAmmoType("Ar2")
	weapon.setModel("models/weapons/Bolter.mdl")
	weapon.setShouldDraw(false)

	function weapon.paperDoll()
	    local tempData = {}
	    tempData.model = weapon.getModel()
	    tempData.bone = "ValveBiped.Bip01_R_Hand"
	    tempData.color = Color(255,255,255,255)
	    tempData.skin = 1
	    tempData.material = ""
	    tempData.pos = Vector(3,14,2)
	    tempData.ang = Angle(100,0,90)
	    tempData.scale = Vector(1,1,1)

	    return tempData
	end

	function weapon.deploy( user )
		if IsValid(user) then 
			getPaperdollManager().register(user, class, weapon.paperDoll()) 
		end
	end

	function weapon.holster( user )
		if IsValid(user) then 
			getPaperdollManager().clearTag(user, class)
		end
	end

	function weapon.projectile( user, swep )
		if SERVER then 
			local attachment = swep:LookupAttachment("muzzle")
			local pos = swep:GetAttachment(attachment)["Pos"]
			local ang = swep:GetAttachment(attachment)["Ang"]

			local entity = ents.Create("prop_physics")
			entity:SetModel("models/Items/AR2_Grenade.mdl")
			entity:SetPos(pos + Vector(0,0,5))
			entity:SetAngles( user:GetAimVector():Angle()  )
			entity:Spawn()
			entity:SetSolid(0)
			entity.owner = user

			local phys = entity:GetPhysicsObject()

			if IsValid(phys) then
				phys:ApplyForceCenter( user:GetAimVector() * 30000 )
			end

			return entity
		end
		return nil
	end

	function weapon.callBack( ply, tr, dmgInfo, projectile ) 
		if tr.Hit then
			util.BlastDamage(ply:GetActiveWeapon(), (ply or nil), tr.HitPos, 150, weapon.getDamage())

			sound.Play("physics/surfaces/underwater_impact_bullet1.wav", tr.HitPos, 75, 100, 1 )

			timer.Simple(tr.HitPos:Distance(ply:GetShootPos())/10000, function()

				local visual = EffectData()
				visual:SetOrigin( tr.HitPos )
				visual:SetScale(2)
				visual:SetAngles( (ply:GetShootPos() - tr.HitPos):Angle() )

				util.Effect("MuzzleEffect", visual )
				if IsValid( projectile ) then
					projectile:Remove()
				end
			end)
		end
	end	

	return weapon
end

classItemData.register( class, generate )

if SERVER then
	classScarcity.addItemToCategory(5, class)
end