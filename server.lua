ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('tape', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('nkhd_changePlate:applyTape', source)
end)

ESX.RegisterUsableItem('tape_remover', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('nkhd_changePlate:removeTape', source)
end)

RegisterServerEvent('nkhd_changePlate:removeTapeItem')
AddEventHandler('nkhd_changePlate:removeTapeItem', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if xPlayer then
        xPlayer.removeInventoryItem('tape', 1)
    else
        print("Error: Player not found - player ID: " .. _source) -- Debug
    end
end)