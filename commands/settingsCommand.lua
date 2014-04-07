require "services.LivesService"
require "models.lives"

settingsCommand = {}

function settingsCommand:new()
	local command = {}
	command.LivesService = nil

	function command:execute(e)
		-- print( "executing command" )
		command:changeSettings(e.type)
		Runtime:dispatchEvent( {name = "saveGameSettings"} )
	end

	function command:changeSettings( type)
		if type == "sound" then
			_G.gameSettings.soundOn= not _G.gameSettings.soundOn
			command:applySoundSettings()
		elseif type == "notification" then
			_G.gameSettings.notificationOn= not _G.gameSettings.notificationOn
			command:applyNotificationSetting( _G.gameSettings.notificationOn )
		end
	end

	function command:applySoundSettings( )
			if gameSettings then
				if gameSettings.soundOn then
					audio.setVolume( 1 )
				else
					audio.setVolume (0)
			end
		end
	end

	function command:applyNotificationSetting( bool )
		if bool then
			--do nothing
		else
			Runtime:dispatchEvent({name = "systemNotification", type = "cancelled"})
		end
	end

	return command
end

return settingsCommand