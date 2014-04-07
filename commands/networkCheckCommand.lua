require "services.networkCheck"
networkCheckCommand = {}

function networkCheckCommand:new( )
	local command = {}
	-- command.GamePlayService = nil

	function command:execute( event )
		print("networkCheckCommand::execute")

		networkCheck:new()
		
		return true
	end

	return command
end

return networkCheckCommand