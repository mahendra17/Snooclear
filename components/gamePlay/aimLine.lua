
require "components.gamePlay.direction"

local maxLength = 400

dotsLine = {}

local function polarCoord( x, y )
	if (x and y) then
		local r = math.sqrt( x*x + y*y )
		local theta = math.atan2( y, x )
		return r, theta
	end
end

local function invPolarCoord(r, theta ) --  theta rad
	local x = r* math.cos( theta )
	local y = r* math.sin(theta)
	return x, y
end 

function dotsLine:new( xStart, yStart, xEnd, yEnd, startPointX, startPointY)
	local line = display.newGroup( )


	if (not startPointX and  not startPointY) then
		startPointX, startPointY = xStart, yStart
	end

	local r, theta = polarCoord (xEnd-xStart, yEnd - yStart)

	local dotline = {}
	
	function line:init( )
		local delta = 15
		local num = math.floor(r/delta)

		for i=1,num do
			local x, y = invPolarCoord(i*delta, theta)
			x, y = x+startPointX, y+startPointY 
			dotline[i] = display.newCircle( x, y , 2.5 ); dotline[i]:setFillColor( 229/255, 69/255,26/255, .9 )
			
			line:insert(dotline[i])
		end	
	end

	function line:setAlpha( )
		num = #dotline
		for i=1,num do
			dotline[i].alpha = (.9/num) * (num-i)
		end
	end

	function line:setColor( r,g,b )
		num = #dotline
		for i=1,num do
			dotline[i]:setFillColor( r,g,b )
		end
	end

	function line:remove( )
		line:removeSelf( )
		line = nil
	end
	function line:autoRemove()
		transition.to( line, {alpha = 0, time = 2000, onComplete = function ( )
			-- line:remove(  )
		end} )
	end

	line:init()
	line:autoRemove()

	return line
end

