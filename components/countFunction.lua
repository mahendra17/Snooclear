
------------------------------------------------------------
function point_dir(xCol, yCol, xObj, yObj)
	if xCol and yCol and xObj and yObj then
		dirX = xObj- xCol
		dirY = yObj- yCol
	end
	return dirX, dirY
end
---------------------------------------------------------------------




