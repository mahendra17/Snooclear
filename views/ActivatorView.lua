require "components.spin"
require "components.Popup"

ActivatorView = {}

local function position(object, a, b )
	object.x, object.y = a,b
end

function ActivatorView:new(parentGroup)
	local view = display.newGroup( )
	view.classType = "ActivatorView"

	if parentGroup then
		parentGroup:insert( view )
	end


	function view:init()
		local SocialButton = SocialButton:new(self, "grey", false, "corner")
		self.SocialButton = SocialButton

		local LivesButton =  LivesButton:new(self, "grey", false)
		self.LivesButton = LivesButton

		local ActivatorButton = ActivatorButton:new(self, "closeBtn", true)
		self.ActivatorButton = ActivatorButton
		ActivatorButton:addEventListener( "onActivatorCloseButtonTouched", self )

		local SettingButton = SettingButton:new(self, "grey", false) 
		self.SettingButton = SettingButton
		
		image_gy = {}
		image_on = {}

		local imgOff_location = {
			[1]="assets/images/ActvtrBanishGreyedLvlObj.png",
			[2]="assets/images/ActvtrBoostGreyedLvlObj.png",
			[3]="assets/images/ActvtrForceGreyedLvlObj.png",
			[4]="assets/images/ActvtrFrSeeGreyedLvlObj.png",
			[5]="assets/images/ActvtrNullGreyedLvlObj.png",
			[6]="assets/images/ActvtrForceGreyedLvlObj.png"
		}

		local imgPos = {}
		imgPos.x = {[1]=  display.contentCenterX, [2] = 454, [3] = 454, [4] = display.contentCenterX, [5] = 193, [6] = 193} 
		imgPos.y = {[1]=  515,[2] = 583,[3] = 756,[4] = 820.5 ,[5] = 756,[6] = 583}


		local imageGroup = display.newGroup( )
		self:insert( imageGroup )

		for i=1,6 do
			image_gy[i] = display.newImageRect(self, imgOff_location[i], 70, 70)
			position (image_gy[i], imgPos.x[i], imgPos.y[i])
			image_gy[i].isVisible = true

			image_on[i] = display.newImageRect(self, imgOn.location[i],70,70)
			position (image_on [i], imgPos.x[i], imgPos.y[i])
			image_on[i].isVisible = false

			imageGroup:insert( image_gy[i]  )
		end

		imageGroup:addEventListener( "touch", self )
		

		local spinButton = display.newImageRect( self, "assets/images/PrldSpinBtn.png", 544*.5, 110*.5 ) 
		position(spinButton, display.contentCenterX , 385)
		spinButton:addEventListener( "touch", self )


		local activator  = display.newText( "free activator",  display.contentCenterX , 283, temporaryData.font.BlanchCapsInline, 100)
		activator:setFillColor( 0 )
		self:insert(activator)

		Runtime:dispatchEvent( {name="onRobotlegsViewCreated", target=self} )
		
	end

	function view:touch(e)
		if (e.phase == "ended") then
			-- audio.play( buttonSound )
			Runtime:dispatchEvent( {name = "buttonSound"} )
			if _G.gameSettings.dailyActivator.notUsedToday then
				spin_button()
				self:showPopup()
				_G.gameSettings.dailyActivator.notUsedToday = false
				self:dispatchEvent( {name ="saveGameSettings"} )
			elseif _G.gameSettings.dailyActivator.notUsedToday == false then
				local function onComplete( event )
			    	if "clicked" == event.action then
			    	    local i = event.index
			    	    if 1 == i then
			    	      self:dispatchEvent( {name="toLevelMenu"} )
			    	      
			    	    end
			    	end
				end

				local alert = native.showAlert( "Daily Activator", "Sorry, already used this today. Come again tomorrow", {"Ok"}, onComplete )
			end
		end
	end

	function view:showPopup()
		local blanket = display.newRect(self, 0,0, display.actualContentWidth, display.actualContentHeight )
		blanket:setFillColor( gray )
		blanket.anchorX, blanket.anchorY = 0,0

		blanket.alpha = 0.01

		function blanket:tap(event)
			return true
		end

		function blanket:touch(event)
			return true
		end

		blanket:addEventListener( "tap", blanket )
		blanket:addEventListener( "touch", blanket )

		function createPopup()
			blanket:removeEventListener( "tap", blanket )
			blanket:removeEventListener( "touch", blanket )
			blanket:removeSelf( )
			local Popup = Popup:new()
			self:insert( Popup )
			self.popup = Popup

			local function listen( event )
				view:dispatchEvent( {name = "activator", type = event.type , condition =  event.condition} )
			end

			local function toLevelMenu(event)
				self:dispatchEvent( {name="toLevelMenu"} )

				local function firstToUpper(str)
				    return (str:gsub("^%l", string.upper))
				end

				timer.performWithDelay( 300, function()
					native.showAlert( "Success!", firstToUpper(event.activatorName) .. " activator successfully claimed!", {"OK"})
				end ) 
			end

			Popup:addEventListener( "activator", listen )
			Popup:addEventListener( "toLevelMenu", toLevelMenu )

			self:dispatchEvent( {name = "loadPopupActivatorContent"} )
		end

		-- should be replaced with "few moments after spinning done"
		timer.performWithDelay( tunggu, createPopup )
	end

	function view:onClaim()
		self.popup:destroy()
		self.popup = nil
	end

	function view:onActivatorCloseButtonTouched(  )
		self:dispatchEvent( {name="toLevelMenu"} )
	end

	function view:destroy()
		Runtime:dispatchEvent( {name="onRobotlegsViewDestroyed", target=self} )
		self:removeSelf( )
	end

	view:init()

	return view
end