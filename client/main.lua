local placedObjects = {}
local isPlacing = false

-- Framework Initialization
local Framework = nil
Citizen.CreateThread(function()
    if Config.Framework == "ESX" then
        while Framework == nil do
            TriggerEvent('esx:getSharedObject', function(obj) Framework = obj end)
            Citizen.Wait(0)
        end
    else
        Framework = exports['qb-core']:GetCoreObject()
    end
end)

-- Placement Logic
RegisterNetEvent('camping:startPlacement')
AddEventHandler('camping:startPlacement', function(objKey)
    if isPlacing then return end
    isPlacing = true
    
    local cfg = Config.CampObjects[objKey]
    lib.requestModel(cfg.model)
    
    local ghostObj = CreateObject(cfg.model, GetEntityCoords(cache.ped), false, true, false)
    SetEntityAlpha(ghostObj, 150, false)
    SetEntityCollision(ghostObj, false, false)
    
    local heading = 0.0
    local zOffset = 0.0

    lib.showTextUI('[E] Place | [Scroll] Rotate | [Shift+Scroll] Height | [X] Cancel')

    while isPlacing do
        local hit, _, coords, _, _ = lib.raycast.fromCamera(511)
        if hit then
            SetEntityCoords(ghostObj, coords.x, coords.y, coords.z + zOffset)
            SetEntityHeading(ghostObj, heading)
            PlaceObjectOnGroundProperly(ghostObj)
        end

        if IsControlJustPressed(0, 38) then -- E
            isPlacing = false
            local finalCoords = GetEntityCoords(ghostObj)
            local finalHeading = GetEntityHeading(ghostObj)
            DeleteEntity(ghostObj)
            TriggerServerEvent('camping:server:spawnObject', objKey, finalCoords, finalHeading)
        end

        if IsControlJustPressed(0, 73) then -- X
            isPlacing = false
            DeleteEntity(ghostObj)
        end

        -- Rotation and Height Adjustments
        if IsControlPressed(0, 21) then -- Shift
            if IsControlJustPressed(0, 15) then zOffset += 0.05 end
            if IsControlJustPressed(0, 16) then zOffset -= 0.05 end
        else
            if IsControlJustPressed(0, 15) then heading += 5.0 end
            if IsControlJustPressed(0, 16) then heading -= 5.0 end
        end
        
        Wait(0)
    end
    lib.hideTextUI()
end)

-- Object Sync & Targeting
RegisterNetEvent('camping:client:syncObject')
AddEventHandler('camping:client:syncObject', function(netId, objKey, owner)
    local timeout = 0
    while not NetworkDoesEntityExistWithNetworkId(netId) and timeout < 100 do
        Wait(10)
        timeout += 1
    end

    local entity = NetToObj(netId)
    local cfg = Config.CampObjects[objKey]
    
    local options = {
        {
            label = 'Pick Up ' .. cfg.label,
            icon = 'fa-solid fa-hand',
            onSelect = function()
                TriggerServerEvent('camping:server:removeObject', netId)
            end
        }
    }

    if cfg.type == "fire" then
        table.insert(options, {
            label = 'Cook Food',
            icon = 'fa-solid fa-utensils',
            onSelect = function() OpenCookingMenu() end
        })
    elseif cfg.type == "tent" then
        table.insert(options, {
            label = 'Open Storage',
            icon = 'fa-solid fa-box-open',
            onSelect = function()
                exports.ox_inventory:openInventory('stash', 'tent_' .. netId)
            end
        })
    elseif cfg.type == "seat" then
        table.insert(options, {
            label = 'Sit Down',
            icon = 'fa-solid fa-chair',
            onSelect = function()
                TaskStartScenarioAtPosition(cache.ped, "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER", GetEntityCoords(entity), GetEntityHeading(entity)+180.0, 0, false, true)
            end
        })
    end

    exports.ox_target:addLocalEntity(entity, options)
end)

function OpenCookingMenu()
    local menu = {}
    for i, recipe in ipairs(Config.Recipes) do
        table.insert(menu, {
            title = recipe.label,
            onSelect = function()
                if lib.progressBar({
                    duration = recipe.time,
                    label = 'Cooking...',
                    useWhileDead = false,
                    canCancel = true,
                    anim = recipe.anim
                }) then
                    TriggerServerEvent('camping:server:cook', i)
                end
            end
        })
    end
    lib.registerContext({ id = 'camp_cook', title = 'Campfire Cooking', options = menu })
    lib.showContext('camp_cook')
end