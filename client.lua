--aktuell


local currentPlate = nil

-- 1. HAUPT-LOOP: Erkennt Ein-/Ausstieg und sendet Daten an Server
CreateThread(function()

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

                Wait(500) 
                
                local model = GetEntityModel(vehicle)
                local fuel = GetVehicleFuelLevel(vehicle)
                local coords = GetEntityCoords(vehicle)
                local heading = GetEntityHeading(vehicle)

                

                print("Plate: " .. tostring(plate) .. " | Model: " .. tostring(model) .. " | Fuel: " .. tostring(fuel))

                if model and fuel then
                    -- Sende jetzt auch die echten Koordinaten
                    TriggerServerEvent("persistentvehicle:update", plate, model, fuel, coords.x, coords.y, coords.z, heading, props, {})
                else

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
                currentPlate = nil
            end
        end
    end
end)


--neue version -> muss vom server getriggert werden
RegisterNetEvent('persistentVehicle:client:spawnVehicle', function(_model, x, y, z, heading, plate, fuel, vehicleConfig, vehicleDamage)
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
    else
        print("^1Error: Can not spawn vehicle (Hash: " .. tostring(modelHash) .. ")")
    end


end)

AddEventHandler('onClientResourceStart', function (resourceName)
    if GetCurrentResourceName() ~= resourceName  then
        return 
    end

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

        if model and fuel then
            -- Sende jetzt auch die echten Koordinaten!
            TriggerServerEvent("persistentvehicle:update", plate, model, fuel, coords.x, coords.y, coords.z, heading)
        end 
    end
end)