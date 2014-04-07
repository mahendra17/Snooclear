require "services.SocialServices"
require "services.networkCheck"
require "services.ReadFileContentsService"

SocialCommand = {}

function SocialCommand:new()
	local command = {}
	local user = loadTable ("userdata.json", system.DocumentsDirectory)
	local service = SocialServices:new(user)
	

	function command:execute(event)
		if (event.service == "facebook") or (event.service == "Facebook") then
			if (event.type == "connect") then
				command:connect ( event)
			elseif event.type == "shareScore" then
				command:shareScore(event)
			elseif event.type == "shareGetLives" then
				if (not _G.gameSettings.shareSettings.reachMax) then
					command:shareGetLives(event)
				else
					native.showAlert( "Snooclear", "Sorry, you can't use this feature again today. Please wait 30 minutes for a free live.", {"OK"})
				end
			elseif event.type == "uploadScore" then
				command:uploadScore(event)
			elseif event.type == "requestScore" then
				command:requestScore()
			end
		elseif (event.service == "Twitter") or event.service == "twitter" then
			if native.canShowPopup( "social", "twitter" ) then
				if (not _G.gameSettings.shareSettings.reachMax) then
					command:twitToGetLives()
				else
					native.showAlert( "Snooclear", "Sorry, you can't use this feature again today. Please wait 30 minutes for a free live.", {"OK"})
				end
			else
				native.showAlert( "Snooclear", "Twitter integration is currently under development." , { "OK"} )
			end
		elseif (event.service == "message") then
			if (event.type == "shareGetLives") then
				if (not _G.gameSettings.shareSettings.reachMaxMessage) then
					command:smsGetLives(event)
				else
					native.showAlert( "Snooclear", "Sorry, you could only use this feature once a day.", {"OK"} )
				end
			end
		end
		
	end

	function command:twitToGetLives( )
		native.showPopup("social", { service = "twitter",
		        			message = "Please help me! I need more lives to continue collecting energy on Snooclear. http://goo.gl/4Glqo7",
		        			listener = function (event )
		        				if ( event.action == "cancelled" ) then
		        	      			print( "User cancelled" )
		        				else
		        	      			Runtime:dispatchEvent({name = "getLives"})
		        				end
		        			end, } )
	end

	function command:smsGetLives(event)
		-- native.showAlert( "Snooclear", "Corona Enterprise subscription is needed to use this feature.", {"OK"} )
		local options = {
			body = "Please help me! I need more lives to continue collecting energy on Snooclear. http://goo.gl/4Glqo7"
		}
		_G.gameSettings.shareSettings.reachMaxMessage = true
		saveTable("gameSettings.json", system.DocumentsDirectory, _G.gameSettings )
		native.showPopup( "sms", options )
	end

	function command:connect( event )
		local connection = netwolocal connection = networkCheck:new( )

		local function facebookLogin()
			local command = 0
			service:facebookLogin(command)

			timer.performWithDelay( 10000, function()
					native.setActivityIndicator( false )
			end )

			timer.performWithDelay( 1200, function() 
				command = command + 1
				if (command == 1 ) or (command == 5) then
					local facebookLogin = service:facebookLogin(command)
				end
			end, 5) 
		end

		local function alert(something)
			native.showAlert( something, "Snooclear is already connected to your " .. something .. " account!", {"OK"})
		end

		if (connection) then
			if (not user) then
				if (event.service == "Facebook") then
					print( "login to Facebook" )
					facebookLogin()
				elseif (event.service == "Twitter") then
					print( "login to Twitter" )
					-- local twitterLogin = service:twitterLogin()
					native.showAlert( "Snooclear", "Twitter integration is currently under development." , {"OK"})
				end
			else if (event.service == "Facebook" and not user.facebook) then
					print( "twitter has logged on, logging in to facebook" )
					facebookLogin()
				elseif (event.service == "Twitter" and not user.twitter) then
					print( "facebook has logged on, logging in to twitter" )
					local twitterLogin = service:twitterLogin()
				else
					alert(event.service)
				end

			end
		end
	end

	function command:shareScore( event )
		if (user) then
			local connection = networkCheck:new( )

			if (connection) then
				local shareScore = service:facebookLogin( 10, event.level, event.score)
			end
		else
			local function listener( event )
				if (event.action == "clicked") then
					if (event.index == 1) then
						-- Runtime:dispatchEvent( {name = "social", service = "Facebook", type = "connect"} )
						command:connect()
						timer.performWithDelay( 1200, function ( )
							Runtime:dispatchEvent({name = "setProfilePicture"})
						end )
					end
				end
			end
			native.showAlert( "Snooclear", "Facebook integration is required in order to use this feature. Do you want to connect Snooclear to Facebook now?", {"Yes", "Later"}, listener )
		end
	end

	function command:shareGetLives(event)
		if (user) then
			local connection = netwolocal connection = networkCheck:new( )

			if (connection) then
				local shareScore = service:facebookLogin( 15, _G.currentLevel)
			end
		else
			local function listener( event )
				if (event.action == "clicked") then
					if (event.index == 1) then
						-- Runtime:dispatchEvent( {name = "social", service = "Facebook", type = "connect"} )
						command:connect()
					end
				end
			end
			native.showAlert( "Snooclear", "Facebook integration is required in order to use this feature. Do you want to connect Snooclear to Facebook now?", {"Yes", "Later"}, listener )
		end
	end

	function command:uploadScore(event)
		service:facebookLogin(20, event.score)
	end

	function command:requestScore()
		print( "requesting score data from facebook" )
		service:facebookLogin(25)
	end

	return command
end

return SocialCommand