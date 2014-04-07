require "services.ReadFileContentsService"

PreLevelDataService = {}

function PreLevelDataService:new()
	local service = {}
	-- local service = ReadFileContentsService:new()
	if _G.PrelevelData == nil then
		_G.PrelevelData = loadTable("services/data/PrelevelData.json", system.ResourceDirectory)	
	end
	
	print( "PreLevelDataService running" )
end		