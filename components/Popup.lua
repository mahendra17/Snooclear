require "components.SettingsButton"
require "components.activatorImageData"
-- require "components.slideView"

local slideView = require( "components.slideView")
local fbAppID = "258512944311281"
local json = require("json")

require "services.ReadFileContentsService"

Popup = {}

function Popup:new(parentGroup)

	local view = display.newGroup()

	if parentGroup then
		parentGroup:insert(view)
	end


	function view:init()
		local background = display.newRect( self, 0,0, display.actualContentWidth, display.actualContentHeight )
		background:setFillColor( gray )
		background.anchorX, background.anchorY = 0,0

		background.alpha = 0.01

		function background:tap(event)
			return true
		end

		function background:touch(event)
			return true
		end

		background:addEventListener( "tap", background )
		background:addEventListener( "touch", background )

		local floatingBackground = display.newImageRect( self, "assets/images/FloatLvlObj.png", 541.5, 706.5 )
		floatingBackground.anchorX, floatingBackground.anchorY = .5,.5 
		floatingBackground.x, floatingBackground.y = display.contentWidth*.5, 567.5
		self.floatingBackground = floatingBackground

		Runtime:addEventListener( "loadPopupSocialContent", self )
		Runtime:addEventListener( "loadPopupActivatorContent", self)
		Runtime:addEventListener( "loadPopupHowToPlay", self)
		Runtime:addEventListener( "loadPopupRestorePurchases", self)
		Runtime:addEventListener( "loadPopupEmail", self)
		Runtime:addEventListener( "highScoreBoard", self )
		Runtime:addEventListener( "createButton", self)
		Runtime:addEventListener( "createLoading", self )
	end

	function text_format(text)
		text.anchorX, text.anchorY = 0.5,0.5
		text:setFillColor( 76/255, 76/255, 76/255 )
	end

	function view:createLoading(event)
		-- local count 
		-- if (event.number) then
		-- 	print( "this side" )
		-- 	count = event.number
		-- else
		-- 	count = event
		-- end
		event.number  = event.number +1
		local dots = ""
		for i=1,event.number%4 do
			dots = dots .. "."
		end
		local loadingText = display.newText( self, "Loading" .. dots, 218, 1136-600, "Blanch-Caps", 60 )
		loadingText.anchorX, loadingText.anchorY = 0,0.5
		self:insert(loadingText)
		loadingText:setFillColor( 63/255, 63/255, 63/255, 0.4)

		timer.performWithDelay( 300, function()
			loadingText:removeSelf( )
			loadingText = nil
			if (not self.scoreboardGroup) then
				self:createLoading(event)
			end
		end )
	end

	function view:createButton()
		local title = display.newText(self, "Hall of fame", display.contentCenterX, display.contentCenterY* .5 , temporaryData.font.BlanchCapsInline, 100 )
		title:setFillColor( 63/255,63/255,63/255 )
		-- self:insert( title )

		local function close(event)
			if (event.phase == "ended") then
				self.closeBtn:removeSelf( )
				self.closeBtn = nil
				self:destroy()
				return true
			end
		end

		local closeBtn = display.newImageRect( "assets/images/ActvtrLvlXBtn.png", 80, 80)
		self.closeBtn = closeBtn
		closeBtn.anchorX, closeBtn.anchorY = 1,1
		closeBtn.x, closeBtn.y =  display.contentWidth-40.7 , display.contentHeight-36.6
		closeBtn:addEventListener( "touch", close )
		self:insert(closeBtn)

		
		if temporaryData.currentView == "PreLevelView" then
			local LivesBtn = display.newImageRect( "assets/images/greyCloseBtn.png", 80, 80)
			LivesBtn.anchorX, LivesBtn.anchorY = 0,0
			LivesBtn.x, LivesBtn.y = 40.7, 36.6
			self:insert(LivesBtn)
		end
	end

	function view:loadScoreboard(event)
		-- local group = display.newGroup( )
		-- local data = event.data

		-- local name = data[#data].user.name .. ".png"
		-- print( "photos to be loaded " .. tostring( #data ) )

		-- local gambar = display.newImageRect( self, name, system.DocumentsDirectory, 5, 5 )
		-- gambar.alpha = 0.01
		-- -- group:insert( gambar )
		-- if (gambar) then
		-- 	self:insert(gambar)
		-- 	self:highScoreBoard(data)
		-- elseif (not gambar) and (popupstatus == true) then
		-- 	timer.performWithDelay( 350, function()
		-- 		self:loadScoreboard(event)
		-- 	end )
		-- end
		-- return group

	end

	function view:highScoreBoard ( event )
		local data = event.scores
		print( "starting scoreboaard" )
		print( "data to be displayed " .. tostring( #data ) )
		local username = {}
		for i=1,#data do
			username[i] = data[i].user.name
			print( data[i].user.name )
		end
		function string:split( inSplitPattern, outResults )

		   if not outResults then
		      outResults = { }
		   end
		   local theStart = 1
		   local theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
		   while theSplitStart do
		      table.insert( outResults, string.sub( self, theStart, theSplitStart-1 ) )
		      theStart = theSplitEnd + 1
		      theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
		   end
		   table.insert( outResults, string.sub( self, theStart ) )
		   return outResults
		end

		local maxNumDisplayed = 5

		-- assumption : sorted score

		local location = { y = {1136-715,1136-620.5,1136-530.5,1136-434,1136-343}, x = {photo = 128.5, name = 218, score = 417 }, }

		local numDisplayed = math.min( #data, maxNumDisplayed )
		local scoreboardGroup = display.newGroup( )
		self:insert(scoreboardGroup)
		self.scoreboardGroup = scoreboardGroup

		local displayData = {name = {}, score = {}, photo = {}}
		-- self:insert( displayData )
		self.displayData = displayData
		local mask = graphics.newMask( "assets/images/maskButton.png" )
		local maxStr = 11
		local endStr

		for i=1,numDisplayed do
			local numDispStr
			data[i].user.name = username[i]:split(" ") --data[i].user.name:split(" ") --get only the first name
			if (string.len(data[i].user.name[1]) > maxStr) then
				endStr = "..."
				numDispStr = 9
			else
				endStr = ""
				numDispStr = math.min( string.len( data[i].user.name[1] ), 11 )
			end
			-- print( data[i].user.name[1] )
			data[i].user.name[1]= string.sub(data[i].user.name[1], 1, numDispStr) .. endStr
			displayData.name [i] = display.newText( data[i].user.name[1], location.x.name , location.y[i] , "Blanch-Caps", 60 ) 
			displayData.name [i]:setFillColor( gray )
			displayData.name [i].anchorX, displayData.name[i].anchorY = 0,0.5
			view:insert( displayData.name[i] )
			scoreboardGroup:insert(displayData.name[i])

			displayData.score [i] = display.newText(data[i].score, location.x.score , location.y[i] , "Blanch-Caps", 60 ) 
			displayData.score [i]:setFillColor( 255/255,186/255,3/255 )
			displayData.score [i].anchorX, displayData.score[i].anchorY = 1,0.5
			view:insert( displayData.score[i] )
			scoreboardGroup:insert(displayData.score[i])

			local photoName = username[i] .. ".png"
			displayData.photo[i] = display.newImageRect( photoName, system.DocumentsDirectory, 80, 80 )
			displayData.photo[i].x, displayData.photo[i].y = location.x.photo, location.y[i]
			displayData.photo[i]:setMask( mask )
			displayData.photo[i].maskScaleX, displayData.photo[i].maskScaleY = .2, .2
			displayData.photo[i].anchorX, displayData.photo[i].anchorY = 0,0.5
			view:insert( displayData.photo[i]  )
			scoreboardGroup:insert(displayData.photo[i])
		end
		scoreboardGroup.alpha = 0
		transition.to( scoreboardGroup, {time = 400, alpha = 1} )
		return displayData
	end

	function view:loadPopupSocialContent()
		-- Social text
		local connect = display.newText(self, "CONNECT" ,(display.contentWidth*.5),340.5, temporaryData.font.BlanchCaps, 100)
		connect:setFillColor( 76/255, 76/255, 76/255)
		connect.anchorX, connect.anchorY = .5,.5
		-- connect.x, connect.y = display.contentWidth*.5, 340.5

		local text = display.newText(self, "YOU ARE NOT ALONE", (display.contentWidth*.5),414.5, temporaryData.font.BlanchCaps, 50)
		text:setFillColor( 76/255, 76/255, 76/255)

		-- Social buttons		
		local LvMnFbBtn = display.newImageRect( self, "assets/images/LvMnFbBtn.png",120, 120 )
		LvMnFbBtn.anchorX, LvMnFbBtn.anchorY = .5,.5
		LvMnFbBtn.x, LvMnFbBtn.y = 227, display.contentHeight-567.5

		local LvMnTwtrBtn = display.newImageRect( self, "assets/images/LvMnTwtrBtn.png", 120, 120 )
		LvMnTwtrBtn.anchorX, LvMnTwtrBtn.anchorY = .5,.5
		LvMnTwtrBtn.x, LvMnTwtrBtn.y = display.contentWidth-227, display.contentHeight-567.5

		self.FacebookButton = LvMnFbBtn
		self.TwitterButton = LvMnTwtrBtn

		function socialButtonTouched( event )
			if (event.phase == "ended") then
					if (event.target == self.FacebookButton) then
						self:dispatchEvent( {name = "facebookLogin", target = self} )
					elseif (event.target == self.TwitterButton) then
						self:dispatchEvent( {name = "twitterLogin", target = self} )
					end
			end
		end

		local twitterCanConnect = false

		if not twitterCanConnect then
			LvMnTwtrBtn.isVisible = false
			LvMnFbBtn.x = display.contentCenterX
		end

		LvMnFbBtn:addEventListener( "touch", socialButtonTouched )
		LvMnTwtrBtn:addEventListener( "touch", socialButtonTouched )
	end

	function view:socialShare( )

		local function onLivesCloseButtonTouchedListener( )
			self:destroy()
		end

		local LivesButton =  LivesButton:new(self, "closeBtn", true)
		LivesButton:addEventListener( "onLivesCloseButtonTouched", onLivesCloseButtonTouchedListener )

		--==================================================================================================
		
		local function listener( e )
			if e.phase == "ended" then
				self:dispatchEvent( {name = "social", type= "shareGetLives", service = e.target.name} )
			end
		end

		local text1 = display.newText(self, "ASK FRIEND", display.contentCenterX ,368.5, temporaryData.font.BlanchCaps, 70)
		text1:setFillColor( 76/255, 76/255, 76/255)

		local text2 = display.newText(self, "MESSAGE FRIEND", display.contentCenterX , display.contentHeight-523,temporaryData.font.BlanchCaps, 70)
		text2:setFillColor( 76/255, 76/255, 76/255)

		local facebookButton =  display.newImageRect( self, "assets/images/LvMnFbBtn.png",120, 120 )
		facebookButton.anchorX, facebookButton.anchorY = .5,.5
		facebookButton.x, facebookButton.y = 223.5, 484.5
		facebookButton.name = "facebook"
		facebookButton:addEventListener( "touch", listener )

		local twitterButton =  display.newImageRect( self, "assets/images/LvMnTwtrBtn.png", 120, 120 )
		twitterButton.anchorX, twitterButton.anchorY = .5,.5
		twitterButton.x, twitterButton.y = 401, 484.5
		twitterButton.name = "twitter"
		twitterButton:addEventListener( "touch", listener )

		local messageButton = display.newImageRect( self, "assets/images/SubLvMnMsgObj.png", 120, 120 )
		messageButton.anchorX, messageButton.anchorY = .5,.5
		messageButton.x, messageButton.y = display.contentCenterX ,  display.contentHeight - 411.5
		messageButton.name = "message"
		messageButton:addEventListener( "touch", listener )

		local cY = display.contentCenterY
		
		if native.canShowPopup( "sms" ) and (native.canShowPopup ("social", "twitter")) then
			-- do nothing
		elseif not native.canShowPopup( "sms" ) and (native.canShowPopup ("social", "twitter")) then
			messageButton.isVisible = false
			text2.isVisible = false


			twitterButton.y , facebookButton.y = cY, cY

			text1.y = cY - 120

		elseif native.canShowPopup( "sms" ) and not (native.canShowPopup ("social", "twitter")) then
			text2.isVisible = false
			twitterButton.isVisible = false
			text1.y = cY - 120

			facebookButton.y = cY
			messageButton.x, messageButton.y = twitterButton.x, cY
		elseif not native.canShowPopup( "sms" ) and not (native.canShowPopup ("social", "twitter")) then
			twitterButton.isVisible = false
			messageButton.isVisible = false
			text2.isVisible = false

			text1.y = cY - 120
			facebookButton.x, facebookButton.y = display.contentCenterX, cY
		end
	end

	function view:loadPopupActivatorContent()
		local text1 = display.newText(self, "You got",display.contentWidth*.5 ,321, temporaryData.font.BlanchCaps, 50)
		text_format(text1)
		local text2 = display.newText(self, imgOn.name[666].." !",display.contentWidth*.5 ,373, temporaryData.font.BlanchCapsInline, 100)
		text_format(text2)
		local text3 = display.newText(self, imgOn.description[666],display.contentWidth*.5 ,431, temporaryData.font.BlanchCaps, 50)
		text_format(text3)

		local bonusImage = display.newImageRect( self, imgOn.location[666], 156.5, 156.5 )
		bonusImage.anchorX, bonusImage.anchorY = .5, .5
		bonusImage.x, bonusImage.y = display.contentWidth*.5, display.contentHeight-544
		self:dispatchEvent( {name = "activator", type = imgOn.name[666], condition =  "add"} )

		local function claimButtonTouched(event)
			if (event.phase == "ended") then
				Runtime:dispatchEvent( {name = "buttonSound"} )
				Runtime:dispatchEvent( {name = "onClaim"} )
				self:dispatchEvent( {name = "toLevelMenu", activatorName = imgOn.name[666] } )
			end
		end

		local claimButton = display.newImageRect( self, "assets/images/PrldClaimBtn.png", 274*1.029, 29.9*1.737 )
		claimButton.anchorX, claimButton.anchorY = .5, .5
		claimButton.x, claimButton.y = display.contentWidth*.5, display.contentHeight-339.5
		claimButton:addEventListener( "touch", claimButtonTouched )
		bonusImage:addEventListener( "touch", claimButtonTouched )

		local LivesBtn = display.newImageRect( "assets/images/greyCloseBtn.png", 80, 80)
		LivesBtn.anchorX, LivesBtn.anchorY = 1,0
		LivesBtn.x, LivesBtn.y = display.contentWidth- 40.7,36.6
		self:insert(LivesBtn)

	end

	function view:loadPopupHowToPlay()
		self.floatingBackground:removeSelf( )

		local showHowToPlay = slideView.new(self, 6)
		self:insert( showHowToPlay )
		
		local closePopupButton = SettingButton:new(new, "closeBtn", true) 
		self.closePopupButton = closePopupButton
		closePopupButton:addEventListener( "onSettingCloseButtonTouched", self )
	end

	function view:loadPopupRestorePurchases()
		local restoreContent = display.newGroup( )
		self:insert( restoreContent )

		local text1 = display.newText(restoreContent, "Restoring",display.contentWidth*.5 ,350, temporaryData.font.BlanchCapsInline , 100)
		text_format(text1)

		local restoreImage = display.newImageRect( restoreContent, "assets/images/SubLvMnRstrGreyedObj.png", 210, 210 )
		restoreImage.anchorX, restoreImage.anchorY = .5, .5
		restoreImage.x, restoreImage.y = display.contentWidth*.5, display.contentHeight-544

		local function onPurchaseRestored()
			restoreContent:removeSelf( )
			restoreContent = nil
			local text1 = display.newText(self, "Restored!",display.contentWidth*.5 ,350, temporaryData.font.BlanchCapsInline, 100)
			text_format(text1)

			local restoreImage = display.newImageRect( self, "assets/images/SubLvMnRstrObj.png", 210, 210 )
			restoreImage.anchorX, restoreImage.anchorY = .5, .5
			restoreImage.x, restoreImage.y = display.contentWidth*.5, display.contentHeight-544

			local function claimButtonTouched(event)
				if (event.phase == "ended") then
					-- audio.play( buttonSound )
					Runtime:dispatchEvent( {name = "buttonSound"} )
					Runtime:dispatchEvent( {name = "onClosePopup"} )
				end
			end

			local claimButton = display.newImageRect( self, "assets/images/PrldClaimBtn.png", 274*1.029, 29.9*1.737 )
			claimButton.anchorX, claimButton.anchorY = .5, .5
			claimButton.x, claimButton.y = display.contentWidth*.5, display.contentHeight-339.5
			claimButton:addEventListener( "touch", claimButtonTouched )
		end

		timer.performWithDelay( 1000, onPurchaseRestored )

	end

	function view:loadPopupEmail()
		local text1 = display.newText(self, "Be in touch",display.contentWidth*.5 ,350, temporaryData.font.BlanchCapsInline, 100)
		text_format(text1)

		local contactImage = display.newImageRect( self, "assets/images/SetPokeBtn.png", 210, 210 )
		contactImage.anchorX, contactImage.anchorY = .5, .5
		contactImage.x, contactImage.y = display.contentWidth*.5, display.contentHeight-544

		local function contactUsButtonTouched(event)
			if (event.phase == "ended") then
				-- audio.play( buttonSound )
				Runtime:dispatchEvent( {name = "buttonSound"} )
				print( "go to external email" )
				Runtime:dispatchEvent( {name = "goToEmail"} )
				local options = {
				to = "snooclear@senja.co.uk",
				subject = "Snooclear Feedback",
				body = "Howdy, Snooclear developers!",
			}
				native.showPopup( "mail", options  )
			end
		end

		local contactUsButton = display.newImageRect( self, "assets/images/PrldCntctUsBtn.png", 274*1.029, 29.9*1.737 )
		contactUsButton.anchorX, contactUsButton.anchorY = .5, .5
		contactUsButton.x, contactUsButton.y = display.contentWidth*.5, display.contentHeight-339.5
		contactUsButton:addEventListener( "touch", contactUsButtonTouched )
		contactImage:addEventListener( "touch", contactUsButtonTouched )

		-- back to settings button
		local closePopupButton = SettingButton:new(new, "closeBtn", true) 
		self.closePopupButton = closePopupButton
		closePopupButton:addEventListener( "onSettingCloseButtonTouched", self )
	end

	function view:onSettingCloseButtonTouched( event )
		self.closePopupButton:removeSelf( )
		self.closePopupButton = nil
		Runtime:dispatchEvent( {name = "onClosePopup"} )
	end

	function view:loadPopupGameOver()
		
		local outofEnergy = display.newText(self, "Out of Energy",display.contentWidth*.5 ,373, temporaryData.font.BlanchCapsInline, 90)
		text_format(outofEnergy)

		-- local retry = display.newText(self, "retry",display.contentWidth*.5 ,520, "Blanch Caps", 80)
		-- text_format(retry)

		-- PrldRetryBtn

		local retry = display.newImageRect ("assets/images/PrldRetryBtn.png", 796*.5, 131*.5, true)
		retry.anchorX, retry.anchorY, retry.x, retry.y = .5,.5, display.contentCenterX, 520
		self:insert(retry)

		local function onRetryTouch( event )

			if (event.phase == "ended") then
				self:destroy()

				function dispatchToPreLevel(  )
					if (self) then
						self:dispatchEvent( {name = "toPreLevel", target = self} )
					end
				end

				timer.performWithDelay( 300, dispatchToPreLevel )
			end
		end 

		retry:addEventListener( "touch", onRetryTouch )

		local goToMenu = display.newImageRect ("assets/images/PrldQuitLvlBtn.png", 796*.5, 131*.5, true)
		goToMenu.anchorX, goToMenu.anchorY, goToMenu.x, goToMenu.y = .5,.5, display.contentCenterX, 673
		self:insert(goToMenu)

		local function goToMenuClicked(event)
			if (event.phase == "ended") then
				self:destroy()

				function dispatchGoToMenu(  )
					self:dispatchEvent( {name = "goToMenu", target = self} )
				end

				timer.performWithDelay( 300, dispatchGoToMenu )
			end
		end
		
		goToMenu:addEventListener( "touch", goToMenuClicked )
	end

	function view:loadPopupOnGamePause()

		local keepPlaying = display.newImageRect ("assets/images/PrldKeepPlayBtn.png", 771*.5, 110*.5, true)
		keepPlaying.anchorX, keepPlaying.anchorY, keepPlaying.x, keepPlaying.y = .5,.5, display.contentCenterX, display.contentCenterY - 150
		self:insert(keepPlaying)

		function resumeGame(event)
			if (event.phase == "ended") then
				self:destroy()

				function dispatchResume(  )
					self:dispatchEvent( {name = "resume", target = self} )
				end

				timer.performWithDelay( 1, dispatchResume )
			end
		end
		
		keepPlaying:addEventListener( "touch", resumeGame )
		
		local goToMenu = display.newImageRect ("assets/images/PrldQuitLvlBtn.png", 771*.5, 131*.5, true)
		goToMenu.anchorX, goToMenu.anchorY, goToMenu.x, goToMenu.y = .5,.5, display.contentCenterX, display.contentCenterY + 150
		self:insert(goToMenu)


		function goToMenuClicked(event)
			if (event.phase == "ended") then
				self:destroy()

				function dispatchGoToMenu(  )
					self:dispatchEvent( {name = "goToMenu", target = self} )
				end

				timer.performWithDelay( 300, dispatchGoToMenu )
			end
		end
		
		goToMenu:addEventListener( "touch", goToMenuClicked )

		local soundSettingON = display.newImageRect ("assets/images/PrldSoundOnBtn.png", 771*.5, 126*.5, true)
		local soundSettingOFF = display.newImageRect ("assets/images/PrldSoundOnGreyedBtn.png", 771*.5, 117*.5, true)

		soundSettingON.anchorX, soundSettingON.anchorY, soundSettingON.x, soundSettingON.y = .5,.5, display.contentCenterX,display.contentCenterY 
		soundSettingOFF.anchorX, soundSettingOFF.anchorY, soundSettingOFF.x, soundSettingOFF.y = .5,.5, display.contentCenterX,display.contentCenterY 
		
		self:insert(soundSettingOFF); self:insert(soundSettingON)

		local function updateStatus( )
			if gameSettings.soundOn then
				soundSettingON.isVisible = true
				soundSettingOFF.isVisible = false
			else
				soundSettingON.isVisible = false
				soundSettingOFF.isVisible = true
			end
		end
		updateStatus( )

		local function touchListen ( e )
			if e.phase == "ended" then
				Runtime:dispatchEvent({name = "changeSettings", type = "sound"})
				updateStatus()
			end
		end

		soundSettingON:addEventListener( "touch",  touchListen)
		soundSettingOFF:addEventListener( "touch",  touchListen)

		
	end
	-- Activator activated in game
	function view:loadPopupActivators( event )

		for i=1,#image do
			if (event.type == image[i].name) then
				event.activeLogo = image[i].on
				event.designation = event.type
				event.desc = image[i].desc
			end
		end

		local text2 = display.newText(self, event.designation,display.contentWidth*.5 ,373, temporaryData.font.BlanchCapsInline, 110)
		text_format(text2)
		local text3 = display.newText(self, event.desc,display.contentWidth*.5 ,740, temporaryData.font.BlanchCaps, 65)
		text_format(text3)

		local actImage = display.newImageRect( self, event.activeLogo, 156.5, 156.5 )
		actImage.anchorX, actImage.anchorY = .5, .5
		actImage.x, actImage.y = display.contentWidth*.5, display.contentHeight-544

		local function listener(  )
			self:destroy()
			self:dispatchEvent( {name = "startPhysics", target = self} )
		end

		timer.performWithDelay( 1000, listener  )		
	end

	function view:destroy()
		exitTransition(self)

		Runtime:removeEventListener( "loadPopupSocialContent", self)
		Runtime:removeEventListener( "loadPopupActivatorContent", self)
		Runtime:removeEventListener( "loadPopupHowToPlay", self)
		Runtime:removeEventListener( "loadPopupRestorePurchases", self)
		Runtime:removeEventListener( "loadPopupEmail", self)
		Runtime:removeEventListener( "highScoreBoard", self )
		Runtime:removeEventListener( "createButton", self)
		Runtime:removeEventListener( "createLoading", self )

		local function removePopup()
			self:removeSelf( )
		end

		timer.performWithDelay( 300, removePopup )
	end

	view:init()
	enterTransition(view)

	return view
end

return Popup