local class = "ump45"

local function generate()
	local weapon = classItemData.genItem("smgBase")
	weapon.setClass(class)
	weapon.setName("H&K UMP-45")
	weapon.setDescription("UMP stands for Universal Machine Pistol, good to know")
	weapon.setFireSound("weapons/ump45/ump45-1.wav")	
	weapon.setFireRate( .05 )
	weapon.setAutomatic(true)
	weapon.setDamage(14)
	weapon.setAccuracy(.09)
	weapon.setClipSize(25)
	weapon.setModel("models/weapons/w_smg_ump45.mdl")

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
if SERVER then
	classScarcity.addItemToCategory(2, class)
end