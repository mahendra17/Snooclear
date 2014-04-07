-- event lib


--[[ internal values ]]--

local stage = display.getCurrentStage()


--[[ ease of use ]]--

-- Easy-access function for dispatching events to the stage
function dispatchEvent( event )
	stage:dispatchEvent( event )
end

-- Easy-access function for adding event listeners to the stage
function addEventListener( name, event )
	stage:addEventListener( name, event )
end

-- Easy-access function for removing event listeners to the stage
function removeEventListener( name, event )
	stage:removeEventListener( name, event )
end


--[[ display.* ]]--

local newcircle = display.newCircle
display.newCircle = function(...)
	local circle = newcircle(unpack({...}))
	dispatchEvent{ name="newCircle", target=circle, arg={...} }
	return circle
end

local newembossedtext = display.newEmbossedText
display.newEmbossedText = function(...)
	local embossedtext = newembossedtext(unpack({...}))
	dispatchEvent{ name="newEmbossedText", target=embossedtext, arg={...} }
	return embossedtext
end

local newgroup = display.newGroup
display.newGroup = function(...)
	local group = newgroup(unpack({...}))
	dispatchEvent{ name="newGroup", target=group, arg={...} }
	return group
end

local newimage = display.newImage
display.newImage = function(...)
	local image = newimage(unpack({...}))
	dispatchEvent{ name="newImage", target=image, arg={...} }
	return image
end

local newimagegroup = display.newImageGroup
display.newImageGroup = function(...)
	local imagegroup = newimagegroup(unpack({...}))
	dispatchEvent{ name="newImageGroup", target=imagegroup, arg={...} }
	return imagegroup
end

local newimagerect = display.newImageRect
display.newImageRect = function(...)
	local imagerect = newimagerect(unpack({...}))
	dispatchEvent{ name="newImageRect", target=imagerect, arg={...} }
	return imagerect
end

local newline = display.newLine
display.newLine = function(...)
	local line = newline(unpack({...}))
	dispatchEvent{ name="newLine", target=line, arg={...} }
	return line
end

local newrect = display.newRect
display.newRect = function(...)
	local rect = newrect(unpack({...}))
	dispatchEvent{ name="newRect", target=rect, arg={...} }
	return rect
end

local newroundedrect = display.newRoundedRect
display.newRoundedRect = function(...)
	local roundedrect = newroundedrect(unpack({...}))
	dispatchEvent{ name="newRoundedRect", target=roundedrect, arg={...} }
	return roundedrect
end

local newsprite = display.newSprite
display.newSprite = function(...)
	local sprite = newsprite(unpack({...}))
	dispatchEvent{ name="newSprite", target=sprite, arg={...} }
	return sprite
end

local newtext = display.newText
display.newText = function(...)
	local text = newtext(unpack({...}))
	dispatchEvent{ name="newText", target=text, arg={...} }
	return text
end


--[[ graphics.* ]]--

local newgradient = graphics.newGradient
graphics.newGradient = function(...)
	local gradient = newgradient(unpack({...}))
	dispatchEvent{ name="newGradient", target=gradient, arg={...} }
	return gradient
end

local newimagesheet = graphics.newImageSheet
graphics.newImageSheet = function(...)
	local imagesheet = newimagesheet(unpack({...}))
	dispatchEvent{ name="newImageSheet", target=imagesheet, arg={...} }
	return imagesheet
end

local newmask = graphics.newMask
graphics.newMask = function(...)
	local mask = newmask(unpack({...}))
	dispatchEvent{ name="newMask", target=mask, arg={...} }
	return mask
end


--[[ physics.* ]]--

local hasphysics = pcall(function()
	local f = physics.start
end)

if (hasphysics) then
	local addbody = physics.addBody
	physics.addBody = function(...)
		local body = addbody(unpack({...}))
		dispatchEvent{ name="addBody", target=body, arg={...} }
		return body
	end

	local newjoint = physics.newJoint
	physics.newJoint = function(...)
		local joint = newjoint(unpack({...}))
		dispatchEvent{ name="newJoint", target=joint, arg={...} }
		return joint
	end

	local newpause = physics.pause
	physics.pause = function(...)
		local pause = newpause(unpack({...}))
		dispatchEvent{ name="pause", target=pause, arg={...} }
		return pause
	end

	local newremovebody = physics.removeBody
	physics.removeBody = function(...)
		local removebody = newremovebody(unpack({...}))
		dispatchEvent{ name="removeBody", target=removebody, arg={...} }
		return removebody
	end

	local newsetgravity = physics.setGravity
	physics.setGravity = function(...)
		local setgravity = newsetgravity(unpack({...}))
		dispatchEvent{ name="setGravity", target=setgravity, arg={...} }
		return setgravity
	end

	local newstart = physics.start
	physics.start = function(...)
		local start = newstart(unpack({...}))
		dispatchEvent{ name="start", target=start, arg={...} }
		return start
	end

	local newstop = physics.stop
	physics.stop = function(...)
		local stop = newstop(unpack({...}))
		dispatchEvent{ name="stop", target=stop, arg={...} }
		return stop
	end
end


--[[ object.* ]]--


local newaddeventlistener = graphics.newMask
graphics.newMask = function(...)
	local mask = newmask(unpack({...}))
	dispatchEvent{ name="newMask", target=mask, arg={...} }
	return mask
end
