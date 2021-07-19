fx_version 'cerulean'
game 'gta5'

description 'qb-Multicharacter'
version '1.0.0'

ui_page "html/index.html"

client_scripts {
    'client/main.lua'
}

server_scripts {
    'server/main.lua'
}

files {
    'html/index.html',
    'html/style.css',
    'html/reset.css',
    'html/script.js',
    'html/zion.png'
}

shared_script '@qb-core/import.lua'


dependencies {
    'qb-core',
    'qb-spawn'
}