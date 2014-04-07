toggle  = {}


function toggle:new( params)
  local obj = display.newGroup( )
  function obj:init(  )
    local object = {}
    object.on = display.newImage( params.on )
    object.on.isVisible = false
    object.on.name = params.name 
    object.off = display.newImage( params.off )
    object.off.isVisible = true
    object.off.name = params.name 

    self:insert( object.on )
    self:insert( object.off )

    object.on:addEventListener( "tap", self )
    object.off:addEventListener( "tap", self )
    return object
  end

  function obj:tap( event )
    event.target.isVisible = not event.target.isVisible
    -- event.target.on.isVisible = not event.target.on.isVisible  
    -- event.target.off.isVisible = not event.target.off.isVisible
    self:dispatchEvent( {name = "toggleChange", target = obj} )
  end


  obj:init()
  return obj
end

-- toggleClass.new = function ( params )
--   local object = {}
      

--       local function listener(event)

          
--           -- changeData(event.target.name)
--       end

      

--   obj.setState = function (bool)
--     toggle.state = tostring(bool) ~= "false"
--     if toggle.state then
--         object.on.isVisible  = true
--         object.off.isVisible = false
--     else
--        object.on.isVisible  = false
--        object.off.isVisible = true
--     end
--   end
-- end

-- function toggle( params )
    

--     function obj:getstate( )
--       -- obj.getState = function ( )
--         if object.on.isVisible then
--           return true
--         else
--           return false
--         end
--       -- end
--     end

    

--     return obj
-- end