include("sh_config.lua")

if SERVER then
	AddCSLuaFile("sh_config.lua")
end

function print(x, y)
	if y then
		MsgN(tostring(x) .. "    ", y)
	else
		MsgN(x)
	end
end

strRootPath = string.Replace(GM.Folder, "gamemodes/", "")

function SearchPaths(originalPath, initial)
	initial = initial or false
	originalPath = originalPath .. "/"
	local files, directories = file.Find(originalPath .. "*", "LUA")

	if !initial then
		for _, strPath in pairs(files) do
			local prefix = string.sub(strPath, 1, 3)
			local correctedPath = string.gsub(originalPath .. strPath, strRootPath .. "/".. "gamemode/", "")

			if string.find(strPath, "sv_") then
				if SERVER then
					include(correctedPath)
				end
			elseif string.find(strPath, "cl_") then
				if SERVER then
					AddCSLuaFile(correctedPath)
					-- print("AddCSLuaFile('"..correctedPath.."')")
				else
					include(correctedPath)
					-- print("include('"..correctedPath.."')")		
				end
			else
				if SERVER then
					AddCSLuaFile(correctedPath)					
					include(correctedPath)
				   	-- print("AddCSLuaFile('"..correctedPath.."')")
				else
					include(correctedPath)		
					-- print("include('"..correctedPath.."')")
				end
			end
		end
	end
	
	for _, strPath in pairs(directories) do
		SearchPaths(originalPath .. strPath)
	end
end
-- BEGINS THE INCLUDER
SearchPaths(strRootPath .. "/".. "gamemode/engine", false)
for _,folder in pairs(GM.MountFolders) do
	SearchPaths(strRootPath .. "/".. "gamemode/games/" .. folder, false)
end