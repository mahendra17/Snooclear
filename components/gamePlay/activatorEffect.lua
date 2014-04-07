local group = display.newGroup( )

function activatorEffect( event, parentGroup )

	local type  = event.type

	if (type == "boost") then

		local trailsVisible = false
		local cueOnTrail = false

		local function trails(object, parentGrp) -- create trail effects (available in animation)
			local Group = display.newGroup( )

			-- if parentGrp then
			-- 	parentGrp:insert( Group )
			-- end
			
			trailsVisible = true

			local trail = {}

			local numberOfTrails = 50

			local i = 0
			local j = -25

			function createTrails(object)
				-- print( "CREATING TRAILS" )


				if object.location then
					trail[i] = display.newImage( object.location)
					trail[i].width, trail[i].height = 40,40
					trail[i].x, trail[i].y = object.x, object.y
				else
					trail[i] = display.newCircle( object.x, object.y, 20 )
					trail[i]:setFillColor( 0 )				
				end
				trail[i].anchorX, trail[i].anchorY = .5, .5
				Group:insert( trail[i] )
				local transitionTime = 1000 - 995*(i/numberOfTrails)
				transition.to( trail[i], {time = transitionTime, alpha = 0, onComplete = function ( )
					if i == numberOfTrails then trailsVisible = false end
				end} )

				if temporaryData.currentView ~= "GamePlayView" or cueOnTrail == false then
					trail[i].isVisible = false
				end

				i = i + 1

			end

			function deleteTrails()
				if (trail[j]) then
					if (trail[j]) then
						trail[j]:removeSelf( )
						trail[j] = nil				
					end
				end
				if j == numberOfTrails then
					
				end

				j = j+1
			end

			timer.performWithDelay( 70, function() createTrails(object) end, numberOfTrails )
			timer.performWithDelay( 90, deleteTrails, numberOfTrails-j )
			return trail
		end

		local function setLinearDamping( num )
			for i=1,#GameObj do
				if GameObj[i] and GameObj[i].bodyType then
					GameObj[i].linearDamping = num
				end
			end
		end	

		local function addTrailCue( )
			if trailsVisible == false then
				trails(GameObj[1], parentGroup)
				-- print( "adding trail" )
			else
				-- print( "trail is visible, cant add more" )
				-- print( "checking add trail ini 1000 ms" )
				timer.performWithDelay( 1000, addTrailCue )
			end
		end

		local function checkVel( )
			if cueOnTrail == true then
				local vx, vy = GameObj[1]:getLinearVelocity( )
				-- print( "vel".. vx, vy )
				if math.abs (vx) > 20 or math.abs (vy) > 20 then
					addTrailCue(); 
					-- print( "velocity > 20 , add trail to cue" )
				else
					timer.performWithDelay( 100, function ( )
						checkVel()
					end )
				end
			end
		end

		if event.activatorState == "start" then
			setLinearDamping( 0 ); cueOnTrail = true; checkVel( )

		elseif event.activatorState == "end" then
			timer.performWithDelay( 10000, function ( )
				setLinearDamping( .8 ); cueOnTrail = false; 
				-- print( "cueOnTrail state" .. tostring (cueOnTrail)  )
			end )
		end		

	elseif (type == "banish") then

		local function activatorStart( )
			disableReactor( )
			-- print( "banish start" )
		end

		local function activatorEnd( )
			-- print( "banish end" )
			avtivateReactor()
		end 

		if event.activatorState == "start" then
			activatorStart( )
		elseif event.activatorState == "end" then
			timer.performWithDelay( 1000, activatorEnd)
		end

	elseif (type == "force") then

		local onAccelerateStateOn = false
		local gravityX, gravityY 

		local function disc(num )
			local temp = math.abs( num )%.1
			if (num < 0) then
				num = num +temp
			else
				num = num- temp
			end
			return num
		end

		local function bodyAwake( )
			for i=1,#GameObj do
				if GameObj[i].bodyType == "dynamic" then
					GameObj[i].isAwake = true
				end
			end
		end

		local function startAccelerate( )
			onAccelerateStateOn = true; bodyAwake( ) 

			timer.performWithDelay( 5000, function ( )	onAccelerateStateOn = false	; end)

			local function getGravity( event )

				if onAccelerateStateOn then
					gravityX= (disc(event.xGravity))*8 ; gravityY = (disc(event.yGravity) * -1)*8
				elseif onAccelerateStateOn == false then
					Runtime:removeEventListener("accelerometer", getGravity)
				end
				
			end

			Runtime:addEventListener("accelerometer", getGravity)
		end

		local function startSetGravity( )
			local function setGravity(  )
				if onAccelerateStateOn then
					physics.setGravity( gravityX, gravityY ); bodyAwake( )
				elseif onAccelerateStateOn == false then
					Runtime:removeEventListener("enterFrame", setGravity)
					physics.setGravity( 0, 0 )
				end
			end
			Runtime:addEventListener("enterFrame", setGravity)
		end

		startAccelerate( ); startSetGravity()
	end
end