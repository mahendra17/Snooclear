
-- require "components.SocialButton"
require "components.LivesButton"
require "components.gamePlay.preLevelGameActivator"
require "components.SocialButton"
require "components.Popup"

-- read user data
require "services.ReadFileContentsService"

require "services.data.preLevelData"

PreLevelView = {}

function PreLevelView:new(parentGroup)
	local view = display.newGroup( )
	view.classType = "PreLevelView"

	local user = loadTable ("userdata.json", system.DocumentsDirectory)

	local font  = temporaryData.font

	if parentGroup then
		parentGroup:insert( view )
	end

	function view:init()

		local LivesButton = LivesButton:new(self, "closeBtn", true)
		self.LivesButton = LivesButton
		LivesButton:addEventListener( "onLivesCloseButtonTouched", self )

		local playBtn = display.newImageRect ("assets/images/PlayMainBtn.png", 554*.5, 131*.5, true)
		self.playBtn = playBtn
		playBtn.anchorX, playBtn.anchorY = .5,.5
		playBtn.x, playBtn.y= display.contentWidth*.5, 795
		playBtn:addEventListener( "touch", self)
		self:insert( playBtn )

		local preloadProfilBtn  = display.newImageRect( "assets/images/PrldProfilBtn.png",80, 80)
		preloadProfilBtn.anchorX,preloadProfilBtn.anchorY = 0,1
		preloadProfilBtn.x, preloadProfilBtn.y = 40.7, display.contentHeight - 36.6
		self:insert( preloadProfilBtn )

		local scoreBoardButton  = display.newImageRect(self, "assets/images/LvMnTrophyBtn.png",80, 80)
		self.scoreBoardButton = scoreBoardButton
		scoreBoardButton.anchorX,scoreBoardButton.anchorY = 1,1
		scoreBoardButton.x, scoreBoardButton.y = display.contentWidth-40.7 , display.contentHeight-36.6
		scoreBoardButton:addEventListener( "touch", self )

		--text-----------------------------------------------------------------------
		local targetShow = false

		local text = display.newGroup( )

		local text_1 = display.newText( "Level " .. tostring( _G.currentLevel ) , display.contentCenterX ,266, font.BlanchCapsInline, 120 ) 
		text_1:setFillColor( 76/255, 76/255, 76/255 )
		self:insert( text_1 )

		local text_2 = display.newText( "REACH", display.contentCenterX ,390.5, "Blanch-Caps", 60 ) 
		text_2:setFillColor(63/255,63/255,63/255)
		self:insert( text_2 )

		local text_3 = display.newText( tostring ( PrelevelData[_G.currentLevel].target), display.contentCenterX ,458.5, "Blanch-Caps", 100 ) 
		text_3:setFillColor (255/255,186/255,3/255)
		self:insert( text_3 )
		
		local text_4 = display.newText( "ACTIVATOR", display.contentCenterX , 562 , font.BlanchCaps, 60 ) 
		text_4:setFillColor( 76/255, 76/255, 76/255 )
		self:insert( text_4 )

		local activator = ingameActivator:new( self )
		
		if targetShow then
			--do Nothing
		else
			text_2.isVisible = false
			text_3.isVisible = false
			text_1.y = text_1.y + 10

			local activatorGroup = display.newGroup( ) ; self:insert( activatorGroup )
			activatorGroup:insert( text_4)
			activatorGroup:insert( activator )

			-- activatorGroup.anchorY = .5

			-- activatorGroup.y = text_1.y + ((-playBtn.y + text_1.y) * .5)

			activatorGroup.y = activatorGroup.y - 75
		end

		self.profilePicture = self:setProfilePicture()
		self:insert( self.profilePicture )

		----------------------------------------------------------------------------------
		Runtime:dispatchEvent( {name="onRobotlegsViewCreated", target=self} )
	end

	local function facebookAlert(event)
		 if "clicked" == event.action then
	        if 1 == event.index then
				print( "connecting to facebook" )
	            view:dispatchEvent( {name = "facebookLogin"} )
	            timer.performWithDelay( 4000, function ()
		            view.profilePicture = view:setProfilePicture("force")
	            end )
	        end
	    end
	end

	local function facebookConnect(event)
		if (event.phase == "ended") then
			native.showAlert( "Snooclear", "Do you want to connect Snooclear to your Facebook account?", {"Yes", "No"}, facebookAlert )
		end
	end

	local count = 0
	local myText1 = display.newText({text = "",x = 222, y =display.contentHeight - 70,  width = 185,height = 100, font = font.BlanchCaps,fontSize = 36})
	view:insert( myText1 )
	myText1:addEventListener( "touch", facebookConnect )
	myText1:setFillColor( 255/255, 30/255, 40/255 )

	function view:setProfilePicture(options)
		if (self.profilePicture) then
			view.profilePicture:removeSelf( )
            -- view.profilePicture = nil
		end
		
		local group = display.newGroup( )
		self:insert( group)
		print( "displaying profilePicture" )
		local user = loadTable ("userdata.json", system.DocumentsDirectory)

		if (user) then
			if (user.facebook) then
				local mask = graphics.newMask( "assets/images/maskButton.png" )

				local profilePicture = display.newImageRect( group, "profilePicture.png", system.DocumentsDirectory, 80, 80 )
				if (profilePicture) then
					profilePicture.x, profilePicture.y = 40.7, display.contentHeight - 36.6
					profilePicture.anchorX, profilePicture.anchorY = 0,1
					profilePicture:setMask( mask )
					profilePicture.maskScaleX, profilePicture.maskScaleY = .2, .2

					myText1.isVisible = false
					myText1:removeEventListener( "touch", facebookConnect  )

					local userText = display.newText({text = "HI " .. user.facebook.firstName .. "!",x = 237, y =display.contentHeight - 70,  width = 200,height = 100, font = font.BlanchCaps,fontSize = 70})
					self:insert( userText )
					userText:setFillColor( 0 )
					profilePicture.alpha = 0
					transition.to( profilePicture, {alpha = 1, time = 300} )

					userText.alpha = 0
					transition.to( userText, {alpha = 1, time = 300, onComplete = function()
						if (self.preloadProfileButton) then
							self.preloadProfileButton:removeSelf( )
							self.preloadProfileButton = nil
						end
					end} )
				else
					count = count+1
					local dots = ""
					for i=1,count%4 do
						dots = dots .. "."
					end
					myText1.text = "Retrieving account details" .. dots
					self:insert( myText1)
					-- myText1 = display.newText({text = completeText,x = 222, y =display.contentHeight - 70,  width = 185,height = 100, font = "Blanch-Caps",fontSize = 36})
			
					timer.performWithDelay( 400, function()
						view:setProfilePicture("force")
					end )					
				end

			end
		else
				local preloadProfilBtn  = display.newImageRect( "assets/images/PrldProfilBtn.png",80, 80)
				preloadProfilBtn.anchorX,preloadProfilBtn.anchorY = 0,1
				preloadProfilBtn.x, preloadProfilBtn.y = 40.7, display.contentHeight - 36.6
				self:insert( preloadProfilBtn )
				self.preloadProfileButton = preloadProfilBtn
				
			if (options) then
				count = count+1
				local dots = ""
				for i=1,count%4 do
					dots = dots .. "."
				end
				myText1.text = "Retrieving account details" .. dots

				timer.performWithDelay( 400, function()
					self:setProfilePicture("force")
					end )
			else
				myText1 = display.newText({text = "CONNECT TO SEE YOUR FRIENDS' SCORE",x = 222, y =display.contentHeight - 70,  width = 185,height = 100, font = font.BlanchCaps,fontSize = 36})
				myText1:setFillColor( 0 )
				self:insert( myText1)

			end
		end

		return group
	end
	
	function view:onSocialCloseButtonTouched( event )
		-- self:dispatchEvent( {name= "socialPopup"} )
		-- print( "social function popup" )
	end

	function view:onLivesCloseButtonTouched( event )
		if (event.target == self.LivesButton) then
			self:dispatchEvent( {name= "toLevelMenu"} )
		elseif event.target == self.closeScoreboard then
			print( "closingpopup" )
			self.Popup:destroy()
			self.Popup = nil

			self.closeScoreboard:removeSelf( )
			self.closeScoreboard = nil
		end
	end

	function view:touch( event )
		if (event.phase == "ended") then
			if event.target == self.playBtn then self:dispatchEvent( {name = "toGamePlay"} ) 
			elseif event.target == self.scoreBoardButton then
				local user = loadTable ("userdata.json", system.DocumentsDirectory)

				if (user) then
					print( "requesting facebook scores" )
					local Popup = Popup:new()
					self:insert( Popup )
					self.Popup = Popup
					Runtime:dispatchEvent( {name = "createButton"})
					Runtime:dispatchEvent( {name = "createLoading", number = 0} )
					Runtime:dispatchEvent( {name = "social", service = "facebook", type = "requestScore"})

				else
					native.showAlert( "Snooclear", "Connect Snooclear to your Facebook account to use this feature.", {"OK"} )

					-- local Popup = Popup:new()
					-- self.Popup = Popup
					-- Runtime:dispatchEvent( {name = "createButton"})
					-- Runtime:dispatchEvent( {name = "createLoading", number = 0} )

				end
			end
		end
	end


	function view:showPopup( )
		-- Handler that gets notified when the alert closes
		local function onComplete( event )
		    if "clicked" == event.action then
		        local i = event.index
		        if 1 == i then
		           view:dispatchEvent( {name = "shareGetLives", level = _G.currentLevel} )
		        else
		            view:dispatchEvent( {name = "toLevelMenu"} )
		        end
		    end
		end

		-- Show alert with two buttons
		local alert = native.showAlert( "Snooclear", "Oh, no! You are out of lives. Use Facebook share to get some lives?", { "Yes", "No" }, onComplete )	end

	function view:destroy()
		Runtime:dispatchEvent( {name="onRobotlegsViewDestroyed", target=self} )
		self:removeSelf( )
	end

	view:init()

	return view

end

return PreLevelView