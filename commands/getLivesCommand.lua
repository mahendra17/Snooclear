require "models.lives"

getLivesCommand = {}

function getLivesCommand:new()
	local command = {}
	command.LivesService = nil

	function command:execute(event)
		-- print( "executing command" )
		lives.instance:addLives()
	end

	return command
end

return getLivesCommand