energyBar = {}

function energyBar:new( parentGroup)
    local bar = display.newGroup()
    bar.classType = "energyBar"

    if (parentGroup) then
        parentGroup:insert( bar )
    end

    function bar:init( )
        _energyBar = display.newRect ((display.contentWidth-600)*.5 ,display.contentHeight-(170*.5), 10 ,100)
        _energyBar.anchorX, _energyBar.anchorY = 0,0.5
        _energyBar:setFillColor (230/255, 69/255, 25/255, 0.8)
        self:insert( _energyBar )

        -- _energyBar.text = display.newText( "8", display.contentWidth*.5,display.contentHeight-110, "Blanch-Caps"" , 60 )
        -- _energyBar.text.anchorX, _energyBar.text.anchorY = 0.5,.5
        -- _energyBar.text:setFillColor( 230/255, 69/255, 25/255)
        -- self:insert( _energyBar.text )

        Runtime:dispatchEvent({name="onRobotlegsViewCreated", target=bar})
    end

    function bar:setValue( value )

        -- _energyBar.width = value*.05*600
        local wid = value*.05*600
        wid = math.max( wid, 4 )
        transition.to( _energyBar, {width = wid, transition = easing.outCubic } )

        if value <=1 then
            _energyBar:setFillColor (.8)
            -- transition.blink(_energyBar, {time = 500} )
        elseif value <3 then
            _energyBar:setFillColor (0.5)
            -- _energyBar.text:setFillColor (0.8)
        elseif value >= 5 then
            _energyBar:setFillColor (255/255, 72.9/100, 1.2/100)
            -- _energyBar.text:setFillColor (255/255, 72.9/100, 1.2/100)
        elseif value >=8 then
            _energyBar:setFillColor (230/255, 69/255, 25/255, 0.8)
            -- _energyBar.text:setFillColor (230/255, 69/255, 25/255, 0.8)
        end
    end

    bar:init()
    bar:setValue( 8 )
    return _energyBar
end



