QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('lscustoms:can-purchase', function(source, cb, price, admin)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)

    if admin then
        cb(true)
    else
        if player.Functions.GetMoney('bank') >= price then
            player.Functions.RemoveMoney('bank', price)

            cb(true)
        elseif player.Functions.GetMoney('cash') >= price then
            player.Functions.RemoveMoney('cash', price)

            cb(true)
        else
            cb(false)
        end
    end
end)

QBCore.Functions.CreateCallback('lscustoms:is-vehicle-owned', function(source, cb, plate)
    local exists = MySQL.Sync.fetchAll("SELECT * FROM player_vehicles WHERE plate = @plate", {
        ['@plate'] = plate
    })[1]

    cb(exists ~= nil)
end)

RegisterNetEvent('lscustoms:update-mods', function(plate, props)
    MySQL.Sync.execute("UPDATE player_vehicles SET mods = @mods WHERE plate = @plate", {
        ['@plate'] = plate,
        ['@mods'] = json.encode(props)
    })
end)