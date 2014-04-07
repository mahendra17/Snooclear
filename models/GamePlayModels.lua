-- require "vo.GamePlayVO"
GamePlayModel = {}
GamePlayModel.instance = {}
 	
---initialize value-----------------
_G.activatorOnGame = {}
_G.activatorOnGame.active = false
_G.activatorOnGame.activeType = nil
_G.activatorOnGame.RCLength = 300
_G.activatorOnGame.nullCount = nil

gamePlaySettings = {}
gamePlaySettings.gamePlayOn = true

local possibleReactions = {71140, 71240, 72040, 20004, 20005, 20009, 20010, 20122, 20222, 20043, 90022, 90004, 90043, 24004, 21522, 20006, 20010, 20011, 20123, 20223, 20044, 90023, 90006, 90044, 24006, 21523, 20014, 20015, 20127, 20227, 20048, 90027, 90014, 90048, 24014, 21527, 20016, 20128, 20228, 20049, 90028, 90016, 90049, 24016, 21528, 20240, 20340, 20161, 21140, 90140, 90122, 90123, 90127, 90128, 90161, 24122, 24123, 24127, 24128, 21640, 20440, 20261, 21240, 90240, 90222, 90223, 90227, 90228, 90268, 24222, 24223, 24227, 24228, 21740, 20082, 90061, 90061, 90043, 90044, 90048, 90049, 90082, 21561, 22540, 91540, 91522, 91523, 91527, 91528, 91561, 25522, 25523, 25527, 25528, 23040}

------------------------------------------------

local inst = GamePlayModel.instance
GamePlayModel.instance.energy = .5
GamePlayModel.instance.maxEnergy = 20

function inst:initValue(  )
	GamePlayModel.instance.energy = PrelevelData[_G.currentLevel].initialEnergy
end

function inst:setPoints(value)
	print( "GamePlayModel::setHitPoints, value:" .. value)
	if (value == nil) then
		return
	end

	value = math.max( value, 0 )
	value = math.min( value,GamePlayModel.instance.maxEnergy )
	self.energy = value

 	local target = PrelevelData[_G.currentLevel].target

 	if gamePlaySettings.gamePlayOn then
 		Runtime:dispatchEvent( {target = self, name = "energyChanged", energy = self.energy} )
 		gamePlaySettings.currentEnergy = self.energy
 		if self.energy <= 0 then self:dispatchToRuntime("gameOver"); self:setGameplayOn(false) end
 	end

end

