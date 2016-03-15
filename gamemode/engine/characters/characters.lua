function createCharacter(ply, name, model)
	if !ply:getData() then return false end
	if GAMEMODE.MaxCharacters <= table.Count(ply:getData():getCharacters()) - 1 then return false end

	local char = classCharacter.new(ply)
	char.setName(name)
	if GAMEMODE.PlayerModels[model] then
		char.setModel(GAMEMODE.PlayerModels[model])
	else
		ply:ChatPrint("Character Model Doesn't exist")
		return false
	end

	hook.Call("CharacterCreated", GAMEMODE, ply, char)

	ply:getData().addCharacter(char)

	if ply:getCharacterIndex() == 0 then
		ply:selectCharacter(1)
	end
end

function deleteCharacter(ply, characterID)
	characterID = math.Round(characterID) 
	local character = ply:getCharacter( characterID )  
	local inventory = character.getInventory()
	local fateBank = ply:getFate().getInventory()
	for _, item in pairs(inventory.getItems()) do
		if fateBank.hasRoom() then
			fateBank.addItem( item )
		end
	end

	hook.Call("CharacterDeleted", GAMEMODE, ply, character)

	ply:getData().deleteCharacter( characterID )

	ply:selectCharacter(0)
end

if SERVER then
	concommand.Add("createCharacter", function(ply,cmd,args) createCharacter(ply, args[1], args[2]) end)
	concommand.Add("deleteCharacter", function(ply,cmd,args) deleteCharacter(ply, args[1]) end)
end


local PMETA = FindMetaTable("Player")

function PMETA:getCharacters()
	return self:getData().getCharacters()
end

function PMETA:getCharacterIndex()
	return self:getData().getCurrentCharacterIndex()
end

function PMETA:getCharacter( charNum )
	if charNum == nil then
		return self:getData().getCurrentCharacter()
	end
	return self:getData().getCharacter( charNum )
end

function PMETA:canSelectCharacter()
	return true
end

function PMETA:selectCharacter( charNum )
	if self:getData().getCharacter(charNum) == nil then return false end
	if !self:canSelectCharacter() then return false end
	self:getData().selectCharacter(charNum)
	self:loadCharacter()
end
if SERVER then
	concommand.Add("selectCharacter", function(ply,cmd,args) ply:selectCharacter(math.Round(args[1])) end)
end

function PMETA:loadCharacter()
	local ply = self
	if SERVER then
		ply:StripAmmo()
		ply:StripWeapons()

		ply:SetNWString( "charName", ply:getCharacter().getName() or "<No Name>" )
		
		if ply:getCharacter().getModel() != nil then
			if ply:getCharacter().getModel() != ply:GetModel() then
				ply:SetModel(ply:getCharacter().getModel())
			end
		else
			print("Player Doesn't have a model " .. tostring(ply))
			GAMEMODE:PlayerSetModel(ply)
		end

		ply:getInventory().load()
	end
end