SettingsViewMediator = {}

function SettingsViewMediator:new()
	local mediator = {}
	
	function mediator:onRegister()
		local view = self.viewInstance
		view:addEventListener( "toLevelMenu", self )
		view:addEventListener( "loadPopupHowToPlay", self )
		view:addEventListener( "loadPopupRestorePurchases", self )
		view:addEventListener( "loadPopupEmail", self )
		view:addEventListener( "changeSettings", self )
	end

	function mediator:changeSettings( event )
		Runtime:dispatchEvent({name = "changeSettings", type = event.type})
	end

	function mediator:toLevelMenu( )
		-- print( "toLevelMenu" )
		Runtime:dispatchEvent ({name = "toLevelMenu"})
		Runtime:dispatchEvent({name ="saveGameSettings"})
	end

	function mediator:loadPopupHowToPlay()
		Runtime:dispatchEvent({name = "loadPopupHowToPlay"})
	end

	function mediator:loadPopupRestorePurchases()
		Runtime:dispatchEvent({name = "loadPopupRestorePurchases"})
	end

	function mediator:loadPopupEmail()
		Runtime:dispatchEvent({name = "loadPopupEmail"})
	end

	function mediator:onRemove()
	end


	return mediator
end

return SettingsViewMediator