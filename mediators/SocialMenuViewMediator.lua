SocialMenuViewMediator = {}

function SocialMenuViewMediator:new()
	local mediator = {}
	
	function mediator:onRegister()
		local view = self.viewInstance
		view:addEventListener("toLevelMenu", self )
		view:addEventListener( "social", self )
	end

	function mediator:toLevelMenu( )
		-- print( "toLevelMenu" )
		Runtime:dispatchEvent ({name = "toLevelMenu"})
	end

	function mediator:social( event )
		Runtime:dispatchEvent({name = "social", service = event.service, type = event.type})
	end

	function mediator:onRemove()
	end


	return mediator
end

return SocialMenuViewMediator