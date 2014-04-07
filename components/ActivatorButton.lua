ActivatorButton = {}

function ActivatorButton:new(parentGroup, state, listener)
	
	layoutWidth, layoutHeight= 80,80

	local button = display.newGroup()
	button.layoutWidth = layoutWidth
	button.layoutHeight = layoutHeight

	if parentGroup then
		parentGroup:insert(button)
	end

	function button:init()

		--button color
		if (state == "color") then
			 ActvtrLvlBtn = display.newImageRect( "assets/images/ActvtrLvlBtn.png", 80, 80)
		end
		if state == "grey" then
			ActvtrLvlBtn = display.newImageRect( "assets/images/ActvtrLvlAntibtn.png", 80, 80)
		end
		if state == "closeBtn" then
			ActvtrLvlBtn = display.newImageRect( "assets/images/ActvtrLvlXBtn.png", 80, 80)
		end
			
		-- button location
		ActvtrLvlBtn.anchorX, ActvtrLvlBtn.anchorY = 1,0
		ActvtrLvlBtn.x, ActvtrLvlBtn.y =  display.contentWidth- 40.7,36.6
				
		self:insert(ActvtrLvlBtn)
		self.ActvtrLvlBtn = ActvtrLvlBtn

		--listener
		if (listener) then
		self:addEventListener( "touch", self )
		end

	end

	function button:touch(event)
		if (event.phase == "ended") then
			
			if state == "color" then
			-- print( "ActivatorButton touched" )
			Runtime:dispatchEvent( {name = "buttonSound"} )
			self:dispatchEvent( {name = "onActivatorButtonTouched", target = self} )
			end

			if (state == "closeBtn") then
			-- print( "onActivatorCloseButtonTouched" )
			-- audio.play( xbuttonSound )
			Runtime:dispatchEvent( {name = "buttonSound", type = "close"} )
			self:dispatchEvent( {name = "onActivatorCloseButtonTouched", target = self} )
			end

			return true
		end
	
	end

	button:init()

	return button
end