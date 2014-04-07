levelMenuCircle = {}

function levelMenuCircle:new(parentGroup)

    circleLevel = display.newGroup( ) 
    local circle_scale = {[1]=100/100,[2]=70/100,[3]=45/100,[4]=30/100,[5]=15/100, [6]=1/100,[7]=1/100,[8]=1/100,[9]=1/100,[10]=1/100,[11]=1/100}
    
    local availableLevel = #_G.levelData

    if #circle_scale > math.ceil(availableLevel/5) then
        --do nothing
    elseif #circle_scale < math.ceil (availableLevel/5) then
        for i=#circle_scale+1,math.ceil(availableLevel/5) do
            circle_scale[i] = 1/100
        end
    end

    local circleGroup = {}

    if parentGroup then
        parentGroup:insert(circleLevel)
    end
    

    local function polar_coord( r, theta )
        x = r * math.sin( theta )
        y = r * math.cos( theta )
        return x,y
    end

    local circle = {}

    _level = 0

    local circNum = 2+(math.floor(gameSettings.openedLevel/5))

    function circleLevel:new( )


        for i=#circle_scale, 1, -1 do
            circleGroup[i] = display.newGroup( )
            circleLevel:insert( circleGroup[i] )
            circleGroup[i].anchorChildren = true
            circleGroup[i].x, circleGroup[i].y = display.contentCenterX, display.contentCenterY

            circle[i] = display.newCircle (display.contentCenterX , display.contentCenterY , (483/2))
            circle[i]:setFillColor(0,0,0,0)
            circle[i].strokeWidth = 10
            circleGroup[i]:insert( circle[i])
            
            if i <= circNum then
                circle[i]:setStrokeColor(27/255, 165/255, 226/255)
                else
                circle[i]:setStrokeColor(.8)
            end
        end 
        
    end

    function circleLevel:newLittleCircle(  )
        for i=1,#circle_scale do
            local radius = (483/2)
            local val = 1
            circle[i].levelCircle = {}          
            for j=1,5 do
                -- local theta = circle_scale[j]*(360+(i*15))*math.pi/180
                
                local theta = math.rad( ((i-1)*15 + (72*(j-1)))-180 )
                x,y =polar_coord(radius,theta)
                circleGroup[i].roatationDefault = theta

                -- x,y =polar_coord(radius,circle_scale[j]*(360)*math.pi/180)
                circle[i].levelCircle[j] = display.newCircle( display.contentCenterX+ x,display.contentCenterY+ y , 35)
                circleGroup[i]:insert( circle[i].levelCircle[j] )
                
                if (i <= circNum) then
                    circle[i].levelCircle[j]:setFillColor( 27/255, 165/255, 226/255)
                else
                    circle[i].levelCircle[j]:setFillColor( .8)
                end

                local num = j + ((i-2)*5)

                --text
                if num <= gameSettings.openedLevel then
                    circle[i].levelCircle[j].text = display.newText(j + ((i-2)*5), circle[i].levelCircle[j].x ,circle[i].levelCircle[j].y , temporaryData.font.BlanchCaps, 75 )
                    circle[i].levelCircle[j].text.anchorX, circle[i].levelCircle[j].text.anchorY = .5,.5
                    -- circle[i].levelCircle[j].text.isVisible = false
                    circle[i].levelCircle[j]:addEventListener( "touch", self )
                    circle[i].levelCircle[j].text.isVisible = true
                else
                    circle[i].levelCircle[j].text = display.newImage( "assets/images/Lv0LvlLock.png" )
                    circle[i].levelCircle[j].text.x, circle[i].levelCircle[j].text.y = circle[i].levelCircle[j].x ,circle[i].levelCircle[j].y
                    circle[i].levelCircle[j].text.anchorX, circle[i].levelCircle[j].text.anchorY = .5,.5
                    circle[i].levelCircle[j].text.width, circle[i].levelCircle[j].text.height = 186*1.5/9,270*1.5/9
                    -- circle[i].levelCircle[j]:setFillColor( .8)
                end
                    circle[i].levelCircle[j].name = num
                    circleGroup[i]:insert(circle[i].levelCircle[j].text)
                    circle[i].levelCircle[j].text.isVisible = false
                


            end
        end
    end

    local onTransition = false

    function circleLevel:move(condition, scaleFactor)
        print( "onTransition is " .. tostring( onTransition ) )
        
        if (not onTransition) then
            
            if (condition == "up") then  

                onTransition = not onTransition

                _level = _level + 1
                _level = math.min( _level,#circle_scale-1 )

                for i=1,#circle_scale do

                    if ( i == _level) then
                        moveListener( "finish" )
                        transition.to( circleGroup[i], { xScale=3.5, yScale=3.5, time = 800, transition = easing.outQuint, onComplete = function ()
                            onTransition = not onTransition
                        end } )
                        circleGroup[i]:scale( 3.5, 3.5 )
                    elseif i> _level then
                        
                        transition.to( circleGroup[i], {xScale=circle_scale[i-_level], yScale=circle_scale[i-_level], time=300, transition = easing.outBack,
                        onComplete = function ( )
                           
                        end })

                    end

                end
            
            elseif (condition == "down") then

                onTransition = not onTransition

                _level = _level - 1
                _level = math.max( _level, 1 )
                for i=1,#circle_scale do
                        moveListener( "finish" )
                        if (i ==1) then
                            transition.to( circleGroup[i+_level], {xScale=circle_scale[i], yScale=circle_scale[i], transition = easing.outBack, 
                                onComplete = function ()
                                    onTransition = not onTransition
                                end} )
                            circleGroup[i+_level]:scale( circle_scale[i], circle_scale[i] )
                        else
                            transition.to( circleGroup[i+_level], { time = 1000, transition = easing.inQuint, onComplete = function ()
                                end })
                            transition.to( circleGroup[i+_level], {xScale=circle_scale[i], yScale=circle_scale[i], transition = easing.outBack} )
                            
                        end
                end
            elseif (condition == "reset") then
                onTransition = not onTransition
                -- transition.to( circleGroup[1+_level], {xScale=1, yScale=1, transition = easing.outBack} )
                for i=1,#circle_scale do
                    if (circleGroup[i+_level]) then
                        transition.to( circleGroup[i+_level], {time = 400, xScale=circle_scale[i], yScale=circle_scale[i], transition = easing.outBack} )
                    end
                end
                timer.performWithDelay( 401,  function () onTransition = not onTransition end )
            else
                -- circleGroup[1+_level].xScale, circleGroup[1+_level].yScale = scaleFactor, scaleFactor --:scale( scaleFactor, scaleFactor )

                for i=1,#circle_scale do
                        if (circleGroup[i+_level]) then
                            circleGroup[i+_level].xScale, circleGroup[i+_level].yScale = circle_scale[i]*scaleFactor, circle_scale[i]*scaleFactor
                        end
                end
            end
        end
    end

    function moveListener( event )
        if (event == "start") then

        elseif event == "finish" then
            for i=1, #circle_scale do
                for j=1, 5 do
                    if (i ==1+_level ) then
                        circle[i].levelCircle[j].text.isVisible =  true
                        transition.to( circle[i].levelCircle[j].text, {alpha = 1, time = 300} )
                    else
                        circle[i].levelCircle[j].text.isVisible = false
                    end
                end
            end
        end
    end 

    function circleLevel:touch( event)
        if event.phase == "ended" then
        -- print( event.target.name )
            -- currentLevel = event.target.name
            -- self:dispatchEvent( {name = "onLevelTouched", target = self, level = event.target.name} )
            self:dispatchEvent( {name = "onLevelTouched", level = event.target.name, target = self} )
        end
        return true
    end

    circleLevel:new ()
    circleLevel:newLittleCircle(  )
    circleLevel:move( "up" )
    circleLevel:move( "down" )

    -- for i=1,#circle_scale do
    --     print(circleGroup[i].x, circleGroup[i].y)
    -- end

    return circleLevel
end
