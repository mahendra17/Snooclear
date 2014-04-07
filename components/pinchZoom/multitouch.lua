-- multitouch

-- require("eventlib")


--[[ internal values ]]--

local stage = display.getCurrentStage()
local isSim = system.getInfo( "environment" ) == "simulator"
local trackgroup = nil

local touches = {}
function touches:add(circle)
	for i=1, #touches do
		local touch = touches[i]
		if (touch.target == circle.target) then
			local list = touch.list
			for t=1, #list do
				if (list[t] == circle) then
					return
				end
			end
			-- add new touch point to existing image
			local list = touch.list
			list[ #list+1 ] = circle
			return
		end
	end
	-- add new image and its first touch circle
	touches[ #touches+1 ] = {target=circle.target,list={circle}}
end
function touches:remove(circle)
	for i=#touches, 1, -1 do
		local touch = touches[i]
		if (touch.target == circle.target) then
			local list = touch.list
			for t=#list, 1, -1 do
				if (list[t] == circle) then
					table.remove(list,t)
					break
				end
			end
			if (#list == 0) then
				table.remove(touches,i)
				break
			end
		end
	end
end
function touches:get(target)
	for i=1, #touches do
		if (touches[i].target == target) then
			return touches[i].list
		end
	end
	return {}
end


--[[ ease of use ]]--

-- Sets the display group to put tracking dots into
function setTrackGroup( group )
	trackgroup = group
end


--[[ display.* ]]--

local function newTouchPoint(e)
	local circle = display.newCircle( trackgroup or stage, e.x, e.y, 25 )
	circle:setFillColor(255,0,0)
	circle.strokeWidth = 5
	circle:setStrokeColor(0,0,255)
	if (isSim) then circle.alpha = .5 else circle.alpha = .8 end
	circle.isHitTestable = true
	circle.isTouchPoint = true
	circle.target = e.target
	circle.id = e.id
	touches:add(circle)
	stage:setFocus(circle,e.id)
	
	function circle:touch(e)
		if (e.phase == "began") then
			stage:setFocus(e.target,e.id)
			circle.x, circle.y = e.x, e.y
			-- dispatch multitouch event here
			circle.target:dispatchEvent{ name="multitouch", phase="moved", target=circle.target, list=touches:get(circle.target) }
			return true
		elseif (e.phase == "moved") then
			circle.x, circle.y = e.x, e.y
			-- dispatch multitouch event here
			circle.target:dispatchEvent{ name="multitouch", phase="moved", target=circle.target, list=touches:get(circle.target) }
			print('moved',circle.target,circle.target.name)
			return true
		else
			circle.x, circle.y = e.x, e.y
			if (not isSim) then touches:remove(circle) end
			-- dispatch multitouch event here
			local phase = "ended"
			if (isSim) then phase = "moved" end
			circle.target:dispatchEvent{ name="multitouch", phase=phase, target=circle.target, list=touches:get(circle.target) }
			stage:setFocus(e.target,nil)
			if (not isSim) then circle:removeSelf() end
			return true
		end
		return false
	end
	circle:addEventListener("touch",circle)
	
	function circle:tap(e)
		if (e.numTaps == 1) then
			touches:remove(circle)
			circle.target:dispatchEvent{ name="multitouch", phase="ended", target=circle.target, list=touches:get(circle.target) }
			circle:removeSelf()
		end
		return true
	end
	if (isSim) then circle:addEventListener("tap",circle) end
	
	return circle
end

-- START FROM HERE
-- local function handleTouch(e)
-- 	if (e.phase == "began") then
-- 		local circle = newTouchPoint(e)
-- 		circle.target:dispatchEvent{ name="multitouch", phase="began", target=circle.target, list=touches:get(circle.target) }
-- 	end
-- 	print('handleTouch(e)',e.target)
-- 	return true
-- end

-- -- bagian bawah ga perlu, tinggal pake touch listener di object

-- -- WORKS BUT ONLY IF ONE TYPE OF LISTENER IS ATTACHED...

-- function multitouchListener( e )
-- 	print('multitouchListener',e)
-- 	for k,v in pairs(e) do
-- 	print(k,v)
-- 	end
-- 	print('  ')
	
-- 	e.target:addEventListener("touch",handleTouch)
-- end

-- -- didispatch tiap kali bikin grup
-- addEventListener( "newGroup", multitouchListener )
--addEventListener( "newImage", multitouchListener )
--addEventListener( "newImageGroup", multitouchListener )
--addEventListener( "newImageRect", multitouchListener )



--[[

-- DOESN'T WORK BUT SHOULD...

function replaceAddEventListener(e)
	local oldAddEventListener = e.target.addEventListener
	e.target.addEventListener = function(...)
		print("addEventListener args...")
		for k,v in ipairs(arg) do
			print(k,v)
		end
		if (arg[2] == "multitouch") then
			print('oldAddEventListener 1',arg[1],"touch",handleTouch)
			arg[1]:addEventListener("touch",handleTouch) -- e.target,"touch",handleTouch)
		else
			print('oldAddEventListener 2',arg[1],arg[2],arg[3])
			oldAddEventListener(arg[1],arg[2],arg[3])
		end
	end
end

addEventListener( "newGroup", replaceAddEventListener )
addEventListener( "newImage", replaceAddEventListener )

]]--
