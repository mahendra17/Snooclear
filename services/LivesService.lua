

LivesService = {}

function LivesService:new()
	local service = {}

	local livesStat = gameSettings.lives
	-- countdownMax = 1800
	maxLives = 5

	-- print( livesStat )

	if ((os.time() - livesStat.referenceTime) > countdownMax) then
		local addLives = math.floor( (os.time() - livesStat.referenceTime)/countdownMax )
		if (addLives < (maxLives - livesStat.lives)) then
			livesStat.lives = livesStat.lives + addLives
			livesStat.referenceTime = livesStat.referenceTime + addLives * countdownMax
		else
			livesStat.lives = 5
			livesStat.referenceTime = os.time()
		end
		gameSettings.lives = livesStat
		Runtime:dispatchEvent( {name = "saveGameSettings"} )
	end

	print( "Lives service running" )

	return service
end

return LivesService