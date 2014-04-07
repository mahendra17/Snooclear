require "physics" 
require "components.gamePlay.ball"
require "components.gamePlay.energyBar"
require "components.gamePlay.direction"
require "components.activatorToggle"
require "components.gamePlay.reactor"
require "components.gamePlay.boundary"
require "components.gamePlay.aimLine"


require "components.gamePlay.animation"
require "components.gamePlay.activatorEffect"
require "components.countFunction"
require "views.tutorialOverlayView"
local slideView = require( "components.slideView")
--fix

if not disruptor and not levelData then
	local levelData = require "services.data.gameObject"
	local disruptor = require "services.data.disruptorData"
end

local pos = {}-- untuk input touch

GamePlayView = {}
function GamePlayView:new(parentGroup)
	
	local view = display.newGroup( )
	view.anchorChildren = false
	view.classType = "GamePlayView"

	if parentGroup then
		parentGroup:insert( view )
	end
	
	local gameDisruptorGroup = display.newGroup( )
	view:insert( gameDisruptorGroup )

	local back = display.newGroup( )
	view:insert( back )


	local gameObjectGroup = display.newGroup( )
	view:insert( gameObjectGroup )

	function view:init()
		physics.start()
		physics.setGravity( 0, 0 )
		-- physics.setDrawMode( "hybrid" )
	
		local background = display.newImageRect(self, "assets/images/background.png", display.contentWidth, display.contentHeight, true)
		background.anchorX, background.anchorY= 0.5, 0.5
		background.x, background.y = display.contentCenterX, display.contentCenterY

		

		local boundary = boundary:new( self )
		local ergBar = energyBar:new (self)

		local closeBtn = display.newImageRect( "assets/images/LvMnQuitBtn.png", 80, 80)
		closeBtn.anchorX, closeBtn.anchorY = 1,0
		closeBtn.x, closeBtn.y =  display.contentWidth- 40.7,36.6
		closeBtn:addEventListener( "touch", closeBtnTouch )
		self:insert(closeBtn)

		local ActivatorToggle =  activatorToggle:new(self)
		ActivatorToggle:addEventListener( "onGameActivator", self )

		foreground = display.newRect( display.contentCenterX, display.contentCenterY + 130, display.actualContentWidth, display.actualContentHeight)
	    foreground.alpha = .01
	    foreground:setFillColor( gray )
	    self:insert( foreground)
	    foreground:addEventListener( "touch", self )

		_G.GameObj = {}

		--disruptor
		GameObj.disrupt = {}
		if (#disruptor[_G.currentLevel]>0) then
			for i=1, #disruptor[_G.currentLevel] do
				GameObj.disrupt[i] = reactor:new( self, disruptor[_G.currentLevel][i].type, disruptor[_G.currentLevel][i].x, disruptor[_G.currentLevel][i].y  )
				gameDisruptorGroup:insert(GameObj.disrupt[i])
			end
			addMotion( )
		end

		
	    --ball
	    for i=1, #levelData[_G.currentLevel] do --load game objet
	    	GameObj[i] = ball:new (self, levelData[_G.currentLevel][i].color, levelData[_G.currentLevel][i].x, levelData[_G.currentLevel][i].y)
	    	gameObjectGroup:insert( GameObj[i] )
	    end

		

		if gameSettings.showTutorial.gameTutorial then

			gameSettings.showTutorial.gameTutorial = false
			
			local showHowToPlay = slideView.new(self, 7)
			self:insert( showHowToPlay )
			self.showHowToPlay = showHowToPlay
			showHowToPlay:addEventListener( "closeSlideView", self )

			local closeTutorialBtn = ActivatorButton:new(self, "closeBtn", true)
    		self.closeTutorialBtn = closeTutorialBtn
    		closeTutorialBtn:addEventListener( "onActivatorCloseButtonTouched", self )
    	elseif gameSettings.showTutorial.level[currentLevel] then
    		self.tutorial = tutorialOverlay:new( view, "GamePlayView" )
		end

		if display.actualContentWidth > background.width then
			local frontGroup = display.newGroup( )
			self:insert( frontGroup )

			local whiteSq1 = display.newRect( display.contentCenterX - (background.width*.5) , display.contentCenterY , display.actualContentWidth , display.actualContentHeight )
			whiteSq1.anchorX, whiteSq1.anchorY = 1,.5
			frontGroup:insert( whiteSq1 )

			local whiteSq2 = display.newRect( display.contentCenterX + (background.width*.5) , display.contentCenterY , display.actualContentWidth , display.actualContentHeight )
			whiteSq2.anchorX, whiteSq2.anchorY = 0,.5
			frontGroup:insert( whiteSq2 )
		end


		Runtime:addEventListener("addImpactForce", self)
		Runtime:addEventListener( "collision", self )

		Runtime:addEventListener( "closeSlideView", self )
		Runtime:dispatchEvent( {name="onRobotlegsViewCreated", target=self} )
	end

	function view:closeSlideView()
		self:onActivatorCloseButtonTouched()
	end

	function view:onActivatorCloseButtonTouched()
		transition.to( self.showHowToPlay, {alpha = 0, time = 300, onComplete = function ()
			self.showHowToPlay:removeSelf( )
			self.showHowToPlay = nil
		end} )

		self.closeTutorialBtn:removeSelf( )
		self.closeTutorialBtn = nil

		self.tutorial = tutorialOverlay:new( view, "GamePlayView" )
	end
	
	function view:addImpactForce( e )
		if e.type == "nukeplosion" then
			view:dispatchEvent( {name = "targetAchieved"}) 
		else
			view:addForce_( e.value, e.x, e.y )
		end
	end

	function view:onGameActivator(event )
		if event.activatorState == "start" or event.activatorState == "end" then
			activatorEffect(event, back)
		elseif event.condition == "use" then
			self:dispatchEvent( {name = "onGameActivator", type= event.type, condition = event.condition} )
		end
	end

	function view:collision ( event )
		if event.phase == "began"  then
			-- print( event.object1.name .. event.object2.name )
			if event.object1.name and event.object2.name then
				local collisionObject = {}
				print( event.object1.name, event.object2.name )
				collisionObject[1], collisionObject[2]= event.object1, event.object2
				collisionObject.x, collisionObject.y= .5*(event.object1.x+event.object2.x), .5*(event.object1.y+event.object2.y)

				for i=1,2 do
					collisionObject[i].isCue = math.floor( collisionObject[i].ID/10^4 )
					collisionObject[i].isUnreactive = math.floor( collisionObject[i].ID/10^3 )%10 
					collisionObject[i].isBig = math.floor( collisionObject[i].ID/10^2 )%10
					collisionObject[i].colorID = collisionObject[i].ID%100
				end

				collisionObject.ID = collisionObject[1].ID + collisionObject[2].ID
				collisionObject.isCue = math.floor( collisionObject.ID/10^4 )
				collisionObject.isUnreactive = math.floor( collisionObject.ID/10^3 )%10 
				collisionObject.isBig = math.floor( collisionObject.ID/10^2 )%10
				collisionObject.colorID = collisionObject.ID%100

				self:dispatchEvent({name= "collision", object = collisionObject})
			else
				print( "WARNING: Collision with unidentified object!" )
			end
		end
	end
	

	function view:touch( event)

		aimLine:new( GameObj[1], event ) -- adding aim line

		if event.phase == "ended" then --dispatch event
			if event.yStart <170 and event.y < 170 and event.xStart-event.x < 15 then -- handle touch to gameplay button
			
			else
				self:dispatchEvent( {name = "directionOnTouch", dir = event})		
			end
		end
	end


	function closeBtnTouch (event)
		if (event.phase == "ended") then
			view:dispatchEvent( {name = "onGamePause", target = self} )
		end
	end

	function view:showGamePausePopup( )
		local function goToMenu( )
			view:dispatchEvent( {name= "toLevelMenu"} )
			-- view:dispatchEvent( {name = "loseLives"} )
		end

		local function onGameResume( )
			physics.start( )
		end

		local function showPopup()
			local Popup = Popup:new()
			self:insert( Popup )
			self.Popup = Popup

			Popup:loadPopupOnGamePause()

			Popup:addEventListener( "goToMenu", goToMenu )
			Popup:addEventListener( "resume", onGameResume )
			physics.pause( )
		end
		
		timer.performWithDelay( .1, showPopup )
	end


	--game funct
	function view:addForce(force) -- addforce to cue
		GameObj[1]:applyForce( force.x, force.y, GameObj[1].x, GameObj[1].y )
		-- GameObj[1]:applyLinearImpulse( force.x, force.y, GameObj[1].x, GameObj[1].y )
	end

	function view:addForce_( value, posX, posY )
		for i=1,#GameObj do
			if GameObj[i] and (GameObj[i].name) then
				local force = {}
				force.mag = magnitude (posX, posY, GameObj[i].x, GameObj[i].y)
				if force.mag then
					-- print( force.mag ..  "mag::view" )
					force.x, force.y = point_dir(posX, posY, GameObj[i].x, GameObj[i].y)
					force.x, force.y = force.x/(force.mag^2), force.y/(force.mag^2)
					if GameObj[i] and (GameObj[i].name) and GameObj[i].bodyType then
						-- print( "addForce_" )
						GameObj[i]:applyForce( force.x*value, force.y*value, GameObj[i].x, GameObj[i].y )
					end
				end
			end
		end
	end

	function view:onCollisionJoint( object )

			physics.newJoint( "friction", object[1], object[2], (object[1].x+object[2].x)*.5, (object[1].y+object[2].y)*.5 )

			transition.to( object[1], {x= object[2].x, y = object[2].y, onComplete = function ( )
				object[1]:removeSelf( )
				object[1].name=nil 
				object[1] = nil

				local x,y = object[2].x, object[2].y
				local num = #GameObj + 1				
				GameObj[num] = ball:new(view, "black", x, y)

				object[2].isVisible = false
				physics.removeBody( object[2] )

				transition.to( GameObj[num], {width = 40, height = 40, transition = easing.outBack, onComplete = function()
				object[2]:removeSelf( )
				object[2].name=nil 
				object[2] = nil
				end} )

			end} )
	end

	function view:removeObject( event )
		event.name = nil ; event:removeSelf( ); event = nil
	end

	function view:onCollisionReaction(object, destroyID, createID, v1, v2)
		
		if createID then
			local createDB = {}
			createDB[1] = "cue"
			createDB[2] = "blue"
			createDB[3] = "yellow"
			createDB[4] = "green"
			createDB[5] = "purple"
			createDB[6] = "bigGreen"
			createDB[7] = "bigPurple"
			createDB[8] = "littleGreen"
			createDB[9] = "black"
			createDB[10] = "blueh"
			createDB[11] = "yellowh"
			createDB[12] = "greenh"
			createDB[13] = "purpleh"
			createDB[14] = "blackh"
			createDB[15] = "redh"

			local x = object.x
			local y = object.y

			if (v1 == nil) then
				v1, v2 = 0, 0
			end

			local va, vb 
			local vc, vd 

			if (object[1]:getLinearVelocity()) and (object[2]:getLinearVelocity()) then
				va, vb = object[1]:getLinearVelocity( )
				vc, vd = object[2]:getLinearVelocity( )
				if (object[1].bodyType == "static") or (object[2].bodyType == "static") then
					va, vb = -va, -vb
					vc, vd = -vc, -vd
				end
			else
				va, vb = 10, 10
				vc, vd = 10, 10
			end

			local vx, vy = (va+vc)*v1, (vb+vd)*v2
			local num = #GameObj + 1
			if ((createID > 9) and (createID < 16)) or (createID == 1) then
				num = 1
			end

			if not ((createID == 1) and (GameObj[1].ID == 61020)) then
				GameObj[num] = ball:new (view, createDB[createID], x, y)
				gameObjectGroup:insert( GameObj[num] )

				if createID == 6 or createID == 7 then
					transition.to( GameObj[num], {xScale = 2, yScale = 2, time = 200} )
				end

				timer.performWithDelay( 1, function()
					GameObj[num]:setLinearVelocity( vx, vy )
				end ) 
			end
		end
		

		local destroyDB = {}
		destroyDB[1] = 10041
		destroyDB[2] = 14002
		destroyDB[3] = 14003
		destroyDB[4] = 14007
		destroyDB[5] = 14008
		destroyDB[6] = 11520

		if destroyID == 0 then
			view:onCollisionJoint( object )
		elseif (destroyID == 1) then
			
			local function remove( )
				object[1].name = nil; object[2].name = nil
				object[1].ID = nil; object[2].ID = nil
				if object[1] then object[1]:removeSelf( );object[1] = nil; end
				if object[2] then object[2]:removeSelf( );object[2] = nil; end
			end
			timer.performWithDelay( 101, remove )
			
			physics.removeBody( object[1]) ; physics.removeBody( object[2] )

			transition.to (object[1], {x= object[2].x, y = object[2].y, time = 100 })

			
		elseif destroyID == 2 then
			for i=1,2 do
				for j=1,6 do
					if (object[i].ID == destroyDB[j]) then
						print( object[i].name .. " has removed" )
						if (object[i]) then
							object[i].ID = nil;object[i].name = nil;  
							object[i]:removeSelf( );
							object[i] = nil
							return true
						end
					end
				end
			end

		elseif destroyID == 3 then -- purplebig and greenbig
			
			for i=1,2 do
				if object[i].ID == 10120 or object[i].ID == 10220 then
					print( object[i].name .. "removed" )
					object[i]:removeSelf( ); object[i].ID = nil; object[i].name = nil; object[i] = nil
					return true
				end
			end

		elseif destroyID == 4 then
			if object[1].name ~= "bigBlack" and object[1].type ~= "circled" then view:removeObject(object[1])
			elseif object[2].type ~= "circled" then view:removeObject(object[2]) end 
		end

	end

	function view:animation(param )

		local type = param.type
		local parentGroup

		if type ~= "blackBlast" or type ~= "threeBallReaction" or type ~= "greenBigBurst" or type ~= "purpleBigBurst" then
			parentGroup = back
		else
			parentGroup = gameObjectGroup
		end

		local Animation = animation:new (param, parentGroup)
		Animation:addEventListener( "sprite", function (e )
					print( "listen sprite" )
					if e.value then	view:addForce_( e.value, e.x, e.y ) end 
					if e.value == nil and e.condition == "nukeplosionFinish" then view:dispatchEvent( {name = "targetAchieved"}) end
				end )
	end

	function view:showGameOverPopup()
		local function goToMenu( )
			view:dispatchEvent( {name= "toLevelMenu"} )

		end

		local function goToPrelevel( )
			view:dispatchEvent( {name = "goToPrelevel"} )
		end

		local function showPopup()
			local Popup = Popup:new()
			self:insert( Popup )
			self.Popup = Popup

			Popup:loadPopupGameOver()

			Popup:addEventListener( "goToMenu", goToMenu )
			Popup:addEventListener( "toPreLevel", goToPrelevel)
			physics.stop( )
		end
		
		timer.performWithDelay( .1, showPopup )

	end 

	function view:showActivatorPopup( event )
		
		local function start( )
			physics.start( )
		end

		local function showPopup()
			physics.pause( )
			
			local Popup = Popup:new()
			self:insert( Popup )
			self.Popup = Popup

			Popup:loadPopupActivators(event)
			Popup:addEventListener( "startPhysics", start )
		end
		
		timer.performWithDelay( .1, showPopup )

	end

	
	function view:countObject( )
		
		local objectSum = 0

		-- local onCount = true

		-- if (onCount) then
			for i=1,#GameObj do
				if GameObj[i].name and GameObj[i] then
					objectSum = objectSum+1
				elseif GameObj[i] and GameObj.bodyType == nil then
					-- GameObj[i]:removeSelf( )
					-- GameObj[i] = nil
				end
			end
			-- view:dispatchEvent( {name = "objectSum", sum = objectSum} )
			print( "view::object sum".. objectSum )
			-- objectSum = 0
		-- else

		-- end
		return objectSum
	end

	function view:endGameExplosion (object)
		local data = {
		{name = "yellow" , reactionName = "explosion" }, 
		{name = "green" , reactionName = "greenBigBurst" },
		{name = "blue" , reactionName = "implosion" },
		{name = "purple" , reactionName = "purpleBigBurst" },
		{name = "black" , reactionName = "blackBlast" },
		} 

		for i=1,#data do
			if data[i].name == object.name then
				local param = {	type = data[i].reactionName, posX= object.x, posY= object.y }
				object.isVisible = false
				view:animation (param)
			else
				object.isVisible= false
			end
		end
	end

	function view:moveView(event)
		local type = event.type

		if (type == "levelCleared") then

			local function animationFinish( )

				transition.to( gameDisruptorGroup, {alpha = 0, time = 100} )

				transition.to( GameObj[1], {x= display.contentCenterX, y = display.contentCenterY,transition = easing.outQuad, onComplete = function ()
					physics.pause( )
					transition.to( gameObjectGroup, {alpha = 0, time = 500, onComplete = function ( )
					end} )
					self:dispatchEvent( {name = "playFinishAnimation"} )
				end} )
			end
		
			local function checkVar()
				if gamePlaySettings.activeAnimation == nil then
					timer.performWithDelay( 500, animationFinish )

				elseif gamePlaySettings.activeAnimation then
					timer.performWithDelay( 100, checkVar )
					-- print( "gamePlaySettings.activeAnimation" .. tostring(gamePlaySettings.activeAnimation) )
				end
			end

			checkVar()

		elseif type == "gameOver"then

			print( "VIEW :: Gameover Popup" )

			function checkSpeed(  )
				if temporaryData.currentView == "GamePlayView" then
					local vx, vy = GameObj[1]:getLinearVelocity( )
					if math.abs(vx) <= 3 and math.abs( vy ) <= 3 then
						view:dispatchEvent( {name = "showGameOverPopup", target = self} )
					else
						timer.performWithDelay( 1000, function ( )
							checkSpeed()
						end )
					end
				end
			end

			checkSpeed()
		end
	end

	function view:addBlanket( )
		
		local function strayTouch(event )
			-- body
			return true
		end

		local blanket = display.newRect( display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight)
	    blanket.alpha = .01
	    self:insert( blanket)
	    blanket:addEventListener( "touch", strayTouch )	
	    blanket:addEventListener( "tap", strayTouch )

	end

	function view:destroy()
		Runtime:dispatchEvent( {name="onRobotlegsViewDestroyed", target=self} )
		Runtime:removeEventListener( "touch", self )
		Runtime:removeEventListener( "collision", self )

		Runtime:removeEventListener("addImpactForce", self)

		Runtime:removeEventListener ("accelerometer", onAccelerate)

		Runtime:removeEventListener( "enterFrame", startMove )

		Runtime:removeEventListener( "closeSlideView", self )

		removeListeneraddMotion( )
		self:removeSelf( )
		physics.stop( )
	end

	view:init()

	return view

end

return GamePlayView