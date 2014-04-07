require "components.SocialButton"
require "components.ActivatorButton"
require "components.LivesButton"
require "components.SettingsButton"
require "components.levelCirc"

-- import pinch zoom library
require "components.pinchZoom.multitouch"
require "components.pinchZoom.pinchlib"



LevelMenuView = {}

function LevelMenuView:new(parentGroup)
	system.activate( "multitouch" )
	local view = display.newGroup( )
	view.classType = "LevelMenuView"
	view.FONT_NAME = "Blanch-CapsInline"

	if parentGroup then
		parentGroup:insert( view )
	end

	function view:init()
		system.setTapDelay( .2 )

		local SocialButton = SocialButton:new(self, "color", true, "corner")
		self.SocialButton = SocialButton
		SocialButton:addEventListener( "onSocialButtonTouched", self )

		local LivesButton =  LivesButton:new(self, "color", true)
		self.LivesButton = LivesButton
		LivesButton:addEventListener( "onLivesButtonTouched", self )

		local ActivatorButton = ActivatorButton:new(self, "color", true)
		self.ActivatorButton =ActivatorButton
		ActivatorButton:addEventListener( "onActivatorButtonTouched", self )

		local SettingButton = SettingButton:new(self, "color", true) 
		self.SettingButton =SettingButton
		SettingButton:addEventListener( "onSettingButtonTouched", self )


		--LEVEL CIRCLE----------------------------------------------------------------------------------------
		local maxLevel = 11
		local val = 0

		local group1 = display.newGroup( )
		local group2 = display.newGroup( )
		local group3 = display.newGroup( )
		local group4 = display.newGroup( )
		self:insert( group1)
		self:insert( group2)
		self:insert( group3)
		self:insert( group4)

		local aBox = display.newRect(display.contentCenterX, display.contentCenterY, display.actualContentWidth , display.actualContentHeight - 300)
		aBox:setFillColor( 230/255, 190/255, 10/255, .01 )
		group1:insert( aBox )

		local circle =  levelMenuCircle:new(self)
		self.circle = circle
		circle:addEventListener( "onLevelTouched", self )
		group2:insert( circle )

		local circleForeG = display.newCircle( display.contentCenterX, display.contentCenterY, 555*.35 )
		circleForeG:setFillColor( 1,1,1,.01 )
		group3:insert( circleForeG )

		local centerCircle = display.newCircle(self, display.contentCenterX, display.contentCenterY, 34 )
		centerCircle:setFillColor( .5,.1,.1,.01 )
		group4:insert( centerCircle)

		-- function to handle multitouch
		function multitouch(phase, target, list)
			print('do multitouch',target)
			if (phase == "began") then
				doPinchZoom( target, {}, true, false, true) -- suppressrotation, suppressscaling, suppresstranslation )
				doPinchZoom( target, list, true, false, true) -- suppressrotation, suppressscaling, suppresstranslation ) -- this is where the pinch function is called (in pinchlib.lua)
			elseif (phase == "moved") then
				doPinchZoom( target, list, true, false, true) -- suppressrotation, suppressscaling, suppresstranslation )
				if ((target.xScale > .6) and (target.xScale < 1.6)) then
					circleLevel:move("zoom", target.xScale)
				end
			else
				print( target.xScale )
				if (target.xScale > 1.3) then
					circleLevel:move( "up")
				elseif (target.xScale < .8) then
					circleLevel:move("down")
				else
					circleLevel:move("reset")
				end
				transition.to( target, {xScale = 1, yScale = 1, time = 300} )
			end
			
			return true -- unfortunately, this will not propogate down if false is returned
		end

		local stage = display.getCurrentStage()
		local isSim = system.getInfo( "environment" ) == "simulator"

		local touches = {}
		function touches:add(circle)
			for i=1, #touches do
				local touch = touches[i]
				if (touch.target == circle.target) then
					local list = touch.list
					for t=1, #list do
						if (list[t] == circle) then
							return
						end
					end
					-- add new touch point to existing image
					local list = touch.list
					list[ #list+1 ] = circle
					return
				end
			end
			-- add new image and its first touch circle
			touches[ #touches+1 ] = {target=circle.target,list={circle}}
		end
		function touches:remove(circle)
			for i=#touches, 1, -1 do
				local touch = touches[i]
				if (touch.target == circle.target) then
					local list = touch.list
					for t=#list, 1, -1 do
						if (list[t] == circle) then
							table.remove(list,t)
							break
						end
					end
					if (#list == 0) then
						table.remove(touches,i)
						break
					end
				end
			end
		end
		function touches:get(target)
			for i=1, #touches do
				if (touches[i].target == target) then
					return touches[i].list
				end
			end
			return {}
		end

		local function newTouchPoint(e)
			local circle = display.newCircle( stage, e.x, e.y, 25 )
			circle:setFillColor(255,0,0)
			circle.strokeWidth = 5
			circle:setStrokeColor(0,0,255)
			if (isSim) then circle.alpha = .5 else circle.alpha = 0 end
			circle.isHitTestable = true
			circle.isTouchPoint = true
			circle.target = e.target
			circle.id = e.id
			touches:add(circle)
			stage:setFocus(circle,e.id)
			
			function circle:touch(e)
				if (e.phase == "began") then
					stage:setFocus(e.target,e.id)
					circle.x, circle.y = e.x, e.y
					-- dispatch multitouch event here
					multitouch("moved", circle.target, touches:get(circle.target))
					return true
				elseif (e.phase == "moved") then
					circle.x, circle.y = e.x, e.y
					-- dispatch multitouch event here
					multitouch("moved", circle.target, touches:get(circle.target))
					print('moved',circle.target,circle.target.name)
					return true
				else
					circle.x, circle.y = e.x, e.y
					if (not isSim) then touches:remove(circle) end
					-- touches:remove(circle)
					-- dispatch multitouch event here
					local phase = "ended"
					if (isSim) then phase = "moved" end
					multitouch(phase, circle.target, touches:get(circle.target))
					stage:setFocus(e.target,nil)
					if (not isSim) then circle:removeSelf() end
					return true
				end
				return false
			end
			circle:addEventListener("touch",circle)
			
			function circle:tap(e)
				if (e.numTaps == 1) then
					touches:remove(circle)
					multitouch("ended", circle.target, touches:get(circle.target))
					circle:removeSelf()
				end
				return true
			end
			if (isSim) then circle:addEventListener("tap",circle) end
			
			return circle
		end


		local function handleTouch(e)
			if (e.phase == "began") then
				local circle = newTouchPoint(e)
				multitouch("began", circle.target, touches:get(circle.target))
			end
			print('handleTouch(e)',e.target)
			return true
		end

		local function handleTap(e)
			if (e.numTaps == 2 ) then
				circleLevel:move("up")
			elseif e.numTaps == 1 then
				circleLevel:move("down")
			end
			return true
		end

		local function strayTap()
			return true
		end

		circleForeG:addEventListener( "touch", handleTouch )
		aBox:addEventListener( "touch", handleTouch )
		circleForeG:addEventListener( "tap", strayTap )
		centerCircle:addEventListener( "tap", handleTap )
		centerCircle:addEventListener( "touch", strayTap )
		----------------------------------------------------------------------------------------
		-- Shows lives left next to lives page button
		local livesText = display.newText(self,tostring (gameSettings.lives.lives), 140, 35, Calibri, 50 )
		
		livesText.anchorX, livesText.anchorY =.5,.5
		livesText:setFillColor( 228/255, 70/255, 25/255)

		timer.performWithDelay(100, function ()
			livesText.text = tostring (gameSettings.lives.lives)
		end, 3)		
								
		Runtime:dispatchEvent( {name="onRobotlegsViewCreated", target=self} )
	end

	function view:onSocialButtonTouched(event)
		-- print( "Social Button in Level Menu is tapped" )
		self:dispatchEvent( {name="toSocialMenu"} )
	end

	function view:onActivatorButtonTouched(event )
		-- print( "onActivatorButtonTouched at view level" )
		self:dispatchEvent( {name="toActivatorPage"} )
	end

	function view:onLivesButtonTouched( event )
		-- print( "onLivesButtonTouched at view level" )
		self:dispatchEvent( {name = "toLivePage"} )
	end

	function view:onSettingButtonTouched( event )
		-- print( "onSettingButtonTouched at view level" )
		self:dispatchEvent( {name = "toSettings"} )
	end

	function view:onLevelTouched( event )
		-- if (event.phase == "ended") then
			-- print( "go to pre level, level = " .. event.target.name )
			currentLevel=event.level
			self:dispatchEvent( {name = "toPreLevel", level = event.level} )
		-- end
	end

		-- sambung ke onDestroy di mediator
	function view:destroy()
		-- print( "leaving level menu View" )
		gameSettings.onCircleLevel = _level
		Runtime:dispatchEvent( {name="onRobotlegsViewDestroyed", target=self} )
		system.deactivate( "multitouch" )
		self:removeSelf( )
	end

	function view:adjust( )
		-- local currentCircleLevel = 1

		local function moveCircle() 
			if _level < gameSettings.onCircleLevel  then
				circleLevel:move("up")
				-- currentCircleLevel = currentCircleLevel + 1
				timer.performWithDelay( 850, function ( )
					moveCircle()
				end )
			end
		end
		moveCircle()
	end

	view:init()
	view:adjust( )

	return view

end

return LevelMenuView