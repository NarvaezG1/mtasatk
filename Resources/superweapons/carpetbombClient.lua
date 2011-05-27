--Special thanks IJs and arc_ for math
root = getRootElement ()
count = 1
bombs = {}
startDropping = false

function FireCB ( APosX, APosY, APosZ, BPosX, BPosY, BPosZ )
    AAPosX = APosX --for CBdrop
	planeAngle = 360 - math.deg( math.atan2 ( (APosX - BPosX), (APosY - BPosY) ) )
    planeAngle = planeAngle % 360  --planes: 1683, 14553, 10757
	APosZ = APosZ + 45
	BPosZ = APosZ -- fixed height for plane to fly
	UPosX = BPosX - APosX
	UPosY = BPosY - APosY
	UPosZ = BPosZ - APosZ
	ULen = math.sqrt(UPosX*UPosX + UPosY*UPosY + UPosZ*UPosZ) --U stands for normalized units among line intersecting the points
	UPosX = UPosX / ULen
	UPosY = UPosY / ULen
	UPosZ = UPosZ / ULen
	planeX = APosX + UPosX * -250
	planeY = APosY + UPosY * -250
	planeMoveX = APosX + UPosX * 500
	planeMoveY = APosY + UPosY * 500
	carpetBomber = createObject ( 14553, planeX, planeY, APosZ, 14, 0, planeAngle )
	dropBay = createObject ( 14548, planeX - 0.005279, planeY + 3.635193, APosZ + 0.637207, 14, 0, planeAngle ) --plane's cargo bay
	attachElements ( dropBay, carpetBomber )
	loggedTick = getTickCount ()	
    addEventHandler ( "onClientRender", root, CBdrop )   

	setTimer (function()
	removeEventHandler ( "onClientRender", root, CBdrop ) 
	triggerServerEvent ( "serverCarpetBombFinished", getRootElement() )
	for k,v in pairs(bombs) do
		destroyElement ( bombs[k].bomb )
	end 
	bombs = {}	 
	count = 1
	startDropping = false
	destroyElement ( carpetBomber )
	destroyElement ( dropBay ) 
	end, 10000, 1 )
	
	distanceX = planeX - planeMoveX
	distanceY = planeY - planeMoveY
	--Normalized distance, despite point B location. Travel time = "mph" * line units in direction
    flightDistance = math.sqrt( distanceX*distanceX + distanceY*distanceY )
	flightTime = flightDistance * 14
	moveObject ( carpetBomber, flightTime, planeMoveX, planeMoveY, APosZ )
end
addEvent("ClientFireCB",true)
addEventHandler("ClientFireCB", getRootElement(), FireCB)

function CBdrop ()
		local planeX, planeY, planeZ = getElementPosition ( carpetBomber )
		local planeRotX, planeRotY, planeRotZ = getElementRotation ( carpetBomber )
		
		for k,v in pairs(bombs) do
			local x, y, z = getElementPosition ( bombs[k].bomb )
			if z <= bombs[k].zHeight then
				createExplosion ( x, y, z, 7 )
                destroyElement ( bombs[k].bomb )
				bombs[k] = nil
			end
		end

		if ( planeX - AAPosX < 1 ) and ( planeX - AAPosX > -1 ) then --Wait to drop until APosX for lack of better way to do it that I know
			startDropping = true
		end

		currentTick = getTickCount ()

	    if ( currentTick - loggedTick >= 150 ) and ( startDropping == true ) and ( count <= 16 --[[only drop this many bombs]]) then
            loggedTick = getTickCount ()
    		bomb = createObject ( 3790, planeX + UPosX * -32 --[[drop at bay door]], planeY + UPosY * -32, planeZ, planeRotX, planeRotY, planeRotZ + 90 ) --bombs. +90 due to weird original rotation
			bombDriftX = math.random (-40,40) + planeX + UPosX * -15
			bombDriftY = math.random (-40,40) + planeY + UPosY * -15
    		zHeight = getGroundPosition ( bombDriftX, bombDriftY, planeZ, 0, 0, planeAngle )
    		moveObject ( bomb, 2500, bombDriftX, bombDriftY, zHeight )
    		bombs[count] = { }
    		bombs[count].bomb = bomb
    		bombs[count].zHeight = zHeight
    		count = count + 1
    	end
end