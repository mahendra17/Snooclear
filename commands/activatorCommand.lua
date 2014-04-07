require "models.GamePlayModels"
activator = {}

function activator:new( )
	local command = {}
	command.GamePlayService = nil

	function command:execute( event )
		print("activator::execute")

		GamePlayModel.instance:activator(event)

		return true
	end

	return command
end

return activator