-- require thingy

--channel 1 reserve buat page ini

require "appsAudio"

SnooclearGameMediator = {}

function SnooclearGameMediator:new()
	local mediator = {}

	function mediator:onRegister( )
		local view = self.viewInstance
		Runtime:addEventListener ("startup", self)
		Runtime:addEventListener ("toGameMenuView", self)
		Runtime:addEventListener ("toSocialMenu", self )
		Runtime:addEventListener ("toLevelMenu", self )
		Runtime:addEventListener ("toActivatorPage", self )
		Runtime:addEventListener ("toSettings", self )
		Runtime:addEventListener ("toLivePage", self )
		Runtime:addEventListener ("toGamePlay", self )
		Runtime:addEventListener ("toPreLevel", self )
		Runtime:addEventListener ("toFinishGameView", self)
		Runtime:addEventListener ("moveView", self)

		--sound
		Runtime:addEventListener("buttonSound", self)
	end

	function mediator:buttonSound( event )
		if event.type == "close" then
			playSounds("button")
		else 
			playSounds("xButton")
		end
	end

	function mediator:toGameMenuView( )
		self.viewInstance:showView("GameMenuView")
		playAmbianceSounds("gameMenu")
	end

	function mediator:moveView( event )
		if event.type == "gameOver" then
			playAmbianceSounds("gameOver")
		elseif event.type == "levelCleared" then
			playAmbianceSounds ("moveView")
			playSounds("levelCleared")
		end
	end

	function mediator:toSocialMenu( )
		self.viewInstance:showView("SocialMenuView")
	end

	function mediator:toLevelMenu( )
		if ((self.viewInstance.currentViewName ~= "LifePageView") and (self.viewInstance.currentViewName ~= "ActivatorView" ) and (self.viewInstance.currentViewName ~= "SocialMenuView" ) and (self.viewInstance.currentViewName ~= "SettingsView" ) ) then
			playAmbianceSounds ("levelMenu")
		end
		self.viewInstance:showView("LevelMenuView")
	end

	function mediator:toActivatorPage( )
		self.viewInstance:showView("ActivatorView")
	end

	function mediator:toSettings( )
		-- print( "display Settings page ")
		self.viewInstance:showView ("SettingsView")
	end

	function mediator:toLivePage( )
		self.viewInstance:showView ("LifePageView")
	end

	function mediator:toGamePlay( )
		self.viewInstance:showView ("GamePlayView")
		playAmbianceSounds( "gamePlay")
		playSounds("startGamePlay")
	end

	function mediator:toPreLevel( )
		self.viewInstance:showView ("PreLevelView")
		playSounds()
		playAmbianceSounds("preLevel")
	end

	function mediator:toFinishGameView( )
		self.viewInstance:showView ("finishGameView")
		playSounds("finishGame")
		playAmbianceSounds("finishGame")

	end

	return mediator

end

return SnooclearGameMediator