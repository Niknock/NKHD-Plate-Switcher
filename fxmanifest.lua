fx_version 'cerulean'
game 'gta5'

lua54 'yes'

author 'Niknock HD'
description 'Plate Changer'
version '1.0.0'

client_script{
	"client.lua",
}

server_script{
	"server.lua",
}

shared_script '@es_extended/imports.lua'

dependencies {
	'es_extended'
}