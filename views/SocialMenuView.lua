require "components.SocialButton"
require "components.ActivatorButton"
require "components.LivesButton"
require "components.SettingsButton"

SocialMenuView = {}

function SocialMenuView:new(parentGroup)
	local view = display.newGroup( )
	view.classType = "SocialMenuView"

	if parentGroup then
		parentGroup:insert( view )
	end	

	function view:init()

		local font = temporaryData.font

		-- 4 corners buttons
		local SocialButton = SocialButton:new(self, "closeBtn", true, "corner")
		self.SocialButton = SocialButton
		SocialButton:addEventListener( "onSocialCloseButtonTouched", self )

		local LivesButton =  LivesButton:new(self, "grey", false)
		self.LivesButton = LivesButton

		local ActivatorButton = ActivatorButton:new(self, "grey", false)
		self.ActivatorButton =ActivatorButton

		local SettingButton = SettingButton:new(self, "grey", false) 
		self.SettingButton =SettingButton

		-- Social text
		local connect = display.newText(self, "CONNECT" ,(display.contentWidth*.5),280, font.BlanchCapsInline, 100)
		connect:setFillColor( 76/255, 76/255, 76/255)
		connect.anchorX, connect.anchorY = .5,.5

		local text = display.newText(self, "YOU ARE NOT ALONE", (display.contentWidth*.5),410, font.BlanchCaps, 60)
		text:setFillColor( 76/255, 76/255, 76/255)

		-- Social Buttons
		local LvMnFbBtn = display.newImageRect( self, "assets/images/LvMnFbBtn.png",150, 150 )
		LvMnFbBtn.name = "Facebook"
		LvMnFbBtn.anchorX, LvMnFbBtn.anchorY = .5,.5
		LvMnFbBtn.x, LvMnFbBtn.y = 227, display.contentHeight-600
		LvMnFbBtn:addEventListener( "touch", self )

		local LvMnTwtrBtn = display.newImageRect( self, "assets/images/LvMnTwtrBtn.png", 150, 150 )
		LvMnTwtrBtn.name = "Twitter"
		LvMnTwtrBtn.anchorX, LvMnTwtrBtn.anchorY = .5,.5
		LvMnTwtrBtn.x, LvMnTwtrBtn.y = display.contentWidth-227, display.contentHeight-600
		LvMnTwtrBtn:addEventListener( "touch", self )
		
		local twitterCanConnect = false

		if not twitterCanConnect then
			LvMnTwtrBtn.isVisible = false
			LvMnFbBtn.x = display.contentCenterX
			LvMnFbBtn.y = LvMnFbBtn.y + 50
		end

		Runtime:dispatchEvent( {name="onRobotlegsViewCreated", target=self} )
	end
	
	-- function fbButtonListener( event )
	-- 	if (event.phase == "ended") then
			
	-- 	end
	-- 	return true
	-- end

	-- function twitterButtonListener( event )
		
	-- 	local options = {
	-- 	   service = "twitter",
	-- 	   message = "Check out these photos!",
	-- 	   listener = socialEventListener,
	-- 	   url = "http://coronalabs.com"
	-- 	}

	-- 	if (event.phase == "ended") then
	-- 		if (native.canShowPopup ("social", "twitter")) then
	-- 		native.showPopup( "social", options )
	-- 		else
	-- 		print( "can't show twitter native popup" ) 
	-- 		end
	-- 	end
	-- 	return true
	-- end

	function view:touch( e )
		if e.phase == "ended" then
			self:dispatchEvent( {name = "social", service = e.target.name, type= "connect" } )
		end
	end

	function view:onSocialCloseButtonTouched(event)
		print( "Social Close Button in Level Menu is tapped" )
		self:dispatchEvent( {name="toLevelMenu"} )
	end
		
	function view:destroy()
		Runtime:dispatchEvent( {name="onRobotlegsViewDestroyed", target=self} )
		self:removeSelf( )
	end

	view:init()

	return view

end

return SocialMenuView