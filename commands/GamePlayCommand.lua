require "services.GamePlayService"
GamePlayCommand = {}

function GamePlayCommand:new( )
	local command = {}
	command.GamePlayService = nil

	function command:execute( event )
		print("GamePlayCommand::execute")
		if _G.levelData == nil then
			GamePlayService = GamePlayService:new()
		end

		_G.gamePlaySettings = {}
		gamePlaySettings.gamePlayOn = true
		GamePlayModel.instance:initValue(  )

		Runtime:dispatchEvent( {name = "loseLives"} )

		Runtime:dispatchEvent({name = "chartBoost" , type = "cacheAd"}) 

		command:freeActivator( )
	end

	function command:freeActivator( )


		local leveldata = {10,15,20,25,30}
    	local getActivator = {5,2,3,4,1}
    	local name = { [1]="banish", [2]="boost", [3]="force", [4]="forsee", [5]="null"}

    	for i=1,#leveldata do
        	if currentLevel == leveldata[i] then
        		if gameSettings.showTutorial.level[currentLevel] then
        			_G.temporaryData.data = {}; 
        			for i=1,5 do
        				temporaryData.data [i] = false
        			end

        			local activator = name[getActivator[i]]
        	    	Runtime:dispatchEvent({name = "activator", condition = "add", type = activator}) 
        	    	temporaryData.data[getActivator[i]] = true
        		end
        	end
    	end

    	
	end

	return command
end

return GamePlayCommand