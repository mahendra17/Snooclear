-- json = require "json"
require "services.ReadFileContentsService"

GamePlayService = {}

function GamePlayService:new()
	local service = {}
	
	if _G.levelData == nil then
		_G.levelData = loadTable("services/data/gameObject.json", system.ResourceDirectory)
		_G.disruptor = loadTable("services/data/activatorData.json", system.ResourceDirectory)
	end
	
	
	print( "GamePlayService running" )
	
end		