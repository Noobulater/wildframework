local class = "mp5"

local function generate()
	local weapon = classItemData.genItem("smgBase")
	weapon.setClass(class)
	weapon.setName("H&K MP5")
	weapon.setDescription("Thug life")
	weapon.setFireSound("weapons/mp5navy/mp5-1.wav")	
	weapon.setFireRate( .08 )
	weapon.setAutomatic(true)
	weapon.setDamage(20)
	weapon.setAccuracy(.03)
	weapon.setClipSize(32)
	weapon.setModel("models/weapons/w_smg_mp5.mdl")

	if CLIENT then
		function weapon.paperDoll(ply, prop)
			local BoneIndx = ply:LookupBone("ValveBiped.Bip01_R_Hand")
			local BonePos , BoneAng = ply:GetBonePosition( BoneIndx )

			prop:SetAngles(BoneAng + Angle(-9,0,170))
			prop:SetPos(BonePos + BoneAng:Forward() * 6 + BoneAng:Up() * 3 + BoneAng:Right() * 0.25 )
			prop:SetModel(weapon.getModel())
		end
	end

	return weapon
end

classItemData.register( class, generate )

-- EXAMPLE OF A CUSTOM WEAPON