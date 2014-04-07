-- require "robotlegs.mediator"


finishGameViewMediator = {}

function finishGameViewMediator:new()
	local mediator = {}
	
	function mediator:onRegister()
		local view = self.viewInstance
		view:addEventListener ("toSocialMenu", self)
		view:addEventListener("toLevelMenu", self )
		view:addEventListener("toNextLevel", self)
		view:addEventListener( "shareScore", self )
		view:addEventListener( "facebookLogin", self )
		Runtime:addEventListener( "setProfilePicture", self )
	end

	function mediator:setProfilePicture()
		self.viewInstance:setProfilePicture()
	end

	function mediator:facebookLogin()
		Runtime:dispatchEvent( {name = "social", service = "Facebook", type = "connect"} )
	end

	function mediator:shareScore(event)
		print( "sharing score" )
		Runtime:dispatchEvent( {name = "social", service = "Facebook", type = "shareScore", score = event.score, level = event.level} )
	end

	function mediator:toLevelMenu( )
		print( "toLevelMenu" )
		Runtime:dispatchEvent ({name = "toLevelMenu"})
	end

	function mediator:toSocialMenu( event )
		-- Runtime:dispatchEvent( {name = "toSocialMenu"} )
	end

	function mediator:toNextLevel( )
		currentLevel = currentLevel + 1
		Runtime:dispatchEvent ({name = "toPreLevel"})
	end

	function mediator:onRemove()
	end


	return mediator
end

return finishGameViewMediator