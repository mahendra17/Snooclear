require "services.startupService"
require "services.chartBoostService"

startupCommand = {}

function startupCommand:new( )
	local command = {}

	function command:execute(event)
		startupSetting:new()
		startupSetting:sounds( )
		print("startupCommand::execute")

		lives.instance:getTimeToNewLives()


		chartBoostService:new()
	end

	return command
end

return startupCommand