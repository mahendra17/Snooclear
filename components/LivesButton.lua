LivesButton = {}

function LivesButton:new(parentGroup, state, listener)
	
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
			LivesBtn = display.newImageRect( "assets/images/LvMnLivesBtn.png", 80, 80)
		end
		if state == "grey" then
			LivesBtn = display.newImageRect( "assets/images/LvMnLivesAntiBtn.png", 80, 80)
		end
		if state == "closeBtn" then
			LivesBtn = display.newImageRect( "assets/images/LvMnLivesXBtn.png", 80, 80)
		end
			
		-- button location
		LivesBtn.anchorX, LivesBtn.anchorY = 0,0
		LivesBtn.x, LivesBtn.y = 40.7, 36.6
				
		self:insert(LivesBtn)
		self.LivesBtn = LivesBtn

		--listener
		if (listener) then
		self:addEventListener( "touch", self )
		end

	end

	function button:touch(event)
		if (event.phase == "ended") then
			
			if (state == "color") then
				Runtime:dispatchEvent( {name = "buttonSound"} )
				-- audio.play( buttonSound )
				self:dispatchEvent( {name = "onLivesButtonTouched", target = self} )
			end

			if (state == "closeBtn") then
				Runtime:dispatchEvent( {name = "buttonSound", type = "close"} )
				-- audio.play( xbuttonSound )
				self:dispatchEvent( {name = "onLivesCloseButtonTouched", target = self} )
			end

		end
	end

	button:init()

	return button
end