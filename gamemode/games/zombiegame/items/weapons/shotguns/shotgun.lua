local class = "shotgun"

local function generate()
	local weapon = classItemData.genItem("shotgunBase")
	weapon.setClass(class)
	weapon.setName("Shotty Gun")
	weapon.setDescription("This is an example of a custom weapon")
	weapon.setFireSound("weapons/shotgun/shotgun_fire6.wav")	
	weapon.setFireRate( .3 )
	weapon.setDamage(12)
	weapon.setAccuracy(.1)
	weapon.setClipSize(6)
	weapon.setNumBullets(8)
	weapon.setReloadTime(0.5)
	weapon.setHoldType("shotgun")
	weapon.setModel("models/weapons/w_shotgun.mdl")

	-- weapon.callBack = function( ply, tr, dmgInfo )  
	-- 	local visual = EffectData()
	-- 	visual:SetOrigin( tr.HitPos )
	-- 	util.Effect("AR2Impact", visual )
	-- end

	if CLIENT then
		function weapon.paperDoll(ply, prop)
			local BoneIndx = ply:LookupBone("ValveBiped.Bip01_R_Hand")
			local BonePos , BoneAng = ply:GetBonePosition( BoneIndx )

			prop:SetAngles(BoneAng + Angle(165,0,-15))
			prop:SetPos(BonePos + BoneAng:Forward() * 18 + BoneAng:Up() * -3  + BoneAng:Right()  )
			prop:SetModel(weapon.getModel())
		end
	end

	return weapon
end

classItemData.register( class, generate )

-- EXAMPLE OF A CUSTOM WEAPON

if SERVER then
	classScarcity.addItemToCategory(2, class)
end