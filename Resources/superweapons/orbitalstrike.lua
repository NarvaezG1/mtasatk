root = getRootElement ()
players = getElementsByType ( "player" )
OS_Trigger = false
OS_Active = false

function ResourceStartOS ( name, root )
	for k,v in ipairs(players) do
   		bindKey ( v, "o", "down", placeOSBeacon )
	end
end
addEventHandler ( "onResourceStart", getResourceRootElement(getThisResource()), ResourceStartOS )


function OSPlayerJoin ()
	bindKey ( source, "o", "down", placeOSBeacon )
end
addEventHandler ( "onPlayerJoin", root, OSPlayerJoin )

function placeOSBeacon ( player, key, state )
	if ( OS_Trigger == false ) and ( OS_Active == false ) then
		OS_Trigger = true
		defineLaunchType = key		 
		showCursor ( player, true ) 
		outputChatBox ( "Click para activar el ataque orbital. Press la tecla de nuevo para Desactivar.", player, 105, 252, 55 )
	elseif ( OS_Trigger == true ) then --Cancel activation
		OS_Trigger = false
		defineLaunchType = nil
		showCursor ( player, false )
		outputChatBox ( "Ataque Orbital Desactivado.", player, 105, 252, 55 )	
	end    	
end

function playerClick ( button, state, clickedElement, x, y, z )   
	if ( OS_Active ~= false ) then
		outputChatBox ( "", source, 105, 252, 55 )
	end 

	if ( button ~= "left" ) or ( state ~= "down" ) or ( defineLaunchType ~= "o" ) then return end
	showCursor ( source, false )
	OS_Trigger = false
	OS_Active = true
	defineLaunchType = nil --reset stuff
	triggerClientEvent ( "ClientFireOS", getRootElement(), x, y, z )
end
addEventHandler ( "onPlayerClick", root, playerClick )

function OrbitalStrikeFinished ()
	OS_Active = false	
end
addEvent("serverOrbitalStrikeFinished", true) 
addEventHandler("serverOrbitalStrikeFinished", root, OrbitalStrikeFinished)