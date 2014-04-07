boundary = {}

function boundary:new( parentGroup )
	local _boundary = display.newGroup( )
	local bound = {}

	if parentGroup then parentGroup:insert( _boundary ) end

	function _boundary:init( )
			bound[1] = display.newRect(0,970, display.contentWidth, 4)
		    bound[1].anchorX, bound[1].anchorY= 0.5, 0.5
		    bound[1].x, bound[1].y= display.contentCenterX, 970
		    bound[1].alpha = .1
		    physics.addBody(bound[1], "static", {friction= 0, bounce=0.92})
		    self:insert( bound[1] )
		    bound[1].name = "boundary"
		    bound[1].ID = 0.5

		    bound[2] = display.newRect(0,0,2, display.contentHeight)
		    bound[2].anchorX, bound[2].anchorY= 0, 0
		    bound[2].alpha = .1
		    physics.addBody(bound[2], "static", {friction= 0, bounce=0.92})
		    self:insert( bound[2] )
		    bound[2].name = "boundary"
		    bound[2].ID = 0.5
		    

		    bound[3] = display.newRect(640, 0,2, display.contentHeight)
		    bound[3].anchorX, bound[3].anchorY= 1, 0
		    bound[3].alpha = .1
		    physics.addBody(bound[3], "static", {friction= 0, bounce=0.92})
		    self:insert( bound[3] )
		    bound[3].name = "boundary"
		    bound[3].ID = 0.5
		    

		    bound[4] = display.newRect(0,170, display.contentWidth, 4)
		    bound[4].anchorX, bound[4].anchorY= 0, 1
		    bound[4].alpha = .1
		    physics.addBody(bound[4], "static", {friction= 0, bounce=0.92})
		    self:insert( bound[4] )
		    bound[4].name = "boundary"
		    bound[4].ID = 0.5
		    
	end

	function _boundary:addLine()
		local line = {}

		line[1] = display.newLine( self, 0, 170, 0, 970 )
		line[1]:setStrokeColor( 63/255,63/255,63/255, .05 )
		line[1].width = 3

		line[2] = display.newLine( self, 640, 170, 640, 970 )
		line[2]:setStrokeColor( 63/255,63/255,63/255 , .05)
		line[2].width = 3
	end

	_boundary:init( )
	_boundary:addLine()
	return _boundary
end