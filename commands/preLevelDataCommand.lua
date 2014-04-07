require "services.PreLevelDataService"

preLevelDataCommand = {}

function preLevelDataCommand:new( )
	local command = {}
	command.PreLevelDataService = nil

	function command:execute(event)
		print("preLevelDataCommand::execute")
		PreLevelDataService:new()
	end

	return command
end

return preLevelDataCommand