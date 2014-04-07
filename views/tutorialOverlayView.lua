-- PopupBonus.png 563 169
-- PopupCancel 900 179
-- PopupChsActivator.png 949 200
-- PopupConnect.png 441 169
-- PopupEnergy.png 672 172
-- PopupLives.png 516 169
-- PopupSetting.png 441 169
-- PopupTryActivator.png 721 174



local imageData = {}

tutorialOverlay = {}

function tutorialOverlay:new( parentGroup, pageView )
	
	local view = display.newGroup( )

	if parentGroup then
		parentGroup:insert( view )
	end

	function view:init( )
		-- local backGround = view:addBackground(self)
		local object 

		if pageView == "PreLevelView" then
			object = view:PreLevelView( )
		elseif pageView == "ActivatorView" then
			object = view:ActivatorView( )
		elseif pageView == "LevelMenuView" then
			object = view:LevelMenuView( )
		elseif pageView == "GamePlayView" then
			object = view:GamePlayView( )
		end


		local foreGround = view:addforeGround(view)
		foreGround:addEventListener( "foreGroundTouched", function ()
				view:destroy( )
		end )
	end

	

	function view:showTutorialCheck( name )

		local showTutorial = gameSettings.showTutorial

		if name == "PreLevelView" then
			return showTutorial.prelevel
		elseif name == "LevelMenuView" then
			return showTutorial.levelMenu
		elseif name == "GamePlayView" then
			return showTutorial.level[currentLevel]
		else
			return false
		end

	end

	function view:PreLevelView( )
		local PopupChsActivator = display.newImageRect( self, view:getFileLocation("PopupChsActivator"), 949*.5, 200*.5 )
		PopupChsActivator.x, PopupChsActivator.y = display.contentWidth*.5, 680
		gameSettings.showTutorial.prelevel= false
	end

	function view:ActivatorView( )
		--body
	end

	function view:LevelMenuView( )

		local function listener( e )
			
			if e.phase == "ended" then
				self:destroy()
			end
		end

		local PopupBonus = display.newImageRect(self ,self:getFileLocation("PopupBonus"), 563*.5, 169*.5 )
		PopupBonus.anchorX, PopupBonus.anchorY = 1, 0
		PopupBonus.x, PopupBonus.y =  display.contentWidth - 40.7 - 2,126
		PopupBonus:addEventListener( "touch", listener )

		local PopupConnect = display.newImageRect(self ,self:getFileLocation ("PopupConnect") ,441*.5, 169*.5 )
		PopupConnect.anchorX, PopupConnect.anchorY = 1,1
		PopupConnect.x, PopupConnect.y =  display.contentWidth-40.7 - 2 , display.contentHeight-126
		PopupConnect:addEventListener( "touch", listener )

		local PopupLives = display.newImageRect(self ,self:getFileLocation ("PopupLives") ,561*.5, 169*.5 )
		PopupLives.anchorX, PopupLives.anchorY = 0,0
		PopupLives.x, PopupLives.y =  40.7-2, 126
		PopupLives:addEventListener( "touch", listener )

		local PopupSetting = display.newImageRect(self ,self:getFileLocation ("PopupSetting") ,441*.5, 169*.5 )
		PopupSetting.anchorX, PopupSetting.anchorY = 0,1
		PopupSetting.x, PopupSetting.y =  40.7-2, display.contentHeight - 126
		PopupSetting:addEventListener( "touch", listener )

		gameSettings.showTutorial.levelMenu= false
	end

	function view:GamePlayView( )
		print( "currentLevel".. currentLevel )

		if currentLevel == 1 then
		local PopupCancel = display.newImageRect( self, self:getFileLocation("PopupCancel"), 900*.5, 179*.5 )
		PopupCancel.x, PopupCancel.y =(.33*display.contentWidth) +50 ,85

		local PopupEnergy = display.newImageRect( self, self:getFileLocation("PopupEnergy"), 672*.5, 172*.5 )
		PopupEnergy.anchorX = 1
		PopupEnergy.x, PopupEnergy.y = display.contentWidth- 40.7 , display.contentHeight-85
		else
			local PopupTryActivator = display.newImageRect( self, self:getFileLocation("PopupTryActivator"), 721*.5, 174*.5 )
			PopupTryActivator.x , PopupTryActivator.y = display.contentCenterX -50 ,85
		end

		gameSettings.showTutorial.level[currentLevel]= false
	end

	function view:getFileLocation( name )
		return "assets/images/tutorial/"..name .. ".png"
	end

	function view:addBackground( group )

		local backg = display.newRect( display.contentCenterX , display.contentCenterY , display.contentWidth , display.contentHeight )
		backg.alpha = 0.01

		if (group) then
			group:insert( backg )
		end

		backg:addEventListener( "touch", function (e)
			return true
		end )

		return backg
	end

	function view:addforeGround( group )

		local foreg = display.newRect( display.contentCenterX , display.contentCenterY , display.contentWidth , display.contentHeight )
		foreg.alpha = 0.01

		if (group) then
			group:insert( foreg )
		end

		local function listener(e )
			if e.phase == "ended" then
				foreg:dispatchEvent( {name = "foreGroundTouched", target = self} )
				-- return true
			end
		end

		foreg:addEventListener( "touch", listener)
		return foreg
	end

	function view:destroy( )
		transition.to( self, {alpha = 0, time = 500, onComplete = function ( )
			self:removeSelf( )
		end} )
		Runtime:dispatchEvent( {name = "saveGameSettings" } )
	end

	timer.performWithDelay( 500, function ( )
		if view:showTutorialCheck( pageView ) then view:init (); view.alpha = 0; transition.to( view, {alpha = 1, time = 500} ) end
	end )

	

	return view
end

return tutorialOverlay