local QBCore = exports['qb-core']:GetCoreObject()

local zones = {}

-------------------------------------------------
-- إنشاء SQL تلقائي
-------------------------------------------------
CreateThread(function()

    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS greenzones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    type VARCHAR(20) DEFAULT 'coords',
    blip_id INT DEFAULT NULL,
    x DOUBLE DEFAULT NULL,
    y DOUBLE DEFAULT NULL,
    z DOUBLE DEFAULT NULL,
    radius INT,
    enabled INT DEFAULT 1
)
    ]])

    print('[GreenZone] SQL Ready')

end)

-------------------------------------------------
-- التحقق من الأدمن
-------------------------------------------------
local function IsAdmin(src)

    if QBCore.Functions.HasPermission(src, "admin") then
        return true
    end

    if QBCore.Functions.HasPermission(src, "god") then
        return true
    end

    if IsPlayerAceAllowed(src, "greenzone.admin") then
        return true
    end

    local identifiers = GetPlayerIdentifiers(src)

    for _, id in pairs(identifiers) do
        for _, allowed in pairs(Config.AllowedLicenses) do

            if id == allowed then
                return true
            end

        end
    end

    return false
end

-------------------------------------------------
-- Callback
-------------------------------------------------
QBCore.Functions.CreateCallback(
    'greenzone:isAdmin',

    function(source, cb)
        cb(IsAdmin(source))
    end
)

-------------------------------------------------
-- تحميل المناطق
-------------------------------------------------
CreateThread(function()

    Wait(2000)

    zones = {}

    local result = MySQL.query.await(
        'SELECT * FROM greenzones'
    )

    for _, z in pairs(result) do

table.insert(zones, {

    id = z.id,
    name = z.name,

    type = z.type or "coords",

    blipId = z.blip_id,

    coords =
        z.x and vector3(
            z.x,
            z.y,
            z.z
        ) or nil,

    radius = z.radius,

    enabled =
        z.enabled == true
        or z.enabled == 1
        or z.enabled == "1"
})

    end

    print('[GreenZone] Loaded '..#zones..' zones')

end)

-------------------------------------------------
-- إرسال المناطق
-------------------------------------------------
RegisterNetEvent("greenzone:requestZones", function()

    TriggerClientEvent(
        "greenzone:update",
        source,
        zones
    )

end)

-------------------------------------------------
-- إنشاء منطقة
-------------------------------------------------
RegisterNetEvent("greenzone:create", function(data)

    local src = source

    if not IsAdmin(src) then
        return
    end

    local id = MySQL.insert.await([[
        INSERT INTO greenzones
        (name, x, y, z, radius, enabled)
        VALUES (?, ?, ?, ?, ?, ?)
    ]], {

        data.name,

        data.coords.x,
        data.coords.y,
        data.coords.z,

        data.radius,

        1

    })

    table.insert(zones, {

        id = id,

        name = data.name,

        coords = data.coords,

        radius = data.radius,

        enabled = true

    })

    TriggerClientEvent(
        "greenzone:update",
        -1,
        zones
    )

end)

-------------------------------------------------
-- حذف منطقة
-------------------------------------------------
RegisterNetEvent("greenzone:delete", function(id)

    local src = source

    if not IsAdmin(src) then
        return
    end

    MySQL.query.await(
        'DELETE FROM greenzones WHERE id = ?',
        {id}
    )

    for i, z in pairs(zones) do

        if z.id == id then

            table.remove(zones, i)

            break
        end

    end

    TriggerClientEvent(
        "greenzone:update",
        -1,
        zones
    )

end)

-------------------------------------------------
-- تعديل Radius
-------------------------------------------------
RegisterNetEvent("greenzone:updateRadius", function(id, radius)

    local src = source

    if not IsAdmin(src) then
        return
    end

    for _, z in pairs(zones) do

        if z.id == id then

            z.radius = radius

            MySQL.query.await(
                'UPDATE greenzones SET radius = ? WHERE id = ?',
                {
                    radius,
                    id
                }
            )

            break
        end

    end

    TriggerClientEvent(
        "greenzone:update",
        -1,
        zones
    )

end)

-------------------------------------------------
-- تعطيل / تفعيل
-------------------------------------------------
RegisterNetEvent("greenzone:toggle", function(id)

    local src = source

    if not IsAdmin(src) then
        return
    end

    for _, z in pairs(zones) do

        if z.id == id then

            z.enabled = not z.enabled

            MySQL.query.await(
                'UPDATE greenzones SET enabled = ? WHERE id = ?',
                {
                    z.enabled and 1 or 0,
                    id
                }
            )

            break
        end

    end

    TriggerClientEvent(
        "greenzone:update",
        -1,
        zones
    )

end)

-------------------------------------------------
-- حذف العناصر الممنوعة
-------------------------------------------------
RegisterNetEvent(
    'greenzone:removeBlockedItem',

    function(item)

        local src = source

        local Player =
            QBCore.Functions.GetPlayer(src)

        if not Player then
            return
        end

        if Config.BlockedItems[item] then

            Player.Functions.RemoveItem(
                item,
                1
            )

            TriggerClientEvent(
                'inventory:client:ItemBox',
                src,
                QBCore.Shared.Items[item],
                "remove"
            )

        end
    end
)


RegisterNetEvent("greenzone:createBlip", function(data)

    local src = source

    if not IsAdmin(src) then
        return
    end

    local id = MySQL.insert.await([[
        INSERT INTO greenzones
        (name, type, blip_id, radius, enabled)
        VALUES (?, ?, ?, ?, ?)
    ]], {
        data.name,
        "blip",
        data.blipId,
        data.radius,
        1
    })

table.insert(zones,{
    id = id,
    name = data.name,
    type = "blip",
    blipId = data.blipId,
    coords = nil,
    radius = data.radius,
    enabled = true
})

    TriggerClientEvent(
        "greenzone:update",
        -1,
        zones
    )

end)