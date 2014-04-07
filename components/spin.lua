 imgOn = {}

 imgOn.location = {
	[1]="assets/images/ActvtrBanishLvlObj.png",
	[2]="assets/images/ActvtrBoostLvlObj.png",
	[3]="assets/images/ActvtrForceLvlObj.png",
	[4]="assets/images/ActvtrFrSeeLvlObj.png",
	[5]="assets/images/ActvtrNullLvlObj.png",
	[6]="assets/images/ActvtrForceLvlObj.png",
}

imgOn.name = {
	[1]="banish",
	[2]="boost",
	[3]="force",
	[4]="noresee",
	[5]="null",
	[6]="force",
}

imgOn.activatorName = {
	[1]="Banish",
	[2]="Boost",
	[3]="Force",
	[4]="Noresee",
	[5]="Null",
	[6]="Force",
}


imgOn.description = {
	[1]="Banish all reactor",
	[2]="Twice the speed",
	[3]="Tilt with style",
	[4]="See the future",
	[5]="5 free shots",
	[6]="Tilt with style",
}

local imageState = {}

local function changeState( on )
	for i=1,6 do
		if (i == on) then
			imageState[i] = 1
			else
			imageState [i] = 0
		end
	end
end

local function spin_image( )
 	for i=1,#imageState do
 		
 		if imageState[i] == 1 then
 			image_on[i].isVisible = true
 			image_gy[i].isVisible = false
 			-- bonus=i
 			imgOn.location[666] = imgOn.location[i]
 			imgOn.name[666] = imgOn.activatorName[i]
 			imgOn.description[666] = imgOn.description[i]
 		else
 			image_on[i].isVisible = false
 			image_gy[i].isVisible = true
 		end
	end
end

local x  = math.floor( math.random(1,3) )

local function spin ()
		changeState ( x )
		spin_image() 
		if (x==6) then x=1 else	x=x+1 end
end

function spin_button ()
local numberOfSpin = math.floor( math.random(10,20))
local wait = 100*numberOfSpin + 200 * numberOfSpin * 3/4 + 10000
timer.performWithDelay( 100, spin, numberOfSpin )
timer.performWithDelay( 100*numberOfSpin, function()
	timer.performWithDelay( 200, spin, math.floor( numberOfSpin*3/4 )  )
	timer.performWithDelay( 200* math.floor( numberOfSpin*3/4 ), function()
		timer.performWithDelay( 400, spin, 5 )
	end )
end )
tunggu = 100*numberOfSpin + 200 * numberOfSpin * 3/4 + 3000
-- print( tunggu )
end
