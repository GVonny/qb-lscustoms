fx_version 'adamant'

game 'gta5'

client_scripts {
	'@NativeUI/NativeUI.lua',
	
	'config/init.lua',
	'config/blacklist.lua',
	'config/categories.lua',
	'config/doors.lua',
	'config/labels.lua',
	'config/prices.lua',
	'config/names.lua',
	'config.lua',
	
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