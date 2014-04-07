require "components.SocialButton"
require "components.gamePlay.preLevelGameActivator"
require "components.Popup"


finishGameView = {}

function finishGameView:new(parentGroup)
	local view = display.newGroup( )
	view.classType = "finishGameView"

	local user = loadTable ("userdata.json", system.DocumentsDirectory)

	if parentGroup then
		parentGroup:insert( view )
	end

	local font = temporaryData.font
	
	function view:init()

		
		local text_1 = display.newText( "Level " .. tostring( _G.currentLevel ) , display.contentCenterX ,240.5, font.BlanchCapsInline, 120 ) 
		text_1:setFillColor( 76/255, 76/255, 76/255 )
		self:insert( text_1 )

		local text_2 = display.newText( "SNOOCLEARED!", display.contentCenterX ,340.5, font.BlanchCaps, 120 ) -- "Blanch condensed
		text_2:setFillColor(230/255, 69/255, 25/255, 0.8)
		self:insert( text_2 )

		local nextLevelButton = display.newImageRect ("assets/images/PrldNextLvlBtn.png", 771*.5, 131*.5, true)
		nextLevelButton.anchorX, nextLevelButton.anchorY, nextLevelButton.x, nextLevelButton.y = .5,.5, display.contentCenterX, display.contentHeight-500
		nextLevelButton:addEventListener( "touch", nextLevelButtonTouch )
		self:insert(nextLevelButton)

		local shareButton = display.newImageRect ("assets/images/PrldShareBtn.png", 771*.5, 59, true)
		shareButton.anchorX, shareButton.anchorY, shareButton.x, shareButton.y = .5,.5, display.contentCenterX, display.contentHeight-410
		shareButton:addEventListener( "touch", shareScore )
		self:insert(shareButton)

		local gotoMenuButton = display.newImageRect ("assets/images/PrldGoToMnBtn.png", 796*.5, 131*.5, true)
		gotoMenuButton.anchorX , gotoMenuButton.anchorY , gotoMenuButton.x, gotoMenuButton.y = .5,.5, display.contentCenterX, display.contentHeight-320
		gotoMenuButton:addEventListener( "touch", gotoMenuButtonTouch )
		self:insert(gotoMenuButton)

		local scoreBoardButton  = display.newImageRect( "assets/images/LvMnTrophyBtn.png",80, 80)
		scoreBoardButton.anchorX,scoreBoardButton.anchorY = 1,1
		scoreBoardButton.x, scoreBoardButton.y = display.contentWidth-40.7 , display.contentHeight-36.6
		scoreBoardButton:addEventListener( "touch", self )
		self:insert( scoreBoardButton )

		self.profilePicture = self:setProfilePicture()
		self:insert( self.profilePicture )

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
	local myText1 = display.newText({text = "",x = 222, y =display.contentHeight - 70,  width = 185,height = 100, font = font.BlanchCaps ,fontSize = 36})
	view:insert( myText1 )
	myText1:addEventListener( "touch", facebookConnect )
	myText1:setFillColor( 255/255, 30/255, 40/255 )

	function view:setProfilePicture(options)
		if (self.profilePicture) then
			view.profilePicture:removeSelf( )
            -- view.profilePicture = nil
		end
		
		local group = display.newGroup( )
		self:insert( group )
		print( "displaying profilePicture" )
		

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
			
					timer.performWithDelay( 200, function()
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
					view:setProfilePicture("force")
					end )
			else
				myText1 = display.newText({text = "CONNECT TO SEE YOUR FRIENDS' SCORE",x = 222, y =display.contentHeight - 70,  width = 185,height = 100, font = font.BlanchCaps,fontSize = 36})
				myText1:setFillColor( 0 )
				self:insert( myText1)

			end
		end

		return group
	end
	

	function shareScore(event)
		if (event.phase == "ended") then
			view:dispatchEvent( {name = "shareScore", score = _G.temporaryData.energy, level = _G.currentLevel} )
		end
	end


	function nextLevelButtonTouch( event )
		if (event.phase == "ended") then
			print( "nextLevelButton check" )
			view:dispatchEvent( {name = "toNextLevel"} )
		end
	end

	function gotoMenuButtonTouch( event )
		if (event.phase == "ended") then
			view:dispatchEvent( {name= "toLevelMenu"} )
		end
	end
	
	function view:touch( e )
		if e.phase == "ended" then
		local user = loadTable ("userdata.json", system.DocumentsDirectory)
			if (user) then
				print( "requesting facebook scores" )
				local Popup = Popup:new()
				self:insert( Popup )
				self.Popup = Popup
				Runtime:dispatchEvent( {name = "createButton"})
				Runtime:dispatchEvent( {name = "createLoading", number = 0} )
				Runtime:dispatchEvent( {name = "social", service = "Facebook", type = "requestScore"})
			else
				native.showAlert( "Snooclear", "Connect Snooclear to your Facebook account to use this feature.", {"OK"} )
			end
		end
	end

	function view:onSocialButtonTouched(event)
		print( "Social Button in Level Menu is tapped" )
		self:dispatchEvent( {name="toSocialMenu"} )
	end
	
	function view:destroy()
		Runtime:dispatchEvent( {name="onRobotlegsViewDestroyed", target=self} )
		self:removeSelf( )
	end


	view:init()

	return view

end

return finishGameView