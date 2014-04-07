require "components.AutoSizeText"
require "components.SocialButton"
require "components.Popup"

GameMenuView = {}

function GameMenuView:new(parentGroup)
	local view = display.newGroup( )
	view.classType = "GameMenuView"
	view.FONT_NAME = "Blanch-CapsInline"


	if parentGroup then
		parentGroup:insert( view )
	end

	function view:init()

		local font = temporaryData.font

		local title = display.newText(self, "SNOOCLEAR" ,display.contentWidth*.5, 272, font.BlanchCapsInline , 120 )
		title.anchorX, title.anchorY = .5,.5
		title:setFillColor( 76/255, 76/255, 76/255 )
		self.title = title

		local LdBallMainObj = display.newImageRect(self, "assets/images/LdBallMainObj.png", 247.5, 31.5)
		LdBallMainObj.anchorX, LdBallMainObj.anchorY = .5,.5
		LdBallMainObj.x, LdBallMainObj.y = display.contentWidth*.5, 542
		self.LdBallMainObj=LdBallMainObj

		local playButton = display.newImageRect( self, "assets/images/PlayMainBtn.png", 554*.5, 131*.5 )
		playButton.anchorX, playButton.anchorY = .5,.5
		playButton.x, playButton.y= display.contentWidth*.5, display.contentHeight -352
		playButton:addEventListener( "touch", self )

		-- Social Button
		local SocialButton = SocialButton:new(self, "color", true, "center")
		self.SocialButton = SocialButton
		SocialButton:addEventListener( "onSocialButtonTouched", self )
		
		-- sambung ke onRegister di mediator
		Runtime:dispatchEvent( {name="onRobotlegsViewCreated", target=self} )
	end

	function view:onSocialButtonTouched(event)
		local Popup = Popup:new(self)
		self:insert( Popup )
		self.popup = Popup

		self:dispatchEvent( {name = "loadPopupSocialContent"} )
		Popup:addEventListener( "facebookLogin", self )
		Popup:addEventListener( "twitterLogin", self )

		local SocialButton = SocialButton:new(self, "closeBtn", true, "center")
		self.SocialButton = SocialButton
		SocialButton:addEventListener( "onSocialCloseButtonTouched", self )
	end

	function view:facebookLogin()
		self:dispatchEvent( {name = "facebookLogin"} )
	end

	function view:twitterLogin()
		self:dispatchEvent( {name = "twitterLogin"} )
	end

	function view:onSocialCloseButtonTouched(event)
		self.popup:destroy()
		self.popup = nil

		local SocialButton = SocialButton:new(self, "color", true, "center")
		self.SocialButton = SocialButton
		SocialButton:addEventListener( "onSocialButtonTouched", self )
	end

	function view:touch(event)
		if (event.phase == "ended") then
			-- audio.play( buttonSound )
			Runtime:dispatchEvent( {name = "buttonSound"} )
			self:dispatchEvent( {name="toLevelMenu"} )
		end
	end

	function view:destroy()
		Runtime:dispatchEvent( {name="onRobotlegsViewDestroyed", target=self} )
		print( "leaving Game Menu View" )
		self:removeSelf( )
	end

	view:init()

	return view

end

return GameMenuView