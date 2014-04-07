local timeUp   = 200
local timeExit = 300

function enterTransition ( displayObject )
 displayObject.alpha = 0
 transition.to( displayObject, { delay =timeUp, alpha=1, time=timeDown, alpha=1, y=0 } )
 -- transition.from( displayObject, {xScale = .2, yScale=.2, time = timeUp, transition = easing.outBack } )
end

function exitTransition ( displayObject )
 transition.to( displayObject, {delay = 0, time=timeExit, alpha=0 } )
end