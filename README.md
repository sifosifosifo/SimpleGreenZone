<p align="center">
  <img src="./preview/banner.png" width="100%" alt="Green Zone System Banner">
</p>

<h1 align="center">🟢 Green Zone System for FiveM QBCore</h1>

<p align="center">
Advanced FiveM Green Zone script for QBCore with Waypoint Zones, Blip Zones, permissions, database support, HUD integration, and exports.
</p>

<div align="center">

# 🛒 SIFO STORE

### 🚀 Premium FiveM Scripts & Resources

Looking for more **FiveM QBCore scripts, resources, systems and add-ons** for your server?

<a href="https://sifo.tebex.store/" target="_blank">
  <img src="https://img.shields.io/badge/🛍️%20VISIT%20SIFO%20STORE-FF6B00?style=for-the-badge&logo=shopify&logoColor=white" alt="Visit SIFO Store">
</a>

<br><br>

**SIFO STORE:** https://sifo.tebex.store/

</div>

---

## 🔎 About This FiveM Script

**SimpleGreenZone** is a configurable **FiveM QBCore Green Zone script** designed for roleplay servers. Create protected areas using map waypoints or blip IDs, manage zones in-game, and control combat inside configured areas.

**Keywords:** FiveM, FiveM scripts, QBCore, QBCore scripts, Green Zone, Safe Zone, FiveM Green Zone, FiveM Safe Zone, GTA 5 RP, QBCore resource, FiveM roleplay, Lua, oxmysql.

---

# ✨ Features

- 📍 Create Green Zones using waypoints.
- 🗺️ Create Green Zones using Blip IDs.
- 🏪 Automatically create zones for all matching locations.
- 🔫 Disable weapons inside Green Zones.
- 👊 Disable melee attacks.
- 💾 Database support.
- 📏 Edit zone radius.
- 🟢 Enable / Disable zones.
- 🗑️ Delete zones.
- 👮 Permission system.
- 🌍 Multi-language support.
- 🖥️ HUD support.
- 🔌 Export support.
- ⚡ Unlimited zones support.
- 🎮 Fully managed in-game using `/gz`.

---

# 🆕 Blip Zone System

The new Blip Zone system allows you to create a single Green Zone entry that automatically applies to all matching locations.

Example:

```text
Name: Clothing Stores
Blip ID: 73
Radius: 100
```

Result:

- Ponsonbys
- Sub Urban
- Binco
- Any other clothing store using the same blip ID

Manage them all from a single menu entry.

---

# 🎮 Usage

Open the menu:

```text
/gz
```

Available options:

```text
Create Waypoint Zone
Create Blip Zone
Manage Zones
```

---

## Create Waypoint Zone

1. Run `/gz`
2. Select **Create Waypoint Zone**
3. Set the zone name and radius.
4. Place your waypoint and confirm.

---

## Create Blip Zone

1. Run `/gz`
2. Select **Create Blip Zone**
3. Enter:
   - Zone Name
   - Blip ID
   - Radius

Example:

```text
Name: Clothing Stores
Blip ID: 73
Radius: 100
```

The system will automatically protect every location using that blip.

---

# 📚 Finding Blip IDs

You can find all available FiveM Blip IDs here:

https://docs.fivem.net/docs/game-references/blips/

---

# ⚙️ Dependencies

- qb-core
- qb-menu
- qb-input
- oxmysql

---

# 🚀 Installation

Place the resource inside your resources folder:

```text
resources/[standalone]/greenzone
```

Add to your `server.cfg`:

```cfg
ensure greenzone
```

---

# 🔐 Permissions

Add to your `server.cfg`:

```cfg
add_ace group.admin greenzone.admin allow
add_ace group.god greenzone.admin allow
```

---

# 🗄️ Database Structure

```sql
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
);
```

---

# 📍 Supported Zone Types

| Type | Description |
|------|-------------|
| coords | Traditional waypoint zone |
| blip | Automatically generated zones from matching blips |

---

# 🖥️ HUD Integration

```lua
AddEventHandler('hud:zoneStatus', function(status, zoneName)

    -- status:
    -- green
    -- red

end)
```

---

# 🔌 Export Example

```lua
local inZone, zone = exports['greenzone']:IsInGreenZone()

if inZone then
    print("Player is inside:", zone.name)
end
```

---

# 📷 Preview

Place your promotional image here:

```text
greenzone/
│
├── preview/
│   └── banner.png
├── client/
├── server/
├── config.lua
├── fxmanifest.lua
└── README.md
```

---

# 🔒 License

This resource is distributed under:

```text
All Rights Reserved
```

You may:

- Use the resource on your server.
- Modify configuration files if allowed.

You may NOT:

- Redistribute the resource.
- Resell the resource.
- Share the source code.
- Claim ownership of the resource.
- Publish modified versions without permission.

---

# ❤️ Support

For bugs or feature requests, open an issue on GitHub.

For more **FiveM scripts and QBCore resources**, visit:

**https://sifo.tebex.store/**
