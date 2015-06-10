local PMETA = FindMetaTable("Player")

local function initPost()
	if CLIENT then
		LocalPlayer():setupData()
	end
end
hook.Add("InitPostEntity", "dataInit", initPost)

function PMETA:setupData()
	self.characterData = classCharacterData.new( self )
	if SERVER then
		self:getFate().setFatePoints(300)

		self:selectCharacter(0)
	end
end

function PMETA:getFate()
	return self:getData().getFate()
end

function PMETA:getData()
	return self.characterData
end

function PMETA:getStats()
	return self:getCharacter().getStats()
end

function PMETA:getInventory()
	return self:getCharacter().getInventory()
end

function PMETA:Save()
	local saveString = self:getData().toString()

	local directory = string.lower(string.gsub(GAMEMODE.Name, " ", "")) .. "/saves/"

	if !file.Exists( directory , "DATA" ) then
		file.CreateDir(directory)
	end

	local steamID = self:SteamID()

	-- CORRECT THE STEAM ID CUZ WINDOWS WONT SUPPORT : IN A FILE NAME
	steamID = string.gsub(steamID, ":", "_")

	local fileName = directory .. steamID ..".txt"

	file.Write(fileName, saveString)
end

function PMETA:Load()
	local steamID = self:SteamID()

	-- CORRECT THE STEAM ID CUZ WINDOWS WONT SUPPORT : IN A FILE NAME
	steamID = string.gsub(steamID, ":", "_")

	local directory = string.lower(string.gsub(GAMEMODE.Name, " ", "")) .. "/saves/"

	if file.Exists( directory , "DATA" ) then
		local fileName = directory .. steamID ..".txt"
		local content = file.Read(fileName)

		self:getData().loadFromString(content)
	else
		print("Directory doesn't exist")
	end
end