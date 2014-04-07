SocialButton = {}

function SocialButton:new(parentGroup, state, listener, position)
	
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
			socBtn = display.newImageRect( "assets/images/SclLvlBtn.png", 80 , 80)
		elseif state == "grey" then
			socBtn = display.newImageRect( "assets/images/SclLvlAntiBtn.png", 80 , 80)
		elseif state == "closeBtn" then
			socBtn = display.newImageRect( "assets/images/SclLvlXBtn.png", 80 , 80)
		end
			
		-- button location

		if position =="center" then
			socBtn.anchorX, socBtn.anchorY = 0.5,.5
			socBtn.x, socBtn.y =  display.contentWidth*.5 , display.contentHeight -152
		elseif position == "corner" then
			socBtn.anchorX, socBtn.anchorY = 1,1
			socBtn.x, socBtn.y = display.contentWidth-40.7 , display.contentHeight-36.6
		end
		
		self:insert(socBtn)
		self.socBtn = socBtn

		--listener
		if (listener) then
			self:addEventListener( "touch", self )
		end

	end



	function button:touch(event)
		if (event.phase == "ended") then
			if (state == "color") then
				-- print( "Color Social Button touched" )
				audio.play( buttonSound )
				-- print( self )
				self:dispatchEvent( {name = "onSocialButtonTouched", target = self} )
				self.socBtn:removeSelf( )
			elseif (state == "closeBtn") then
				-- print( "Close Social Button touched" )
				local options = {channel=2, loops=0}
				audio.play( xbuttonSound, options )
				self:dispatchEvent( {name = "onSocialCloseButtonTouched", target = self} )
				self.socBtn:removeSelf( )
			end
		end
		
	end

	button:init()

	return button
end

return SocialButton