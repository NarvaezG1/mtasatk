root = getRootElement ()
ballCount = 1
plasmaBalls = {}  
stopOSDrop = false

function FireOS ( x, y, z )
	OSBeaconX = x --these are for the render function
	OSBeaconY = y 
	OSBeaconZ = z
	loggedTick = getTickCount ()
	addEventHandler ( "onClientRender", root, OSdropAndExplode )
end
addEvent("ClientFireOS",true)
addEventHandler( "ClientFireOS", root, FireOS)

function OSdropAndExplode ()
	currentTick = getTickCount ()	
	if ( currentTick - loggedTick >= 250 ) and ( ballCount <= 20 ) then
		loggedTick = getTickCount ()		
		plasmaBalls[ballCount] = {}
		plasmaBalls[ballCount].ball = createMarker ( OSBeaconX + math.random(-45,45), OSBeaconY + math.random(-45,45), 50, "corona", 5, 255, 255, 255, 255 )
	    local x, y, z = getElementPosition ( plasmaBalls[ballCount].ball )
	    plasmaBalls[ballCount].zHeight = getGroundPosition ( x, y, z )
	    ballCount = ballCount + 1
	end	
		
	for k,v in pairs(plasmaBalls) do 
		if plasmaBalls[k].ball ~= nil then 
			if plasmaBalls[k].exploded ~= true then
				local x, y, z = getElementPosition ( plasmaBalls[k].ball )
				setElementPosition ( plasmaBalls[k].ball, x, y, z - 3 )
				if z - 2 <= plasmaBalls[k].zHeight then
					createExplosion ( x, y, z, 7 )
					plasmaBalls[k].exploded = true
					plasmaBalls[k].explodeGrow = true --cant use this in if as it changes
				end	
			end	 
	
		
			--Below is for flash of ball after destruction 
			getBallSize = getMarkerSize ( plasmaBalls[k].ball )
			if ( plasmaBalls[k].explodeGrow == true ) then		
				if ( getBallSize < 25 ) then
					setMarkerSize ( plasmaBalls[k].ball, getBallSize + 1 )
	        	else
	        		plasmaBalls[k].explodeGrow = false
	        		
	        	end
	        end
	        
	        if ( plasmaBalls[k].explodeGrow == false ) and ( plasmaBalls[k].exploded == true ) then
				if getBallSize > 0 then 
	        		setMarkerSize ( plasmaBalls[k].ball, getBallSize - 1 )
				else
					destroyElement ( plasmaBalls[k].ball )
					plasmaBalls[k] = {}
				end	
			end	
		end
	end	
	
	for k,v in pairs(plasmaBalls) do 
		if plasmaBalls[k].ball ~= nil then
			OSIsActive = true
		else
			OSIsActive = false
		end
	end
	if ( OSIsActive == false ) and ( #plasmaBalls == 20 --[[20 balls gone through cycle]] ) and ( stopOSDrop == false ) then
	    stopOSDrop = true --wait 3 seconds before stopping everything but prevent calling this timer every render
		setTimer (function()
		ballCount = 0
		plasmaBalls = {}
		removeEventHandler ( "onClientRender", root, OSdropAndExplode )
		triggerServerEvent ( "serverOrbitalStrikeFinished", root )
		stopOSDrop = false
		end, 3000, 1 )
	end		
end