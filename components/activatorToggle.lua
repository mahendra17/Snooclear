-- local toggle = require "components.toggle"
require "components.activatorImageData"

local center = display.contentCenterX - 75

local inGamePos = {
    [1] = center -100 - 100,
    [2] = center -100,
    [3] = center,  
    [4] = center+100, 
    [5] = center+100 + 100,  
  
    
}


local function toggle( params )
    local obj = display.newGroup( )
    local object = {}
        object.on = display.newImage( params.on )
        object.on.isVisible = true
        object.on.name = params.name 
        object.off = display.newImage( params.off )
        object.off.isVisible = false

        obj:insert( object.on )
        obj:insert( object.off )

        local function listener(event)
            object.on.isVisible = false  
            object.off.isVisible = true
            listenerToggleDispatch(event)
        end

        object.on:addEventListener( "tap", listener )

    return obj
end

activatorToggle = {}

function activatorToggle:new( parentGroup )
    
    local actToggle = display.newGroup( )

    if parentGroup then
        parentGroup:insert(actToggle)
    end
        
    local data = _G.temporaryData.data

    function actToggle:readData( )
        data.sequence = {}
        for i=1,#data do
            -- print( data[i] )
            if data[i] then
                if #data.sequence == 0 or #data.sequence == nil then
                    data.sequence[1] = i
                else 
                    data.sequence[#data.sequence+1] = i
                end
            end
        end
    end

    function actToggle:init( )
        local object = {} 

        function listenerToggleDispatch( event )
            self:dispatchEvent( {name = "onGameActivator", type = event.target.name, condition =  "use"} )
        end

        for i=1,#data.sequence do

            -- print( data.sequence[i] )

                 object[i] = toggle( {on = image[data.sequence[i]].on, off = image[data.sequence[i]].off, name = image[data.sequence[i]].name} )

                 object[i].anchorX, object[i].anchorY = .5,.5
                 object[i].x, object[i].y = inGamePos[i], 85
                 object[i].width, object[i].height = 60,60
                 self:insert( object[i] )
        end
        
        return object
    end

    actToggle:readData( )
    actToggle:init()
    return actToggle
end


