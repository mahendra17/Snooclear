PreLevelViewMediator = {}

function PreLevelViewMediator:new()
	local mediator = {}
	
	function mediator:onRegister()
		local view = self.viewInstance
		view:addEventListener("toLevelMenu", self )
		view:addEventListener( "toGamePlay", self )
		view:addEventListener( "shareGetLives", self )
		view:addEventListener( "facebookLogin", self )
		-- view:addEventListener( "eventName", listener )
	end

	function mediator:facebookLogin()
		Runtime:dispatchEvent( {name = "social", service = "Facebook", type = "connect"} )
	end

	function mediator:shareGetLives(event)
		Runtime:dispatchEvent( {name = "social", service = "Facebook", type = "shareGetLives", level = event.level} )
	end

	function mediator:toLevelMenu( )
		print( "toLevelMenu" )
		Runtime:dispatchEvent ({name = "toLevelMenu"})
	end

	function mediator:toGamePlay( )
		print( "toGamePlay" )

		if gameSettings.lives.lives > 0 then
			Runtime:dispatchEvent ({name = "toGamePlay"})
		elseif gameSettings.lives.lives <= 0 then
			mediator.viewInstance : showPopup ()
		end

	end

	function mediator:onRemove()
	end


	return mediator
end

return PreLevelViewMediator