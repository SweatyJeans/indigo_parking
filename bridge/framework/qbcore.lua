QBBridge = {}
QBBridge.Player = {}

function QBBridge.Player.GetPlayer(src)
    return exports['qb-core']:GetCoreObject().Functions.GetPlayer(src)
end


--citizenid on qb-core | Identifier on esx
function QBBridge.Player.GetID(src)
    return exports['qb-core']:GetCoreObject().Functions.GetPlayer(src).PlayerData.citizenid
end

return QBBridge