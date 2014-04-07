LifePageViewMediator = {}

function LifePageViewMediator:new()
	local mediator = {}
	
	function mediator:onRegister()
		local view = self.viewInstance
		view:addEventListener("toLevelMenu", self )
		view:addEventListener( "saveSettingsData", self )
		view:addEventListener( "social", self )
	end

	function mediator:social( event )
		-- print("social")
		-- print(event.service)
		Runtime:dispatchEvent({name = "social", service = event.service, type = event.type})
	end

	function mediator:saveSettingsData( )
		Runtime:dispatchEvent( {name = "saveGameSettings" } )
	end

	function mediator:toLevelMenu( )
		Runtime:dispatchEvent ({name = "toLevelMenu"})
	end

	function mediator:onRemove()
	end


	return mediator
end

return LifePageViewMediator