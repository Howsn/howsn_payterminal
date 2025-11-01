local config = require 'config'
local locale = require('locales/'..config.language)

-- Function to get the closest players
local function getClosestPlayers()
    local closestPlayers = {}
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    -- Iterate through all players
    for _, playerId in ipairs(GetActivePlayers()) do
        if playerId ~= PlayerId() then -- Exclude the local player
            local targetPed = GetPlayerPed(playerId)
            local targetCoords = GetEntityCoords(targetPed)
            local distance = #(playerCoords - targetCoords) -- Calculate distance

            if distance <= 4.0 then -- Change this value to adjust the range
                closestPlayers[#closestPlayers+1] = {
                    label = "[" .. GetPlayerServerId(playerId) .. "] - (" .. string.format("%.2f", distance) .. "m)", -- Player's name with distance
                    value = GetPlayerServerId(playerId), -- Player ID or any unique identifier
                }
            end
        end
    end

    return closestPlayers
end

-- Create targets from config
CreateThread(function()
    for _, target in ipairs(config.targets) do
        exports.ox_target:addSphereZone({
            coords = target.coords,
            radius = 0.4,
            rotation = 0.0,
            debug = config.debugPoly,
            drawSprite = true,
            options = {
                {
                    name = 'payment_terminal',
                    icon = target.icon,
                    label = target.label,
                    onSelect = function()
                        TriggerEvent("howsn_payterminal:client:openInput")
                    end,
                    groups = target.groups,
                    distance = 1.5
                }
            }
        })
    end
end)

-- Add animation function
local function PlayTerminalAnimation()
    lib.requestAnimDict('cellphone@')
    lib.requestModel('bzzz_prop_payment_terminal')
    
    local ped = PlayerPedId()
    local propName = 'bzzz_prop_payment_terminal'
    local boneIndex = 57005
    
    local prop = CreateObject(GetHashKey(propName), 1.0, 1.0, 1.0, true, true, false)
    AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, boneIndex), 0.18, 0.01, 0.0, -54.0, 220.0, 43.0, true, true, false, true, 1, true)
    
    TaskPlayAnim(ped, 'cellphone@', 'cellphone_text_read_base', 8.0, -8.0, -1, 49, 0, false, false, false)
    
    return prop
end

local function StopTerminalAnimation(prop)
    local ped = PlayerPedId()
    ClearPedTasks(ped)
    if prop then
        DeleteObject(prop)
    end
end

-- Event to open input dialog for payment
RegisterNetEvent("howsn_payterminal:client:openInput", function(source)
    local prop = PlayTerminalAnimation()
    local closestPlayersOptions = getClosestPlayers()

    local input = lib.inputDialog(locale.terminal.header, {
        {
            type = 'select',
            label = locale.terminal.dialog.player_id.label,
            description = locale.terminal.dialog.player_id.description,
            required = true,
            options = closestPlayersOptions
        },
        {
            type = 'select',
            label = locale.terminal.dialog.payment_type.label,
            description = locale.terminal.dialog.payment_type.description,
            required = true,
            options = {
                { value = 'cash', label = locale.terminal.payment_type.cash },
                { value = 'bank', label = locale.terminal.payment_type.bank }
            }
        },
        {
            type = 'number',
            label = locale.terminal.dialog.amount.label,
            description = locale.terminal.dialog.amount.description,
            required = true,
            min = 1
        }
    })

    if input then
        local targetPlayerId = input[1]
        local moneytype = input[2]
        local amount = input[3]
        local sourcePlayerId = GetPlayerServerId(PlayerId())

        -- Store prop in a temporary variable
        _G.currentTerminalProp = prop

        TriggerServerEvent("howsn_payterminal:server:sendNotifyToTarget", targetPlayerId, moneytype, amount)
        lib.notify({title = locale.notifications.payment_request_sent, type = 'success'})
    else
        StopTerminalAnimation(prop)
    end
end)

-- Event to send notification to target player
RegisterNetEvent("howsn_payterminal:client:sendNotifyToTarget", function(moneytype, amount, targetPlayerId, sourcePlayerId)
    local alertContent = string.format(locale.terminal.request.content,
        moneytype == 'cash' and locale.terminal.payment_type.cash or locale.terminal.payment_type.bank,
        amount
    )

    local alert = lib.alertDialog({
        header = locale.terminal.request.header,
        content = alertContent,
        centered = true,
        cancel = true,
        labels = {
            cancel = locale.terminal.request.cancel,
            confirm = locale.terminal.request.confirm
        }
    })

    if alert == 'confirm' then
        TriggerServerEvent("howsn_payterminal:server:chargeCustomer", targetPlayerId, moneytype, amount, sourcePlayerId)
    else
        lib.notify({title = locale.notifications.payment_cancelled_by_user, type = 'error'})
        TriggerServerEvent("howsn_payterminal:server:SendNotifyToSource", sourcePlayerId)
        TriggerServerEvent("howsn_payterminal:server:paymentCancelled", sourcePlayerId)
    end
end)

RegisterNetEvent('howsn_payterminal:client:useTerminal', function()
    TriggerEvent("howsn_payterminal:client:openInput")
end)

-- Add new event for stopping animation
RegisterNetEvent("howsn_payterminal:client:stopAnimation", function(prop)
    StopTerminalAnimation(prop)
end)

-- Add to existing payment completed event
RegisterNetEvent("howsn_payterminal:client:playSound", function()
    TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "kaching", 0.3)
    if _G.currentTerminalProp then
        StopTerminalAnimation(_G.currentTerminalProp)
        _G.currentTerminalProp = nil
    end
end)

-- Add new event for cancelled payment
RegisterNetEvent("howsn_payterminal:client:paymentCancelled", function()
    if _G.currentTerminalProp then
        StopTerminalAnimation(_G.currentTerminalProp)
        _G.currentTerminalProp = nil
    end
end)