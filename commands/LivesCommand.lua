require "services.LivesService"
require "models.lives"

LivesCommand = {}

function LivesCommand:new()
	local command = {}
	command.LivesService = nil

	function command:execute(event)
		-- print( "executing command" )
		-- local LivesService = LivesService:new( )

		lives.instance:getTimeToNewLives( )
		-- print( "to next life".. lives.instance:getTimeToNewLives( )  )

	end

	return command
end

return LivesCommand