fx_version 'cerulean'
game 'gta5'

-- Built with THE ORB Studio — https://app.theorb.tech
-- Discord: https://discord.gg/4m8es2VJN8  ·  Scripts: https://theorb.tech

author 'THE ORB Studio'
description 'Prop "a_back_pack_with_a_cat_in_it" — built with THE ORB Studio (https://app.theorb.tech)'
version '1.0.0'

files {
    'stream/**/*.ydr',
    'stream/**/*.ytd',
    'stream/**/*.ytyp',
    'stream/**/*.ybn',
}

-- REQUIRED: registers the archetype so the game knows this model exists.
-- Without it the model streams but CreateObject returns 0 / an invisible prop.
data_file 'DLC_ITYP_REQUEST' 'stream/**/*.ytyp'

client_script 'client.lua'
