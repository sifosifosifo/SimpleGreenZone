fx_version 'cerulean'
game 'gta5'

lua54 'yes'

author 'SIFO'
description 'Simple Green Zone System'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'config.lua',
    'locales/*.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}