require "services.ReadFileContentsService"

saveActivatorDataCommand = {}

function saveActivatorDataCommand:new( )
	local command = {}

	function command:execute(event)
		print("saveActivatorDataCommand::execute")
		
		local save = saveTable("activatorData.json", system.DocumentsDirectory, activatorData )

		if save then print "data saved" else print "data not saved" 	end
	end

	return command
end

return saveActivatorDataCommand