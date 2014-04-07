require "services.ReadFileContentsService"

saveSettingsService = {}

function saveSettingsService:new()
	local service = {}

	local _save = saveTable("gameSettings.json", system.DocumentsDirectory, gameSettings)
	
	if (_save) then
		print( "saveSettingsService :: settings file saved!" )
	else
		print( "saveSettingsService :: settings file not saved!" )
	end

	print( "saveSettingsService running" )
end		



-- function saveSettingsService:sounds( )
-- 		if gameSettings then
-- 			if gameSettings.soundOn then
-- 				audio.setVolume( 1 )
-- 			else
-- 				audio.setVolume (0)
-- 		end
-- 	end
-- end