-- slideView.lua
-- 
-- Version 1.0 
--
-- Copyright (C) 2010 ANSCA Inc. All Rights Reserved.
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy of 
-- this software and associated documentation files (the "Software"), to deal in the 
-- Software without restriction, including without limitation the rights to use, copy, 
-- modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, 
-- and to permit persons to whom the Software is furnished to do so, subject to the 
-- following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in all copies 
-- or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
-- INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
-- PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE 
-- FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
-- OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
-- DEALINGS IN THE SOFTWARE.

module(..., package.seeall)

local screenW, screenH = display.contentWidth, display.contentHeight
local viewableScreenW, viewableScreenH = display.viewableContentWidth, display.viewableContentHeight
local screenOffsetW, screenOffsetH = display.contentWidth -  display.viewableContentWidth, display.contentHeight - display.viewableContentHeight

local imgNum = nil
local images = nil
local touchListener, nextImage, prevImage, cancelMove, initImage
local background
local imageNumberText, imageNumberTextShadow

function new(parentGroup, numberOfImages, setOfImages, slideBackground, top, bottom )	
	local pad = 20
	local top = top or 0 
	local bottom = bottom or 0

	local g = display.newGroup()

	if parentGroup then
		parentGroup:insert(g)
	end

	local imageSet = {}
	if (setOfImages) then
		imageSet = setOfImages
	else
		imageSet = {
			"assets/images/tutorial/TutP01.png",
			"assets/images/tutorial/TutP02.png",
			"assets/images/tutorial/TutP03.png",
			"assets/images/tutorial/TutP04.png",
			"assets/images/tutorial/TutP05.png",
			"assets/images/tutorial/TutP06.png",
			"assets/images/tutorial/TutP07.png",
		}
	end

	-- Position of circles
	local basePosition
	if (numberOfImages%2 == 0) then -- even slides
		basePosition = display.contentCenterX - 15 - (numberOfImages/2 - 1)*30 
	else -- odd slides
		basePosition = display.contentCenterX - (numberOfImages/2 - 1)*30 
	end
	
	-- three circles
	local positionCircle = {}
	for i=1,numberOfImages do
		positionCircle[i] = display.newCircle(g, basePosition + 30*(i-1), 930 , 10 )
		positionCircle[i]:setFillColor( 76/255, 76/255, 76/255, .4)
	end

	local markCircle = display.newCircle(g, basePosition, 930 , 10 )
	markCircle:setFillColor( 228/255, 70/255, 25/255)
	markCircle.anchorX, markCircle.anchorY = .5, .5

	local function moveMarkCircle()
		markCircle.x = basePosition + 30*(imgNum-1)
	end

	if slideBackground then
		background = display.newImage(slideBackground, 0, 0, true)
	else
		-- background = display.newRect( 0, 0, screenW, screenH-(top+bottom) )
		background = display.newRect( display.contentWidth*.5, 567.5, 706.5, display.contentWidth )
		background.anchorX, background.anchorY = .5, .5
		background:setFillColor(255, 255, 255)
		background.alpha = 0.01

	end
	g:insert(background)
	
	images = {}
	for i = 1, numberOfImages do
		local p = display.newImageRect( imageSet[i], 541.5, 706.5 )
		p.anchorX, p.anchorY = .5, .5
		g:insert(p)
	    
		if (i > 1) then
			p.x = screenW*1.5 + pad -- all images offscreen except the first one
		else 
			p.x = screenW*.5
		end
		
		p.y = 567.5

		images[i] = p
	end
	
	imgNum = 1
	
	g.x = 0
	g.y = top + display.screenOriginY
	

	-- Event listener buat touch	
	function touchListener (self, touch) 
		local phase = touch.phase
		-- print("slides", phase)
		if ( phase == "began" ) then
            -- Subsequent touch events will target button even if they are outside the stageBounds of button
            display.getCurrentStage():setFocus( self )
            self.isFocus = true

			startPos = touch.x
			prevPos = touch.x
			
        elseif( self.isFocus ) then
        
			if ( phase == "moved" ) then
			
				if tween then transition.cancel(tween) end
	
				-- print(imgNum)
				
				local delta = touch.x - prevPos
				prevPos = touch.x
				
				images[imgNum].x = images[imgNum].x + delta
				
				if (images[imgNum-1]) then
					images[imgNum-1].x = images[imgNum-1].x + delta
				end
				
				if (images[imgNum+1]) then
					images[imgNum+1].x = images[imgNum+1].x + delta
				end

			elseif ( phase == "ended" or phase == "cancelled" ) then
				
				dragDistance = touch.x - startPos
				if (dragDistance < -100 and imgNum < #images) then
					nextImage()
					moveMarkCircle()
				elseif (dragDistance > 100 and imgNum > 1) then
					prevImage()
					moveMarkCircle()
				elseif (dragDistance < -100 and imgNum == 7 ) then
					if (parentGroup) then
						-- print( "dispatching" )
						Runtime:dispatchEvent( {name="closeSlideView"} )
						-- self:dispatchEvent( {name = "closeSlideView", target = g} )
					end
					-- cancelMove()
				else
					cancelMove()
				end
									
				if ( phase == "cancelled" ) then		
					cancelMove()
				end

                -- Allow touch events to be sent normally to the objects they "hit"
                display.getCurrentStage():setFocus( nil )
                self.isFocus = false
														
			end
		end
					
		return true
		
	end
	
	function setSlideNumber()
		-- print("Showing image ", imgNum .. " of " .. #images)
	end
	
	function cancelTween()
		if prevTween then 
			transition.cancel(prevTween)
		end
		prevTween = tween 
	end
	
	function nextImage()
		tween = transition.to( images[imgNum], {time=400, x=(screenW*.5 + pad)*-1, transition=easing.outExpo } )
		tween = transition.to( images[imgNum+1], {time=400, x=screenW*.5, transition=easing.outExpo } )
		imgNum = imgNum + 1
		initImage(imgNum)
	end
	
	function prevImage()
		tween = transition.to( images[imgNum], {time=400, x=screenW*1.5+pad, transition=easing.outExpo } )
		tween = transition.to( images[imgNum-1], {time=400, x=screenW*.5, transition=easing.outExpo } )
		imgNum = imgNum - 1
		initImage(imgNum)
	end
	
	function cancelMove()
		tween = transition.to( images[imgNum], {time=400, x=screenW*.5, transition=easing.outExpo } )
		tween = transition.to( images[imgNum-1], {time=400, x=(screenW*.5 + pad)*-1, transition=easing.outExpo } )
		tween = transition.to( images[imgNum+1], {time=400, x=screenW*1.5+pad, transition=easing.outExpo } )
	end
	
	function initImage(num)
		if (num < #images) then
			images[num+1].x = screenW*1.5 + pad			
		end
		if (num > 1) then
			images[num-1].x = (screenW*.5 + pad)*-1
		end
		setSlideNumber()
	end

	background.touch = touchListener
	background:addEventListener( "touch", background )

	------------------------
	-- Define public methods
	
	function g:jumpToImage(num)
		local i
		-- print("jumpToImage")
		-- print("#images", #images)
		for i = 1, #images do
			if i < num then
				images[i].x = -screenW*.5;
			elseif i > num then
				images[i].x = screenW*1.5 + pad
			else
				images[i].x = screenW*.5 - pad
			end
		end
		imgNum = num
		initImage(imgNum)
	end

	function g:cleanUp()
		-- print("slides cleanUp")
		background:removeEventListener("touch", touchListener)
	end

	return g	
end

