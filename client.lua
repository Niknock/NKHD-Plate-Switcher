ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

local originalPlates = {}

RegisterNetEvent('nkhd_changePlate:applyTape')
AddEventHandler('nkhd_changePlate:applyTape', function()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if vehicle == 0 then
        local lastVehicle = GetVehiclePedIsIn(playerPed, true)
        
        if lastVehicle and IsVehicleStopped(lastVehicle) then
            local playerCoords = GetEntityCoords(playerPed)
            local vehicleCoords = GetEntityCoords(lastVehicle)

            if #(playerCoords - vehicleCoords) < 3.0 then -- If the Player is near the Rear of the Vehicle
                local plate = GetVehicleNumberPlateText(lastVehicle)
                originalPlates[lastVehicle] = plate
                SetVehicleNumberPlateText(lastVehicle, " ") -- If you want to change the Numberplate, you can set it here
                makePlateInvisible(lastVehicle)
                TriggerServerEvent('nkhd_changePlate:removeTapeItem')

                playAnimation()  -- Starts the Animation and the ProgressBar

            else
                ESX.ShowNotification("You need to be closer to the rear of the vehicle.") -- Edit this to your Language
            end
        else
            ESX.ShowNotification("No vehicle nearby.") -- Edit this to your Language
        end
    else
        ESX.ShowNotification("You must get out of the vehicle.") -- Edit this to your Language
    end
end)

RegisterNetEvent('nkhd_changePlate:removeTape')
AddEventHandler('nkhd_changePlate:removeTape', function()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, true)

    if vehicle and originalPlates[vehicle] then
        local playerCoords = GetEntityCoords(playerPed)
        local vehicleCoords = GetEntityCoords(vehicle)

        if #(playerCoords - vehicleCoords) < 3.0 then
            SetVehicleNumberPlateText(vehicle, originalPlates[vehicle])
            SetVehicleNumberPlateTextIndex(vehicle, 0) -- Set here your Numberplate ID, which you want to have, when it got scraped off
            originalPlates[vehicle] = nil

            playAnimationab(false)
        else
            ESX.ShowNotification("You need to be closer to the rear of the vehicle.") -- Edit this to your Language
        end
    else
        ESX.ShowNotification("No suitable vehicle nearby.") -- Edit this to your Language
    end 
end)


function makePlateInvisible(vehicle)
    SetVehicleNumberPlateTextIndex(vehicle, 5) -- Set here your Numberplate ID
end

function playAnimation()
    local playerPed = PlayerPedId()
    local animDict = "mini@repair" -- Edit your Animation here
    local animName = "fixing_a_ped"
    local duration = 5000 -- Duration of the Animation, Currently 5 Seconds

    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(100)
    end

    TaskPlayAnim(playerPed, animDict, animName, 8.0, -8.0, -1, 49, 0, false, false, false)

    exports['progressBars']:startUI(duration, "Tape is getting attached...") -- If you want to use your own ProgressBar, and your own Translation

    Citizen.Wait(duration)
    ClearPedTasks(playerPed)  -- Stops the Animation
end

function playAnimationab()
    local playerPed = PlayerPedId()
    local animDict = "mini@repair" -- Edit your Animation here
    local animName = "fixing_a_ped"
    local duration = 5000 -- Duration of the Animation, Currently 5 Seconds

    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(100)
    end

    TaskPlayAnim(playerPed, animDict, animName, 8.0, -8.0, -1, 49, 0, false, false, false)

    exports['progressBars']:startUI(duration, "Tape is getting scraped off...") -- If you want to use your own ProgressBar

    Citizen.Wait(duration)
    ClearPedTasks(playerPed)  -- Stops the Animation
end

function IsVehicleWithUndercoverPlate(vehicle)
    if originalPlates[vehicle] then
        return true
    else
        return false
    end
end

exports('IsVehicleWithUndercoverPlate', IsVehicleWithUndercoverPlate)
