root = getRootElement ()
outputChatBox ( "Super Armas de Ransom Cargado", root, 105, 252, 55 )
players = getElementsByType ( "player" )
N_Trigger = false
N_Active = false

function ResourceStartN ( name, root )
	for k,v in ipairs(players) do
   	bindKey ( v, "n", "down", placeNBeacon )
	end
end
addEventHandler ( "onResourceStart", getResourceRootElement(getThisResource()), ResourceStartN )


function NPlayerJoin ()
	bindKey ( source, "n", "down", placeNBeacon )
end
addEventHandler ( "onPlayerJoin", root, NPlayerJoin )

function placeNBeacon ( player, key, state )
	if ( N_Trigger == false ) and ( N_Active == false ) then
		N_Trigger = true
		defineLaunchType = key		 
		showCursor ( player, true ) 
		outputChatBox ( "Click para activar el nuke. Presiona otravez la tecla para desactivar.", player, 105, 252, 55 )
	elseif ( N_Trigger == true ) then --Cancel activation
		N_Trigger = false
		defineLaunchType = nil
		showCursor ( player, false )
		outputChatBox ( "Nuke Desactivado.", player, 105, 252, 55 )	
	end    	
end

function playerClick ( button, state, clickedElement, x, y, z )   
	if ( N_Active ~= false ) then
		outputChatBox ( "", source, 105, 252, 55 )
	end 
	if ( button ~= "left" ) or ( state ~= "down" ) or ( defineLaunchType ~= "n" ) then return end
	showCursor ( source, false )
	N_Trigger = false
	N_Active = true
	defineLaunchType = nil --reset stuff
	triggerClientEvent ( "ClientFireN", getRootElement(), x, y, z )
end
addEventHandler ( "onPlayerClick", root, playerClick )

function NukeFinished ()
	N_Active = false	
end
addEvent("serverNukeFinished", true) 
addEventHandler("serverNukeFinished", root, NukeFinished)

function KillNukedPlayer ()
	killPed ( source )
	outputChatBox ( "Has Muerto!", source, 105, 252, 55 )	
end
addEvent("serverKillNukedPlayer", true) 
addEventHandler("serverKillNukedPlayer", root, KillNukedPlayer)