
notificationCommand = {}

local notificationID

function notificationCommand:new( )
	local command = {}
	-- command.GamePlayService = nil

	function command:execute( event )
		print("notificationCommand::execute")

		if event.type == "add"  then
			if gameSettings.notificationOn then command:addNotification( ) end
		elseif event.type  == "cancelled" then
		  command:cancelNotification( )
		end

		return true
	end

	function command:addNotification( )
		local deltaTime = 30*5*60

		local options = {
		    alert = "Snooclear Full Live!",
		}

		notificationID = system.scheduleNotification( deltaTime, options )
	end

	function command:cancelNotification( )
		print( "NOTIFICATION COMMAND :: cancel" )
		if notificationID then
			system.cancelNotification( notificationID )
			print( "NOTIFICATION COMMAND :: cancelled" )
		end
	end

	return command
end

return notificationCommand