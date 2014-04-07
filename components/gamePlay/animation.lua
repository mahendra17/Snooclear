local particleNumber

local function invPolarCoord(r, theta ) --  theta rad
	local x = r* math.cos( theta )
	local y = r* math.sin(theta)
	return x, y
end 

local function addParticle(circRad, x, y )
			local group = display.newGroup( )
			local newParticle

			function group:init( )
				local num = math.random(1,circRad )
				newParticle = display.newCircle(x, y, num )
				group:insert( newParticle)
				newParticle:setFillColor(27/255,165/255,226/255) 	
			end

			function group:setColor(r, g, b )
				newParticle:setFillColor( r,g,b )
			end

			function group:setScale( num )
				newParticle:scale( num, num )
			end

			function group:remove(  )
				group:removeSelf( )
				group = nil
				return true
			end

			group:init()
			return group
end

--==================================================================================================================
-- ANIMATION START FROM HERE
-- reserve global variable gamePlaySettings.activeAnimation = xxxx
--==================================================================================================================


animation = {}
-- require "physics"
require "components.gamePlay.ball"

-- physics.start( )

particleNumber = {sum = 0, max =400, reachMax = false}

function animation:new( param, parentGroup )


	local animate = display.newGroup( ) 

	local type = param.type
	local x, y = param.posX, param.posY

	local value = nil

	if (parentGroup) then
		parentGroup:insert(animate)
	else 
		--
	end

	function animate:init( )

		gamePlaySettings.activeAnimation = type

		if  type == "explosion"  then
			animationSprite = animate:explosion( x,y )
			-- self:insert( animationSprite )
		elseif type == "implosion"  then
			animationSprite = animate:implosion( x,y )
			-- self:insert( animationSprite )
		elseif type == "blackBlast"  then
			animationSprite = animate:blackBlast( x,y )
			-- self:insert( animationSprite )
		elseif type == "nukeplosion" then
			animationSprite = animate:nukeplosion( display.contentCenterX, display.contentCenterY )
			-- self:insert( animationSprite )
		elseif type == "threeBallReaction" then
			animationSprite = animate:threeBallReaction( x,y )
			-- self:insert( animationSprite )
		elseif type == "greenBigBurst" then
			animationSprite = animate:greenBigBurst( )
			-- self:insert( animationSprite )
		elseif type == "purpleBigBurst" then
			animationSprite = animate:purpleBigBurst( )
			-- self:insert( animationSprite )
		end

		self:insert( animationSprite )		

		if type == "nukeplosion" then -- ADDING IMPACT FORCE
			animationSprite:addEventListener( "sprite", self )
		-- else
			-- animationSprite:addEventListener( "onGameAnimation", self )
		end
	end

	function animate:resetVariable( num )
		if num then
			if num > 0 then
				particleNumber.sum = particleNumber.sum + num
			elseif num < 0 then
				particleNumber.sum = particleNumber.sum + num
				if particleNumber.sum == 0 then
					gamePlaySettings.activeAnimation = nil
				end
			end

			if particleNumber.sum > particleNumber.max then
				particleNumber.reachMax = true
			else 
				particleNumber.reachMax = false
			end
			print( particleNumber.sum )
		else
			gamePlaySettings.activeAnimation = nil
		end

	end

	function animate:sprite( e )
		if e.phase == "ended" then
			if e.target.name == "nukeplosion" then
			self:dispatchEvent({ name = "sprite", condition = "nukeplosionFinish"} )
			end
		-- elseif e.phase == nil then
		-- 	print( "addImpact" )
		-- 	self:dispatchEvent({ name = "sprite", value = value, x=x, y=y, target = self} )
		end
	end

	function animate:dispatcher ()
		if value then
			Runtime:dispatchEvent({ name = "addImpactForce", value = value, x=x, y=y, target = self} )
		elseif value == nil and type == "nukeplosion" then
			Runtime:dispatchEvent({ name = "addImpactForce", type = type} )
		end
	end

	function animate:explosion( )
		
		local explosion = display.newGroup( )

		value = 100000*2

		local sum = 0
		local par = {}
		local radius = .125*display.contentCenterX
		
		local count = 150

		if particleNumber.reachMax then
			count = 0.1*count
		end

		local onAnimation = false


		function explosion:init( )

			for i=1,count do
				par[i] = addParticle(5, x,y)
				par[i]:setColor( 255/255,186/255,3/255 )
				self:insert( par[i])

				--particle prop
				par[i].theta = math.random(0,360)
				par[i].vel = math.random(1,100)*.01*10
				par[i].r = math.random(1,2 )
				par[i].alpha = 1
			end
		end

		function explosion:move( )
			if _G.temporaryData.currentView == "GamePlayView"  then
			for i=1,#par do
				local r = par[i].r + 1*par[i].vel
				par[i].r = r
				local delX, delY = invPolarCoord(par[i].r, par[i].theta )
				par[i].x, par[i].y = delX, delY

				if explosion then explosion:fade( par[i], par[i].r ) end
			end end
		end

		function explosion:fade( obj, r )
			if _G.temporaryData.currentView == "GamePlayView"  then
			if r > radius then
				if obj.alpha == 0 then
					sum = sum + 1
				else
					obj.alpha = obj.alpha - 0.06
				end
			end
			if sum >= count then 
				timer.performWithDelay( 200, function ()
					onAnimation = false
				end )
			end
			end
		end

		function explosion:start( )

			onAnimation = true

			animate:resetVariable( count )

			self:dispatchEvent({name = "sprite", target = self})

			local function startMove( )
				if explosion and onAnimation then explosion:move() 
				elseif onAnimation == false then Runtime:removeEventListener ("enterFrame", startMove); explosion:kill() end
				
				if _G.temporaryData.currentView ~= "GamePlayView"  then
					onAnimation = false
				end
				
			end

			Runtime:addEventListener( "enterFrame", startMove )

			animate:dispatcher()

		end

		function explosion:kill( )
			animate:resetVariable( -count )
			if explosion then transition.to( explosion, {alpha = 0, time = 100, onComplete = function ( )
				explosion:removeSelf( ); explosion= nil;	end} ) end
		end

		explosion:init()
		explosion:start()

		return explosion				
	end

	function animate:implosion( )
		value = -100000*2

		local sum = 0
		local par = {}
		local circle = {}
		local radius2 = .4*display.contentCenterX
		local radius1 = .95 * radius2

		local count = 250

		if particleNumber.reachMax then
			count = 0.1*count
		end
		
		local onReverse = false
		local onAnimate = false
		local slowMotion = false
		
		local implosion = display.newGroup( )

		function implosion:init( )
			for i=1,count do
				par[i] = addParticle( 4, x,y)
				self:insert( par[i])
				par[i].theta = math.rad( math.random(0,360) ) 
				par[i].vel = math.random(5,100)*.001*30
				par[i].r = math.random(1,2 )
				par[i].alpha = 1
				par[i].scl = 1
			end
						
		end

		function implosion:move( )
			for i=1,#par do
				if onReverse then
					par[i].r = par[i].r - 1*par[i].vel
					par[i].theta =  par[i].theta -  .1*par[i].vel

					local delX, delY = invPolarCoord(par[i].r, par[i].theta )
					par[i].x, par[i].y = delX, delY

					par[i].scl = par[i].scl * 0.998
					-- par[i]:setScale(par[i].scl)

				elseif onReverse == false and slowMotion == false then 
					par[i].r = par[i].r + 1*par[i].vel

					local delX, delY = invPolarCoord(par[i].r, par[i].theta )
					par[i].x, par[i].y = delX, delY	

				elseif onReverse == false and slowMotion then
					par[i].r = par[i].r + .1*par[i].vel

					local delX, delY = invPolarCoord(par[i].r, par[i].theta )
					par[i].x, par[i].y = delX, delY	
				end

				
				if (par[i].r <= 0) then
					par[i].isVisible = false
					sum = sum+1
				elseif  par[i].r > radius2 then
					onReverse = true
					-- print("onReverse")
				elseif par[i].r > radius1 then
					slowMotion = true
				end
			end

			if sum >= count then onAnimate = false end			
		end

		

		function implosion:start( )
			onAnimate = true

			animate:resetVariable( count )

			animate:dispatcher()

			local function startMove( )
				if onAnimate and implosion then implosion:move()
				elseif onAnimate == false then Runtime:removeEventListener( "enterFrame", startMove ); implosion:kill( ) end
			
				if _G.temporaryData.currentView ~= "GamePlayView"  then
					onAnimation = false
				end

			end

			Runtime:addEventListener( "enterFrame", startMove )
		end

		function implosion:kill( )
			animate:resetVariable( -count );
			if (implosion) then	implosion:removeSelf( ); implosion= nil	end
		end

		implosion:init()
		implosion:start()

		return implosion
	end

	function animate:blackBlast( )

		-- local count = 12

		local group = display.newGroup( )
		local function blackBallBig( scale, opacity )
			local circ = display.newCircle( 0, 0, 425/2 )
			circ:setFillColor( 63/255,63/255,63/255 )
			circ:scale(scale,scale)
			circ.alpha = opacity
			return circ
		end

		local function whiteBallBig( scale, opacity )
			local circ = display.newCircle( 0, 0, 425/2 )
			circ:setFillColor( 1 )
			circ:scale(scale,scale)
			circ.alpha = opacity
			return circ
		end


		local black = {}
		local white=  {}

		local circleGroup = display.newGroup( )
		group:insert( circleGroup )
		animate:insert( 1, circleGroup )

		local function createCirc ( x, y)

			local data = {{scale =.4 , opacity = 1},{scale =.6 , opacity = .8},{scale =.8 , opacity = .6},{scale =1 , opacity = .4},}
			
			for i=1,4 do
				black[i]= blackBallBig( data[i].scale, data[i].opacity)
				white[i]= whiteBallBig( data[i].scale, 1)

				black[i].x, black[i].y= x, y
				white[i].x, white[i].y = x, y

				black[i].isVisible = false
				white[i].isVisible = false

				circleGroup:insert( (i-1)*2+1,  black[i] )
				circleGroup:insert( i*2, white[i]  )


			end
		end

		local function baseAnimation(object1, object2  )

			local scale = object1.xScale

			object1.isVisible = true
			object1:scale (0.01, 0.01)
			object2:scale (0.01, 0.01)

			transition.to ( object1, {xScale=scale*.5, yScale=scale*.5, time = 250, onComplete = function ( )
				object2.isVisible = true
				transition.to (object1,{xScale=scale, yScale=scale, time = 250})
				transition.to (object2,{xScale=scale, yScale=scale, time = 500, onComplete = function ( )
					object1.isVisible = false
					object2.isVisible = false
				end})
			end} )
		end

		local function listener1(x,y )

			-- animate:resetVariable()

			createCirc ( x,y )

			for i=1,4 do

				local anim = {}

				local function listen( )
					baseAnimation( black[i], white[i] )
					if (i== 4 ) then
						local function remove( )
							animate:resetVariable()
							
							for i= #black,0, -1 do
								if black[i] then black [i]:removeSelf( ); black[i] = nil end
								if white[i] then white[i]:removeSelf( ); white[i] = nil end
							end

							if black and white then	black, white =  nil, nil end

						end
						timer.performWithDelay( ((i-1)*375)+50, remove )
					end
				end
				anim[i] =(timer.performWithDelay( (i-1)*375, listen))
			end

			local function addBody( )
				physics.addBody( black[4], {radius = 425/2 } )
				black[4].name = "blackBig"
				black[4].isSensor = true
				black[4].ID = .1
			end

			timer.performWithDelay( 750+(375*.5), addBody )
		end

		listener1(x,y)

		return group
	end

	function animate:nukeplosion( x, y)
		local nukeplosion = display.newGroup( )


		local par = {}
		local circle = {}
		local count = 300
		local radius = .4*display.contentCenterX

		local onCircleTouch = false
		local onAnimation = false

		function nukeplosion:addParticle(x, y, n, nmax)
			local group = display.newGroup( )
			local newParticle
			local minSize = 10*(n/nmax)*(1- (n/nmax))
			local maxSize = 30*(n/nmax)*(1- (n/nmax))
			function group:init( )
				local rad = math.random(minSize,maxSize )
				newParticle = display.newCircle(x, y, rad )
				group:insert( newParticle)
				newParticle:setFillColor(230/255, 69/255, 25/255) 	
			end

			function group:addScale( num )
				newParticle:scale( num, num )
			end

			function group:remove(  )
				group:removeSelf( )
				group = nil
				return true
			end

			function group:fade( )
				transition.to( group,{time = 2000, onComplete = function ( )
					group.isVisible = false
				end} )
			end

			function group:killOutsideScreen( )
				if group.x > display.actualContentWidth or group.x <= 0 or group.y > display.actualContentHeight or group.y < 0 then
					group:remove()
				end
			end

			group:init()
			return group
		end

		function nukeplosion:circle( x, y )
		 	local circleGroup = display.newGroup( )
		 	local circleOut = {}
		 	local circleIn = {}
		 	circleOut = display.newCircle (x , y , ( display.contentCenterX *.5) - 20)
		 	circleOut:setFillColor( 230/255, 69/255, 25/255 )
		 	circleGroup:insert( circleOut)
		 	circleOut:scale( .01, .01 )


		 	circleIn = display.newCircle( x , y , ( display.contentCenterX *.5) - 20)
		 	circleGroup:insert( circleIn )
		 	circleIn:scale( .01, .01 )


		 	function circleGroup:setScale (num)
		 		circleOut:scale( num, num )
		 	end

		 	function circleGroup:zoomin( )
		 		local count1 = 0
		 		transition.to( circleOut, {xScale = 2, yScale = 2, time = 1300, transition = easing.inQuad, onComplete = function ( )
		 	 		end} )

		 		timer.performWithDelay( 10, function ()
		 			transition.to( circleIn, {xScale = 1.8, yScale = 1.8, time = 1300, transition = easing.inQuad,  onComplete = function ( )
		 				transition.to( circleOut,{alpha = .1, time = 900, transition = easing.inBack} )
		 				transition.to(circleIn, {xScale = 2.2, yScale = 2.2, transition = easing.inBack, time = 1000, onComplete = function()
		 				end})
		 			end} )
		 		end )
		 	end

		 	circleGroup:setScale(.01)
		 	circleGroup:zoomin()

		 	return circleGroup
		 end


		function nukeplosion:init( )
			local background = display.newGroup( ); self:insert( background )
			local foreground = display.newGroup( ); self:insert( foreground )

			timer.performWithDelay( 500, function()
				local circle = nukeplosion:circle(x, y)
				circle.scl = .3
				background:insert( circle )
			end )


			for i=1, count do
				par[i] = nukeplosion:addParticle(x,y,i,count)
				foreground:insert( par[i])
				par[i].theta = math.rad( math.random(0,360) ) 
				par[i].vel = math.random(800,1500)*.0001*5
				local minDist = 9.8*(i/count)
				local maxDist = 10*(i/count)
				par[i].r = math.random(minDist,maxDist)
				par[i].alpha = 1
				par[i].scl = 1
			end

			

		end

		function nukeplosion:move( )
			local sum = 0

			for i=1,#par do

				if (onCircleTouch) then
					par[i].r = par[i].r + 3*par[i].vel
					local delX, delY = invPolarCoord(par[i].r, par[i].theta )
					par[i].x, par[i].y = delX, delY
				else 
					par[i].r = par[i].r + 1*par[i].vel
					local delX, delY = invPolarCoord(par[i].r, par[i].theta )
					par[i].x, par[i].y = delX, delY
				end
				
				nukeplosion:hide(par[i])

				if par[i].isVisible == false then
					sum = sum+1
				end
				
			end

			if sum >= count then onAnimation = false end
		end

		function nukeplosion:hide (object)
			if object.r > radius then
				onCircleTouch = true
				timer.performWithDelay( 100, function ( )
					object.isVisible = false
				end )
				
			end
		end

		function nukeplosion:start( )

			onAnimation = true

			local function startMove( )
				if nukeplosion and onAnimation then nukeplosion:move() 
				elseif onAnimation == false then Runtime:removeEventListener( "enterFrame", startMove ); nukeplosion:kill() end
				
				if _G.temporaryData.currentView ~= "GamePlayView"  then
					onAnimation = false
				end


			end
			self:dispatchEvent( {name = "start", target = self} )
			Runtime:addEventListener( "enterFrame", startMove )
		end

		function nukeplosion:kill( )
			transition.to( nukeplosion, {alpha = 0} )
			nukeplosion:removeSelf( )
			nukeplosion= nil
			animate:resetVariable( );animate:dispatcher ()
		end

		function nukeplosion:cueZoom( )
			local circ = display.newCircle( display.contentCenterX, display.contentCenterY, 20 )
			circ:setFillColor( 229/255, 69/255,26/255 )
			self:insert( circ )
			transition.to (circ, {alpha = 0, time = 100, onComplete = function ( )
				transition.to (circ, {alpha = 1, time = 100, onComplete = function ( )
					transition.to (circ, {alpha = 0, time = 100, onComplete = function ( )
						transition.to (circ, {alpha = 1, time = 100, onComplete = function ( )
							transition.to (circ, {xScale=30, yScale=30, time = 600, onComplete = function ( )
									nukeplosion:init()
									nukeplosion:start()
								
							end})

							transition.to (circ, {alpha = 1, time = 300, onComplete = function ( )
								circ.alpha = 1
								transition.to (circ, {alpha = 0, time = 300, onComplete = function ( )
								end})
							end})
						end})
					end})
				end})
			end})
		end

		nukeplosion:cueZoom( )

		return nukeplosion
	end

	function animate:threeBallReaction(x, y )

		local count = 150

		local group = display.newGroup( )

		local function trails(object, Group, num) -- create trail effects (available in animation)
			local trail = {}

			local numberOfTrails = 50

			if num then numberOfTrails = numberOfTrails*.5 end

			local i = 0
			local j = -25

			function createTrails(object)
				trail[i] = display.newCircle( object.x, object.y, 20 )
				trail[i]:setFillColor( 0 )
				trail[i].anchorX, trail[i].anchorY = .5, .5
				Group:insert( trail[i] )
				local transitionTime = 1000 - 995*(i/numberOfTrails)
				transition.to( trail[i], {time = transitionTime, alpha = 0} )

				i = i + 1
			end

			function deleteTrails()
				if (trail[j]) then
					trail[j]:removeSelf( )
					trail[j] = nil
				end

				-- if j == numberOfTrails then
				-- 	animate:resetVariable()
				-- end

				j = j+1
			end

			timer.performWithDelay( 100, function() createTrails(object) end, numberOfTrails )
			timer.performWithDelay( 80, deleteTrails, numberOfTrails-j )
			return trail
		end

		local miniBlack = {}

		local deg = {0,  math.rad( 120 ), math.rad( 240 )}
		local deltaDeg = math.rad( 1 ) -- the bigger the value would spin faster
		local distance = 10 -- the bigger the value would coming out faster

		timer.performWithDelay( 0, function() -- creating little balls

			animate:resetVariable( count )
			
			for i=1,3 do
				miniBlack[i] = display.newCircle( x, y, 20 )
				miniBlack[i]:setFillColor( 0 )
				group:insert( miniBlack[i] )

				miniBlack[i].x, miniBlack[i].y = x, y

				local num = nil

				if particleNumber.reachMax then num = 1 end

				local trailing = trails(miniBlack[i], group, nil)
			end

			local initx, inity = x, y

			local repetition = 0

			timer.performWithDelay( 100, function()
				repetition = repetition + 1
				local totalDistance = repetition*distance
				local x, y = {}, {}
				local dirX, dirY = 0,0

				for i=1,3 do
					deg[i] = deg[i] + repetition*deltaDeg
					x[i], y[i] = initx + totalDistance* (math.sin(deg[i])), inity + totalDistance* (math.cos(deg[i]))
					transition.to( miniBlack[i], {time = 90, x = x[i], y = y[i], transition = easing.linear} )
				end

				if repetition == 4 then
					for i=1, 3 do
						physics.addBody (miniBlack[i],"dynamic" , {density=1.0, friction = 0, bounce = 0, radius = 20})
						miniBlack[i].name = " "
						miniBlack[i].type = " "
						miniBlack[i].ID = math.pi
					end
				
				elseif repetition == 11 then
					for i=1,3 do
						
						miniBlack[i]:setLinearVelocity( (math.sin(deg[i] + math.rad(90)))*1000, (math.cos(deg[i] + math.rad(90)))*1000 )
						transition.to( miniBlack[i], {alpha = 0, time = 4000, onComplete = function ( )
						physics.removeBody( miniBlack[i] )	; if i == 3 then animate:resetVariable(-count) end					
						end} )
					end
				end

			end, 11)
			
		end)
		return group
	end

	function animate:greenBigBurst( )

		local createNewBall = require "components.gamePlay.ball"

		local group = display.newGroup( )

		function createBall( )
			
			local Ball = {}

			for i=1,5 do

				if  i== 1  then
					animate:resetVariable( 5 )					
				elseif i == 5 then
					animate:resetVariable( -5 )
				end

				local theta = 2*math.pi*i*.2
				local r = 10

				local delX, delY = invPolarCoord(r, theta)

				Ball[i] = ball:new(group, "littleGreen", x+ delX,y+delY)

				Ball[i]:setLinearVelocity( delX*300, delY*300 )

				animate:insert( Ball[i] )
			end
		end

		createBall()

		return group
	end

	function animate:purpleBigBurst( )

		local createNewBall = require "components.gamePlay.ball"

		local combination = {
		{"yellow", "blue", "green"}, 
		{"yellow", "blue", "purple"}, 
		{"yellow", "purple", "green"} 
		}

		local group = display.newGroup( )

		local num = math.floor(math.random(1, 3.9))

		function createBall( )
			
			local number = #GameObj

			for i=1,3 do

				-- if  i== 1  then
				-- 	animate:resetVariable( 3 )					
				-- elseif i == 3 then
				-- 	animate:resetVariable( -3 )
				-- end

				local theta = 2*math.pi*i*.33
				local r = 50

				local delX, delY = invPolarCoord(r, theta)

				GameObj[number+i] = ball:new(group, combination[num][i] , x+ delX,y+delY)

				GameObj[number+i]:setLinearVelocity( delX*100, delY*100 )

			end

			animate:resetVariable()
		end

		createBall()

		return group
	end

	animate:init()
	return animate
end