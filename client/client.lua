ESX = nil
ESX = exports['es_extended']:getSharedObject()

local ScratchTable = nil
local usingox = GetResourceState('ox_inventory') == 'started'

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        DeleteEntity(ScratchTable)
    end
end)

local function ShowWeapons()
    if IsPedArmed(PlayerPedId(), 7) then
        TriggerEvent('weapons:ResetHolster')
        SetCurrentPedWeapon(PlayerPedId(), `WEAPON_UNARMED`, true)
    end

    local resgisteredMenu = {
        id = 'mtk-weaponscratch',
        title = 'Available Weapons',
        options = {}
    }
    local options = {}

    if usingox then
        local playeritems = exports.ox_inventory:GetPlayerItems()
        local items = exports.ox_inventory:Items()

        for _, v in pairs(playeritems) do
            if items[v.name] and items[v.name].weapon and v.metadata.serial ~= 'Scratched' then
                options[#options+1] = {
                    title = items[v.name]["label"],
                    description = 'Scratch Weapon Serial',
                    metadata = {
                        {label = 'Serial', value = v.metadata.serial},
                        {label = 'Slot', value = v.slot},
                    },
                    serverEvent = 'mtk-weaponscratch:scratchserial',
                    args = {
                        weapon = v.name,
                        slot = v.slot
                    }
                }
            end
        end
    else
        local xPlayer = ESX.GetPlayerData()
        local playeritems = xPlayer.inventory

        for _, v in pairs(playeritems) do
            if v.type == 'weapon' and v.info and v.info.serie ~= 'Scratched' then
                options[#options+1] = {
                    title = v.label,
                    description = 'Scratch Weapon Serial',
                    metadata = {
                        {label = 'Serial', value = v.info.serie},
                        {label = 'Slot', value = v.slot},
                    },
                    serverEvent = 'mtk-weaponscratch:scratchserial',
                    args = {
                        weapon = v.name,
                        slot = v.slot
                    }
                }
            end
        end
    end

    resgisteredMenu["options"] = options
    lib.registerContext(resgisteredMenu)
    lib.showContext('mtk-weaponscratch')
end

CreateThread(function ()
    local coords = vector4(5365.0464, -5557.1846, 43.1726, 100.3118)
    local hash = `prop_toolchest_05`
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(0)
    end
    ScratchTable = CreateObject(hash, coords.x, coords.y, coords.z -1, true, true, true)
    SetEntityHeading(ScratchTable, coords.w)
    FreezeEntityPosition(ScratchTable, true)

    exports['qtarget']:AddTargetEntity(ScratchTable, {
        options = {
            {
                icon = 'fas fa-screwdriver',
                label = 'Use Tools',
                action = function()
                    ShowWeapons()
                end,
            },
        },
        distance = 2.0
    })
end)
