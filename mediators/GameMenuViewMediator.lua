GameMenuViewMediator = {}

function GameMenuViewMediator:new()
	local mediator = {}
	
	function mediator:onRegister()
		local view = self.viewInstance
		view:addEventListener( "toSocialMenu", self )
		view:addEventListener( "toLevelMenu", self )
		view:addEventListener( "loadPopupSocialContent", self )
		view:addEventListener( "facebookLogin", self )
		view:addEventListener( "twitterLogin", self )

		-- Runtime:addEventListener( "toSocialMenu", self )
	end

	function mediator:loadPopupSocialContent( )
		-- print( "loadPopupSocialContent is in mediator" )
		Runtime:dispatchEvent( {name = "loadPopupSocialContent"})
	end


	function mediator:toSocialMenu( )
		-- print( "toSocialMenu" )
		Runtime:dispatchEvent( {name = "toSocialMenu"} )
	end

	function mediator:toLevelMenu( )
		-- print( "toLevelMenu" )
		Runtime:dispatchEvent ({name = "toLevelMenu"})
	end

	function mediator:facebookLogin()
		-- Runtime:dispatchEvent( {name = "facebookLogin", service = "Facebook"} )
		Runtime:dispatchEvent( {name = "social", service = "Facebook", type = "connect"} )
	end
	
	function mediator:twitterLogin()
		-- Runtime:dispatchEvent( {name = "twitterLogin", service = "Twitter"} )
		Runtime:dispatchEvent( {name = "social", service = "Twitter", type = "connect"} )
	end


	function mediator:onRemove()
	end


	return mediator
end

return GameMenuViewMediator