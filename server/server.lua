local config = require 'config'
local locale = require('locales/'..config.language)

-- Event to send a notification to the target player
RegisterNetEvent("howsn_payterminal:server:sendNotifyToTarget", function(targetPlayerId, moneytype, amount)
    local sourcePlayerId = source
    local TargetSource = targetPlayerId
    TriggerClientEvent("howsn_payterminal:client:sendNotifyToTarget", targetPlayerId, moneytype, amount, TargetSource, sourcePlayerId)
end)

-- Event to charge the customer
RegisterNetEvent("howsn_payterminal:server:chargeCustomer", function(targetPlayerId, moneytype, amount, sourcePlayerId)
    local Player = exports.qbx_core:GetPlayer(targetPlayerId)
    local SourcePlayer = exports.qbx_core:GetPlayer(sourcePlayerId)
    local sourceJobName = SourcePlayer.PlayerData.job.name
    local sourceJobLabel = SourcePlayer.PlayerData.job.label

    if moneytype == "cash" then
        if Player.Functions.RemoveMoney(moneytype, amount, "SNR-Buns") then
            exports['Renewed-Banking']:addAccountMoney(sourceJob, amount)
            lib.notify(sourcePlayerId, {
                title = locale.notifications.payment_successful, 
                type = 'success'
            })
            TriggerClientEvent("howsn_payterminal:client:playSound", sourcePlayerId)
        else 
            lib.notify(targetPlayerId, {
                title = locale.notifications.insufficient_funds, 
                type = 'error'
            })
            lib.notify(sourcePlayerId, {
                title = locale.notifications.payment_failed, 
                type = 'error'
            })
        end
    elseif moneytype == "bank" then
        local bank = Player.PlayerData.money.bank
        if amount <= bank then
            if Player.Functions.RemoveMoney(moneytype, amount, sourceJobLabel) then
                exports['Renewed-Banking']:addAccountMoney(sourceJobName, amount)
                lib.notify(sourcePlayerId, {
                    title = locale.notifications.payment_successful, 
                    type = 'success'
                })
                TriggerClientEvent("howsn_payterminal:client:playSound", sourcePlayerId)
            end
        else 
            lib.notify(targetPlayerId, {
                title = locale.notifications.insufficient_funds, 
                type = 'error'
            })
            lib.notify(sourcePlayerId, {
                title = locale.notifications.payment_failed, 
                type = 'error'
            })
        end
    end
end)

-- Add new server event for cancelled payment
RegisterNetEvent("howsn_payterminal:server:paymentCancelled", function(sourceId)
    TriggerClientEvent("howsn_payterminal:client:paymentCancelled", sourceId)
end)

RegisterNetEvent("howsn_payterminal:server:SendNotifyToSource", function(sourcePlayerId)
    lib.notify(sourcePlayerId, {
        title = locale.notifications.payment_cancelled,
        type = 'error'
    })
end)