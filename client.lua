local QBCore = exports['qb-core']:GetCoreObject()

local function spawnObjects()
    for k,v in pairs (Config.Props) do
        print("spawning")
        RequestModel(v.model)
        while not HasModelLoaded(v.model) do
            Wait(0)
        end
        if v.create then
            local created_object = CreateObjectNoOffset(v.model, v.coords.x, v.coords.y, v.coords.z - 1, 1, 0, 1)
            PlaceObjectOnGroundProperly(created_object)
            SetEntityHeading(created_object, v.coords.w)
            v.objectHandle = created_object
        else
            local obj = GetClosestObjectOfType(v.coords.x, v.coords.y, v.coords.z, 3.0, GetHashKey(v.model), false, false, false)
            v.objectHandle = obj
        end
        if v.objectHandle ~= nil then
            FreezeEntityPosition(v.objectHandle, true)
            exports["ox_target"]:addLocalEntity(v.objectHandle, {
                [1] = {
                    label = Lang:t("interaction.opentrash"),
                    icon = "fa-solid fa-recycle",
                    onSelect = function(data)
                        options = {
                            maxweight = 5000000,
                            slots = 200,
                        }
                        TriggerServerEvent('inventory:server:OpenInventory', 'stash', "trash_" .. k, options)
                        TriggerEvent('inventory:client:SetCurrentStash', "trash_" .. k)
                    end
                },
                [2] = {
                    label = Lang:t("interaction.clear"),
                    icon = "fa-solid fa-broom",
                    onSelect = function(data)
                        TriggerServerEvent('inventory:server:ClearStashInventory', 'trash_' .. k)
                        QBCore.Functions.Notify(Lang:t('success.deleted'), 'success')
                    end
                }
            })
        end
    end
end

local function deleteObjects()
    for k,v in pairs (Config.Props) do
        if v.create and v.objectHandle ~= nil then
            DeleteObject(v.objectHandle)
        end
    end
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    spawnObjects()
end)

AddEventHandler('onResourceStop', function(resource)
    if GetCurrentResourceName() == resource then
        deleteObjects()
    end
end)

AddEventHandler('onResourceStart', function(resource)
    if GetCurrentResourceName() == resource then
        spawnObjects()
    end
end)
