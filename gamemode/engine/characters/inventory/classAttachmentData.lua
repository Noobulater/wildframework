classAttachmentData = {}

function classAttachmentData.new( refOwner )
	local public = classEquipmentData.new(refOwner)

	function public.equip( user )
		-- This is called right before the item is moved into the slot 
	end
	
	function public.unEquip( user )
		-- This is called after the item has been moved out
	end

	function public.use( user )
		-- This is called by the weapon when the user presses ALT and right clicks
	end

	function public.paperDoll(ply, prop)
		local BoneIndx = ply:LookupBone("ValveBiped.Bip01_L_Hand")
		local BonePos , BoneAng = ply:GetBonePosition( BoneIndx )

		prop:SetPos(BonePos)
		prop:SetAngles(BoneAng + Angle(0,0,180))
		prop:SetModel(public.getModel())
	end

	function public.isAttachment()
		return true
	end

	return public
end