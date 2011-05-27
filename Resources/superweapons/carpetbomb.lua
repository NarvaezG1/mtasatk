root = getRootElement ()
players = getElementsByType ( "player" )
CB_Trigger = false
CB_Active = false
APosX = nil
BPosX = nil
	
function ResourceStartCB ( name, root )
	for k,v in ipairs(players) do
   		bindKey ( v, "b", "down", placeCBBeacon )
	end
end
addEventHandler ( "onResourceStart", getResourceRootElement(getThisResource()), ResourceStartCB )


function CBPlayerJoin ()
	bindKey ( source, "b", "down", placeCBBeacon )
end
addEventHandler ( "onPlayerJoin", root, CBPlayerJoin )

function placeCBBeacon ( player, key, state )
	if ( CB_Trigger == false ) and ( CB_Active == false ) then
		CB_Trigger = true
		defineLaunchType = key
		showCursor ( player, true )
		outputChatBox ( "Click 2 Veces para usar el Bombardeo. 1er click = Inicio 2nd click = Direccion.", player, 105, 252, 55 )
		outputChatBox ( "Presiona la Tecla de nuevo para Deactivar.", player, 105, 252, 55 )
	elseif ( CB_Trigger == true ) then --Cancel activation
		CB_Trigger = false
		defineLaunchType = nil
		showCursor ( player, false )
		APosX = nil
		outputChatBox ( "Bombardeo desactivado.", player, 105, 252, 55 )
	end
end

function playerClick ( button, state, clickedElement, x, y, z )
	if ( CB_Active ~= false ) then
		outputChatBox ( "", source, 105, 252, 55 )
	end

	if ( button ~= "left" ) or ( state ~= "down" ) or ( defineLaunchType ~= "b" ) then return end

	if APosX == nil then
	    APosX = x
	    APosY = y
	    APosZ = z
		return --requires 2nd point so return    
	end	
	if ( APosX == x ) then
		outputChatBox ( "El 2do click tiene que inidicar la Direccion, no puede ser el mismo Punto.", source, 105, 252, 55 )
	    return
	end
	BPosX = x
	BPosY = y
	BPosZ = z 
	showCursor ( source, false )
	CB_Trigger = false
	CB_Active = true
	defineLaunchType = nil --reset stuff
	triggerClientEvent ( "ClientFireCB", getRootElement(), APosX, APosY, APosZ, BPosX, BPosY, BPosZ )
end
addEventHandler ( "onPlayerClick", root, playerClick )

function CarpetBombFinished ()
	CB_Active = false
	APosX = nil
	BPosX = nil
end
addEvent("serverCarpetBombFinished", true)
addEventHandler("serverCarpetBombFinished", root, CarpetBombFinished)