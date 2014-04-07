--[[
	Copyright (c) 2011 the original author or authors

	Permission is hereby granted to use, modify, and distribute this file
	in accordance with the terms of the license agreement accompanying it.
--]]

lives = {}
lives.instance = {}
lives.instance.maxLives = 5


local livesTimer

-- VARIABEL GLOBAL SETTINGS UNTUK LIVES = gameSettings.lives

local inst = lives.instance

function inst:setLives(value)
	print("LifeModel::setLifePoints, life: ", value)

	if(value == nil) then
		return
	end
	-- make sure we don't go below 0, or above our max
	value = math.max(value, 0)
	value = math.min(value, lives.instance.maxLives)

	self.lives = value


	if  livesTimer == nil then
		if self.lives == 0 then
			Runtime:dispatchEvent({name = "systemNotification", type = "add"}) -- add timer to system
		elseif self.lives < 5 then
			inst:addLivesTimer(); inst:setRefferenceTime()
		end
	else
		if self.lives == 5 then
			timer.cancel( livesTimer ); livesTimer = nil
			inst:setRefferenceTime()
			print( "LIFE :: timer cancelled" )
		end
	end

	

	gameSettings.lives.lives = self.lives
	Runtime:dispatchEvent ({name = "saveGameSettings"})
end

function inst:loseLevel()
	if self.lives == 5 then self:setRefferenceTime() end

	self:setLives(self.lives - 1)
end

function inst:addLives()
	self:setLives(self.lives + 1)
end

function inst:setRefferenceTime( )
	gameSettings.lives.referenceTime = tonumber(os.time( t ))
end

function inst:addLivesTimer( time) -- add timer to next +1
	local deltaTime 

	if time then deltaTime = time*1000 else deltaTime = 30*60*1000 end

	livesTimer= timer.performWithDelay( deltaTime, function ( )
		inst:addLives(); inst:setRefferenceTime()
	end )

	print( "LIVE ::: timer to new life set  = ".. deltaTime .. " ms" )

end

function inst:getTimeToNewLives( ) -- get time to next new lives
	if livesTimer then
		local number = timer.pause( livesTimer ) -- in ms
		timer.resume( livesTimer )
		number = math.floor( number*.001 ) -- in sec

		gameSettings.lives.timeToNewLive = number -- assigning value

		return number
	end
end



function inst:updateLives( ) -- for startupsettings
	self.lives = gameSettings.lives.lives

	if self.lives == 5 then
		inst:setRefferenceTime()
	elseif self.lives < 5 then
		local deltaTime = 60*30
		local timeNow = tonumber(os.time( t ))
		local deltaLives = math.floor( (timeNow -gameSettings.lives.referenceTime)/deltaTime )

		local value = self.lives+deltaLives

		if value < 5 then
			local time = deltaTime - ((timeNow -gameSettings.lives.referenceTime) % deltaTime)
			inst:addLivesTimer(time); 
			print( "LIVE ::: time to new life".. time .. " second" )
		end

		self:setLives(value)
	end
end

return lives