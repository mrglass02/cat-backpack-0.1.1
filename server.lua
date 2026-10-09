local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateUseableItem('a_back_pack_with_a_cat_in_it', function(source, item)
    local src = source
    TriggerClientEvent('cat_backpack:client:ToggleBackpack', src)
end)