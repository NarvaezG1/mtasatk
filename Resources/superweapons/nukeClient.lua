root = getRootElement ()
localPlayer = getLocalPlayer ()
N_loops = 0
N_cloudRotationAngle = 0  
NFlashDelay = 0
stopNFlash = false   

function FireN ( x, y, z )
	NBeaconX = x --these are for the render function
	NBeaconY = y 
	NBeaconZ = z
	N_Cloud = NBeaconZ	
    setTimer ( function() setTimer ( NExplosion, 170, 35 ) end, 2700, 1 ) -- wait 2700 seconds then 35 loops @ 170ms
    setTimer ( NShot, 500, 1 )	
end
addEvent("ClientFireN",true)
addEventHandler("ClientFireN", getRootElement(), FireN)

function NShot ()
	NukeObjectA = createObject ( 16340, NBeaconX, NBeaconY, NBeaconZ + 200 )
	NukeObjectB = createObject ( 3865, NBeaconX + 0.072265, NBeaconY + 0.013731, NBeaconZ + 196.153122 )
	NukeObjectC = createObject ( 1243, NBeaconX + 0.060547, NBeaconY - 0.017578, NBeaconZ + 189.075554 )
	setElementRotation ( NukeObjectA, math.deg(3.150001), math.deg(0), math.deg(0.245437) )
	setElementRotation ( NukeObjectB, math.deg(-1.575), math.deg(0), math.deg(1.938950) )
	setElementRotation ( NukeObjectC, math.deg(0), math.deg(0), math.deg(-1.767145) )
	shotpath = NBeaconZ - 200
	moveObject ( NukeObjectA, 5000, NBeaconX, NBeaconY, shotpath, 0, 0, 259.9 ) 
	moveObject ( NukeObjectB, 5000, NBeaconX + 0.072265, NBeaconY + 0.013731, shotpath - 3.846878, 0, 0, 259.9 )
	moveObject ( NukeObjectC, 5000, NBeaconX + 0.060547, NBeaconY - 0.017578, shotpath - 10.924446, 0, 0, 259.9 )
end
  
function NExplosion ()
	N_loops = N_loops + 1	
	r = math.random(1.5, 4.5)
	angleup = math.random(0, 35999)/100
	explosionXCoord = r*math.cos(angleup) + NBeaconX
	ExplosionYCoord = r*math.sin(angleup) + NBeaconY	
	if N_loops == 1 then
		N_Cloud = NBeaconZ
		createExplosion ( explosionXCoord, ExplosionYCoord, N_Cloud, 7 )
		killXPosRadius = NBeaconX + 35
		killXNegRadius = NBeaconX - 35
		killYPosRadius = NBeaconY + 35
		killYNegRadius = NBeaconY - 35 --+/- 35 x/y
		killZPosRadius = NBeaconZ + 28-- +28
		killZNegRadius = NBeaconZ - 28-- -28
		local x, y, z = getElementPosition ( localPlayer )
		if ( x < killXPosRadius ) and ( x > killXNegRadius ) and ( y < killYPosRadius ) and ( y > killYNegRadius ) and 
		( z < killZPosRadius ) and ( z > killZNegRadius ) then
			triggerServerEvent ( "serverKillNukedPlayer", localPlayer )
		end
	elseif N_loops == 2 then
		N_Cloud = NBeaconZ + 4
		createExplosion ( explosionXCoord, ExplosionYCoord, N_Cloud, 7 )
       	destroyElement ( NukeObjectA ) --Exploded, get rid of objects
		destroyElement ( NukeObjectB )
		destroyElement ( NukeObjectC )
	elseif N_loops > 20 then
		N_cloudRotationAngle = N_cloudRotationAngle + 22.5
		if N_explosionLimiter == false then
			N_cloudRadius = 7
			explosionXCoord = N_cloudRadius*math.cos(N_cloudRotationAngle) + NBeaconX --recalculate
			ExplosionYCoord = N_cloudRadius*math.sin(N_cloudRotationAngle) + NBeaconY --recalculate
			createExplosion ( explosionXCoord, ExplosionYCoord, N_Cloud, 7 )
			N_explosionLimiter = true
		elseif N_explosionLimiter == true then
			N_explosionLimiter = false
		end
		N_cloudRadius2 = 16
		explosionXCoord2 = N_cloudRadius2*math.cos(N_cloudRotationAngle) + NBeaconX
		ExplosionYCoord2 = N_cloudRadius2*math.sin(N_cloudRotationAngle) + NBeaconY
		createExplosion ( explosionXCoord2, ExplosionYCoord2, N_Cloud, 7 )
	else
    	N_Cloud = N_Cloud + 4
    	createExplosion ( explosionXCoord, ExplosionYCoord, N_Cloud, 7 )
    end
	
	if N_loops == 1 then
		NExplosionFlash = createMarker ( NBeaconX, NBeaconY, NBeaconZ, "corona", 0, 255, 255, 255, 255 )
		N_FlashSize = 1
		addEventHandler ( "onClientRender", root, NFlash )
	elseif N_loops == 35 then
		stopNFlash = true       
	end	
end

function NFlash () --Corona "flare". Grows after cp marker B grows a little
	if ( stopNFlash == false ) then
			if N_FlashSize > 60 then --beginning flash must grow fast, then delayed
				if NFlashDelay == 2 then
					N_FlashSize = N_FlashSize + 1
					NFlashDelay = 0
				else	
					NFlashDelay = NFlashDelay + 1									
				end  
			else
				N_FlashSize = N_FlashSize + 1			
			end                      
	else
		N_FlashSize = N_FlashSize - 1
	end	
	setMarkerSize ( NExplosionFlash, N_FlashSize )					
	if N_FlashSize == 0 then
		removeEventHandler ( "onClientRender", root, NFlash )
		destroyElement ( NExplosionFlash )
		N_loops = 0 --reset stuff
		N_cloudRotationAngle = 0 --reset stuff
		stopNFlash = false --reset stuff
		NFlashDelay = 0 --reset stuff
		triggerServerEvent ( "serverNukeFinished", getRootElement() )
	end
end	