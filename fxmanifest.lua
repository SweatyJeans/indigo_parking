fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'Indigo Parking'
author 'SweatyJeans'
version '1.0.0'
description 'A script that saves players cars in the database and respawns them when the server starts.'



shared_scripts {
    'config.lua',
}
client_scripts {
    'client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'bridge/framework/*.lua',
    'server.lua'
}

dependency 'oxmysql'