require "models.GamePlayModels"
addForceCommand = {}

function addForceCommand:new( )
	local command = {}
	command.GamePlayService = nil

	function command:execute( event )
		print("addForceCommand::execute")

		local addForce = GamePlayModel.instance:addForce(event)
		-- local addForce = GamePlayModel.instance:addForce(event.dirX, event.dirY)
		return true
	end

	return command
end

return addForceCommand