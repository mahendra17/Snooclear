SettingButton = {}

function SettingButton:new(parentGroup, state, listener)
	
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
			SettingsBtn = display.newImageRect( "assets/images/GearLvlBtn.png",80, 80)
		end
		if state == "grey" then
			SettingsBtn = display.newImageRect( "assets/images/GearLvlAntibtn.png",80, 80)
		end
		if state == "closeBtn" then
			SettingsBtn = display.newImageRect( "assets/images/GearLvlXBtn.png",80, 80)
		end
			
		-- button location
		SettingsBtn.anchorX,SettingsBtn.anchorY = 0,1
		SettingsBtn.x, SettingsBtn.y = 40.7, display.contentHeight - 36.6
				
		self:insert(SettingsBtn)
		self.SettingsBtn = SettingsBtn

		--listener
		if (listener) then
		self:addEventListener( "touch", self )
		end

	end

	function button:touch(event)
		if (event.phase == "ended") then
			
			if (state == "color") then	
			-- print( "SettingButton touched" )
			-- audio.play( buttonSound )
			Runtime:dispatchEvent( {name = "buttonSound"} )
			self:dispatchEvent( {name = "onSettingButtonTouched", target = self} )
			return true
			end

			if (state== "closeBtn") then
			-- print( "closeBtn touched" )
			-- audio.play( xbuttonSound )
			Runtime:dispatchEvent( {name = "buttonSound", type = "close"} )
			self:dispatchEvent( {name = "onSettingCloseButtonTouched", target = self} )
			end
			
		end
	end

	button:init()

	return button
end