local framework = {}

if Config.Framework == 'qbcore' then
    framework = QBBridge
elseif Config.Framework == 'esx' then
    framework = ESXBridge
else
    print("Unknown framework:" .. Config.Framework)
end


local PlayerVehicles = {}

local SpawnedPlates = {}

local CachedVehicles = {}

local function RequestVehiclesFromDBToRAM()
    CachedVehicles = MySQL.query.await("SELECT * FROM persistent_vehicles")

    if not CachedVehicles then
        print("^3[" .. GetCurrentResourceName() .. "]^7 Keine geparkten Fahrzeuge zum Laden gefunden.")
        return 
    end
end

RegisterNetEvent('persistentVehicle:server:clientReady', function ()
    local src = source 

    if not CachedVehicles then return end 

    if #CachedVehicles == #SpawnedPlates then
        print('[INFO] All vehicles spawned')
        return
    end

    for _,vehicle in pairs(CachedVehicles) do
        if not SpawnedPlates[vehicle.plate] then
            TriggerClientEvent('persistentVehicle:client:spawnVehicle', src, vehicle.model, vehicle.x, vehicle.y, vehicle.z+0.5, vehicle.heading, vehicle.plate, vehicle.fuel)
            SpawnedPlates[vehicle.plate] = true
            print("Spawned plate: " .. vehicle.plate)
        end
        

    end
end)


local function CreateDatabaseIfNotExist()
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS persistent_vehicles (
            plate VARCHAR(20) NOT NULL,
            owner VARCHAR(80) NOT NULL,
            model VARCHAR(100) NOT NULL,
            fuel FLOAT DEFAULT 100,
            x DOUBLE NOT NULL,
            y DOUBLE NOT NULL,
            z DOUBLE NOT NULL,
            heading FLOAT NOT NULL,

            PRIMARY KEY (plate),

            INDEX idx_owner (owner)
        )
    ]])

    print("^2[" .. GetCurrentResourceName() .. "]^7 Database checked.")
end


-- 1. SERVER-START: Lade ALLE Fahrzeuge aus der DB und spawn sie
AddEventHandler('onResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end

    if Config.AutoCreateTableInDB == true then
        CreateDatabaseIfNotExist()
    end
    

    Wait(5000)

    RequestVehiclesFromDBToRAM()
    print("GEFUNDENE FAHRZEUGE: " .. #CachedVehicles)
    print("ERFOLG")
end)


-- 3. SPEICHERN: Beim Update (Einsteigen) in RAM und DB speichern
RegisterNetEvent("persistentvehicle:update", function(plate, model, fuel, x, y, z, heading)
    local src = source
    local Player = nil
    if Config.Framework == 'qbcore' then
        Player = framework.Player.GetPlayer(src)
    else 
        Player = nil
    end

    if not Player then return end
    
    local owner = framework.Player.GetID(src)
    
    PlayerVehicles[owner] = PlayerVehicles[owner] or {}
    
    PlayerVehicles[owner][plate] = {
        model = model,
        fuel = fuel,
        x = x,
        y = y,
        z = z,
        heading = heading,
        dirty = true
    }
end)

local function WritePlayerVehiclesToDB()
    for owner, vehicles in pairs(PlayerVehicles) do
        for plate, data in pairs(vehicles) do
            if data.dirty then
                MySQL.insert([[
                    INSERT INTO persistent_vehicles 
                    (plate, owner, model, fuel, x, y, z, heading) 
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?)
                    ON DUPLICATE KEY UPDATE 
                        model = VALUES(model), fuel = VALUES(fuel),
                        x = VALUES(x), y = VALUES(y), z = VALUES(z), heading = VALUES(heading)
                    ]], {
                    plate, owner, data.model, data.fuel, data.x, data.y, data.z, data.heading
                })
                data.dirty = false
            end
        end
    end
    print("^3[" .. GetCurrentResourceName() .. "]^7 Vehicle-data safed to DB.")
end


AddEventHandler('playerDropped', function (reason)
    local src = source 
    local Player = framework.Player.GetPlayer(src)

    if Player then
        TriggerClientEvent('persistentVehicle:client:sendCurrentPositions', src)
        Wait(10)
        WritePlayerVehiclesToDB()
        print(src, "Dropped: ", reason)
    end
end)


AddEventHandler('onResourceStop', function (resource)
    if resource == GetCurrentResourceName() then
        print("Resource stopped > saving all current player vehicles...")
        TriggerClientEvent('persistentVehicle:client:sendCurrentPositions', -1)
        Wait(10)
        WritePlayerVehiclesToDB()
    end
    
end)


--main loop
CreateThread(function()
    while true do
        Wait(Config.DBUpdateInterval)
        WritePlayerVehiclesToDB()
    end
end)

-- 5. SCHLÜSSEL

RegisterNetEvent('persistentvehicle:server:giveKeys', function(plate)
    local src = source
    local Player = nil

    if Config.Framework == 'qbcore' then
        Player = framework.Player.GetPlayer(src)
        exports['qb-vehiclekeys']:GiveKeys(src, plate)
    end
   
    if not Player then return end
end)


-- Debug Command
RegisterCommand("pvdebug", function(src, args, rawCommand)
    if src == 0 then
        print(json.encode(PlayerVehicles, { indent = true }))
    end
end, false)   