ESXBridge = {}
ESXBridge.Player = {}


function ESXBridge.Player.GetPlayer(src)
    return exports['es_extended']:getSharedObject().GetPlayerFromId(src)
end


--citizenid on qb-core | Identifier on esx
function ESXBridge.Player.GetID(src)
    return exports['es_extended']:getSharedObject().GetPlayerFromId(src).identifier
end

return ESXBridge