local facebook = require( "facebook")
local json = require ("json")

require "services.ReadFileContentsService"

local fbAppID = "258512944311281"
local imageLink = "http://s3.postimg.org/6j3z3delv/Facebook_Photo.png"

local platformName = system.getInfo( "platformName" )
local getDevice

if (platformName == "iPhone OS") then
	getDevice = "iOS"
elseif (platformName == "Android") then
	getDevice = "Android"
else
	getDevice = "Unknown"
end
SocialServices = {}

function SocialServices:new(data)
	local service = {}

	local user = {}
	if (data) then
		user = data
	else
		print( "Unknown user!!" )
	end

	local facebookStatus
	
	function service:facebookLogin(command, level, score)

		print( "facebookLogin " .. command )

		if (command ==  0) or (command == 10) or (command == 15) then -- login or share
			native.setActivityIndicator( true )
			facebookStatus = false
		end

		-- debugging function
		local function printTable(t, label, level)
			if label then print( label ) end
			level = level or 1

			if t then
				for k,v in pairs( t ) do
					local prefix = ""
					for i=1,level do
						prefix = prefix .. "\t"
					end

					print( prefix .. "[" .. tostring(k) .. "] = " .. tostring(v) )
					if type( v ) == "table" then
						print( prefix .. "{" )
						printTable( v, nil, level + 1 )
						print( prefix .. "}" )
					end
				end
			end
		end

		-- facebook listener
		local function facebookListener(event)
			-- Debug event parameters printout
			print( "Facebook listener events:" )

			local maxStr = 20
			local endStr

			for k,v in pairs(event) do
				local valueString = tostring(v)
				if (string.len(valueString) > maxStr) then
					endStr = "... #" .. tostring(string.len(valueString)) .. ")"
				else
					endStr = ")"
				end
				print( "   " .. tostring(k) .. "(" .. tostring(string.sub(valueString, 1, maxStr)) .. endStr )
			end
			-- end of debug event routine
			print( "event.name:", event.name )
			print( "event.type:", event.type)
			print( "isError:" .. tostring(event.isError) )
			print( "didComplete:" .. tostring(event.didComplete) )

			-- login phase (even if the app is already logged in, we will still get a "login" phase)
			if ("session" == event.type) then
				print( "Session status: " .. event.phase )

				if (event.phase ~= "login") then -- exit if login error
					return
				end

				-- Various facebook commands
				if (command == 1) then -- request user information
					print( "*** Requesting user information..." )
					facebook.request( "me" )

				elseif (command == 5) then -- posting photo
					print( "*** Posting Facebook photo..." )
					local attachment = {
						name = "I play Snooclear on my " .. getDevice ..  " device!",
						link = "http://v3.senja.co.uk/",
						caption = "Play arcade ball game with a new fun way.",
						description = "Snooclear is available on iOS and Android. Play with your Facebook friends for maximum fun!",
						picture = imageLink,
						actions = json.encode( { { name = "About Developer", link = "http://v3.senja.co.uk/" } } )
					}

					facebook.request( "me/feed", "POST", attachment ) -- posting photo

				elseif (command == 10) then -- share score
					print("*** Share score...")
					local attachment = {
						name = "I have " .. tostring( score ) .. " energy left on Snooclear level " .. tostring( level ) .. "!",
						link = "http://v3.senja.co.uk/",
						caption = "Play arcade ball game with a new fun way.",
						description = "Snooclear is available on iOS and Android. Play with your Facebook friends for maximum fun!",
						picture = imageLink,
						actions = json.encode( { { name = "About Developer", link = "http://v3.senja.co.uk/" } } )
					}

					facebook.request( "me/feed", "POST", attachment ) -- posting photo
				elseif (command == 15) then -- share to add live
					print("*** Need more live...")
					local attachment = {
						name = "I need more live to finish level " .. tostring( level ) .. " on Snooclear. Please help me!"  ,
						link = "http://v3.senja.co.uk/",
						caption = "Play arcade ball game with a new fun way!",
						description = "Snooclear is available on iOS and Android. Play with your Facebook friends for maximum fun!",
						picture = imageLink,
						actions = json.encode( { { name = "About Developer", link = "http://v3.senja.co.uk/" } } )
					}

					facebook.request( "me/feed", "POST", attachment ) -- posting photo

				elseif (command == 20) then -- upload total energy to Facebook (highscore)
					local attachment = {
						score = tostring( level ) -- in this command, level IS the score
					}

					facebook.request("me/scores", "POST", attachment)

				elseif (command == 25) then -- retrieving "me/scores"
					facebook.request( fbAppID .. "/scores" )
				end

			elseif ("request" == event.type) then
				local response = event.response

				if (not event.isError) then
					response = json.decode( event.response )

					if (command == 1) then -- getting Facebook name
						print( "getting facebook name" )
						user.facebook = {}
						user.facebook.name = response.name
						user.facebook.firstName = response.first_name

						local saveUserData = saveTable("userdata.json", system.DocumentsDirectory, user)
						print( "User facebook data successfully saved!" )

						-- retrieving user's facebook profile picture
						local function downloadProgress(event)
							if (event.phase == "ended") then
								local gambar = display.newImageRect( "profilePicture.png", system.TemporaryDirectory, 140, 140 )
								gambar.anchorX, gambar.anchorY = .5,.5
								gambar.x, gambar.y = 227, display.contentHeight-567.5
								display.save( gambar, "profilePicture.png", system.DocumentsDirectory )
								print( "Profile picture successfully retrieved!" )
								gambar:removeSelf( )
								gambar = nil
								facebookStatus = true
							end
						end
						network.download( "http://graph.facebook.com/" .. response.username .. "/picture?type=square" , "GET", downloadProgress, "profilePicture.png", system.TemporaryDirectory, 0, 0 )
						native.setActivityIndicator( false )
						
						timer.performWithDelay( 5000, function()
							if facebookStatus then
								native.showAlert( "Facebook", "Snooclear is now connected to your Facebook accout!", {"Ok"})
							else
								native.showAlert( "Facebook", "Failed to connect Snooclear to your Facebook. Please try again later.", {"Ok"})
							end
						end)

					elseif (command == 5) or (command == 10) then -- posting photo
						printTable(response, "photo", 3)
						print( "*** Uploading post to Facebook..." )

						if (command == 10) then
							native.setActivityIndicator( false )
							native.showAlert( "Snooclear", "Your score has been successfully posted on your Facebook page!", {"OK"} )
						end
						elseif (command == 15) then
							printTable(response, "photo", 3)
							native.setActivityIndicator( false )
							Runtime:dispatchEvent({name = "getLives"})
							native.showAlert( "Snooclear", "Message successfully posted to Facebook!", {"OK"} )
							-- share to get lives is limited to 5 times a day
							_G.gameSettings.shareSettings.count = _G.gameSettings.shareSettings.count + 1
							if (_G.gameSettings.shareSettings.count == 5) then
								_G.gameSettings.shareSettings.reachMax = true
							end
							saveTable("gameSettings.json", system.DocumentsDirectory, _G.gameSettings )
					elseif (command == 25) then
						local savedUser = loadTable("userdata.json", system.DocumentsDirectory)

						print( "size of response.data " .. tostring( #response.data ) )
						local data = response.data
						local maxDisplay = math.min( #data, 5)
						local gambar = {}

						for i=1, #data do
							-- Check user's rank among friends -- 
							if (data[i].user.name == savedUser.facebook.name) then
								_G.temporaryData.userRank = i
							end

							-- Download facebook leaderboards profile picture (max 5)
							if (i < maxDisplay + 1) then
								local photoName = data[i].user.name .. ".png"
								local function downloadProgress(event)
									if (event.phase == "ended") then
										gambar[i] = display.newImageRect( photoName, system.TemporaryDirectory, 80,  80 )
										gambar[i].alpha = .01
										gambar[i].anchorX, gambar.anchorY = .5,.5
										gambar[i].x, gambar[i].y = display.contentWidth- 40.7,36.6
										display.save( gambar[i], photoName, system.DocumentsDirectory )
										print( data[i].user.name .. "'s profile picture successfully retrieved!" )
										gambar[i]:removeSelf( )
										gambar[i] = nil

										if (i == maxDisplay) then
											print( "showing Scoreboard" )
											Runtime:dispatchEvent( {name = "highScoreBoard", scores = data } )
											if (gambar) then
												gambar:removeSelf( )
												gambar = nil
											end
										end
									end
								end
								network.download( "http://graph.facebook.com/" .. data[i].user.id .. "/picture?type=square" , "GET", downloadProgress, photoName, system.TemporaryDirectory, 0, 0 )
							end
						end
					else
						print( "Unknown Facebook command response" )
					end
				else -- failed post
					printTable(event.response, "Post failed response", 3)
				end

			elseif ("dialog" == event.type) then
				print( "dialog response:", event.response )
			end
		end

		if (command ==0) then
			facebook.login( fbAppID, facebookListener, {"publish_actions, user_games_activity, friends_games_activity"})
		else
			facebook.login(fbAppID, facebookListener)			
		end
	end

	function service:twitterLogin()
		user.twitter = {}

		print( "pura2 login di twitter" )

		-- user.twitter.name = "Marissachan Haque"
		-- user.twitter.firstName = "Icha"

		-- saving user data to json
		local saveUserData = saveTable("userdata.json", system.DocumentsDirectory, user)
	end

	function service:share( type, options )
		-- print ("service :: " .. type)
		if (type == "social") then
			local check = native.canShowPopup( "social", options )

			if check then
				local function listener( event )
					if (event) then
					    print( "services :: name(" .. event.name .. ") type(" .. event.type .. ") action(" .. tostring(event.action) .. ") limitReached(" .. tostring(event.limitReached) .. ")" )
						if (event.action == "sent") then
							print("service share :: addLives")
							Runtime:dispatchEvent( {name = "getLives"} )
						end	
					end
				end
				local _options = {
				    service = options,
				    message = "hi there try Snooclear!",
				    listener = listener,
				    -- image = {{ filename = "world.jpg", baseDir = system.ResourceDirectory },},
				    -- url ={"http://docs.coronalabs.com"}
				}
				native.showPopup(type, _options)
			else
				-- alert
				print("Service :: Can't Show native popup")
				native.showAlert(
				       "Cannot send " .. options .. " message.",
				       "Please setup your " .. options .. " account or check your network connection",
				       { "OK" })
			end
		elseif type == "message" then
			--send sms
			Runtime:dispatchEvent({name = "getLives"})
			print( "snd message" )
			local _options = {body = "I need more lives for playing Snooclear. Help me"}
			native.canShowPopup( "sms", _options )
		elseif type == "mail" then
			local _options = {to = {"snooclear@senja.co.uk"}}
			native.canShowPopup( type, _options )
		end
	end

	return service
end	

return SocialServices
