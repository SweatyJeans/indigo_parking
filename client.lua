--aktuell

--print("Persistent Vehicles Client gestartet")

local currentPlate = nil

-- 1. HAUPT-LOOP: Erkennt Ein-/Ausstieg und sendet Daten an Server
CreateThread(function()
    --print("TEST CLIENT THREAD STARTED")
    while true do
        Wait(1000)
        local ped = PlayerPedId()
        
        if IsPedInAnyVehicle(ped, false) then
            local vehicle = GetVehiclePedIsIn(ped, false)
            local plate = GetVehicleNumberPlateText(vehicle)
            local props = lib.getVehicleProperties(vehicle)
            
            -- Nur wenn neues Fahrzeug erkannt
            if plate ~= currentPlate and plate ~= "" then
                currentPlate = plate

                --print("PROPS: " .. json.encode(props))
                
                --print("NEUES FAHRZEUG ERKANNT: " .. plate)
                --print("Versuche Daten zu lesen...")

                -- Kurze Wartezeit für Synchronisation
                Wait(500) 
                
                local model = GetEntityModel(vehicle)
                local fuel = GetVehicleFuelLevel(vehicle)
                local coords = GetEntityCoords(vehicle)
                local heading = GetEntityHeading(vehicle)

                

                print("Plate: " .. tostring(plate) .. " | Model: " .. tostring(model) .. " | Fuel: " .. tostring(fuel))

                if model and fuel then
                    --print("Alle Daten gültig, sende Event...")
                    -- Sende jetzt auch die echten Koordinaten
                    TriggerServerEvent("persistentvehicle:update", plate, model, fuel, coords.x, coords.y, coords.z, heading, props, {})
                    --print("Event gesendet!")
                else
                    --print("^1Error: ")
                end
            end
        else
            if currentPlate ~= nil then
                local vehicle = GetVehiclePedIsIn(ped, true) 
                local plate = GetVehicleNumberPlateText(vehicle) 

                local model = GetEntityModel(vehicle)
                local fuel = GetVehicleFuelLevel(vehicle)
                local coords = GetEntityCoords(vehicle)
                local heading = GetEntityHeading(vehicle)
                local props = lib.getVehicleProperties(vehicle)

                print("PROPS: " .. json.encode(props))

                TriggerServerEvent("persistentvehicle:update", plate, model, fuel, coords.x, coords.y, coords.z, heading, props, {})
                --print("Safed Data")
                --print("AUSGESTIEGEN (Letztes Plate: " .. currentPlate .. ")")
                currentPlate = nil
            end
        end
    end
end)

--[[
-- 2. SPAWN EVENT: Wird vom Server beim Login ausgel st, wenn ein geparktes Auto existiert
RegisterNetEvent('persistentvehicle:client:spawnCar', function(plate, x, y, z, heading, model, fuel)
    print("^2[SYSTEM]^7 Empfange Spawn-Daten f r: " .. plate)
    
    local ped = PlayerPedId()
    local coords = vector3(x, y, z)
    
    -- Sicherheitscheck: Ist das Auto vielleicht schon da? (Verhindert Dupes)
    local nearbyVeh = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 70)
    if nearbyVeh ~= 0 then
        local existingPlate = GetVehicleNumberPlateText(nearbyVeh)
        if existingPlate == plate then
            print("^3[WARNUNG]^7 Fahrzeug existiert bereits in der N he. Skip Spawn.")
            return
        end
    end

    -- Modell laden
    --local model = model
    -- Falls data.model ein String ist (z.B. "adder"), muss er evtl. noch gehasht werden, 
    -- aber GetHashKey macht das automatisch oder akzeptiert den String oft auch.
    -- Zur Sicherheit:
    if type(model) == "string" then model = GetHashKey(model) end

    RequestModel(model)
    while not HasModelLoaded(model) do 
        Wait(0) 
    end

    print("Spawned Vehicle with Plate: ".. plate)

    -- Auto spawnen
    local veh = CreateVehicle(model, x, y, z, heading, true, false)
    
    -- Warten bis das Fahrzeug bereit ist
    while not DoesEntityExist(veh) do Wait(0) end

    SetVehicleNumberPlateText(veh, plate)
    SetVehicleFuelLevel(veh, fuel or 100.0)
    SetVehicleOnGroundProperly(veh)
    SetEntityAsMissionEntity(veh, true, true)
    
    print("^2[ERFOLG]^7 Persistent Vehicle gespawnt: " .. plate .. " bei " .. x .. ", " .. y)
end)
]]

