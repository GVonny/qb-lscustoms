# QB LS Customs
_Developed by GVONNY_

This menu is designed to be completely configurable of which includes:
- Configurable category labels
- Configurable mod labels
- Configurable pricing
- Configurable mod blacklist
- Configurable door controls

This menu is up to date with game build version 2802
- Includes all chameleon paints
  - Follow the beginning of this guide to stream all the chameleon paints: [GITHUB](https://forum.cfx.re/t/how-to-get-the-chameleon-paints/4869883)
- Includes new track wheel set

## Events
There are four different variations of menus (everything/mods only/wheels only/respray only):
- TriggerEvent('lscustoms:open-menu', {true or false})
  - Contains all mods including respray and wheels
- TriggerEvent('lscustoms:open-mods', {true or false})
  - Contains only mod options
- TriggerEvent('lscustoms:open-wheels', {true or false})
  - Contains only wheel options
-  TriggerEvent('lscustoms:open-respray', {true or false})
    - Contains only respray options

Note: Each event takes in a boolean parameter (admin)
- When in admin mode it will not charge the player for mod applications
- When in admin mode it will override the Config.Debug value to always print debug messages in the console

## Configs
**init.lua** - _The starting variables for the script_
---
Config.Debug: defines whether or not to print the mod details in the console when cycling through each option
- With Config.Debug enabled when you select a category it it will print to the console the details of that category
  - `{model}` `{category number}`: `{mod index}` `{mod label key}` `{carcols category}`

Config.AllowBlacklised: defines whether or not to allow all blacklisted mods in blacklist.lua to show in the listing

**config.lua** - _All of the functions used by the menu_
---
Config.Colors: defines all the color options used in respray and tire smoke

Config.Mods: defines most mods that aren't physical

**categories.lua** - _Where to define custom categories for each vehicle_
---
Using ```luaGetDisplayNameFromVehicleModel(GetEntityModel(_{vehicle}_)):lower()``` feel free to add any vehicle here
- Note: when adding import vehicles be sure to change the *gameName* in the vehicles.meta to something that will be used here, this is what the native above returns
- Note: it is advised to not modify Config.DefaultColors or Config.VmtCategories, feel free to modify any category within Config.DefaultCategories

Each model then has it's own list of categories where you can define the label to be used for that category

- From the details printed in debug mode use the `{model}` to create the table subset for the vehicle
- Then using the `{category number}` set the desired label for that category

_I've already done all the base game vehicles so you'll likely only need to add your imports_

**names.lua** - _Where to add provided mod labels_
---
This file is to be used if the mod provided has a dlc.rpf even if there is a FiveM specific directory still do this

Once you have the vehicle mod open in OpenIV follow these steps:
- Navigate to x64/data/lang/americandlc.rpf (or which ever language you prefer)
- Open the global.gtx2 file

There are two options here

1. Copy each line into the file using the native AddTextEntry(`{hash}`, `{label}`) (not recommended)
2. There is a tool out there where you can take the whole contents of the global.gtx2 file and have it auto generate AddTextEntry() values
    * That tool can be found here: [GITHUB](https://github.com/Starystars67/FiveM-names.lua-Maker/releases)
    * Just copy the content from the global.gtx2 into the gtx2.txt file and run the exe
    * The tool will create a names.lua file for you to copy into the config/names.lua file in this script

**labels.lua** - _Where to add/override any mod label_
---
Using ```luaGetDisplayNameFromVehicleModel(GetEntityModel(vehicle)):lower()``` feel free to add any vehicle here
- Note: when adding import vehicles be sure to change the *gameName* in the vehicles.meta to something that will be used here, this is what the native above returns
- Note: this will override anything provided in names.lua

Each model then has it's own list of labels where you can define/override the label to be used for that mod

- From the details printed in debug mode use the `{model}` to create the table subset for the vehicle
- Then using the `{mod label key}` set the desired label for that mod

_I've already done all the base game vehicles so you'll likely only need to add your imports_

**prices.lua** - _Where to add/override any category pricing_
---
Config.DefaultPrice defines the price for every category that does not have an override

Config.Prices defines the global price for each category that differs from the global price

Config.CustomPrices defines the overrides for any previously defined prices

Using ```luaGetDisplayNameFromVehicleModel(GetEntityModel(vehicle)):lower()``` feel free to add any vehicle here
- Note: when adding import vehicles be sure to change the *gameName* in the vehicles.meta to something that will be used here, this is what the native above returns
- Note: this will override anything defined in Config.Prices or the global Config.DefaultPrice

Each model then has it's own list of prices where you can define the price to be used for that category

- From the details printed in debug mode use the `{model}` to create the table subset for the vehicle
- Then using the `{category number}` set the desired price for that category

**blacklist.lua** - _Where to define individual mods or whole categories to be blacklisted_
---
Using ```luaGetDisplayNameFromVehicleModel(GetEntityModel(vehicle)):lower()``` feel free to add any vehicle here
- Note: when adding import vehicles be sure to change the *gameName* in the vehicles.meta to something that will be used here, this is what the native above returns

Each model then has it's own blacklist where you can define the mod or whole category to block

- From the details printed in debug mode use the `{model}` to create the table subset for the vehicle
- Then using the `{category number}` set the desired category to be blocked as a table
  - With the table empty that will blacklist the whole category
  - Using the `{mod index}` you can add any index to the table to blacklist any individual mod in that category

_I've already done all the base game vehicles so you'll likely only need to add your imports, but feel free to modify any existing blacklist_

**doors.lua** - _Where to define which doors are opened when modifying certian categories_
---
Config.Doors defines the presets to be used depending on which doors need to be opened when selecting a category

Using ```luaGetDisplayNameFromVehicleModel(GetEntityModel(vehicle)):lower()``` feel free to add any vehicle here
- Note: when adding import vehicles be sure to change the *gameName* in the vehicles.meta to something that will be used here, this is what the native above returns

Each model then has it's own door list where you can define the doors preset to open when modifying certain categories

- From the details printed in debug mode use the `{model}` to create the table subset for the vehicle
- Then using the `{category number}` set the desired preset from Config.Doors for that category

_I've already done all the base game vehicles so you'll likely only need to add your imports_
