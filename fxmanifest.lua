fx_version 'adamant'

game 'gta5'

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/index.css',
	'html/index.js',
	'html/reset.css',
	'html/jquery-3.4.1.min.js',
	'html/img/*.png',
	'html/sounds/*.wav',
}

shared_scripts {
	'config/init.lua',
	'config/blacklist.lua',
	'config/categories.lua',
	'config/doors.lua',
	'config/labels.lua',
	'config/prices.lua',
	'config/names.lua',
	'config.lua',
}

client_scripts {
	'@NativeUI/NativeUI.lua',
	'client/*.lua',
}

server_scripts{
	'@mysql-async/lib/MySQL.lua',
	'server/*.lua',
}

exports{
}

server_exports {
}