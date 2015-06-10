local PMETA = FindMetaTable("Player")

function PMETA:canSelectCharacter()
	if self:getCharacterIndex() == 0 then return true end
	if util.isActivePlayer(self) && getGame() then return false end
	return true
end