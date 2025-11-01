fx_version 'cerulean'
game 'gta5'

description 'Payment terminal script for stores'
author 'Howsn'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    '@qbx_core/modules/lib.lua',
    'config.lua',
    'locales/*.lua'
}

client_scripts {
    '@qbx_core/modules/playerdata.lua',
    'client/*.lua',
}

server_scripts {
    'server/*.lua',
}

files {
    'config.lua',
}

dependencies {
    'ox_lib',
    'ox_target',
    'ox_inventory',
    'qbx_core',
}

data_file 'DLC_ITYP_REQUEST' 'stream/bzzz_prop_payment_terminal.ytyp'

lua54 'yes'
use_experimental_fxv2_oal 'yes'