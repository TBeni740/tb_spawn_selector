fx_version 'cerulean'
game 'gta5'

description 'TB spawn selector'
version '1.0.0'

shared_script "config.lua"

client_script 'client.lua'

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/index.js',
	'html/index.css',
	'html/audio/*.mp3'
}

lua54 'yes'