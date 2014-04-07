require "robotlegs.Context"

SnooclearGameContext = {}

function SnooclearGameContext:new()
	local context = Context:new()
	
	function context:init()
		self:mapMediator("views.GameMenuView", "mediators.GameMenuViewMediator")

		self:mapMediator ("views.LevelMenuView", "mediators.LevelMenuViewMediator")

		self:mapMediator ("views.ActivatorView", "mediators.ActivatorViewMediator")

		self:mapMediator ("views.SettingsView", "mediators.SettingsViewMediator")

		self:mapMediator ("views.LifePageView", "mediators.LifePageViewMediator")

		self:mapMediator ("views.SocialMenuView", "mediators.SocialMenuViewMediator")

		self:mapMediator ("views.GamePlayView", "mediators.GamePlayViewMediator")

		self:mapMediator ("views.PreLevelView", "mediators.PreLevelViewMediator")

		self:mapMediator ("views.finishGameView", "mediators.finishGameViewMediator")

		self:mapMediator ("SnooclearGame", "mediators.SnooclearGameMediator")

		self:mapMediator ("components.gamePlay.energyBar", "mediators.gamePlay.energyBarMediator") --game mediators
		
		self:mapCommand ("startup", "commands.startupCommand")

		self:mapCommand ("saveGameSettings", "commands.saveGameSettingsCommand")

		self:mapCommand ("changeSettings", "commands.settingsCommand")

		self:mapCommand ("toSettings","commands.loadSettingsCommand")

		self:mapCommand ("toPreLevel", "commands.preLevelDataCommand")

		self:mapCommand ("toGamePlay", "commands.GamePlayCommand")

		self:mapCommand ("directionOnTouch", "commands.addForceCommand") --gameplay command

		self:mapCommand ("onCollision", "commands.onCollisionCommand") --gameplay command

		self:mapCommand ("activator", "commands.activatorCommand") --gameplay command

		self:mapCommand ("social", "commands.socialCommand")--social function command

		self:mapCommand ("saveActivatorData", "commands.saveActivatorDataCommand")

		self:mapCommand ("toLivePage", "commands.LivesCommand")

		self:mapCommand ("loseLives", "commands.loseLivesCommand")

		self:mapCommand ("getLives", "commands.getLivesCommand")

		self:mapCommand ("chartBoost", "commands.chartBoostCommand")

		self:mapCommand ("networkCheck", "commands.networkCheckCommand")

		self:mapCommand ("saveScore", "commands.scoresCommand")

		-- self:mapCommand( "systemNotification", "commands.notificationCommand")

		Runtime:dispatchEvent({name = "startup"})
	end

	return context

end

return SnooclearGameContext