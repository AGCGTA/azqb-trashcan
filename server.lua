local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('azqb-jobstash:server:getPlayer', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    cb(Player)
end)