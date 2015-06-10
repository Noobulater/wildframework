function GM:PlayerConnect(strName, strIPAddress)
	-- Player connects but hasnt authed yet.
end
function GM:PlayerAuthed(ply, strSteamID, intUniqueID)
	-- Player's steam id is ready to go.
end

function GM:PlayerNoClip(ply)
	-- Only admins can noclip
	return ply:IsAdmin()
end

function GM:PlayerFootstep(ply, vecPos, intFoot, sound, nVolume, rf)
	-- Don't allow default footsteps
     return not GAMEMODE.FootSteps
end
 
function GM:CanPlayerEnterVehicle(ply, vhcVehicle, intRole)
	-- No vehicles
	return false
end
