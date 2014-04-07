local facebook = require( "facebook" )

local splash = display.newGroup( )
local background = display.newRect(splash, 0, 0, display.actualContentWidth, display.actualContentHeight)
local splashScreen = display.newImageRect(splash, "splash.png", display.contentWidth, display.contentHeight)

splash.anchorX, splash.anchorY = 0.5,0.5
splash.x, splash.y = display.contentCenterX, display.contentCenterY
splashScreen.alpha = 0
transition.to( splashScreen, { delay =300,alpha=1} )


local function startApp ()
	local function bootstrap ()
		display.setStatusBar( display.HiddenStatusBar )
		_G.stage = display.getCurrentStage( )

		require "SnooclearGame"
		local app = SnooclearGame:new( )

	end

	bootstrap()

end

local function onError (e)
	return true
end

Runtime:addEventListener( "unhandledError", onError )
timer.performWithDelay( 2900, function()
	startApp()
	timer.performWithDelay( 400, function()
		splash:removeSelf( )
		splash = nil
	end )
end)


system.setIdleTimer( false )