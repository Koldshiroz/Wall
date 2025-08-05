-- Server-side script for Qbox/MRI Qbox

local QBCore = exports['qb-core']:GetCoreObject()

-- Store wallhack user data
local wall_users = {}

-- Register server event to set wallhack info
RegisterNetEvent('qbox_wall:setWallInfos')
AddEventHandler('qbox_wall:setWallInfos', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        -- Check if player has permission (e.g., admin)
        if QBCore.Functions.HasPermission(src, 'admin') then
            wall_users[src] = {
                user_id = Player.PlayerData.citizenid, -- Qbox equivalent of vRP user_id
                name = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname,
                wallstats = true -- Example; adjust based on your needs
            }
        end
    end
end)

-- Register callback to get wallhack user data
QBCore.Functions.CreateCallback('qbox_wall:getWallInfos', function(source, cb)
    cb(wall_users)
end)

-- Example command to toggle wallhack (admin only)
QBCore.Commands.Add('wall', 'Toggle wallhack', {}, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player and QBCore.Functions.HasPermission(source, 'admin') then
        TriggerClientEvent('qbox_wall:toggle', source, not wall_users[source])
        if not wall_users[source] then
            wall_users[source] = {
                user_id = Player.PlayerData.citizenid,
                name = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname,
                wallstats = true
            }
        else
            wall_users[source] = nil
        end
    else
        TriggerClientEvent('QBCore:Notify', source, 'You do not have permission to use this command!', 'error')
    end
end, 'admin')