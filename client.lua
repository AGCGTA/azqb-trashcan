local QBCore = exports['qb-core']:GetCoreObject()

local function prepareEntity(entity, stashid)
    if entity ~= nil then
        FreezeEntityPosition(entity, true)
        exports["ox_target"]:addLocalEntity(entity, {
            [1] = {
                label = Lang:t("interaction.opentrash"),
                icon = "fa-solid fa-recycle",
                onSelect = function(data)
                    options = {
                        maxweight = 5000000,
                        slots = 200,
                    }
                    TriggerServerEvent('inventory:server:OpenInventory', 'stash', "trash_" .. stashid, options)
                    TriggerEvent('inventory:client:SetCurrentStash', "trash_" .. stashid)
                end
            },
            [2] = {
                label = Lang:t("interaction.clear"),
                icon = "fa-solid fa-broom",
                onSelect = function(data)
                    TriggerServerEvent('inventory:server:ClearStashInventory', 'trash_' .. stashid)
                    QBCore.Functions.Notify(Lang:t('success.deleted'), 'success')
                end
            }
        })
    end
end

local function spawnObjects()
    for k,v in pairs (Config.Props) do
        RequestModel(v.model)
        while not HasModelLoaded(v.model) do
            Wait(0)
        end
        if v.create then
            local created_object = CreateObjectNoOffset(v.model, v.coords.x, v.coords.y, v.coords.z - 1, false, false, false)
            PlaceObjectOnGroundProperly(created_object)
            SetEntityHeading(created_object, v.coords.w)
            SetModelAsNoLongerNeeded(created_object)
            v.objectHandle = created_object
            prepareEntity(created_object, k)
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

CreateThread(function()
    while true do
        for k,v in pairs (Config.Props) do
            if not v.create and (v.objectHandle == nil or not DoesEntityExist(v.objectHandle)) then
                local obj = GetClosestObjectOfType(v.coords.x, v.coords.y, v.coords.z, 3.0, GetHashKey(v.model), false, false, false)
                if obj ~= 0 then
                    print("success attach")
                    SetEntityAsMissionEntity(v.objectHandle, true, true)
                    v.objectHandle = obj
                    prepareEntity(obj, k)
                end
            end
        end
        Wait(15 * 1000)
    end
end)
