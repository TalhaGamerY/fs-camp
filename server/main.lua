local PlayerObjects = {}

-- Item Usage Registration
Citizen.CreateThread(function()
    for key, data in pairs(Config.CampObjects) do
        exports.ox_inventory:registerHook('createItem', function(payload)
            -- This is where you'd handle item metadata if needed
        end)
        
        -- ESX / QB logic for usable items
        if Config.Framework == "ESX" then
            local ESX = exports['es_extended']:getSharedObject()
            ESX.RegisterUsableItem(data.item, function(source)
                TriggerClientEvent('camping:startPlacement', source, key)
            end)
        else
            local QBCore = exports['qb-core']:GetCoreObject()
            QBCore.Functions.CreateUseableItem(data.item, function(source)
                TriggerClientEvent('camping:startPlacement', source, key)
            end)
        end
    end
end)

RegisterNetEvent('camping:server:spawnObject')
AddEventHandler('camping:server:spawnObject', function(objKey, coords, heading)
    local src = source
    local cfg = Config.CampObjects[objKey]
    
    if not PlayerObjects[src] then PlayerObjects[src] = {} end
    if #PlayerObjects[src] >= Config.MaxObjectsPerPlayer then
        return TriggerClientEvent('ox_lib:notify', src, {type = 'error', description = 'Object limit reached!'})
    end

    local obj = CreateObjectNoOffset(cfg.model, coords.x, coords.y, coords.z, true, true, false)
    SetEntityHeading(obj, heading)
    
    local netId = NetworkGetNetworkIdFromEntity(obj)
    table.insert(PlayerObjects[src], {netId = netId, key = objKey})
    
    if cfg.type == "tent" then
        exports.ox_inventory:RegisterStash('tent_' .. netId, cfg.label, cfg.storage.slots, cfg.storage.weight)
    end

    exports.ox_inventory:RemoveItem(src, cfg.item, 1)
    TriggerClientEvent('camping:client:syncObject', -1, netId, objKey, src)
end)

RegisterNetEvent('camping:server:removeObject')
AddEventHandler('camping:server:removeObject', function(netId)
    local src = source
    local entity = NetworkGetEntityFromNetworkId(netId)
    
    if DoesEntityExist(entity) then
        local model = GetEntityModel(entity)
        local itemToGive = nil
        
        for k, v in pairs(Config.CampObjects) do
            if v.model == model then itemToGive = v.item break end
        end

        DeleteEntity(entity)
        if itemToGive then exports.ox_inventory:AddItem(src, itemToGive, 1) end
    end
end)

RegisterNetEvent('camping:server:cook')
AddEventHandler('camping:server:cook', function(recipeIndex)
    local src = source
    local recipe = Config.Recipes[recipeIndex]
    
    -- Verify Ingredients
    for _, ingredient in ipairs(recipe.input) do
        local count = exports.ox_inventory:GetItemCount(src, ingredient.item)
        if count < ingredient.count then
            return TriggerClientEvent('ox_lib:notify', src, {type = 'error', description = 'Missing ingredients!'})
        end
    end

    -- Process
    for _, ingredient in ipairs(recipe.input) do
        exports.ox_inventory:RemoveItem(src, ingredient.item, ingredient.count)
    end
    exports.ox_inventory:AddItem(src, recipe.output, 1)
end)

AddEventHandler('playerDropped', function()
    local src = source
    if Config.CleanupOnDisconnect and PlayerObjects[src] then
        for _, data in ipairs(PlayerObjects[src]) do
            local entity = NetworkGetEntityFromNetworkId(data.netId)
            if DoesEntityExist(entity) then DeleteEntity(entity) end
        end
        PlayerObjects[src] = nil
    end
end)