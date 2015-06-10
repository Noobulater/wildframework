local class = "minigun"

local function generate()
	local weapon = classItemData.genItem("rifleBase")
	weapon.setClass(class)
	weapon.setName("Minigun")
	weapon.setDescription("'nuff said")
	weapon.setFireSound("weapons/minigun/mini-1.wav")	
	weapon.setFireRate( .01 )
	weapon.setDamage(10)
	weapon.setAccuracy(.1)
	weapon.setClipSize(200)
	weapon.setReloadTime(1)
	weapon.setAutomatic(true)
	weapon.setHoldType("crossbow")
	weapon.setAmmoType("minigunAmmo")
	weapon.setModel("models/weapons/w_minigun.mdl")
	weapon.primClip = weapon.getClipSize()

	if CLIENT then
		function weapon.paperDoll(ply, prop)
			local BoneIndx = ply:LookupBone("ValveBiped.Bip01_R_Hand")
			local BonePos , BoneAng = ply:GetBonePosition( BoneIndx )

			prop:SetAngles(BoneAng + Angle(80,0,90))
			prop:SetPos(BonePos + BoneAng:Forward() * 20 + BoneAng:Up() * -3 + BoneAng:Right() * 0.25 )
			prop:SetModel(weapon.getModel())
		end
	end

	return weapon
end

classItemData.register( class, generate )

-- EXAMPLE OF A CUSTOM WEAPON