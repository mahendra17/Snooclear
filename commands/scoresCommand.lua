require "services.highscoresService"

scoresCommand = {}

function scoresCommand:new(event)
	local command = {}
	local service = highscoresService:new()

	function command:execute(event)
		service:storeData(event.level, event.score)
	end

	return command
end

return scoresCommand