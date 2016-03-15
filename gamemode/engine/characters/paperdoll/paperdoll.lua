classPaperdoll = {}

if SERVER then 

	util.AddNetworkString( "networkPaperDoll" )
	util.AddNetworkString( "networkRemovePaperDoll" )

	function networkPaperDoll( entity, tag, visualData, ply )
		ply = ply or player.GetAll()

		net.Start( "networkPaperDoll" )
			net.WriteUInt( entity:EntIndex(), 8 )
			net.WriteString( tag )

			net.WriteString(visualData.model)
			net.WriteVector(visualData.pos or Vector(0,0,0))
			net.WriteAngle(visualData.ang or Angle(0,0,0))
			net.WriteVector(visualData.scale or Vector(1,1,1))
			net.WriteString(visualData.bone or "ValveBiped.Bip01_R_Hand")
			net.WriteString(visualData.material or "")
			net.WriteUInt(visualData.skin or 1, 8)
			net.WriteString(visualData.color.r .. "|" .. visualData.color.g .. "|" .. visualData.color.b .. "|" .. visualData.color.a)
		net.Send( ply )	
	end

	function networkRemovePaperDoll( entity, tag, ply )
		ply = ply or player.GetAll()

		net.Start( "networkRemovePaperDoll" )
			net.WriteUInt( entity:EntIndex(), 8 )
			net.WriteString( tag )
		net.Send( ply )	
	end

else
	net.Receive( "networkPaperDoll", function(len)   
		local entityIndex = net.ReadUInt( 8 )
		local tag = net.ReadString()

		local tempData = {}
		tempData.model = net.ReadString()
		tempData.pos = net.ReadVector()
		tempData.ang = net.ReadAngle()
		tempData.scale = net.ReadVector()
		tempData.bone = net.ReadString()
		tempData.material = net.ReadString()
		tempData.skin = net.ReadUInt(8)
		
		local colorString = net.ReadString()
		
		local colorTable = string.Explode( "|", colorString )
		local color = Color(255,255,255,255)

		color.r = tonumber(colorTable[1])
		color.g = tonumber(colorTable[2])
		color.b = tonumber(colorTable[3])
		color.a = tonumber(colorTable[4])

		tempData.color = color
		
		local entity 
		for key, ent in pairs(ents.GetAll()) do
			if string.Replace(ent:GetClass(), "class", "") == ent:GetClass() then
				if tonumber(ent:EntIndex()) == tonumber(entityIndex) then
					entity = ent
				end
			end
		end

		if IsValid(entity) then
			getPaperdollManager().register(entity, tag, tempData)
		end

	end)

	net.Receive( "networkRemovePaperDoll", function(len)   
		local entityIndex = net.ReadUInt( 8 )
		local tag = net.ReadString()

		local entity 
		for key, ent in pairs(ents.GetAll()) do
			if ent:EntIndex() == entityIndex then
				entity = ent
			end
		end
		if IsValid(entity) then
			getPaperdollManager().clearTag(entity, tag)
		end
	end)
end

function classPaperdoll.new()
	local public = {}

	local managed = {}

	function public.getEntities()
		return managed
	end

	function public.clear( entity )
		if managed[entity] != nil then
			for tag, _ in pairs(managed[entity]) do
				public.clearTag(entity, tag)
			end
			managed[entity] = nil
		end 
	end

	function public.clearTag( entity, tag )
		if SERVER then
			networkRemovePaperDoll(entity, tag)
		end
		if managed[entity] != nil then
			if managed[entity][tag] != nil then
				if CLIENT then
					local removeTable = {}

					for index, data in pairs(managed[entity][tag]) do
						if IsValid(data.entity) then
							table.insert(removeTable, data.entity)
							data.entity = nil
						end
					end
					
					timer.Simple(0.25, function() for _, ent in pairs(removeTable) do if IsValid(ent) then ent:Remove() end end end)
				end
				table.remove(managed[entity][tag])
			end
		end
	end

	function public.getTag( entity, tag )
		if managed[entity] != nil then
			return managed[entity][tag]
		end
	end

	function public.register( entity, tag, visualTable )
		if SERVER then
			networkPaperDoll(entity, tag, visualTable )
		end
		if !managed[entity] then
			managed[entity] = {}
		end
		if tag != nil then
			if !managed[entity][tag] then
				managed[entity][tag] = {}
			end
			if CLIENT then
				visualTable.entity = ents.CreateClientProp()
			end
			table.insert(managed[entity][tag], visualTable)
		end	
	end

	return public
end

local pdManager = classPaperdoll.new()

function getPaperdollManager()
	return pdManager
end

local data
local entity
local bone
local pos
local ang
local dist

local function paperDoll()
	data = pdManager.getEntities()

	bone = data.bone

	for parent, paperData in pairs(data) do
		if IsValid(parent) then
			dist = LocalPlayer():GetPos():Distance(parent:GetPos())
			
			for tag, tagTable in pairs(paperData) do
				for index, data in pairs(tagTable) do
					entity = data.entity
					if IsValid(entity) then
						if dist < 600 then
							
							entity:SetParent(nil)

							bone = data.bone
							if bone == "none" then 
								pos = parent:GetPos() 
								ang = parent:GetAngles() 
							else
								bone = parent:LookupBone(data.bone)
								if bone != nil then
									pos,ang = parent:GetBonePosition( bone )
								else
									pos = parent:GetPos() 
									ang = parent:GetAngles() 								
								end
							end

							entity:SetAngles(ang)
							entity:SetAngles(entity:LocalToWorldAngles(data.ang or Angle(0,0,0)))
							entity:SetPos(pos)
						 	entity:SetPos(entity:LocalToWorld(data.pos or Vector(0,0,0)))
							entity:SetModel(data.model)

							if data.scale != Vector(1,1,1) then
								local mat = Matrix()
								mat:Scale( data.scale )
								entity:EnableMatrix( "RenderMultiply", mat )
							end

							entity:SetColor(data.color)
							entity:SetMaterial(data.material)
						else
							entity:SetParent(parent)
						end
					end
				end
			end
			
		else
			pdManager.clear(parent)
		end
	end

end

hook.Add("PostDrawOpaqueRenderables", "paperDollManaged", paperDoll)