----------------------------------------------------------------
local function hitsDetect( xStart, yStart, xEnd, yEnd, startPointX, startPointY )

	group = display.newGroup( )

	if (not startPointX and  not startPointY) then
		startPointX, startPointY = xStart, yStart
	end

	local deltaX, deltaY = xEnd-xStart, yEnd-yStart

	

	function group:getData( )
		-- if (gamePlaySettings) then 
			maxLength = _G.activatorOnGame.RCLength 
		-- end
	end

	function group:init( )

		-- set max length

		local r, theta = polarCoord(deltaX, deltaY)

		-- print(maxLength)

		-- r = math.max(400, r)
		r = math.min(400, r)


		deltaX, deltaY = invPolarCoord (r, theta)

		--

		local hits1 = physics.rayCast( startPointX, startPointY, startPointX+deltaX, startPointY+deltaY )

		if (hits1) then

			local line1 = dotsLine:new( startPointX, startPointY, hits1[1].position.x, hits1[1].position.y)
			group:insert( line1 )

			if hits1[1].object.ID == .5 then
				local reflectX, reflectY = physics.reflectRay(startPointX, startPointY, hits1[1] )
				-- print( "hits".. reflectX, reflectY )

				length = r -  magnitude(startPointX, startPointY, hits1[1].position.x, hits1[1].position.y)

				reflectX = (reflectX*length)+hits1[1].position.x
				reflectY = (reflectY*length)+hits1[1].position.y

				local hits2 = physics.rayCast( hits1[1].position.x, hits1[1].position.y, reflectX, reflectY )
					if hits2  then
						local line2 = dotsLine:new( hits1[1].position.x, hits1[1].position.y, hits2[1].position.x, hits2[1].position.y)
						line2:setAlpha()
						group:insert( line2 )
					else
						local line2 = dotsLine:new( hits1[1].position.x, hits1[1].position.y, reflectX, reflectY )
						line2:setAlpha()
						group:insert( line2 )
					end	
			else
				line1:setAlpha()
			end

		else
			local line = dotsLine:new( xStart, yStart, xStart+deltaX, yStart+deltaY, startPointX, startPointY)
			line:setAlpha()
			group:insert( line )
		end
	end	

	function group:initOnActivator( )

		-- set max length

		local r, theta = polarCoord(deltaX, deltaY)

		maxLength = 5000

		r = math.min(maxLength, r)

		deltaX, deltaY = invPolarCoord (r, theta)

		--

		local hits1 = physics.rayCast( startPointX, startPointY, startPointX+deltaX, startPointY+deltaY )

		if (hits1) then

			local line1 = dotsLine:new( startPointX, startPointY, hits1[1].position.x, hits1[1].position.y)
			group:insert( line1 ); line1:setColor( .8, .8, .8 )

			local reflectX, reflectY = physics.reflectRay(startPointX, startPointY, hits1[1] )

			-- length = r -  magnitude(startPointX, startPointY, hits1[1].position.x, hits1[1].position.y)
			length = 500

			reflectX = (reflectX*length)+hits1[1].position.x
			reflectY = (reflectY*length)+hits1[1].position.y

			local hits2 = physics.rayCast( hits1[1].position.x, hits1[1].position.y, reflectX, reflectY )
			
			if hits2  then
				local line2 = dotsLine:new( hits1[1].position.x, hits1[1].position.y, hits2[1].position.x, hits2[1].position.y)
				group:insert( line2 ); line2:setColor( .8, .8, .8 )
				------------------------------------------------------------------------------------
				reflectX, reflectY = physics.reflectRay(hits1[1].position.x, hits1[1].position.y, hits2[1] )
				-- print( "hits".. reflectX, reflectY )

				-- length = r -  magnitude(hits1[1].position.x, hits1[1].position.y, hits2[1].position.x, hits2[1].position.y)

				length = 500

				reflectX = (reflectX*length)+hits2[1].position.x
				reflectY = (reflectY*length)+hits2[1].position.y

				local hits3 = physics.rayCast( hits2[1].position.x, hits2[1].position.y, reflectX, reflectY )
				
				if hits3  then
					-- print ("hits 3")
					local line3 = dotsLine:new( hits2[1].position.x, hits2[1].position.y, hits3[1].position.x, hits3[1].position.y)
					line3:setColor( .8, .8, .8 )
					group:insert( line3 )
				else
					local line3 = dotsLine:new( hits2[1].position.x, hits2[1].position.y, reflectX, reflectY )
					group:insert( line3 )
					line3:setColor( .8, .8, .8 )
				end	
				-------------------------------------------------------------------------------------------------

			else
				local line2 = dotsLine:new( hits1[1].position.x, hits1[1].position.y, reflectX, reflectY )
				-- line2:setAlpha()
				group:insert( line2 ); line2:setColor( .8, .8, .8 )
			end	

		else
			local line = dotsLine:new( xStart, yStart, xStart+deltaX, yStart+deltaY, startPointX, startPointY)
			line:setColor( .8, .8, .8 )
			-- line:setAlpha()
			group:insert( line )
		end
	end	

	function group:remove(  )
		if group then group:removeSelf( ); group = nil end
	end

	-- group:getData()
	if _G.activatorOnGame.active and _G.activatorOnGame.activeType == "forsee" then
		group:initOnActivator() 
	end
	group:init()	
	


	return group

end

---------------------------------------------------------------------------------

aimLine = {}

local myLine

function aimLine:new( object, e )
	local group = display.newGroup( )
	if e.phase == "began" then
		myLine = hitsDetect ( 0, 0, 5, 5, object.x, object.y); group:insert(myLine)
	elseif e.phase == "moved" then

		if myLine then myLine:remove() end

		if e.y >= .98* display.contentHeight or e.y <=1 or e.x <= 1 or e.x >= display.contentWidth *.98 then
			
		else
			myLine = hitsDetect ( e.xStart, e.yStart, e.x, e.y, object.x, object.y); group:insert(myLine)
		end

	elseif e.phase == "ended" or e.phase == "cancelled" then
		if myLine then myLine:remove() end
	end

	function group:remove( )
		group:removeSelf( )
		greoup = nil
	end

	return group
end



