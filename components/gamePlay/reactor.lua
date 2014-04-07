local physics = require "physics"

local wall = {}

function wall:new( x, y)
    local newWall = display.newGroup( )
    local  triangleWall 
    local onMotion = false
    newWall.name = "wall"
    newWall.ID = .5

    function newWall:init( )
        triangleWall = display.newImage( "assets/images/RctrTriWallGmlvlObj.png"  )
        triangleWall.name= "wall" 
        triangleWall.ID = .5
        triangleWall.width, triangleWall.height = 132,132
        self:insert( triangleWall )
        triangleWall.x, triangleWall.y = x, y
        triangleWall.anchorX, triangleWall.anchorY = 0.5 , 0.5
    end

    function newWall:notVisible( )
        newWall.isVisible = false
    end

    function newWall:appear( )
       transition.to( newWall, {alpha = 1, time = 1000} )
    end

    function newWall:addBody( )
        local triangleShape = { 40, 36  ,  -40, 36  ,  -0, -36 }
        physics.addBody( triangleWall, "static", {density=1, friction=0, bounce=0, shape = triangleShape } )
    end

    function newWall:removeBodyTriangle( )
        physics.removeBody( triangleWall )
    end

    function newWall:addMotion( )
        onMotion = true

        local function rotateTriangle()

            if triangleWall == nil or newWall == nil then
                onMotion = false
            elseif _G.temporaryData.currentView ~= "GamePlayView" then
                onMotion = false
            end

            if onMotion and newWall then
                triangleWall.rotation = triangleWall.rotation + .5
            elseif onMotion == false then
                Runtime:removeEventListener( "enterFrame", rotateTriangle )
            end    
        end

        Runtime:addEventListener( "enterFrame", rotateTriangle )
    end

    function newWall:stopMotion( )
        onMotion = false
    end

    newWall:init()
    newWall:addBody()
    newWall:addMotion()
    -- newWall:removeBodyTriangle( )

    return newWall
end

--===========================================================
reactor = {}

local functionalReactor = true

function reactor:new(parentGroup, type, x,y, x1, y1)
    
    _reactor = display.newGroup( )
    _reactor.anchorChildren = false

    if parentGroup then
        parentGroup:insert(_reactor)
    end

    if (x==nil and y==nil) then
        x, y = display.contentCenterX, display.contentCenterY
    end

    function _reactor:init( )
        if type == "disruptor" then
            newReactor = display.newImage( "assets/images/RctrDisrptGmlvlObj.png" )
            newReactor.name = "disruptor" 
            newReactor.width, newReactor.height = 66,66
            
        elseif type == "wall" then
            newReactor = wall:new(x,y)

        elseif type == "portal" then
            newReactor = display.newImage( "assets/images/RctrPortalGmlvlObj.png"  )
            newReactor.name = "portal"
            newReactor.width, newReactor.height = 66,66
        end

        if type ~= "wall" then
            newReactor.x, newReactor.y = x, y
            newReactor.anchorX, newReactor.anchorY = 0.5 , 0.5 
        end
        self:insert( newReactor )

    end
    
    _reactor:init( )
    return newReactor
end


