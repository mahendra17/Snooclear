require "SnooclearGameContext"
require "views.GameMenuView"
require "views.LevelMenuView"
require "views.SettingsView"
require "views.LifePageView"
require "views.ActivatorView"
require "views.SocialMenuView"
require "views.PreLevelView"
require "views.GamePlayView"

require "views.tutorialOverlayView"

require "setTransition"

SnooclearGame = {}
 


function SnooclearGame:new()
	local application = display.newGroup( )
	application.classType = "SnooclearGame"
	application.currentView = nil
	application.currentViewName = nil

	function application:init()
		-- print( "Initializing game" )
		local background = display.newRect( self, 0, 0, display.actualContentWidth, display.actualContentHeight)
		self.background = background
		background.anchorX, background.anchorY = 0.5,0.5
		background.x, background.y = display.contentCenterX, display.contentCenterY

		function background:tap(event)
			Runtime:dispatchEvent( {name="onStageTap", phase = event.phase} )
		end

		function background:touch(event)
			Runtime:dispatchEvent( {name="onStageTouch", phase = event.phase} )
		end

		background:addEventListener( "tap", background )
		background:addEventListener( "touch", background )

		local context = SnooclearGameContext:new()
		context:init()

		-- local GameMenuView = GameMenuView:new(self)
		-- self.GameMenuView = GameMenuView

		
		-- Add a runtime custom event listener, listened by 
		Runtime:dispatchEvent({name="onRobotlegsViewCreated", target=self})

	end

	function application:showView( name )

		local showAd = false

		if name == "LevelMenuView" and self.currentViewName == "finishGameView" or name == "PreLevelView" and self.currentViewName == "finishGameView" or self.currentViewName == "GamePlayView" and name == "LevelMenuView" then
			showAd = true
		end

		print( "Snooclear Game :: name :", name, ", currentViewName:", self.currentViewName )
		
		if name == self.currentViewName then
				return true
		end	

		if self.currentView then
			self.currentView:destroy()
			self.currentView = nil
		end

		local view

		self.currentViewName = name

		-- rangkaian logic view, mana aja viewnya
		if name == "GameMenuView" then
			view = GameMenuView:new(self)
		elseif name == "LevelMenuView" then
			view = LevelMenuView:new(self)
		elseif name == "ActivatorView" then
			view = ActivatorView:new(self)
		elseif name == "SettingsView" then
			view = SettingsView:new (self)
		elseif name == "LifePageView" then
			view = LifePageView:new (self)
		elseif name == "SocialMenuView" then
			view = SocialMenuView:new(self)
		elseif name == "PreLevelView" then
			view = PreLevelView:new(self)
		elseif name == "GamePlayView" then
			view = GamePlayView:new(self)
		elseif name == "finishGameView" then
			view = finishGameView:new(self)
		else
			error( "Unknown view: " .. name )
		end
		
		_G.temporaryData.currentView = name

		self.currentView = view
		enterTransition(view)
		if (name ~= "GamePlayView") then
			self.tutorial = tutorialOverlay:new( view, name )
		end

		
		if showAd then
			Runtime:dispatchEvent({name = "chartBoost", type = "showAd"})
			showAd = false
		end

	end

	function application:onBackKey ()
		-- _G.temporaryData.currentView

		local function onKeyEvent( e )
			if e.keyName == "back" and e.phase == "up" then
				if temporaryData.currentView == "GameMenuView" then
					
					local function listener( event )
						if (event.action == "clicked") then
							if (event.index == 1) then
							 -- doin nothing
							elseif event.index == 2 then
								native.requestExit()
							end
						end
					end

					native.showAlert( "Snooclear", "Are you sure you want to exit the game?", {"No", "Yes"}, listener )

					return true
				elseif temporaryData.currentView == "PreLevelView" then
					-- Runtime:dispatchEvent({name = "toLevelMenu"})
					return true
				elseif temporaryData.currentView == "GamePlayView" or temporaryData.currentView == "ActivatorView" or temporaryData.currentView == "SettingsView" or temporaryData.currentView == "LifePageView" or temporaryData.currentView  == "SocialMenuView" or temporaryData.currentView  == "finishGameView" then
					return true
				elseif temporaryData.currentView  == "LevelMenuView" then
					Runtime:dispatchEvent({name = "toGameMenuView"})
					return true
				else
					return false
				end
			end
		end

		Runtime:addEventListener( "key", onKeyEvent )
	end

	local platformName = system.getInfo("platformName")

	if platformName == "Android" then
		application:onBackKey ()
	end

	application:init()
	Runtime:dispatchEvent({name = "toGameMenuView"})
	
	return application

end

return SnooclearGame

