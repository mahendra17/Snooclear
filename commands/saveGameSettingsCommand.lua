require "services.saveSettingsService"

saveSettingsCommand = {}

function saveSettingsCommand:new( )
	local command = {}

	function command:execute(event)
		saveSettingsService:new()
		-- saveSettingsService:sounds( )
		print("saveSettingsService::execute")

	end

	return command
end

return saveSettingsCommand