
local cb = require "ChartboostSDK.chartboost"
local orientation

chartBoostService = {}

function chartBoostService:new()
	local service = {}

	function service:init(  )
		local appId,appSignature

		if system.getInfo("platformName") == "iPhone OS" then
		   appId =  "532fa7262d42da3fe89bd724"
		   appSignature =  "fb25e2d06f0368836650074e36fdf91236eb5a7a"
		else
		    appId =  "5331701d2d42da66d46a6664"
		    appSignature = "bda091e121708cefd27dd717e9091be5a53a33e7"
		end

		local delegate = {
		    shouldRequestInterstitial = function(location) print("Chartboost: shouldRequestInterstitial " .. location .. "?"); return true end,
		    shouldDisplayInterstitial = function(location) print("Chartboost: shouldDisplayInterstitial " .. location .. "?"); return true end,
		    didCacheInterstitial = function(location) print("Chartboost: didCacheInterstitial " .. location); return end,
		    didFailToLoadInterstitial = function(location, error) print("Chartboost: didFailToLoadInterstitial " .. location)
		                    if error then print("    Error: " .. error) end end,
		    didDismissInterstitial = function(location) print("Chartboost: didDismissInterstitial " .. location); return end,
		    didCloseInterstitial = function(location) print("Chartboost: didCloseInterstitial " .. location); return end,
		    didClickInterstitial = function(location) print("Chartboost: didClickInterstitial " .. location); return end,
		    didShowInterstitial = function(location) print("Chartboost: didShowInterstitial " .. location); return end,
		    shouldDisplayLoadingViewForMoreApps = function() return true end,
		    shouldRequestMoreApps = function() print("Chartboost: shouldRequestMoreApps"); return true end,
		    shouldDisplayMoreApps = function() print("Chartboost: shouldDisplayMoreApps"); return true end,
		    didCacheMoreApps = function(error) print("Chartboost: didCacheMoreApps")
		                    if error then print("    Error: " .. error) end end,
		    didFailToLoadMoreApps = function(error) print("Chartboost: didFailToLoadMoreApps: " .. error); return end,
		    didDismissMoreApps = function() print("Chartboost: didDismissMoreApps"); return end,
		    didCloseMoreApps = function() print("Chartboost: didCloseMoreApps"); return end,
		    didClickMoreApps = function() print("Chartboost: didClickMoreApps"); return end,
		    didShowMoreApps = function() print("Chartboost: didShowMoreApps"); return end,
		    shouldRequestInterstitialsInFirstSession = function() return true end,
		    didFailToLoadUrl = function(url, error) print("Chartboost:didFailToLoadUrl: " .. tostring(url))
		                    if error then print("    Error: " .. error) end end
		}

		cb.create{
		    appId = appId,
		    appSignature = appSignature,
		    delegate = delegate,
		    appBundle = "com.chartboost.cbtest"
		}

		cb.startSession() -- starting chartboost
		orientation = cb.orientations.PORTRAIT
	end

	function service:cache( )
		cb.cacheInterstitial() -- cache cb
	end

	service:init(  )
	service:cache()

	return service
end

function chartBoostService:showAd( )
	if cb.hasCachedInterstitial() then
        msg = "Chartboost: Loading Interstitial From Cache"
		orientation = cb.orientations.PORTRAIT
		cb.showInterstitial()
	else
		cb.cacheInterstitial() -- cache
    end
end

function chartBoostService:cacheAd( )
	if cb.hasCachedInterstitial() then
        --
	else
		cb.cacheInterstitial() -- cache
    end
end

return chartBoostService