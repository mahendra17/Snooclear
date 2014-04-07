require "services.gameSettingServices"
GamePlayCommand = {}

function GamePlayCommand:new( )
	local command = {}
	command.gameSettingServices = nil

	function command:execute( event )
		print("GamePlayCommand::execute")
		-- gameSettingServices = gameSettingServices:new()
	end

	return command
end

return GamePlayCommand