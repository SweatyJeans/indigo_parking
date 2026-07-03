--aktuell


local currentPlate = nil


local vehicleDamage = {}
vehicleDamage.Wheels = {}
vehicleDamage.Wheels.isBurstToRim = {}
vehicleDamage.Windows = {}
vehicleDamage.Doors = {}


CreateThread(function()

    while true do
        Wait(1000)
        local ped = PlayerPedId()
        
        if IsPedInAnyVehicle(ped, false) then
            local vehicle = GetVehiclePedIsIn(ped, false)
            local plate = GetVehicleNumberPlateText(vehicle)
            local props = lib.getVehicleProperties(vehicle)

            if plate ~= currentPlate and plate ~= "" then
                currentPlate = plate

                Wait(500) 
                
                local model = GetEntityModel(vehicle)
                local fuel = GetVehicleFuelLevel(vehicle)
                local coords = GetEntityCoords(vehicle)
                local heading = GetEntityHeading(vehicle)

                local vehicleType = GetVehicleType(vehicle) 

                if vehicleType == 'automobile' then

                    vehicleDamage.EngineHealth = GetVehicleEngineHealth(vehicle)
                    vehicleDamage.CurrentGear = GetVehicleCurrentGear(vehicle) 

                    vehicleDamage.BodyHealth = GetVehicleBodyHealth(vehicle)

                    vehicleDamage.DirtLevel = GetVehicleDirtLevel(vehicle) 

                    vehicleDamage.Wheels.frontLeft = IsVehicleTyreBurst(vehicle, 0, false)
                    vehicleDamage.Wheels.frontRight = IsVehicleTyreBurst(vehicle, 1, false)
                    vehicleDamage.Wheels.rearLeft = IsVehicleTyreBurst(vehicle, 4, false)
                    vehicleDamage.Wheels.rearRight = IsVehicleTyreBurst(vehicle, 5, false)

                    vehicleDamage.Wheels.isBurstToRim.frontLeft = IsVehicleTyreBurst(vehicle, 0, true)
                    vehicleDamage.Wheels.isBurstToRim.frontRight = IsVehicleTyreBurst(vehicle, 1, true)
                    vehicleDamage.Wheels.isBurstToRim.rearLeft = IsVehicleTyreBurst(vehicle, 4, true)
                    vehicleDamage.Wheels.isBurstToRim.rearRight = IsVehicleTyreBurst(vehicle, 5, true)

                    vehicleDamage.Windows.frontLeft = IsVehicleWindowIntact(vehicle, 0)
                    vehicleDamage.Windows.frontRight = IsVehicleWindowIntact(vehicle, 1)
                    vehicleDamage.Windows.rearLeft = IsVehicleWindowIntact(vehicle, 2)
                    vehicleDamage.Windows.rearRight = IsVehicleWindowIntact(vehicle, 3)

                    vehicleDamage.Doors.frontLeft = IsVehicleDoorDamaged(vehicle, 0)
                    vehicleDamage.Doors.frontRight = IsVehicleDoorDamaged(vehicle, 1)
                    vehicleDamage.Doors.rearLeft = IsVehicleDoorDamaged(vehicle, 2)
                    vehicleDamage.Doors.rearRight = IsVehicleDoorDamaged(vehicle, 3)
                    vehicleDamage.Doors.Hood = IsVehicleDoorDamaged(vehicle, 4)
                    vehicleDamage.Doors.Trunk = IsVehicleDoorDamaged(vehicle, 5)

                elseif vehicleType == 'bike' then

                    vehicleDamage.Wheels.frontLeft = IsVehicleTyreBurst(vehicle, 0, false)
                    vehicleDamage.Wheels.rearLeft = IsVehicleTyreBurst(vehicle, 4, false)

                    vehicleDamage.Wheels.isBurstToRim.frontLeft = IsVehicleTyreBurst(vehicle, 0, true)
                    vehicleDamage.Wheels.isBurstToRim.rearLeft = IsVehicleTyreBurst(vehicle, 4, true)

                    vehicleDamage.EngineHealth = GetVehicleEngineHealth(vehicle)
                    vehicleDamage.BodyHealth = GetVehicleBodyHealth(vehicle)
                end


                if model and fuel then
                    TriggerServerEvent("persistentvehicle:update", plate, model, fuel, coords.x, coords.y, coords.z, heading, props, vehicleDamage)
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

                local vehicleType = GetVehicleType(vehicle) 

                if vehicleType == 'automobile' then

                    vehicleDamage.EngineHealth = GetVehicleEngineHealth(vehicle)
                    vehicleDamage.CurrentGear = GetVehicleCurrentGear(vehicle) 

                    vehicleDamage.BodyHealth = GetVehicleBodyHealth(vehicle)

                    vehicleDamage.DirtLevel = GetVehicleDirtLevel(vehicle) 

                    vehicleDamage.Wheels.frontLeft = IsVehicleTyreBurst(vehicle, 0, false)
                    vehicleDamage.Wheels.frontRight = IsVehicleTyreBurst(vehicle, 1, false)
                    vehicleDamage.Wheels.rearLeft = IsVehicleTyreBurst(vehicle, 4, false)
                    vehicleDamage.Wheels.rearRight = IsVehicleTyreBurst(vehicle, 5, false)

                    vehicleDamage.Wheels.isBurstToRim.frontLeft = IsVehicleTyreBurst(vehicle, 0, true)
                    vehicleDamage.Wheels.isBurstToRim.frontRight = IsVehicleTyreBurst(vehicle, 1, true)
                    vehicleDamage.Wheels.isBurstToRim.rearLeft = IsVehicleTyreBurst(vehicle, 4, true)
                    vehicleDamage.Wheels.isBurstToRim.rearRight = IsVehicleTyreBurst(vehicle, 5, true)

                    vehicleDamage.Windows.frontLeft = IsVehicleWindowIntact(vehicle, 0)
                    vehicleDamage.Windows.frontRight = IsVehicleWindowIntact(vehicle, 1)
                    vehicleDamage.Windows.rearLeft = IsVehicleWindowIntact(vehicle, 2)
                    vehicleDamage.Windows.rearRight = IsVehicleWindowIntact(vehicle, 3)

                    vehicleDamage.Doors.frontLeft = IsVehicleDoorDamaged(vehicle, 0)
                    vehicleDamage.Doors.frontRight = IsVehicleDoorDamaged(vehicle, 1)
                    vehicleDamage.Doors.rearLeft = IsVehicleDoorDamaged(vehicle, 2)
                    vehicleDamage.Doors.rearRight = IsVehicleDoorDamaged(vehicle, 3)
                    vehicleDamage.Doors.Hood = IsVehicleDoorDamaged(vehicle, 4)
                    vehicleDamage.Doors.Trunk = IsVehicleDoorDamaged(vehicle, 5)

                elseif vehicleType == 'bike' then

                    vehicleDamage.Wheels.frontLeft = IsVehicleTyreBurst(vehicle, 0, false)
                    vehicleDamage.Wheels.rearLeft = IsVehicleTyreBurst(vehicle, 4, false)

                    vehicleDamage.Wheels.isBurstToRim.frontLeft = IsVehicleTyreBurst(vehicle, 0, true)
                    vehicleDamage.Wheels.isBurstToRim.rearLeft = IsVehicleTyreBurst(vehicle, 4, true)

                    vehicleDamage.EngineHealth = GetVehicleEngineHealth(vehicle)
                    vehicleDamage.BodyHealth = GetVehicleBodyHealth(vehicle)
                end



                

                TriggerServerEvent("persistentvehicle:update", plate, model, fuel, coords.x, coords.y, coords.z, heading, props, vehicleDamage)
                currentPlate = nil
            end
        end
    end
end)