function addMotion( )
    local wall =0
    local port = 0

    for i=1,#disruptor[_G.currentLevel] do
        if (disruptor[_G.currentLevel][i].type == "wall") then
            wall= wall+1
        elseif (disruptor[_G.currentLevel][i].type == "portal") then
            port = port + 1
        end
    end


    if #disruptor > wall then

        local portal = {}


        for i=wall+1 , wall+port , 1 do
            portal[i-wall] = GameObj.disrupt[i]
        end


        -- collision function
        local function hasCollidedCircle(obj1, obj2)
            if obj1 == nil or obj1.name == "sprite" or obj1.name == nil then
                return false
            end
            if obj2 == nil or obj2.name == "sprite" or obj2.name == nil then
                return false
            end
            local sqrt = math.sqrt


            if (obj1.x and obj2.x and obj1.y and obj2.y) then
               local dx =  obj1.x - obj2.x;
               local dy =  obj1.y - obj2.y;
               
               local distance = sqrt(dx*dx + dy*dy);
               local objectSize = (obj2.contentWidth/2) + (obj1.contentWidth/2)

               if distance < .5*objectSize and distance > .45*objectSize then
                    if (obj1.isPortable) or (obj2.isPortable) then
                       return true
                    end
               end 
            end

            return false
        end

        -- local direction = require "components.gamePlay.direction"

        local function testCollisions()
                    for i=1,#portal do
                        for j=1,#GameObj do

                            local outPortalNum

                            function getRandomNumber ( inPortal )
                                outPortalNum = math.floor( math.random(1, #portal+.1) )
                                if outPortalNum == inPortal then
                                    getRandomNumber(inPortal)
                                else
                                    local vx, vy = GameObj[j]:getLinearVelocity( )
                                    local dirX = (vx)/math.sqrt(vx^2+vy^2)
                                    local dirY = (vy)/math.sqrt(vx^2+vy^2)
                                    print( dirX, dirY )
                                    transition.to( GameObj[j], {time = 200, x = portal[inPortal].x, y = portal[inPortal].y, xScale = .2, yScale = .2, onComplete = function()
                                        GameObj[j].x,GameObj[j].y = portal[outPortalNum].x, portal[outPortalNum].y

                                        local maxScale
                                        if (GameObj[j].name == "bigGreen") or (GameObje[j].name == "bigPurple") then
                                            maxScale = 2
                                        else
                                            maxScale = 1
                                        end

                                        -- keep the ball inside arena after come out of the other portal
                                        local outX, outY = portal[outPortalNum].x+ (dirY*55), portal[outPortalNum].y+ (dirY*55)
                                        if (outX < 4 ) then -- x boundaries
                                            outX = 15
                                        elseif (outX > 636) then
                                            outX = 640 - 15
                                        end

                                        if (outY < 174) then -- y boundaries
                                            outY = 170 + 15
                                        elseif (outY > 966) then
                                            outY = 970 - 15
                                        end

                                        transition.to( GameObj[j], {xScale = maxScale, yScale = maxScale, x = outX, y = outY, time = 300, onComplete = function ()
                                            timer.performWithDelay( 200, function() GameObj[j].isPortable = true end ) -- GameObj[j].isPortable = true
                                        end} )
                                    end} )
                                end
                            end

                            if hasCollidedCircle(GameObj[j], portal[i]) then
                                GameObj[j].isPortable = false
                                if functionalReactor then getRandomNumber(i); end 
                            end     
                        end 
                    end
                end       

        Runtime:addEventListener("enterFrame", testCollisions)
        
    end
    
    if #disruptor > wall+ port then

        local Dist = {}

        for i=wall+port+1, #disruptor do
            Dist[i-wall-port] = GameObj.disrupt[i]
        end


        local function hasCollided( obj1, obj2 )
           if ( obj1 == nil ) or obj1.ID == nil and obj1.name == nil then  --make sure the first object exists
              return false
           end
           if ( obj2 == nil ) or obj2.ID == nil and obj2.name == nil then  --make sure the other object exists
              return false
           end

           -- print( obj1.contentBounds.xMin, obj2.contentBounds.xMin )

           local left = obj1.contentBounds.xMin <= obj2.contentBounds.xMin and obj1.contentBounds.xMax >= obj2.contentBounds.xMin
           local right = obj1.contentBounds.xMin >= obj2.contentBounds.xMin and obj1.contentBounds.xMin <= obj2.contentBounds.xMax
           local up = obj1.contentBounds.yMin <= obj2.contentBounds.yMin and obj1.contentBounds.yMax >= obj2.contentBounds.yMin
           local down = obj1.contentBounds.yMin >= obj2.contentBounds.yMin and obj1.contentBounds.yMin <= obj2.contentBounds.yMax

           return (left or right) and (up or down)
        end

        local function disruptSensors(  )
            
          if temporaryData.currentView == "GamePlayView" and gamePlaySettings.gamePlayOn then
              for i=1, #Dist do
                  for j=1,#GameObj do
                      if hasCollided(Dist[i], GameObj[j]) then
                          if GameObj[j].bodyType and functionalReactor then
                              local vx, vy = GameObj[j]:getLinearVelocity()
                              GameObj[j]:setLinearVelocity( .92*vx, .92*vy )
                          end
                      end
                  end
              end
          else
              Runtime:removeEventListener( "enterFrame", disruptSensors )
          end
           
        end

        Runtime:addEventListener( "enterFrame", disruptSensors )
    end


end


function removeListeneraddMotion( )
    -- Runtime:removeEventListener( "enterFrame", rotListener )
    Runtime:removeEventListener("enterFrame", testCollisions)
    Runtime:removeEventListener( "enterFrame", disruptSensors )
end


function disableReactor( )
   for i=1,#GameObj.disrupt do
         if GameObj.disrupt[i].name == "wall" then
            GameObj.disrupt[i]:removeBodyTriangle()
            GameObj.disrupt[i].isVisible = false
            print (i .. "remove triangleWall")
         else
             GameObj.disrupt[i].isVisible = false
         end
         print( "disable reactor ".. GameObj.disrupt[i].name )
    end
    functionalReactor = false
end

function avtivateReactor( )
    for i=1,#GameObj.disrupt do
        if GameObj.disrupt[i].name == "wall" then
            GameObj.disrupt[i]:addBody()
        end
        GameObj.disrupt[i].isVisible = true
        GameObj.disrupt[i].alpha = 0
        transition.to( GameObj.disrupt[i], {alpha = 1, time = 1000} )
    end
    functionalReactor = true
    addMotion()
end


