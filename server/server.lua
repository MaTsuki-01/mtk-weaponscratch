ESX = nil
ESX = exports['es_extended']:getSharedObject()

local usingox = GetResourceState('ox_inventory') == 'started'

RegisterNetEvent('mtk-weaponscratch:scratchserial', function(data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if usingox then
        local weapon = exports.ox_inventory:GetSlot(src, data.slot)
        if weapon.name ~= data.weapon then return end
        local Item = xPlayer.getInventoryItem('steelfile')
        
        if Item and Item.count > 0 then
            if weapon.metadata.serial ~= 'Scratched' then
                weapon.metadata.serial = 'Scratched'
                exports.ox_inventory:SetMetadata(src, weapon.slot, weapon.metadata)
                TriggerClientEvent("esx:showNotification", src, 'Successfully scratched weapon serial number', "success")
            end
        else
            TriggerClientEvent("esx:showNotification", src, 'You do not have any tools for this..', "error")
        end
    else
        local weapon = xPlayer.getInventoryItem(data.weapon)
        
        if not weapon then return end
        
        local Item = xPlayer.getInventoryItem('steelfile')
        
        if Item and Item.count > 0 then
            if weapon.info and weapon.info.serial ~= 'Scratched' then
                if not xPlayer.removeInventoryItem(data.weapon, 1) then return end
                TriggerClientEvent('esx:showNotification', src, 'Weapon removed for scratching', "success")
                Wait(400)
                
                local info = {
                    serial = 'Scratched',
                    quality = weapon.info and weapon.info.quality or 100,
                    ammo = weapon.info and weapon.info.ammo or 0
                }
                
                xPlayer.addInventoryItem(data.weapon, 1, info)
                TriggerClientEvent('esx:showNotification', src, 'Weapon serial scratched successfully', "success")
            end
        else
            TriggerClientEvent("esx:showNotification", src, 'You do not have any tools for this..', "error")
        end
    end
end)
