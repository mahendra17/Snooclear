LevelMenuViewMediator = {}

function LevelMenuViewMediator:new()
	local mediator = {}
	
	function mediator:onRegister()
		local view = self.viewInstance

		view:addEventListener ("toLivePage", self )
		view:addEventListener ("toActivatorPage", self )
		view:addEventListener ("toSettings", self)
		view:addEventListener ("toSocialMenu", self)
		view:addEventListener( "toPreLevel", self )

	end


	function mediator:toSocialMenu( )
		-- print( "toSocialMenu" )
		Runtime:dispatchEvent( {name = "toSocialMenu"} )
	end

	function mediator:toActivatorPage( )
		-- print( "toActivatorPage" )
		Runtime:dispatchEvent ({name = "toActivatorPage"})
	end

	function mediator:toSettings( )
		-- print( "toSettings" )
		Runtime:dispatchEvent( {name = "toSettings"} )
	end

	function mediator:toLivePage( )
		-- print( "toLivePage")
		Runtime:dispatchEvent( {name = "toLivePage"} )
	end

	function mediator:toPreLevel( )
		-- print( "toPreLevel" )
		Runtime:dispatchEvent( {name = "toPreLevel"} )
	end

	function mediator:onRemove()
	end


	return mediator
end

return LevelMenuViewMediator