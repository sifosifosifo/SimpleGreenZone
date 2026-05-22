Config = {}

-- Language
Config.Locale = 'en' -- en, es, fr, ar,

-- Notifications
Config.EnableZoneNotify = true -- Send a notification when entering or leaving a green zone that supports 'qb-notification'

-- Allowed Licenses
Config.AllowedLicenses = {
    "license:YOUR_LICENSE" --If you do not add the permissions in server.cfg
}

-- Disable Weapons In GreenZone
Config.DisableWeapons = true -- Disable weapons in green zones

-- Allowed Jobs
Config.AllowedJobs = {

    ["police"] = true,
    ["ambulance"] = true,

}

-- Allowed Weapons
Config.AllowedWeapons = {

    [`WEAPON_STUNGUN`] = true,
    [`WEAPON_NIGHTSTICK`] = true,
    [`WEAPON_FLASHLIGHT`] = true,

}

-- Blocked Items
Config.BlockedItems = {

    ["lockpick"] = true,
    ["weapon_pistol"] = true,

}
