root = getRootElement ()
players = getElementsByType ( "player" )
IC_Trigger = false
IC_Active = false

function ResourceStartIC ( name, root )
	for k,v in ipairs(players) do
   		bindKey ( v, "i", "down", placeICBeacon )
	end
end
addEventHandler ( "onResourceStart", getResourceRootElement(getThisResource()), ResourceStartIC )


function ICPlayerJoin ()
	bindKey ( source, "i", "down", placeICBeacon )
end
addEventHandler ( "onPlayerJoin", root, ICPlayerJoin )

function placeICBeacon ( player, key, state )
	if ( IC_Trigger == false ) and ( IC_Active == false ) then
		IC_Trigger = true
		defineLaunchType = key		 
		showCursor ( player, true ) 
		outputChatBox ( "Click para activar el canon de iones. Presiona otravez la tecla para Desactivar.", player, 105, 252, 55 )
	elseif ( IC_Trigger == true ) then --Cancel activation
		IC_Trigger = false
		defineLaunchType = nil
		showCursor ( player, false )
		outputChatBox ( "Canon de Iones Desactivado.", player, 105, 252, 55 )	
	end    	
end

function playerClick ( button, state, clickedElement, x, y, z )   
	if ( IC_Active ~= false ) then
		outputChatBox ( "", source, 105, 252, 55 )
	end 
	if ( button ~= "left" ) or ( state ~= "down" ) or ( defineLaunchType ~= "i" ) then return end
	showCursor ( source, false )
	IC_Trigger = false
	IC_Active = true
	defineLaunchType = nil --reset stuff
	triggerClientEvent ( "ClientFireIC", getRootElement(), x, y, z )
end
addEventHandler ( "onPlayerClick", root, playerClick )

function IonCannonFinished ()
	IC_Active = false	
end
addEvent("serverIonCannonFinished", true) 
addEventHandler("serverIonCannonFinished", root, IonCannonFinished)