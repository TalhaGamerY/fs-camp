fx_version 'cerulean'
game 'gta5'
lua54 'yes'

description 'Camping System'
author 'FS Labs'
version '1.0.0'

-- Shared scripts load FIRST for both sides
shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

-- Then load the server logic
server_scripts {
    'server/main.lua'
}

-- Then load the client logic
client_scripts {
    'client/main.lua'
}

dependencies {
    'ox_lib',
    'ox_target',
    'ox_inventory'
}