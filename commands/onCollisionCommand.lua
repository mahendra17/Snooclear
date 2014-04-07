require "models.GamePlayModels"
onCollisionCommand = {}

function onCollisionCommand:new( )
	local command = {}
	-- command.GamePlayService = nil

	function command:execute( event )
		print("onCollisionCommand::execute")
		GamePlayModel.instance:onCollision(event)
		return true
	end

	return command
end

return onCollisionCommand