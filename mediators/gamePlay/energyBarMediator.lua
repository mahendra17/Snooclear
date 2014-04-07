require "models.GamePlayModels"

energyBarMediator = {}

function energyBarMediator:new()
	
	local mediator = {}
	
	function mediator:onRegister()
		Runtime:addEventListener( "energyChanged", self )
	end

	function mediator:energyChanged(event)
		mediator.viewInstance:setValue(event.energy)
	end
	
	function mediator:onRemove()
		Runtime:removeEventListener("energyChanged", self)
	end

	return mediator
	
end

return energyBarMediator

