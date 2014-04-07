networkCheck = {}

function networkCheck:new()
	local connection ={}

		-- checking internet connection
		local http = require("socket.http")
		local ltn12 = require("ltn12")

		if http.request( "http://www.google.com") == nil  then
		        native.showAlert( "Your device is not connected to the internet", "Please check again your internet connection.", { "Exit" }, print( "Internet connection is not available" ) )
			return false
		end

		print( "Internet connection success!" )

	return connection

end

return networkCheck

	