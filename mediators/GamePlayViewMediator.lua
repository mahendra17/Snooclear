-- require "robotlegs.mediator"
require "gamesAudio"

GamePlayViewMediator = {}

function GamePlayViewMediator:new()
	local mediator = {}
	
	function mediator:onRegister()
		print( "SL GamePlayViewMediator onRegister check" )
		local view = self.viewInstance
		view:addEventListener("toLevelMenu", self )
		view:addEventListener("collision", self) --cek
		view:addEventListener ("directionOnTouch", self)
		view:addEventListener ("toLevelMenu", self)
		view:addEventListener("showGameOverPopup", self)
		view:addEventListener( "targetAchieved", self )
		view:addEventListener( "objectSum", self )
		view:addEventListener( "onGamePause", self )
		view:addEventListener ("goToPrelevel", self)

		--in game
	
		view:addEventListener ("onGameActivator", self)
		view:addEventListener( "playFinishAnimation",self )

		Runtime:addEventListener("setActivator", self)
		Runtime:addEventListener("onCollisionReaction", self)
		Runtime:addEventListener("onGameAnimation", self)

		Runtime:addEventListener("moveView", self)
		Runtime:addEventListener( "addForce", self )
	end

	function mediator:setActivator (event)
		mediator.viewInstance:onGameActivator(event )
	end

	function mediator:playFinishAnimation( )
		local param = {};
		param.type, param.posX, param.posY = "nukeplosion", display.contentCenterX, display.contentCenterY
		mediator:onGameAnimation(param)
	end

	function mediator:onCollisionReaction(event)
		mediator.viewInstance:onCollisionReaction(event.object, event.destroyID, event.createID, event.v1, event.v2)
		_sounds("collision")
	end

	function mediator:onGameAnimation(event)
		local param = {	type = event.type, posX= event.posX, posY= event.posY }
		mediator.viewInstance:animation (param)
		_sounds (event.type)
	end

	function mediator:goToPrelevel( )
		Runtime:dispatchEvent( {name= "toPreLevel" } )
	end

	function mediator:onGamePause()
		mediator.viewInstance:showGamePausePopup()
	end

	function mediator:countGameObject( )
		mediator.viewInstance:countObject()
	end

	function mediator:objectSum(event )
		Runtime:dispatchEvent({name = "objectSum", sum = event.sum})
	end

	function mediator:addForce( event )
		mediator.viewInstance:addForce(event.force)
		_sounds("addForce")
	end

	function mediator:collision(event)
		Runtime:dispatchEvent({name ="onCollision", object = event.object})
		
	end

	function mediator:directionOnTouch(event)
		Runtime:dispatchEvent({name= "directionOnTouch", dir = event.dir})
	end

	----on game effect--------------------------------------

	function mediator:onGameActivator(event )
		mediator.viewInstance:showActivatorPopup(event)
		Runtime:dispatchEvent({name="activator", type = event.type, condition = event.condition })
	end

	----------------------------------------------------------

	function mediator:toLevelMenu( )
		Runtime:dispatchEvent ({name = "toLevelMenu"})
	end

	function mediator:showGameOverPopup()
		mediator.viewInstance:showGameOverPopup()
	end

	function mediator:targetAchieved( event )
			local function dispatch( )
				Runtime:dispatchEvent ({name = "toFinishGameView"})				
			end
		timer.performWithDelay( .1, dispatch )
		-- print( "targetAchieved" )
	end

	function mediator:moveView( event )
		--event.typetouch
		mediator.viewInstance:moveView(event)
		mediator.viewInstance:addBlanket()
	end

	function mediator:onRemove()
		print( "SL GamePlayViewMediator onRemove check" )

		Runtime:removeEventListener("onCollisionReaction", self)
		Runtime:removeEventListener("onGameAnimation", self)

		Runtime:removeEventListener("moveView", self)
		Runtime:removeEventListener( "addForce", self ) --listener
		Runtime:removeEventListener ("countGameObject", self)
	end

	return mediator
end

return GamePlayViewMediator