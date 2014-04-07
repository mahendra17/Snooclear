
function magnitude ( x0, y0, x , y)
	if x0 and y0 and y and x then
		local X = (x-x0)*(x-x0)
		if X ==nil then X= 0 end

		local Y = (y-y0)*(y-y0)
		if Y == nil then Y= 0 end
		
		return math.sqrt( X+Y )
	else
		return 0 
	end
end

function dir(x0, y0, x , y)
	if x0 and y0 and y and x then
			local mag = magnitude (x0, y0, x , y)
			if mag >0 then
				
				local X = (x-x0)/mag
				if X == nil then X =0 end
				local Y = (y-y0)/mag
				if Y == nil then Y= 0 end
					
				return X, Y
			else 
				return 0,0
			end
	end
end