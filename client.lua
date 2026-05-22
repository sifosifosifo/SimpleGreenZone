local QBCore = exports['qb-core']:GetCoreObject()

local Lang = Locales[Config.Locale]

local zones = {}

local inside = false
local blockedWeapon = false
local currentZone = nil


local function Notify(msg, type)

    if not Config.EnableZoneNotify then
        return
    end

    QBCore.Functions.Notify(
        msg,
        type or 'primary'
    )

end


function DrawTxt(text, x, y)

    SetTextFont(4)
    SetTextProportional(1)
    SetTextScale(0.35, 0.35)

    SetTextColour(255, 255, 255, 215)

    SetTextEntry("STRING")

    SetTextCentre(true)

    AddTextComponentString(text)

    DrawText(x, y)

end


CreateThread(function()

    Wait(3000)

    TriggerEvent(
        'hud:zoneStatus',
        'red'
    )

end)

CreateThread(function()

    Wait(2000)

    TriggerServerEvent(
        "greenzone:requestZones"
    )

end)


RegisterNetEvent("greenzone:update", function(data)

    zones = data

end)


RegisterCommand("gz", function()

    QBCore.Functions.TriggerCallback(
        'greenzone:isAdmin',

        function(hasPerm)

            if not hasPerm then

                Notify(
                    Lang['no_permission'],
                    'error'
                )

                return
            end

            exports['qb-menu']:openMenu({

                {
                    header = "Green Zone System",
                    isMenuHeader = true
                },

                {
                    header = "🟢 "..Lang['create_zone'],

                    params = {
                        event = "greenzone:createMenu"
                    }
                },

                {
                    header = "⚙️ "..Lang['manage_zones'],

                    params = {
                        event = "greenzone:manageMenu"
                    }
                }

            })

        end
    )

end)


RegisterNetEvent("greenzone:createMenu", function()

    local input = exports['qb-input']:ShowInput({

        header = Lang['create_zone'],

        submitText = "Create",

        inputs = {

            {
                text = "Name",
                name = "name",
                type = "text",
                isRequired = true
            },

            {
                text = "Radius",
                name = "radius",
                type = "number",
                isRequired = true
            }

        }

    })

    if not input then return end

    local name = input.name
    local radius = tonumber(input.radius)

    Notify(
        Lang['waypoint_help'],
        'primary'
    )

    CreateThread(function()

        while true do

            Wait(0)

            DrawTxt(
                "~g~"..Lang['waypoint_help'],
                0.50,
                0.90
            )

            if IsControlJustPressed(0, 38) then

                local blip = GetFirstBlipInfoId(8)

                if DoesBlipExist(blip) then

                    local c = GetBlipInfoIdCoord(blip)

                    TriggerServerEvent(
                        "greenzone:create",
                        {

                            name = name,

                            coords = vector3(
                                c.x,
                                c.y,
                                c.z
                            ),

                            radius = radius

                        }
                    )

                    Notify(
                        Lang['zone_created'],
                        'success'
                    )

                else

                    Notify(
                        Lang['need_waypoint'],
                        'error'
                    )

                end

                break
            end
        end
    end)

end)


RegisterNetEvent("greenzone:manageMenu", function()

    local menu = {}

    table.insert(menu, {

        header = Lang['manage_zones'],
        isMenuHeader = true

    })

    for _, z in pairs(zones) do

        table.insert(menu, {

            header = z.name,

            txt =
                "ID: "..z.id..
                " | Radius: "..z.radius..
                " | "..(
                    z.enabled and
                    "🟢 Enabled"
                    or
                    "🔴 Disabled"
                ),

            params = {

                event = "greenzone:options",

                args = z

            }

        })

    end

    exports['qb-menu']:openMenu(menu)

end)


