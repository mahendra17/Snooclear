require "components.SocialButton"
require "components.ActivatorButton"
require "components.LivesButton"
require "components.SettingsButton"
require "components.Popup"

local toggle = require "components.toggle"



function text_param(object )
    object.anchorX, object.anchorY = 0,.5
    object:setFillColor(63/255, 63/255, 63/255 )
end

SettingsView = {}

function SettingsView:new(parentGroup)
	local view = display.newGroup( )
	view.classType = "SettingsView"
	view.FONT_NAME = "Blanch-CapsInline"

	if parentGroup then
		parentGroup:insert( view )
	end

	function view:init()

		local font = temporaryData.font

		-- 4 corners buttons
		local SocialButton = SocialButton:new(self, "grey", false, "corner")
		self.SocialButton = SocialButton

		local LivesButton =  LivesButton:new(self, "grey", false)
		self.LivesButton = LivesButton

		local ActivatorButton = ActivatorButton:new(self, "grey", false)
		self.ActivatorButton =ActivatorButton

		local SettingButton = SettingButton:new(self, "closeBtn", true) 
		self.SettingButton =SettingButton
		SettingButton:addEventListener( "onSettingCloseButtonTouched", self )

		--TEXT-----------------------------------------------------------------------------------------
		local text  = display.newGroup( )
		local title = display.newText("settings",display.contentWidth*.5 ,266, font.BlanchCapsInline, 140)
		title.anchorX, title.anchorY = 0.5,0.5
		title:setFillColor( 76/255, 76/255, 76/255 )
		-- title.width, title.height = 251.15, 105.1
		self:insert( title )

		local center  = ((1136 - ((1136 - title.y)*.5) - 100)/1136)* display.contentHeight

		local location = {
		howto = {icon = {x = title.x + title.width*.5, y = center}, text = {x = title.x - title.width*.5,  y = center}}, -- 2nd
		sound = {icon = {x = title.x + title.width*.5, y = center - 100 }, text = {x = title.x- title.width*.5 ,  y = center - 100 }}, -- 1st
		email = {icon = {x = title.x + title.width*.5, y = center + 100}, text = {x = title.x- title.width*.5 ,  y = center + 100}}, -- 3rd
		}

		title.y = title.y +10

		local sound_txt = display.newText(self, "sound", location.sound.text.x, location.sound.text.y, font.BlanchCaps, 60 )
		text_param (sound_txt)
		
		local  question_txt = display.newText(self, "how to play", location.howto.text.x , location.howto.text.y, font.BlanchCaps,60 )
		text_param(question_txt)

		local email_txt = display.newText(self, "email us", location.email.text.x, location.email.text.y, font.BlanchCaps, 60)
		text_param(email_txt)

		--------------------------------------------------------------------------------------
		local setButton = display.newGroup()
		self:insert( setButton)
	
		---SETTINGS BUTTON-----------------------------------------------------------------------------
		sound = toggle.new ({on = "assets/images/SetSoundBtn.png", off = "assets/images/SetSoundGreyedBtn.png", callback = function()
				view:dispatchEvent( {name = "changeSettings", type = "sound"} )
				end})

		sound.setState (_G.gameSettings.soundOn)
		sound.anchorX, sound.anchorY = 1,0
		sound.x, sound.y = location.sound.icon.x, location.sound.icon.y
		sound.width, sound.height = 80,80
		self:insert( sound )

		question = display.newImageRect(setButton, "assets/images/SetQstnBtn.png", 80,80 )
		question.anchorX, question.anchorY = 1,.5
		question.x, question.y = location.howto.icon.x, location.howto.icon.y
		question:addEventListener( "touch", self )
 
		email = display.newImageRect( setButton, "assets/images/SetPokeBtn.png",80,80 )
		email.anchorX, email.anchorY = 1,.5
		email.x, email.y = location.email.icon.x, location.email.icon.y
		email:addEventListener( "touch", self )

 		---------------------------------------------------------------------

 		Runtime:addEventListener( "onClosePopup", self )

		Runtime:dispatchEvent( {name="onRobotlegsViewCreated", target=self} )
	end

	function view:onSettingCloseButtonTouched(event)
		print( "closeBtn touched" )
		self:dispatchEvent( {name="toLevelMenu"} )
	end

	function view:touch(event)
		if (event.phase == "ended") then
			-- audio.play( buttonSound )
			Runtime:dispatchEvent( {name = "buttonSound"} )
			local Popup = Popup:new()
			self:insert( Popup )
			self.Popup = Popup

			if (event.target == question) then
				-- self:dispatchEvent( {name = "loadPopupHowToPlay"} )
				Popup:loadPopupHowToPlay()
			-- elseif (event.target == restore) then
			-- 	self:dispatchEvent( {name = "loadPopupRestorePurchases"} )
			elseif (event.target == email) then
				-- self:dispatchEvent( {name = "loadPopupEmail"} )
				Popup:loadPopupEmail()
			end
		end
	end

	function view:onClosePopup()
		self.Popup:destroy()
		self.Popup = nil
	end

	function view:destroy()
		Runtime:removeEventListener( "onClosePopup", self )
		print( "leaving Game Level View" )
		Runtime:dispatchEvent( {name="onRobotlegsViewDestroyed", target=self} )
		self:removeSelf( )
	end

	view:init()

	return view

end

return SettingsView