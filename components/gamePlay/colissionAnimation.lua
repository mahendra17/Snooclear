PS = require("classes.ParticleSugar").instance()
-- PS =  require("components.gamePlay.particleSugar.classes.ParticleSugar").instance()

Runtime:addEventListener( "enterFrame", PS )

parEmitter = {}

function parEmitter:new(parentGroup)
	
	particles = display.newGroup( )

	if parentGroup then
		parentGroup:insert(particles)
	end

	function particles:init( )
		dustEm = PS:newEmitter{
			name="em1",
			x= display.contentCenterX,y=display.contentCenterY,
			rotation=0,
			visible=true,
			loop=false, 
			autoDestroy=true
		}
	    dustEm:setParentGroup(particles)


		PS:newParticleType{
			name="starPt",prop={
				scaleStart = 1,
				scaleVariation = 0,
				velocityStart = 350,
				velocityVariation = 170,
				rotationStart = 0,
				rotationVariation = 0,
				directionVariation = 360,
				killOutsideScreen = false,
				lifeTime = 350,
				alphaStart = .7,
				fadeOutSpeed = -2,
				fadeOutDelay = 100,
				imagePath={
					"assets/images/BallYellGmlvlObj.png",
				},
				imageWidth=15,
				imageHeight=15,
			}
		}

		PS:attachParticleType("em1", "starPt", 500, 300, 0)
	end

	function particles:startEmit( x,y )
		-- print( "start emitter" )
		dustEm.x = x
		dustEm.y = y
		PS:startEmitter('em1')	
	end

particles:init( )
end




