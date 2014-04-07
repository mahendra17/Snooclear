require "components.SocialButton"
require "components.ActivatorButton"
require "components.LivesButton"
require "components.SettingsButton"
require "components.Popup"

-- require "services.LivesService"

LifePageView = {}

function LifePageView:new(parentGroup)
	local view = display.newGroup( )
	view.classType = "LifePageView"


	if parentGroup then
		parentGroup:insert( view )
	end

	function set_text(object)
		object.anchorX, object.anchorY =.5,.5
		object:setFillColor( 76/255, 76/255, 76/255)
	end

	function view:init()

		local font =  _G.temporaryData.font

		local SocialButton = SocialButton:new(self, "grey", false, "corner")
		self.SocialButton = SocialButton
		
		local LivesButton =  LivesButton:new(self, "closeBtn", true)
		self.LivesButton = LivesButton
		LivesButton:addEventListener( "onLivesCloseButtonTouched", self )

		local ActivatorButton = ActivatorButton:new(self, "grey", false)
		self.ActivatorButton =ActivatorButton

		local SettingButton = SettingButton:new(self, "grey", false) 
		self.SettingButton =SettingButton

		-- local icon = display.newImage(self, "assets/images/LvMnLivesBtn.png" ,display.contentWidth*.5,display.contentHeight-501.5 )
		-- icon.width, icon.height = 200,200
		-- icon.anchorX, icon.anchorY = .5, .5


		-- Text for less than 5 lives
		local lessLivesText = display.newGroup( )
		self:insert( lessLivesText )

		local next_life = display.newText(lessLivesText, "next life", display.contentWidth*.5, 280.5-65, font.BlanchCapsInline, 140)
		set_text(next_life)

		local more_lives = display.newImageRect (lessLivesText, "assets/images/PrldMrlvsBtn.png", 808*.5+40, 131*.5, true)
		more_lives.anchorX, more_lives.anchorY, more_lives.x, more_lives.y = .5,.5, display.contentCenterX, display.contentHeight-263.5

		more_lives:addEventListener( "touch", self )		

		local timeToNextLife = display.newText(lessLivesText, "", display.contentWidth*.5, 400-65, "Calibri", 80 )
		timeToNextLife.anchorX, timeToNextLife.anchorY =.5,.5
		timeToNextLife:setFillColor( 255/255, 185/255, 0/255)

		--Text for maximum lives
		local maxLivesText = display.newGroup( )
		self:insert(maxLivesText)

		local maxLivesText1 = display.newText(maxLivesText, "You have", display.contentWidth*.5, 290-60, font.BlanchCaps, 60)
		set_text(maxLivesText1)

		local maxLivesText2 = display.newText(maxLivesText, "Maximum", display.contentWidth*.5, 340-60, font.BlanchCapsInline, 140)
		set_text(maxLivesText2)

		local maxLivesText3 = display.newText(maxLivesText, "number of lives", display.contentWidth*.5, 420-60, font.BlanchCapsLight, 60)
		set_text(maxLivesText3)

		-- Text for lives
		local livesLeft = display.newText( self, "You've got", display.contentWidth*.5,display.contentHeight-600-65, font.BlanchCaps, 80)
		set_text(livesLeft)


		local livesLeftBtm = display.newText( self, "Lives left", display.contentWidth*.5,display.contentHeight-320-75, font.BlanchCaps, 80)
		set_text(livesLeftBtm)

		local livesText = display.newText(self, "", display.contentWidth*.5, display.contentHeight-400-70 , font.calibri, 260 )
		livesText.anchorX, livesText.anchorY =.5,.5
		livesText:setFillColor( 228/255, 70/255, 25/255)

		if (_G.temporaryData.device == "iPhone OS" ) then
			livesText.y = display.contentHeight - 510
		end

		if temporaryData.device == "Android" or temporaryData.device == "Win" then
			livesText.y = 0.5*(livesLeft.y + livesLeftBtm.y)
		end

		local livesStat = gameSettings.lives
		print( "livesStat.timeToNewLive " .. livesStat.timeToNewLive )
		
		local timeleft_second = livesStat.timeToNewLive

		local function updateTime()
			if (livesStat.lives < 5) then

				-- local countdownMax = 1800

				lessLivesText.isVisible = true
				maxLivesText.isVisible = false

				-- local timePass = os.time()
				-- local diff = timePass - livesStat.referenceTime

				local timeToNextLifeMinutes = math.floor( timeleft_second / 60 )
				if (timeToNextLifeMinutes < 10) then timeToNextLifeMinutes = "0" .. timeToNextLifeMinutes end

				local timeToNextLifeSeconds = (timeleft_second)%60
				if (timeToNextLifeSeconds < 10) then timeToNextLifeSeconds = "0" .. timeToNextLifeSeconds end

				-- if (countdownMax == diff) then
				-- 	livesStat.referenceTime = os.time()
				-- end

				timeToNextLife.text = timeToNextLifeMinutes .. ":" .. timeToNextLifeSeconds

				timeleft_second = timeleft_second -1

				if timeleft_second <= 0 then
					timeleft_second = 30*60
				end
			else
				lessLivesText.isVisible = false
				maxLivesText.isVisible = true
			end

			livesText.text = livesStat.lives

			gameSettings.lives = livesStat
		end

		updateTime()

		local clockTimer = timer.performWithDelay( 1000, updateTime, -1 )

	Runtime:dispatchEvent( {name="onRobotlegsViewCreated", target=self} )
	end


	function view:touch(event )
		if event.phase == "ended" then
			view:socialPopup ()
		end
	end

	function view:socialPopup( )

		local function listener( event )
			-- print(event.service, event.type)
			self:dispatchEvent( {name = "social", service = event.service, type = event.type, target = self} )
		end

		local Popup = Popup:new()
		self:insert( Popup )
		self.Popup = Popup

		Popup:socialShare()

		Popup:addEventListener( "social", listener )
	end

	function view:dispatch( event )
		self:dispatchEvent( {name = "Social", } )
	end

	function view:onLivesCloseButtonTouched( event )
		-- print( "closeBtn touched" )

		self:dispatchEvent( {name= "toLevelMenu"} )
	end

	function view:destroy()
		--SAVE DATA
		-- view:saveData ()
		Runtime:dispatchEvent( {name="onRobotlegsViewDestroyed", target=self} )
		self:removeSelf( )
		
	end

	view:init()

	return view

end

return LifePageView