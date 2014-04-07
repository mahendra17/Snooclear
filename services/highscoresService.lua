require "services.ReadFileContentsService"

highscoresService = {}

function highscoresService:new()
	local service ={}

	-- read saved 
	local userData = loadTable ("userscores.json", system.DocumentsDirectory)
	local user = loadTable ("userdata.json", system.DocumentsDirectory)

	function service:storeData(alevel, score)
		local tempData = {}
		-- tempData.perLevel = {}

		if (userData) then
			tempData = userData
			if (not userData.perLevel) then
				tempData.perLevel = {}
			end
		else
			tempData.perLevel = {}
		end
		
		local level = tonumber( alevel )
		-- if (userData) then
			-- if (userData.perLevel) then
				-- compare data stored to current score
				if (tempData.perLevel[level]) then
					print( "comparing data" )
					if (tempData.perLevel[level] < score) then tempData.perLevel[level] = score end
				else
					tempData.perLevel[level] = score
				end
		-- 	else
		-- 		userData.perLevel[level] = score
		-- 	end
		-- -- else
			-- userData.perLevel[level] = score
		-- end

		-- if logged in to Facebok, then upload total energy(score) to Facebook
		if (user) then
			local sumEnergy = 0
			for i=1,#tempData.perLevel do
				sumEnergy = sumEnergy + tempData.perLevel[i]
			end

			_G.temporaryData.totalEnergy = sumEnergy
			tempData.totalEnergy = sumEnergy

			-- ask for user's score first
			Runtime:dispatchEvent( {name = "social", service = "Facebook", } )
			Runtime:dispatchEvent( {name = "social", service = "Facebook", type = "uploadScore", score = sumEnergy} )
		end

		-- write data to .json file
		saveTable("userscores.json", system.DocumentsDirectory, tempData)
		print( "user score saved" )
	end

	return service
end

return highscoresService
-- read and store level highscores in json
-- compare's current highscore to json data
-- sums up all highscores to create overall energy