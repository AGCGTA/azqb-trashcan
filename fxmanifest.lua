fx_version 'bodacious'
game 'gta5'

author 'azutake'
version '1.0.0'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'locales/ja.lua',
    'locales/*.lua',
    'config.lua',
}

client_script 'client.lua'
server_script 'server.lua'
dependency 'qb-core'