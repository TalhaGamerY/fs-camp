🌲 Premium Camping System (ESX/QBCore)
A high-performance, fully synced, and interactive camping experience for FiveM. This system allows players to set up camp anywhere in San Andreas with realistic placement mechanics, functional cooking, and persistent-feeling storage.

✨ Features
Dual Framework Support: Native compatibility with both ESX v2+ and QBCore.

Advanced Placement: Real-time "ghost" object preview with 360° rotation and height adjustment.

Deep Integration: Leverages ox_lib for UI, ox_target for interactions, and ox_inventory for item/stash management.

Synced World: Every object (campfires, tents, logs) is fully networked; if you see it, everyone sees it.

Interactive Tents: Includes integrated stashes via ox_inventory.

Campfire Cooking: A modular recipe system with progress bars and custom animations.

Optimized: Runs at 0.00ms on idle. Uses state-of-the-art targeting instead of heavy distance loops.

📦 Dependencies
To ensure this script runs smoothly, the following resources are required:

ox_lib

ox_target

ox_inventory

Framework: ESX or QBCore

🛠️ Installation
Download & Extract: Drop the fs-camp folder into your server's resources directory.

Add Items: Add the following items to your ox_inventory/data/items.lua:

Lua

['campfire_kit'] = { label = 'Campfire Kit', weight = 1000, stack = true, close = true },
['tent_kit'] = { label = 'Tent Kit', weight = 5000, stack = false, close = true },
['camping_log'] = { label = 'Wooden Log', weight = 2000, stack = true, close = true },
['lantern'] = { label = 'Lantern', weight = 500, stack = true, close = true },
['raw_meat'] = { label = 'Raw Meat', weight = 200 },
['cooked_meat'] = { label = 'Roasted Meat', weight = 200 },

Configure: Open config.lua and set Config.Framework to either "ESX" or "QBCore".

Start Resource: Add ensure fs-camp to your server.cfg.

🎮 How to Use
Placement Controls
When you use a camping item (like a Tent Kit), you enter Placement Mode:

Mouse Move: Move the object around the world.

Scroll Wheel: Rotate the object 360°.

Shift + Scroll: Adjust the height (Up/Down) for uneven terrain.

[E] Key: Confirm placement.

[X] Key: Cancel placement.

Interactions
Approach any placed object and use your Target Key (usually Left Alt):

Campfire: Open the cooking menu to turn raw ingredients into meals.

Tent: Open a secure storage stash or pick the tent back up.

Log: Sit down and enjoy the view.

Lantern: Pick up or move the light source.

⚙️ Configuration Snippet
Adding a new recipe is as easy as adding a few lines to the Config.Recipes table:

Lua

{
    label = "Wild Mushroom Soup",
    input = { {item = "mushroom", count = 3}, {item = "water", count = 1} },
    output = "mushroom_soup",
    time = 8000, -- 8 seconds
    anim = { dict = "amb@prop_human_bbq@male@base", clip = "base" }
}


🛡️ Support & Optimization
Cleanup: By default, objects are removed when a player disconnects to prevent "ghost camps." This can be toggled in the config.

Limits: Prevents players from entity-spamming by enforcing a configurable per-player object limit.

Note: This script is built for performance. If you encounter any "leaking" objects, ensure your server artifacts are up to date to support modern networking.