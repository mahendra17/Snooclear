ActivatorViewMediator = {}

function ActivatorViewMediator:new()
	local mediator = {}
	
	function mediator:onRegister()
		local view = self.viewInstance
		view:addEventListener( "toLevelMenu", self )
		view:addEventListener( "loadPopupActivatorContent", self )
		view:addEventListener( "activator", self )
		view:addEventListener( "saveGameSettings", self )

		Runtime:addEventListener( "onClaim", self )
	end

	function mediator:saveGameSettings( )
		Runtime:dispatchEvent( {name = "saveGameSettings"} )
	end

	function mediator:activator( event )
		Runtime:dispatchEvent( {name = "activator", type = event.type, condition = event.condition} )
	end

	function mediator:loadPopupActivatorContent()
		Runtime:dispatchEvent({name = "loadPopupActivatorContent"})
	end

	function mediator:toLevelMenu( )
		-- print( "toLevelMenu" )
		Runtime:dispatchEvent ({name = "toLevelMenu"})
	end

	function mediator:onClaim( )
		-- print( "toLevelMenu" )
		mediator.viewInstance:onClaim()
	end


	function mediator:onRemove()
		-- print( "SL ActivatorViewMediator onRemove check" )
		Runtime:removeEventListener( "onClaim", self )
	end


	return mediator
end

return ActivatorViewMediator