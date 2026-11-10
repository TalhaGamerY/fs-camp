Config = {}

-- "ESX" or "QBCore"
Config.Framework = "ESX"

-- Max camp objects one player can have placed at once
Config.MaxObjectsPerPlayer = 5

-- Remove a player's camp objects when they leave the server
Config.CleanupOnDisconnect = true

-- Placeable objects. `item` is the usable inventory item, `type` controls the target options:
--   fire  = cooking menu, tent = stash, seat = sit down, light = pick up only
-- If a model doesn't load on your server, swap it for any prop name you like.
Config.CampObjects = {
    campfire = {
        label = 'Campfire',
        item  = 'campfire_kit',
        model = `prop_beach_fire`,
        type  = 'fire',
    },
    tent = {
        label = 'Tent',
        item  = 'tent_kit',
        model = `prop_skid_tent_01`,
        type  = 'tent',
        storage = { slots = 20, weight = 50000 },
    },
    log = {
        label = 'Log Seat',
        item  = 'camping_log',
        model = `prop_log_01`,
        type  = 'seat',
    },
    lantern = {
        label = 'Lantern',
        item  = 'lantern',
        model = `h4_prop_h4_lantern_01a`,
        type  = 'light',
    },
}

-- Campfire recipes. `time` is in milliseconds.
Config.Recipes = {
    {
        label  = 'Roasted Meat',
        input  = { { item = 'raw_meat', count = 1 } },
        output = 'cooked_meat',
        time   = 5000,
        anim   = { dict = 'amb@prop_human_bbq@male@base', clip = 'base' },
    },
}
