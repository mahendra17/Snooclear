
require "components.activatorImageData"

local centerX = display.contentCenterX

inGamePos = {
[1] = {x= centerX - 108.5 - 108.5, y= display.contentHeight -471.5 },
[2] = {x= centerX - 108.5,         y= display.contentHeight -471.5 },
[3] = {x= centerX,                 y= display.contentHeight -471.5 },
[4] = {x= centerX + 108.5,         y= display.contentHeight -471.5 },
[5] = {x= centerX + 108.5 + 108.5, y= display.contentHeight -471.5 }, }


local function toggle( params )
    local obj = display.newGroup( )
    local object = {}
        object.on = display.newImage( params.on )
        object.on.isVisible = false
        object.on.name = params.name 
        object.off = display.newImage( params.off )
        object.off.isVisible = true
        object.off.name = params.name 

        obj:insert( object.on )
        obj:insert( object.off )

        local function listener(event)
          if (event.phase == "ended") then
            object.on.isVisible = not object.on.isVisible  
            object.off.isVisible = not object.off.isVisible
            obj:dispatchEvent( {name = "toggleChange", target = obj} )
          end
        end

        function obj:getState( )
          if object.on.isVisible then
            return true
          else
            return false
          end
        end

        function obj:setState( bool )
          if bool then
            object.on.isVisible = true
            object.off.isVisible = false
          else
            object.on.isVisible = false
            object.off.isVisible = true
          end
        end

        object.on:addEventListener( "touch", listener )
        object.off:addEventListener( "touch", listener )

    return obj
end

local function nonActiveToggle( location )
    local obj = display.newGroup( )
    local object = display.newImage( location)  
    obj:insert( object )

    function obj:getState( )
     return false
    end    

    function obj:setState( bool )
    end

    return obj
end


ingameActivator = {}

function ingameActivator:new( parentGroup )
      local Activator  = display.newGroup( )
      local activator = {}
      local data = {}
      
      if parentGroup then
         parentGroup:insert(Activator)
      end

      _G.temporaryData.data = {}

      function Activator : init( )
            for i=1,5 do

                  if activatorData[i].qty == 0 then
                        -- activator[i] = display.newImage( image[i].off )
                        activator[i] = nonActiveToggle( image[i].off )
                  elseif activatorData[i].qty > 0 then
                        activator[i] = toggle( {on = image[i].on, off = image[i].off, name = image[i].name} )
                        activator[i]:addEventListener( "toggleChange", self )
                  end

                  activator[i].anchorX, activator[i].anchorY = .5,.5
                  activator[i].x, activator[i].y = inGamePos[i].x, inGamePos[i].y
                  activator[i].name = image[i].name
                  activator[i].width, activator[i].height = 60,60
                  self:insert( activator[i] )

                  activator[i].text = display.newText( self, activatorData[i].qty, activator[i].x+17, activator[i].y-17, Calibri, 35   )
                  activator[i].text.anchorX, activator[i].text.anchorY = 0,1
                  activator[i].text:setFillColor( 219/255, 219/255, 219/255 )

            end
      return activator
      end

      function Activator:changeData( name )
       
        for i=1,5 do
          data[i] = activator[i]:getState()
        end
        _G.temporaryData.data = data
      end

      function Activator:toggleChange( event )
        local sum = Activator:sum()
        if (sum <= 3) then 
          Activator:changeData (event.target.name)
        elseif sum > 3 then
          print( "warning" )
          local function onComplete( event )
              if "clicked" == event.action then
                  local i = event.index
                  if 1 == i then
                    -- do nothing
                  end
              end
          end
          local alert = native.showAlert( "activator", "only 3 activator or less permitted", { "ok" }, onComplete )
          for i=1,5 do
            activator[i]:setState(data[i])
          end        
        end
      end

      function Activator:sum( )
        local sum = 0
          for i = 1, 5 do
            if (activator[i]:getState()) then
              sum = sum + 1 
            end
          end
        return sum
      end

      function Activator : data ()
        _G.temporaryData.data = {}
      end

   Activator : init( ) 
   Activator : data ()
   return Activator  
end
