fx_version 'cerulean'
game 'gta5'

lua54 'yes'

author 'Sifo'
description 'Advanced Green Zone System'
version     '1.1'

files {
    'README.md',
    'config.lua',
    'client.lua',
    'server.lua',
    'locales/*.lua'
}

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

escrow_ignore {
    'config.lua',
    'locales/*.lua'
}