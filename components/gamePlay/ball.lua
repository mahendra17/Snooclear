-- components.gamePlay.ball
-- require "physics"
ball = {}

function ball:new(parentGroup, color, x,y)
	
	local ball = display.newGroup( )

	if parentGroup then
		parentGroup:insert(ball)
	end

	if (x==nil and y==nil) then
		x, y = display.contentCenterX, display.contentCenterY
	end

	function ball:init( )

		if (color == "cue") or (color=="red") then
			newBall = display.newImage("assets/images/BallRedGmlvlObj.png")
			newBall.name = "cue"
			newBall.ID = 61020
			newBall.location = "assets/images/BallRedGmlvlObj.png"
		elseif (color == "yellow") then
			newBall = display.newImage("assets/images/BallYellGmlvlObj.png")
			newBall.name = "yellow"
			newBall.type = "color"
			newBall.state = "uncoupled"
			newBall.ID = 10003
			newBall.location = "assets/images/BallYellGmlvlObj.png"
		elseif ( color == "blue") then
			newBall = display.newImage("assets/images/BallBlueGmlvlObj.png")
			newBall.name = "blue"
			newBall.type = "color"
			newBall.state = "uncoupled"
			newBall.ID = 10002
			newBall.location = "assets/images/BallBlueGmlvlObj.png"
		elseif (color == "green")then
			newBall = display.newImage("assets/images/BallGreenGmlvlObj.png")
			newBall.name = "green"
			newBall.type = "color"
			newBall.state = "uncoupled"
			newBall.ID = 10007
			newBall.location =  "assets/images/BallGreenGmlvlObj.png"
		elseif (color == "bigGreen")then
			newBall = display.newImage("assets/images/BallGreenGmlvlObj.png")
			newBall.name = "bigGreen"
			newBall.type = "color"
			newBall.state = "coupled"
			newBall.ID = .32 
			timer.performWithDelay( 5, function ()
				newBall.ID = 10120
			end ) 
		elseif (color == "littleGreen")then
			newBall = display.newImage("assets/images/BallGreenGmlvlObj.png")
			newBall.name = "littleGreen"
			newBall.ID = 11520
		elseif (color == "purple") then
			newBall = display.newImage("assets/images/BallPurpGmlvlObj.png")
			newBall.name = "purple"
			newBall.type = "color"
			newBall.state = "uncoupled"
			newBall.ID = 10008 
			newBall.location = "assets/images/BallPurpGmlvlObj.png"
		elseif (color == "bigPurple")then
			newBall = display.newImage("assets/images/BallPurpGmlvlObj.png")
			newBall.name = "bigPurple"
			newBall.type = "color"
			newBall.state = "coupled"
			newBall.ID = .33 
			timer.performWithDelay( 5, function ()
				newBall.ID = 10220
			end ) 
		elseif (color == "black") then
			newBall = display.newImage("assets/images/BallBlackGmlvlObj.png") 
			newBall.name = "black"
			newBall.type = "color"
			newBall.state = "coupled"
			newBall.ID = 10041 
			newBall.location = "assets/images/BallBlackGmlvlObj.png"
		elseif color == "yellowc" then
			newBall = display.newImage("assets/images/BallYellOtlnGmlvlObj.png") 
			newBall.name = "yellowc"
			newBall.type = "circled"
			newBall.ID = 14003
		elseif color == "bluec" then
			newBall = display.newImage("assets/images/BallBlueOtlnGmlvlObj.png") 
			newBall.name = "bluec"
			newBall.type = "circled"
			newBall.ID = 14002
		elseif color == "greenc" then
			newBall = display.newImage("assets/images/BallGreenOtlnGmlvlObj.png") 
			newBall.name = "greenc"
			newBall.type = "circled"
			newBall.ID = 14007
		elseif color == "hollow" then
			newBall = display.newImage("assets/images/BallTransGmlvlObj.png") 
			newBall.name = "hollow"
			newBall.ID = 11020
		elseif color == "redh" then
			newBall = display.newImage("assets/images/BallTransRedGmlvlObj.png")
			newBall.name = "cueh"
			newBall.type = "color"
			newBall.state = "coupled"
			newBall.ID = 80020
		elseif color == "greenh" then
			newBall = display.newImage("assets/images/BallTransGreenGmlvlObj.png")
			newBall.name = "greenh"
			newBall.type = "color"
			newBall.state = "coupled"
			newBall.ID = 80007
		elseif color == "blueh" then 
			newBall = display.newImage("assets/images/BallTransBlueGmlvlObj.png")
			newBall.name = "blueh"
			newBall.type = "color"
			newBall.state = "coupled"
			newBall.ID = 80002
		elseif color == "yellowh" then
			newBall = display.newImage("assets/images/BallTransYellowGmlvlObj.png")
			newBall.name = "yellowh"
			newBall.type = "color"
			newBall.state = "coupled"
			newBall.ID = 80003
		elseif color == "purpleh" then
			newBall = display.newImage("assets/images/BallTransPurpleGmlvlObj.png")
			newBall.name = "purpleh"
			newBall.type = "color"
			newBall.state = "coupled"
			newBall.ID = 80008
		elseif color == "blackh" then
			newBall = display.newImage("assets/images/BallTransBlackGmlvlObj.png")
			newBall.name = "blackh"
			newBall.type = "color"
			newBall.state = "coupled"
			newBall.ID = 80040
		elseif (color == "purplec") then
			newBall = display.newImage("assets/images/BallTransPurpleGmlvlObj.png") 
			newBall.name = "purplec"
			newBall.type = "color"
			newBall.state = "uncoupled"
			newBall.ID = 14008
		end
		newBall.width, newBall.height = 40,40
		newBall.x, newBall.y = x, y
    	-- newBall.isBullet = true

    	if color == "bluec" or color == "greenc" or color == "yellowc" or color == "purplec" then
    		physics.addBody (newBall,"static" , {density=1, friction = .08, bounce = .92, radius = 20})   
    	elseif color == "hollow" then
    		physics.addBody (newBall,"static" , {density=1, friction = .08, bounce = .92, radius = 20})
    	-- elseif color == "black" then
    	-- 	physics.addBody (newBall,"dynamic" , {density=1.70, friction = 0, bounce = .1, radius = 20})
    	-- 	newBall.width, newBall.height = 30,30
    	-- 	newBall.linearDamping = 1
    	elseif color == "bigGreen" or color == "bigPurple" then
    		physics.addBody (newBall,"dynamic" , {density=1, friction = .08, bounce = .92, radius = 40})
    		newBall.linearDamping = .8
    		-- newBall.angularDamping = 0.01
    	elseif color == "littleGreen" then
    		physics.addBody (newBall,"dynamic" , {density=1, friction = .08, bounce = .92, radius = 10})
    		newBall.linearDamping =.8
    		newBall.width, newBall.height = 20,20
    		-- newBall.angularDamping = 0.01
    	else
    		physics.addBody (newBall,"dynamic" , {density=1, friction = .08, bounce =.92, radius = 20})
    		newBall.linearDamping = .8
    		-- newBall.angularDamping = 0.01
    	end

    	newBall.isPortable = true

    	self:insert( newBall)
    	return newBall
	end
	
	ball:init()

	return newBall
end

