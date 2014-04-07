local ext

local platformName = system.getInfo("platformName")

if platformName == "iPhone OS" then
	ext = ".m4a"
elseif platformName == "Android" then
	ext = ".ogg"
else 
	ext = ".ogg"
end

audio.reserveChannels( 2 )



local implosionSound = audio.loadSound( "assets/sounds/Implosion_01"..ext)
local startupSound = audio.loadSound( "assets/sounds/StartScore_01"..ext)
-- local collisionSound = audio.loadSound( "assets/sounds/CollisionBall01.wav")
local collisionSound = audio.loadSound( "assets/sounds/collision.wav")
local addForceSound = audio.loadSound( "assets/sounds/Shot_01"..ext)

local Explosion_01 = audio.loadSound( "assets/sounds/Explosion_01"..ext)
local Explosion_02 = audio.loadSound( "assets/sounds/Explosion_02"..ext)
local Implosion_01 = audio.loadSound("assets/sounds/Implosion_01"..ext)
local Reaction_01 = audio.loadSound( "assets/sounds/Reaction_01"..ext )
local Reaction_02 = audio.loadSound( "assets/sounds/Reaction_02"..ext)
local NegativeReaction_01 = audio.loadSound( "assets/sounds/NegativeReaction_01"..ext )
local Blackplosion = audio.loadSound( "assets/sounds/Blackplosion"..ext )

local nukeplosion = audio.loadSound( "assets/sounds/Nukeplosion"..ext )


function _sounds( name )
	if (name == "collision") then
		local _collisionSound = audio.play( collisionSound )
	elseif name == "addForce" then
		local _addForceSound = audio.play( addForceSound)
	elseif name == "implosion" then
		local _implosionSound = audio.play( implosionSound)
	elseif name == "explosion" then
		local _Explosion_02 = audio.play( Explosion_02)
	elseif name == "blackBlast" then
		local _Blackplosion = audio.play( Blackplosion )
	elseif name == "portal" then
		local _Reaction_01 = audio.play( Reaction_01 )
	elseif name == "blackBox" then
		local _NegativeReaction_01 = audio.play( NegativeReaction_01 )
	elseif name == "bigBallBurst" then
		local _Explosion_01 = audio.play( Explosion_01 )
	elseif name == "threeBallReaction" then
		local _Reaction_02 = audio.play( Reaction_02 ) 
	elseif name == "nukeplosion" then
		local _nukeplosion = audio.play( nukeplosion ) 
	end
end