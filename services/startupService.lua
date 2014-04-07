require "services.ReadFileContentsService"

startupSetting = {}

function startupSetting:new()
	local service = {}
	
	--game settings
	local dataTable = loadTable ("gameSettings.json", system.DocumentsDirectory)

	if (dataTable) then
	 	_G.gameSettings = dataTable

	 	local function updateDailyActivator( )
	 		local _table = _G.gameSettings.dailyActivator
	 		local newDayNumber = tonumber( os.date( "%j" ))

	 		if newDayNumber >_table.dayNumber or _table.dayNumber == 366 and newDayNumber < 366  then
	 			_table.dayNumber = newDayNumber
	 			_table.notUsedToday = true
	 			_G.gameSettings.dailyActivator = _table
	 		end

	 	end

	 	updateDailyActivator( )

	 	local function updateDailyShare( )
	 		local _table = gameSettings.shareSettings
	 		local newDayNumber = tonumber( os.date( "%j" ))

	 		if newDayNumber >_table.dayNumber or _table.dayNumber == 366 and newDayNumber < 366 then
	 			_table.dayNumber = newDayNumber
	 			_table.reachMax = false
	 			_table.reachMaxMessage = false
	 			_table.count = 0
	 			gameSettings.shareSettings = _table
	 		end

	 	end

	 	updateDailyShare( )



	 else

	 	local myGameSettings = {}
	 	myGameSettings.soundOn = true
	 	myGameSettings.AmbSoundOn = true
	 	myGameSettings.notificationOn = true
	 	myGameSettings.openedLevel = 1
	 	myGameSettings.onCircleLevel = 0
	 	myGameSettings.lives = {}
	 		myGameSettings.lives.lives = 5
	 		myGameSettings.lives.referenceTime = tonumber(os.time( t ))
	 		myGameSettings.lives.timeToNewLive = 0

	 	myGameSettings.dailyActivator = {}
	 		myGameSettings.dailyActivator.dayNumber = tonumber( os.date( "%j" ))
	 		myGameSettings.dailyActivator.notUsedToday = true

	 	myGameSettings.shareSettings = {}
	 		myGameSettings.shareSettings.dayNumber = tonumber( os.date( "%j" ))
	 		myGameSettings.shareSettings.reachMax = false
	 		myGameSettings.shareSettings.count = 0
	 		myGameSettings.shareSettings.reachMaxMessage = false

	 	myGameSettings.showTutorial = startupSetting:getTutorialLevelData ()
	 	
	 	saveTable("gameSettings.json", system.DocumentsDirectory, myGameSettings )

	 	_G.gameSettings = myGameSettings
	end 


	--activator data
	local activatorData = loadTable ("activatorData.json", system.DocumentsDirectory)

	if (activatorData) then
	 	_G.activatorData = activatorData
	else

	 	local myActivatorData = {}

	 	for i=1,5 do
	 		myActivatorData[i] = {}
	 		myActivatorData[i].qty = 0
	 	end
	 	
	 	saveTable("activatorData.json", system.DocumentsDirectory, myActivatorData )

	 	_G.activatorData = myActivatorData
	end 

	_G.temporaryData = {}

	local platformName = system.getInfo("platformName")

	temporaryData.device = platformName

	if platformName == "iPhone OS" or platformName == "Mac OS X" then
	  	temporaryData.font = {BlanchCaps = "Blanch-Caps", BlanchCapsInline = "Blanch-CapsInline", BlanchCapsLight ="Blanch-CapsLight", calibri = "Calibri"} 
	elseif platformName == "Android" or platformName == "Win" then
		temporaryData.font = {BlanchCaps = "Blanch Caps", BlanchCapsInline = "Blanch Caps Inline", BlanchCapsLight ="Blanch Caps Light", calibri = "Calibri"} 
	else 
		temporaryData.font = {BlanchCaps = "Blanch-Caps", BlanchCapsInline = "Blanch-CapsInline", BlanchCapsLight ="Blanch-CapsLight", calibri = "Calibri"} 
	end
	
	-- Saving total energy (Facebook score) to global variable
	local gameScore = loadTable ("userscores.json", system.DocumentsDirectory)

	if (gameScore) then
		local sumEnergy = 0
		for i=1,#gameScore do
			sumEnergy = sumEnergy + gameScore[i]
		end

		_G.temporaryData.totalEnergy = sumEnergy
	end

	-- Load user first name and name data, save to global variable
	local user = loadTable("userdata.json", system.DocumentsDirectory)

	if (user) then
		if (user.facebook) then
			_G.temporaryData.userName = user.facebook.name
			_G.temporaryData.userFirstName = user.facebook.firstName 
		end
	end

	lives.instance:updateLives( )

	print( "startupSetting running" )
end		

function startupSetting:sounds( )
		if gameSettings then
			if gameSettings.soundOn then
				audio.setVolume( 1 )
			else
				audio.setVolume (0)
		end
	end
end

function startupSetting:getTutorialLevelData( )
	local showTutorial = {}
	
	showTutorial.level = {}

	for i=1,#levelData do
		showTutorial.level[i]= false
	end

	local data = {1, 10,15,20,25,30}

	for i=1,#data do
		showTutorial.level[data[i]]= true
	end

	showTutorial.prelevel = true
	showTutorial.activatorPage = true
	showTutorial.levelMenu = true
	showTutorial.gameTutorial = true

	return showTutorial
end