function inst:dispatchToRuntime( event )
	if gamePlaySettings.gamePlayOn then
		if event == "gameOver" then
			Runtime:dispatchEvent({name = "moveView", type = "gameOver"})
		elseif event == "levelCleared" then
			Runtime:dispatchEvent({name = "moveView", type = "levelCleared"})
			gamePlaySettings.gamePlayOn = false

			_G.temporaryData.energy = math.floor( self.energy )

			Runtime:dispatchEvent({name = "getLives"})

			gameSettings.openedLevel = math.max( (currentLevel + 1), gameSettings.openedLevel )
			gameSettings.openedLevel = math.min (gameSettings.openedLevel, #_G.levelData)
			Runtime:dispatchEvent( {name = "saveGameSettings" } )

			-- save result to userscores.json
			Runtime:dispatchEvent( {name = "saveScore", level = currentLevel, score = self.energy} )
		end
	end
end

function inst:setGameplayOn( bool )
	if bool then
		gamePlaySettings.gamePlayOn = bool
	else
		return gamePlaySettings.gamePlayOn
	end
end


function inst:countObject()
 	local objectSum = 0
 	local objectID = {}
 	local count1 = 0
 	-- local hollowSum, circledSum = 0,0

	for i=1,#GameObj do
		
		if (GameObj[i].ID) and GameObj[i].name and GameObj[i] then
			if (GameObj[i].ID%1 == 0) then
				count1 = count1+1
				objectID[count1] = GameObj[i].ID
			end
		elseif GameObj[i] and GameObj[i].bodyType == nil then
			GameObj[i].isVisible = false
		end

		if GameObj[i].name and GameObj[i] and GameObj[i].type ~= "circled" then
			objectSum = objectSum+1
		end
	end
	print( "countObject: ".. objectSum .. "object(s) left.")

	local function reactionCheck(object)
		print( "Checking for possible reactions..." )
		local objID = {}
		objID = object

		local combinationID = {}
		local count2 = 0

		for i=1, (#objID - 1) do
			for j=i + 1, #objID do
				count2 = count2 + 1
				combinationID[count2] = objID[i] + objID[j]
				for k=1, #possibleReactions do
					-- print( combinationID[count2] .. " ..... " .. possibleReactions[k])
					if (combinationID[count2] == possibleReactions[k]) then
						return true
					end
				end
			end
		end
		
	end

	if objectSum <= 10 then	local check = reactionCheck(objectID)

		if (check) then	print( "Possible reaction found!!" )
		else self:setGameplayOn(false); self:dispatchToRuntime("levelCleared"); print( "There's no possible reactions!!" ) end
	
	end

	
end

function inst:addForce(event)
	local data =  event.dir

	data.normalizedDirection = {}
	data.normalizedDirection.x, data.normalizedDirection.y = dir(event.dir.xStart, event.dir.yStart, event.dir.x , event.dir.y)
	
	data.magnitude = magnitude(event.dir.xStart, event.dir.yStart, event.dir.x , event.dir.y)
	
	data.magnitudeMax = display.actualContentHeight*.5
	data.magnitudeMin = 5

	if (data.magnitude < 10 ) then data.magnitude = 0
	elseif data.magnitude < data.magnitudeMin then data.magnitude =  data.magnitudeMin
	elseif data.magnitude > data.magnitudeMax then data.magnitude = data.magnitudeMax end

	if data.magnitude >0 then

		local Force
		if (data.magnitude < 50) then
			Force = 1500
		else
			Force = 3500
		end
		
		local percentage = data.magnitude /(data.magnitudeMax- data.magnitudeMin)
		percentage = (3^percentage) - 0.9

		if inst:setGameplayOn() then
			if GamePlayModel.instance.energy >= 0 then	
				-- if GamePlayModel.instance.energy > 0 then
					local force = {x = Force*percentage*data.normalizedDirection.x, y = Force*percentage*data.normalizedDirection.y}
					if activatorOnGame.active and _G.activatorOnGame.nullCount and _G.activatorOnGame.activeType == "null" then
						--FREE
					elseif activatorOnGame.active and _G.activatorOnGame.activeType == "boost" then
						force = {x = Force*2*data.normalizedDirection.x, y = Force*2*data.normalizedDirection.y}
						self:setPoints (self.energy-(1*percentage))
					elseif activatorOnGame.active and _G.activatorOnGame.activeType == "forsee" then
						force = {x = Force*1.5*data.normalizedDirection.x, y = Force*1.5*data.normalizedDirection.y}
						self:setPoints (self.energy-(1*percentage))
					else
						self:setPoints (self.energy-(1*percentage))
					end
					Runtime:dispatchEvent({name = "addForce", force = force, target = self} )
					inst:activatorCheck()	
				-- end
			end
		end

	end
end

function inst:onCollision(event)
	if self:setGameplayOn() then
		local collisionID = {}
		collisionID = event.object
		-- print( collisionID.ID )



		function collisionDispatcher(object, destroyID, createID, v1, v2)

			local function dispatch( )
				Runtime:dispatchEvent( {name = "onCollisionReaction", object = object, destroyID = destroyID, createID = createID, v1 = v1, v2 = v2} )
			end

			local function dispatch2( )
				print( "count object called" )
				if inst:setGameplayOn() then inst:countObject() end
			end

			timer.performWithDelay( 1, dispatch )
			timer.performWithDelay( 900, dispatch2 )
			
		end

		function animationDispatcher(type)

			local posX = 0.5*(collisionID[1].x + collisionID[2].x)
			local posY = 0.5*(collisionID[1].y + collisionID[2].y)

			timer.performWithDelay( 1, function ( )
				if inst:setGameplayOn() then Runtime:dispatchEvent( {name = "onGameAnimation", type = type, posX = posX, posY = posY } ) end
			end )
			
		end
		
		function checkCircle(color, createID)
			if (collisionID.isUnreactive == 4) then
				collisionDispatcher(collisionID, 2, color, 0,0) -- destroy circle, create ball with same color
			else
				self:setPoints (self.energy+2)-- add points
				if (collisionID.colorID == 4) then
					animationDispatcher("implosion")
				elseif (collisionID.colorID == 6) then
					animationDispatcher("explosion")
				end

				if (createID) then
					collisionDispatcher(collisionID, 1, createID, 0.1,0.1) -- destroy and create
				else
					collisionDispatcher(collisionID, 1) -- only destroy
				end
			end
		end
		-- print( collisionID.colorID%1 )

		if ((collisionID.ID%1) == 0) then -- collisionID.ID is integer (not colliding with wall/reactor)

			if ((collisionID[1].ID == 61020) or (collisionID[2].ID == 61020)) then -- Checking color and circled (static balls)
				self:setPoints (self.energy+.2)
			end

			-- for hollow collision, create new cue
			if ((collisionID.ID < 90018) and (collisionID.ID > 90001)) or ((collisionID.ID < 90050) and (collisionID.ID > 90040)) then
				collisionDispatcher(collisionID, 10, 1, .4, .4) -- destroyID 10: destroy nothing
			end

			-- Sorting collision based on colors
			if (collisionID.colorID < 20) then
				if (collisionID.colorID == 4) then -- blue and blue collision
					checkCircle(2) 
				elseif collisionID.colorID == 6 then -- yellow and yellow collision
					checkCircle(3)
				elseif collisionID.colorID == 14 then -- green and green collision
					checkCircle(4, 6) 
				elseif collisionID.colorID == 16 then -- purple and purple collision
					checkCircle(5, 7)
				else
					if (collisionID.isUnreactive == 0) then collisionDispatcher(collisionID, 1, 9, .7, .7) end
				end
			elseif ((41 < collisionID.colorID) and (collisionID.colorID < 80)) then -- collision black with color
				if (collisionID.isUnreactive == 0) then -- react with black
				 	collisionDispatcher(collisionID, 1) -- create 3 small black balls
				 	animationDispatcher("threeBallReaction") --===== three
				end
			elseif collisionID.colorID > 80 then
				collisionDispatcher(collisionID, 1) -- 2 black balls collide together
				animationDispatcher( "blackBlast" )
			end

		elseif ((collisionID.ID%1 > .1) and (collisionID.ID%1 < .11)) then
			-- print("blackisSensor" )
			-- print( collisionID[1].name, collisionID[2].name )
			collisionDispatcher(collisionID, 4)
			
			local name = nil; if collisionID[1].name ~= "blackBig" then  name = collisionID[1].name else name = collisionID[2].name end;
			if name ==  "yellow" then animationDispatcher("explosion") elseif name ==  "blue" then animationDispatcher("implosion")
			elseif name ==  "black" then animationDispatcher("threeBallReaction") end	
		end

		-- Create hollow cue
		if (collisionID.ID == 72040) then -- hollow collided with cue
			collisionDispatcher(collisionID, 1, 15, .7, .7) -- create hollow cue
		end

		-- Create colored hollow cue
		if ((90020 < collisionID.ID) and (collisionID.ID < 90100)) then
			local colorCode-- destroy both balls
			if (collisionID.colorID == 22) then
				colorCode = 10 -- create a blue cue
			elseif (collisionID.colorID == 23) then
				colorCode = 11 -- create a yellow cue
			elseif (collisionID.colorID == 27) then
				colorCode = 12 -- create a green cue
			elseif (collisionID.colorID == 28) then
				colorCode = 13 -- create a purple cue
			elseif (collisionID.colorID == 61) then
				colorCode = 14 -- create a black cue
			end
			collisionDispatcher(collisionID, 1, colorCode,1,1)
		end

		-- Big balls reaction
		if (collisionID.isBig > 0) then -- at least 1 big ball or its descendant is involved
			-- print( "Big collision" 
			for i=1,2 do
				if (collisionID[i].isBig == 5) then -- object little green
					collisionDispatcher(collisionID, 2) -- remove little green
				end
				if ((collisionID.ID%1) == 0) then
					if (collisionID[i].isBig == 1) then -- object is big Green
						-- print( "object is big green" )
						
						collisionDispatcher(collisionID, 3) -- destroy ball (and create little green)
						animationDispatcher("greenBigBurst")
					elseif (collisionID[i].isBig == 2) then -- object big Purple
						collisionDispatcher(collisionID, 3) -- destroy ball (and create balls)
						animationDispatcher("purpleBigBurst")
					end
				end
			end
		end
	end
end


-- activator
function inst:activator( event )

	print(" ".. event.type .. " " .. event.condition)
	local name = {
	      [1]="banish",
	      [2]="boost",
	      [3]="force",
	      [4]="forsee",
	      [5]="null",}

	for i=1,#name do
		if name[i] == event.type then
			if event.condition == "use" then
				activatorData[i].qty = activatorData[i].qty - 1
				activatorData[i].qty = math.max(activatorData[i].qty, 0)
			elseif event.condition == "add" then
				activatorData[i].qty = activatorData[i].qty + 1
			end
			
			Runtime:dispatchEvent({name="saveActivatorData"})
		end
	end

	if event.condition == "use" then
		_G.activatorOnGame.active = true
		_G.activatorOnGame.activeType = event.type

		if event.type == name[1] then
			Runtime:dispatchEvent({name ="setActivator", activatorState = "start", type = "banish"})
		elseif event.type == name[2] then
			Runtime:dispatchEvent({name ="setActivator", activatorState = "start", type = "boost"})
		elseif event.type == name[3] then
			Runtime:dispatchEvent({name ="setActivator", activatorState = "start", type = "force"})
			_G.activatorOnGame.active = false; _G.activatorOnGame.activeType = nil
		elseif event.type == name[4] then
			_G.activatorOnGame.RCLength = 2000
		elseif event.type == name[5] then
			_G.activatorOnGame.nullCount = 5
		end
	end
end

function inst:activatorCheck( event )

	if _G.activatorOnGame.activeType == "banish" then
		GameObj[1].linearDamping = 2
		Runtime:dispatchEvent({name ="setActivator", activatorState = "end", type = "banish"})
		_G.activatorOnGame.active = false; _G.activatorOnGame.activeType = nil
	elseif _G.activatorOnGame.activeType == "boost" then
		Runtime:dispatchEvent({name ="setActivator", activatorState = "end", type = "boost"})
		_G.activatorOnGame.active = false; _G.activatorOnGame.activeType = nil
	elseif _G.activatorOnGame.activeType == "null" then
		if _G.activatorOnGame.nullCount > 0 then
			_G.activatorOnGame.nullCount = _G.activatorOnGame.nullCount - 1 
		elseif _G.activatorOnGame.nullCount == 0 then
			_G.activatorOnGame.nullCount = nil
			_G.activatorOnGame.active = false; _G.activatorOnGame.activeType = nil
		end
	elseif _G.activatorOnGame.activeType == "forsee" then
		_G.activatorOnGame.active = false; _G.activatorOnGame.activeType = nil
	end

end

return GamePlayModel