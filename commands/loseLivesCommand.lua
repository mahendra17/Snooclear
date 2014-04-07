require "models.lives"

loseLivesCommand = {}

function loseLivesCommand:new()
	local command = {}
	command.LivesService = nil

	function command:execute(event)
		-- print( "executing command" )
		lives.instance:loseLevel()
	end

	return command
end

return loseLivesCommand