--[[
RegisterNetEvent('persistentvehicle:lockVehicleDoors', function (vehicleNetId, plate, fuel)
    local vehicle = NetToVeh(vehicleNetId)
    local timeout = 0

    while not DoesEntityExist(vehicle) and timeout < 50 do
        Wait(100)
        vehicle = NetToVeh(vehicleNetId)
        timeout = timeout + 1
    end

    if DoesEntityExist(vehicle) then

        SetVehicleNumberPlateText(vehicle, plate) 
        SetVehicleFuelLevel(vehicle, fuel)
        SetVehicleRadioEnabled(vehicle, false)
        SetVehicleDoorsLocked(vehicle, 4)

        
        print("^3[" .. GetCurrentResourceName() .. "]^7 Configured vehicle with plate: " .. plate)
    end
end)

]]

--neue version -> muss vom server getriggert werden
RegisterNetEvent('persistentVehicle:client:spawnVehicle', function(_model, x, y, z, heading, plate, fuel, vehicleConfig, vehicleDamage)
    --print("SpawnVehicle Start")
    --local model = _model 
    local modelHash = _model

    if type(modelHash) == "string" then
        modelHash = tonumber(modelHash)
    end

    RequestModel(modelHash) 
    while not HasModelLoaded(modelHash) do Wait(0) end

    local vehicle = CreateVehicle(modelHash, x, y, z + 0.5, heading, true, false)

    local timeout = 0
    while not DoesEntityExist(vehicle) and timeout < 50 do
        Wait(0)
        timeout = timeout + 1
    end

    if DoesEntityExist(vehicle) then
        SetEntityAsMissionEntity(vehicle, true, true)
        SetModelAsNoLongerNeeded(modelHash)

        SetVehicleNumberPlateText(vehicle, plate) 
        SetVehicleFuelLevel(vehicle, fuel) 
        SetVehicleOnGroundProperly(vehicle) 
        SetVehicleRadioEnabled(vehicle, false) 
        
        if Config.LockVehiclesAtSpawn == true then
            SetVehicleDoorsLocked(vehicle, 2)
        end

        lib.setVehicleProperties(vehicle, json.decode(vehicleConfig))
        
        --print("CLIENT MODEL NAME: " .. modelHash)
        --print("CLIENT PLATE: " .. plate)
    else
        print("^1Error: Can not spawn vehicle (Hash: " .. tostring(modelHash) .. ")")
    end


end)

AddEventHandler('onClientResourceStart', function (resourceName)
    if GetCurrentResourceName() ~= resourceName  then
        return 
    end

    --print("CLIENT RESOURCE STARTED")

    TriggerServerEvent('persistentVehicle:server:clientReady')
end)


RegisterNetEvent('persistentVehicle:client:sendCurrentPositions', function()
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        local vehicle = GetVehiclePedIsIn(ped, false)
        local plate = GetVehicleNumberPlateText(vehicle)
        

        
        local model = GetEntityModel(vehicle)
        local fuel = GetVehicleFuelLevel(vehicle)
        local coords = GetEntityCoords(vehicle)
        local heading = GetEntityHeading(vehicle)


        --print("Plate: " .. tostring(plate) .. " | Model: " .. tostring(model) .. " | Fuel: " .. tostring(fuel))

        if model and fuel then
            --print("Alle Daten g ltig, sende Event...")
            -- Sende jetzt auch die echten Koordinaten!
            TriggerServerEvent("persistentvehicle:update", plate, model, fuel, coords.x, coords.y, coords.z, heading)
        end 
    end
end)