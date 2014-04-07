require "services.chartBoostService"


chartBoostCommand = {}

function chartBoostCommand:new( )
	local command = {}
	command.chartBoostService = nil

	function command:execute( event )
		print("chartBoostCommand::execute")

		if event.type == "showAd" then
			chartBoostService:showAd()
		elseif event.type == "cacheAd" then
			chartBoostService:cacheAd( )
		else
			chartBoostService:new()
		end

		return true
	end

	return command
end

return chartBoostCommand