local ext = ".m4a"

local platformName = system.getInfo("platformName")

if platformName == "iPhone OS" then
	ext = ".m4a"
elseif platformName == "Android" then
	ext = ".ogg"
else 
	ext = ".ogg"
end


local button = audio.loadSound( "assets/sounds/Button_01".. ext  )
local xButton = audio.loadSound( "assets/sounds/Button_02".. ext  )

local startGameplayScore = audio.loadSound( "assets/sounds/StartScore_01".. ext  )
local winScore  = audio.loadSound( "assets/sounds/WinScore(Mixed)".. ext )
-- local nukeplosion = audio.loadSound( "assets/sounds/Nukeplosion".. ext )
local loosePage = audio.loadSound( "assets/sounds/LosePage_01".. ext )

local inGameLoop = audio.loadSound( "assets/sounds/Score/InGameLoop".. ext )
local InGameOpening = audio.loadSound( "assets/sounds/Score/InGameOpening".. ext )
local LevelMenu_01 = audio.loadSound( "assets/sounds/Score/LevelMenu_01".. ext )
local StartMenuSoundtrack = audio.loadSound( "assets/sounds/Score/StartMenuSoundtrack".. ext )
local WinPage_01 = audio.loadSound( "assets/sounds/Score/WinPage_01".. ext )


local function clearChannel( num )
	local isChannelActive = audio.isChannelActive( num )
	if isChannelActive then
	    audio.stop( num )
	end
end


function playAmbianceSounds (name )

	clearChannel(1)
	local options = {channel=1, loops=-1}

	if name == "gameMenu" then
		local _StartMenuSoundtrack = audio.play( StartMenuSoundtrack, options )
		-- print( "playing gamemenu" )
	elseif name == "levelMenu" then
		local _LevelMenu_01 = audio.play( LevelMenu_01, options)
		-- print( "playing level menu" )
	elseif name == "preLevel" then
		-- print( "playing prelevel" )
		local _StartMenuSoundtrack = audio.play( StartMenuSoundtrack, options )
	elseif name == "gamePlay" then
		local function onComplete( )
			local options1 = {channel = 1, loops = -1}
			local _inGameLoop = audio.play(inGameLoop, options1)
		end
		local options = {channel=1, loops=0, onComplete = onComplete}
		local _InGameOpening = audio.play( InGameOpening, options )
	elseif name == "gameOver" then
		local _loosePage = audio.play( loosePage, options)
	elseif name == "moveView" then

	elseif name == "finishGame" then
		local function onComplete( )
			local options1 = {channel = 1, loops = -1}
			local _WinPage_01 = audio.play(WinPage_01, options1)
		end
		local options = {channel=1, loops=0, onComplete = onComplete}	
		local _winScore = audio.play(winScore, options)
	end

end

function playSounds( name )
	clearChannel(2)
	local options = {channel=2, loops=0}
	
	if name == "levelMenu" then
		--
	elseif name == "preLevel" then
		--
	elseif name == "startGamePlay" then
		local _startGameplayScore = audio.play(startGameplayScore, options)
	elseif name == "moveView" then
		--
	elseif name == "levelCleared" then
		-- local function playsound( )
		-- 	-- local _nukeplosion = audio.play( nukeplosion, options)
		-- end
		-- timer.performWithDelay( 2000, playsound )
	elseif name == "finishGame" then
		local _winScore = audio.play(winScore, options)
	elseif name == "button" then
		local _button = audio.play( button)
	elseif name == "xButton" then
		local _XButton = audio.play( xButton )
	end

end