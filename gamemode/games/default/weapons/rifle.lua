local class = "rifle"

local function generate()
	local weapon = classWeaponData.new()
	weapon.setClass(class)
	weapon.setName("Custom Blasta")
	weapon.setDescription("This is an example of a custom weapon")
	weapon.setFireSound("weapons/ar2/fire1.wav")	
	weapon.setFireRate( .1 )
	weapon.setDamage(10)
	weapon.setAccuracy(.05)
	weapon.setClipSize(30)
	weapon.setHoldType("pistol")
	weapon.setAmmoType("AR2")
	weapon.setModel("models/weapons/w_IRifle.mdl")
	weapon.setAutomatic( true )
	weapon.setTracerName("AR2Tracer")

	weapon.callBack = function( ply, tr, dmgInfo )  
		local visual = EffectData()
		visual:SetOrigin( tr.HitPos )
		util.Effect("AR2Impact", visual )
	end

	return weapon
end

classItemData.register( class, generate )

-- EXAMPLE OF A CUSTOM WEAPON