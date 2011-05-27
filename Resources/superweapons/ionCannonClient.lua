root = getRootElement ()
IC_loops = 0
IC_beamSize = 5 
IC_FlashSize = 5
stopExplosions = false

function FireIC ( x, y, z )
	ICBeaconX = x --these are for the render function
	ICBeaconY = y 
	ICBeaconZ = z
	ICBeam = createMarker ( x, y, z, "checkpoint", 5, 255, 255, 255, 255 )
	ICBeam2 = createMarker ( x, y, z, "checkpoint", 5, 255, 255, 255, 255 )
	ICBeam3 = createMarker ( x, y, z, "checkpoint", 5, 255, 255, 255, 255 )
	ICSecondaryBeam = createMarker ( x, y, z, "checkpoint", 5, 255, 255, 255, 255 )
	ICSecondaryBeam2 = createMarker ( x, y, z, "checkpoint", 5, 255, 255, 255, 255 )
	ICSecondaryBeam3 = createMarker ( x, y, z, "checkpoint", 5, 255, 255, 255, 255 )
	ICbeamFlash = createMarker ( x, y, z, "corona", 5, 255, 255, 255, 255 )  
	setTimer ( ICBeamA, 100, 20 )
	setTimer ( ICBeamB, 150, 20 )
	setTimer ( ICExplode, 170, 18 )
end
addEvent("ClientFireIC",true)
addEventHandler("ClientFireIC", getRootElement(), FireIC)
         
function ICBeamA()    
    IC_beamSize = IC_beamSize + 1    
    setMarkerSize ( ICBeam, IC_beamSize )
    setMarkerSize ( ICBeam2, IC_beamSize )
    setMarkerSize ( ICBeam3, IC_beamSize )
end

function ICBeamB() --used to preserve the "beam" as cp marker ionBeamA disappears when changing size
	setMarkerSize ( ICSecondaryBeam, IC_beamSize )
	setMarkerSize ( ICSecondaryBeam2, IC_beamSize )
	setMarkerSize ( ICSecondaryBeam3, IC_beamSize )
    if ( IC_beamSize == 6 ) then
    	addEventHandler ( "onClientRender", root, ICFlash )
    	setTimer ( ICFlash, 40, 150 )  
    end
end

function ICExplode () --Explosions	
	local r = IC_beamSize --min/max blast radius: 1.5-28
    angleUp = math.random(0, 35999)/100 --random angle between 0 and 359.99
	explosionXCoord = r*math.cos(angleUp) + ICBeaconX --circle trig math
	explosionYCoord = r*math.sin(angleUp) + ICBeaconY --circle trig math
	createExplosion ( explosionXCoord, explosionYCoord, ICBeaconZ, 7 )
	IC_loops = IC_loops + 1
	if IC_loops == 17 then
		ICEndFlash = true		
	elseif IC_loops == 18 then	 
		IC_loops = 0 --reset stuff
    	IC_beamSize = 5 --reset stuff  
    	stopExplosions = true
    	destroyElement ( ICBeam )
		destroyElement ( ICSecondaryBeam ) 
    	destroyElement ( ICBeam2 )
		destroyElement ( ICSecondaryBeam2 )
    	destroyElement ( ICBeam3 )
		destroyElement ( ICSecondaryBeam3 )
	end			
end     

function ICFlash () --Corona "flash". Grows after cp marker B grows a little
	if ( stopExplosions == false ) then
		if ( ICEndFlash == false ) then
			IC_FlashSize = IC_FlashSize + 1
		else 
			IC_FlashSize = IC_FlashSize + 15
			ICEndFlash = false
		end
	else
		IC_FlashSize = IC_FlashSize - 1
	end
	setMarkerSize ( ICbeamFlash, IC_FlashSize )
	if IC_FlashSize == 0 then
		removeEventHandler ( "onClientRender", root, ICFlash )
		destroyElement ( ICbeamFlash )
		stopExplosions = false --reset stuff
		IC_FlashSize = 5 --reset stuff
		triggerServerEvent ( "serverIonCannonFinished", getRootElement() )
	end
end	