RegisterNetEvent('persistentVehicle:client:spawnVehicle', function(_model, x, y, z, heading, plate, fuel, vehicleConfig, _vehicleDamage)
    local modelHash = _model

    local damageData = json.decode(_vehicleDamage or "{}") or {}

    damageData.Wheels = damageData.Wheels or {}
    damageData.Wheels.isBurstToRim = damageData.Wheels.isBurstToRim or {}
    damageData.Windows = damageData.Windows or {}

    if type(modelHash) == "string" then
        modelHash = tonumber(modelHash)
    end

    RequestModel(modelHash) 
    while not HasModelLoaded(modelHash) do Wait(0) end

    local vehicle = CreateVehicle(modelHash, x, y, z + 0.5, heading, true, false)
    local vehicleType = nil

    local timeout = 0
    while not DoesEntityExist(vehicle) and timeout < 50 do
        Wait(0)
        timeout = timeout + 1
    end

    if DoesEntityExist(vehicle) then
        vehicleType = GetVehicleType(vehicle)
        SetEntityAsMissionEntity(vehicle, true, true)
        SetModelAsNoLongerNeeded(modelHash)

        SetVehicleNumberPlateText(vehicle, plate) 
        SetVehicleFuelLevel(vehicle, fuel) 
        SetVehicleOnGroundProperly(vehicle) 
        
        if Config.LockVehiclesAtSpawn == true then
            SetVehicleDoorsLocked(vehicle, 2)
        end

        lib.setVehicleProperties(vehicle, json.decode(vehicleConfig))


        if vehicleType == 'automobile' then

            SetVehicleEngineHealth(vehicle, damageData.EngineHealth)
            
            SetVehicleBodyHealth(vehicle, damageData.BodyHealth)
            SetVehicleDirtLevel(vehicle, damageData.DirtLevel)

            if damageData.Wheels.frontLeft then SetVehicleTyreBurst(vehicle, 0, false, 1000.0) end
            if damageData.Wheels.frontRight then SetVehicleTyreBurst(vehicle, 1, false, 1000.0) end
            if damageData.Wheels.rearLeft then SetVehicleTyreBurst(vehicle, 4, false, 1000.0) end
            if damageData.Wheels.rearRight then SetVehicleTyreBurst(vehicle, 5, false, 1000.0) end

            if damageData.Wheels.isBurstToRim.frontLeft then SetVehicleTyreBurst(vehicle, 0, true, 1000.0) end
            if damageData.Wheels.isBurstToRim.frontRight then SetVehicleTyreBurst(vehicle, 1, true, 1000.0) end
            if damageData.Wheels.isBurstToRim.rearLeft then SetVehicleTyreBurst(vehicle, 4, true, 1000.0) end
            if damageData.Wheels.isBurstToRim.rearRight then SetVehicleTyreBurst(vehicle, 5, true, 1000.0) end

            if damageData.Windows.frontLeft == false then SmashVehicleWindow(vehicle, 0) end
            if damageData.Windows.frontRight == false then SmashVehicleWindow(vehicle, 1) end
            if damageData.Windows.rearLeft == false then SmashVehicleWindow(vehicle, 2) end
            if damageData.Windows.rearRight == false then SmashVehicleWindow(vehicle, 3) end

            if damageData.Doors.frontLeft then SetVehicleDoorBroken(vehicle, 0, true) end
            if damageData.Doors.frontRight then SetVehicleDoorBroken(vehicle, 1, true) end
            if damageData.Doors.rearLeft then SetVehicleDoorBroken(vehicle, 2, true) end
            if damageData.Doors.rearRight then SetVehicleDoorBroken(vehicle, 3, true) end
            if damageData.Doors.Hood then SetVehicleDoorBroken(vehicle, 4, true) end --Motorhaube
            if damageData.Doors.Trunk then SetVehicleDoorBroken(vehicle, 5, true) end --Kofferraum

        elseif vehicleType == 'bike' then

            if damageData.Wheels.frontLeft then SetVehicleTyreBurst(vehicle, 0, false, 1000.0) end
            if damageData.Wheels.rearLeft then SetVehicleTyreBurst(vehicle, 4, false, 1000.0) end
            
            if damageData.Wheels.isBurstToRim.frontLeft then SetVehicleTyreBurst(vehicle, 0, true, 1000.0) end
            if damageData.Wheels.isBurstToRim.rearLeft then SetVehicleTyreBurst(vehicle, 4, true, 1000.0) end
            
            SetVehicleEngineHealth(vehicle, damageData.EngineHealth)
            SetVehicleBodyHealth(vehicle, damageData.BodyHealth)
        end   
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