RegisterNetEvent("greenzone:options", function(zone)

    exports['qb-menu']:openMenu({

        {
            header = zone.name,
            isMenuHeader = true
        },

        {
            header =
                zone.enabled and
                "🔴 "..Lang['disable_zone']
                or
                "🟢 "..Lang['enable_zone'],

            params = {

                isServer = true,

                event = "greenzone:toggle",

                args = zone.id

            }
        },

        {
            header = "✏️ "..Lang['edit_radius'],

            params = {
                event = "greenzone:editRadius",
                args = zone
            }
        },

        {
            header = "🗑 "..Lang['delete_zone'],

            params = {

                isServer = true,

                event = "greenzone:delete",

                args = zone.id

            }
        }

    })

end)


RegisterNetEvent("greenzone:editRadius", function(zone)

    local input = exports['qb-input']:ShowInput({

        header = Lang['edit_radius'],

        submitText = "Save",

        inputs = {

            {
                text = "Radius",
                name = "radius",
                type = "number",
                default = zone.radius,
                isRequired = true
            }

        }

    })

    if not input then return end

    TriggerServerEvent(
        "greenzone:updateRadius",
        zone.id,
        tonumber(input.radius)
    )

end)

CreateThread(function()

    while true do

        local sleep = 500

        local ped = PlayerPedId()

        local coords = GetEntityCoords(ped)

        local inZone = false

        for _, z in pairs(zones) do

            if z.enabled then

                local zc = vector3(
                    z.coords.x,
                    z.coords.y,
                    z.coords.z
                )

                local dist = #(coords - zc)

                if dist < z.radius then

                    blockedWeapon = true

                    inZone = true

                    sleep = 1

                    currentZone = z

                    if not inside then

                        inside = true

                        TriggerEvent(
                            'hud:zoneStatus',
                            'green',
                            z.name
                        )

                        Notify(
                            Lang['enter_zone'],
                            'success'
                        )

                    end
                end
            end
        end

        if not inZone then
            blockedWeapon = false
        end

        if not inZone and inside then

            inside = false

            currentZone = nil

            TriggerEvent(
                'hud:zoneStatus',
                'red'
            )

            Notify(
                Lang['exit_zone'],
                'error'
            )

        end

        Wait(sleep)

    end

end)


CreateThread(function()

    while true do

        Wait(1)

        if inside and blockedWeapon and Config.DisableWeapons then

            local ped = PlayerPedId()

            local PlayerData =
                QBCore.Functions.GetPlayerData()

            local job =
                PlayerData.job and
                PlayerData.job.name


            if not Config.AllowedJobs[job] then

                local weapon =
                    GetSelectedPedWeapon(ped)

                DisableControlAction(0, 24, true)
                DisableControlAction(0, 25, true)
                DisableControlAction(0, 37, true)
                DisableControlAction(0, 45, true)

                DisableControlAction(0, 58, true)

                DisableControlAction(0, 140, true)
                DisableControlAction(0, 141, true)
                DisableControlAction(0, 142, true)
                DisableControlAction(0, 143, true)

                DisableControlAction(0, 257, true)
                DisableControlAction(0, 263, true)
                DisableControlAction(0, 264, true)


                if weapon ~= `WEAPON_UNARMED`
                and not Config.AllowedWeapons[weapon] then

                    SetCurrentPedWeapon(
                        ped,
                        `WEAPON_UNARMED`,
                        true
                    )

                    DisablePlayerFiring(
                        PlayerId(),
                        true
                    )

                end
            end
        end
    end
end)

CreateThread(function()

    while true do

        Wait(1000)

        if inside then

            local Player =
                QBCore.Functions.GetPlayerData()

            if Player and Player.items then

                for _, item in pairs(Player.items) do

                    if item and Config.BlockedItems[item.name] then

                        TriggerServerEvent(
                            'greenzone:removeBlockedItem',
                            item.name
                        )

                    end
                end
            end
        end
    end
end)


exports('IsInGreenZone', function(coords)

    coords =
        coords or
        GetEntityCoords(PlayerPedId())

    for _, z in pairs(zones) do

        if z.enabled then

            local zc = vector3(
                z.coords.x,
                z.coords.y,
                z.coords.z
            )

            local dist = #(coords - zc)

            if dist < z.radius then
                return true, z
            end
        end
    end

    return false, nil

end)