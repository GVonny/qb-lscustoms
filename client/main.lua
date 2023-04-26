QBCore = exports['qb-core']:GetCoreObject()

Config.Menu = NativeUI.CreatePool()

RegisterCommand('lscustoms', function() 
    TriggerEvent('lscustoms:open-menu', false)  
end)

RegisterNetEvent('lscustoms:open-menu', function(admin)
    Config.AdminMode = admin or false
    local player = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(player)
    local plate = QBCore.Functions.GetPlate(vehicle)

    QBCore.Functions.TriggerCallback('lscustoms:is-vehicle-owned', function(owned)
        if IsPedInAnyVehicle(player) and (admin or owned) then
            Config.Vehicle.Vehicle = GetVehiclePedIsIn(player)
            Config.Vehicle.Mods = Config.GetVehicleProperties(Config.Vehicle.Vehicle)
            Config.Categories = {}

            Config.Menu:Remove()
        
            if Config.ModMenu ~= nil and Config.ModMenu:Visible() then
                Config.ModMenu:Visible(false)
                return
            end
            
            OpenModMenu()
            OpenWheelMenu()
            OpenResprayMenu()

            Config.Menu:RefreshIndex()
            Config.Menu:MouseControlsEnabled(false);
            Config.Menu:MouseEdgeEnabled(false);
            Config.Menu:ControlDisablingEnabled(false);
        
            Config.ModMenu:Visible(not Config.ModMenu:Visible())

            Config.ModMenu.OnMenuClosed = function(menu)
                UpdateVehicleMods(plate, QBCore.Functions.GetVehicleProperties(Config.Vehicle.Vehicle))
            end
        
            Config.InMenu = true
            FreezeEntityPosition(Config.Vehicle.Vehicle, true)
            SetVehicleFixed(Config.Vehicle.Vehicle)
        else 
            if not owned then
                QBCore.Functions.Notify("This vehicle is not owned", "error")
            end

            if Config.ModMenu ~= nil and Config.ModMenu:Visible() then
                Config.ModMenu:Visible(false)
            end
        end 
    end, plate)
end)

RegisterCommand('mods', function() 
    TriggerEvent('lscustoms:open-mods', true)  
end)

RegisterNetEvent('lscustoms:open-mods', function(admin)
    Config.AdminMode = admin or false
    local player = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(player)
    local plate = QBCore.Functions.GetPlate(vehicle)

    QBCore.Functions.TriggerCallback('lscustoms:is-vehicle-owned', function(owned)
        if IsPedInAnyVehicle(player) and (admin or owned) then
            Config.Vehicle.Vehicle = GetVehiclePedIsIn(player)
            Config.Vehicle.Mods = Config.GetVehicleProperties(Config.Vehicle.Vehicle)
            Config.Categories = {}

            Config.Menu:Remove()
        
            if Config.ModMenu ~= nil and Config.ModMenu:Visible() then
                Config.ModMenu:Visible(false)
                return
            end
            
            OpenModMenu()

            Config.Menu:RefreshIndex()
            Config.Menu:MouseControlsEnabled(false);
            Config.Menu:MouseEdgeEnabled(false);
            Config.Menu:ControlDisablingEnabled(false);
        
            Config.ModMenu:Visible(not Config.ModMenu:Visible())

            Config.ModMenu.OnMenuClosed = function(menu)
                UpdateVehicleMods(plate, QBCore.Functions.GetVehicleProperties(Config.Vehicle.Vehicle))
            end
        
            Config.InMenu = true
            FreezeEntityPosition(Config.Vehicle.Vehicle, true)
            SetVehicleFixed(Config.Vehicle.Vehicle)
        else 
            if not owned then
                QBCore.Functions.Notify("This vehicle is not owned", "error")
            end

            if Config.ModMenu ~= nil and Config.ModMenu:Visible() then
                Config.ModMenu:Visible(false)
            end
        end
    end, plate)
end)

RegisterCommand('wheels', function()
    TriggerEvent('lscustoms:open-wheels', true)
end)

RegisterNetEvent('lscustoms:open-wheels', function(admin)
    Config.AdminMode = admin or false
    local player = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(player)
    local plate = QBCore.Functions.GetPlate(vehicle)

    QBCore.Functions.TriggerCallback('lscustoms:is-vehicle-owned', function(owned)
        if IsPedInAnyVehicle(player) and (admin or Config.IsVehicleOwned(plate)) then
            Config.Vehicle.Vehicle = GetVehiclePedIsIn(player)
            Config.Vehicle.Mods = Config.GetVehicleProperties(Config.Vehicle.Vehicle)

            Config.Menu:Remove()
        
            if Config.ModMenu ~= nil and Config.ModMenu:Visible() then
                Config.ModMenu:Visible(false)
                return
            end
            
            OpenWheelMenu(true)

            Config.Menu:RefreshIndex()
            Config.Menu:MouseControlsEnabled(false);
            Config.Menu:MouseEdgeEnabled(false);
            Config.Menu:ControlDisablingEnabled(false);

            Config.ModMenu:Visible(not Config.ModMenu:Visible())

            Config.ModMenu.OnMenuClosed = function(menu)
                UpdateVehicleMods(plate, QBCore.Functions.GetVehicleProperties(Config.Vehicle.Vehicle))
            end

            Config.InMenu = true
            FreezeEntityPosition(Config.Vehicle.Vehicle, true)
            SetVehicleFixed(Config.Vehicle.Vehicle)
        else 
            if not owned then
                QBCore.Functions.Notify("This vehicle is not owned", "error")
            end

            if Config.ModMenu ~= nil and Config.ModMenu:Visible() then
                Config.ModMenu:Visible(false)
            end
        end 
    end, plate)   
end)

RegisterCommand('respray', function()
    TriggerEvent('lscustoms:open-respray', true)
end)

RegisterNetEvent('lscustoms:open-respray', function(admin)
    Config.AdminMode = admin or false
    local player = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(player)
    local plate = QBCore.Functions.GetPlate(vehicle)

    QBCore.Functions.TriggerCallback('lscustoms:is-vehicle-owned', function(owned)
        if IsPedInAnyVehicle(player) and (admin or owned) then
            Config.Vehicle.Vehicle = GetVehiclePedIsIn(player)
            Config.Vehicle.Mods = Config.GetVehicleProperties(Config.Vehicle.Vehicle)

            Config.Menu:Remove()
        
            if Config.ModMenu ~= nil and Config.ModMenu:Visible() then
                Config.ModMenu:Visible(false)
                return
            end
            
            OpenResprayMenu(true)

            Config.Menu:RefreshIndex()
            Config.Menu:MouseControlsEnabled(false);
            Config.Menu:MouseEdgeEnabled(false);
            Config.Menu:ControlDisablingEnabled(false);

            Config.ModMenu:Visible(not Config.ModMenu:Visible())

            Config.ModMenu.OnMenuClosed = function(menu)
                UpdateVehicleMods(plate, QBCore.Functions.GetVehicleProperties(Config.Vehicle.Vehicle))
            end

            Config.InMenu = true
            FreezeEntityPosition(Config.Vehicle.Vehicle, true)
            SetVehicleFixed(Config.Vehicle.Vehicle)
        else 
            if not owned then
                QBCore.Functions.Notify("This vehicle is not owned", "error")
            end

            if Config.ModMenu ~= nil and Config.ModMenu:Visible() then
                Config.ModMenu:Visible(false)
            end
        end
    end, plate)
end)

function UpdateVehicleMods(plate, props)
    TriggerServerEvent('lscustoms:update-mods', plate, props)
end

function OpenResprayMenu(standalone)
    if standalone then
        Config.ModMenu = NativeUI.CreateMenu('LS Customs', 'Respray your vehicle', 1400, 50, 'shopui_title_ie_modgarage','shopui_title_ie_modgarage') 
        Config.Menu:Add(Config.ModMenu)

        Config.ModMenu.OnIndexChange = function(sender, index)
            CheckDoorToggle()
        end

        Config.Categories = {}

        LoadPaintTypes(Config.ModMenu)
    else
        Config.Respray = Config.Menu:AddSubMenu(Config.ModMenu, "Respray", "Respray", true, true, true)
        LoadPaintTypes(Config.Respray)
    end
end

function LoadPaintTypes(menu)
    local included = {53,54,56,57}
    
    for num, mods in Config.PairsByKeys(Config.Vehicle.Mods.modList) do
        if Config.TableHasValue(included, num) then
            Config.Categories[num] = Config.Menu:AddSubMenu(menu, Config.DefaultCategories[num], Config.DefaultCategories[num], true, true, true)
            
            Config.Categories[num].OnMenuChanged = function(menu, newmenu, forward)
                local category = newmenu.Category

                if not forward then
                else
                    if num == 53 then
                        local primary, secondary = GetVehicleColours(Config.Vehicle.Vehicle)
                        local pearlescent, wheel = GetVehicleExtraColours(Config.Vehicle.Vehicle)

                        if category == 2 then
                            SetVehicleExtraColours(Config.Vehicle.Vehicle, Config.Colors[1][1].index, wheel)
                        else
                            SetVehicleColours(Config.Vehicle.Vehicle, Config.Colors[category][1].index, secondary)
                        end
                    elseif num == 54 then
                        local primary, secondary = GetVehicleColours(Config.Vehicle.Vehicle)

                        SetVehicleColours(Config.Vehicle.Vehicle, primary, Config.Colors[category][1].index)
                    elseif num == 56 then
                        if category == 6 then
                            SetVehicleInteriorColor(Config.Vehicle.Vehicle, Config.Colors[1][1].index)
                        elseif category == 7 then
                            SetVehicleDashboardColor(Config.Vehicle.Vehicle, Config.Colors[1][1].index)
                        end
                    elseif num == 57 then
                        if category == 0 then
                            local pearlescent, wheel = GetVehicleExtraColours(Config.Vehicle.Vehicle)

                            SetVehicleExtraColours(Config.Vehicle.Vehicle, pearlescent, Config.Colors[1][1].index)
                        elseif category == 8 then
                            SetVehicleTyreSmokeColor(Config.Vehicle.Vehicle, Config.Colors[6][1].index[1], Config.Colors[6][1].index[2], Config.Colors[6][1].index[3])
                        end 
                    end
                end

                newmenu:RefreshIndex()
            end

            for category, colors in pairs(mods) do
                if not Config.Categories[num][category] then
                    Config.Categories[num][category] = Config.Menu:AddSubMenu(Config.Categories[num], Config.DefaultColors[category], Config.DefaultColors[category], true, true, true)
                    Config.Categories[num][category].Category = category

                    Config.Categories[num][category].OnIndexChange = function(sender, index)
                        if num == 53 then
                            local primary, secondary = GetVehicleColours(Config.Vehicle.Vehicle)
                            local pearlescent, wheel = GetVehicleExtraColours(Config.Vehicle.Vehicle)

                            if category == 2 then
                                SetVehicleExtraColours(Config.Vehicle.Vehicle, Config.Colors[1][index].index, wheel)
                            else
                                SetVehicleColours(Config.Vehicle.Vehicle, Config.Colors[category][index].index, secondary)
                            end
                        elseif num == 54 then
                            local primary, secondary = GetVehicleColours(Config.Vehicle.Vehicle)

                            SetVehicleColours(Config.Vehicle.Vehicle, primary, Config.Colors[category][index].index)
                        elseif num == 56 then
                            if category == 6 then
                                SetVehicleInteriorColor(Config.Vehicle.Vehicle, Config.Colors[1][index].index)
                            elseif category == 7 then
                                SetVehicleDashboardColor(Config.Vehicle.Vehicle, Config.Colors[1][index].index)
                            end
                        elseif num == 57 then
                            if category == 0 then
                                local pearlescent, wheel = GetVehicleExtraColours(Config.Vehicle.Vehicle)

                                SetVehicleExtraColours(Config.Vehicle.Vehicle, pearlescent, Config.Colors[1][index].index)
                            elseif category == 8 then
                                SetVehicleTyreSmokeColor(Config.Vehicle.Vehicle, Config.Colors[6][index].index[1], Config.Colors[6][index].index[2], Config.Colors[6][index].index[3])
                            end 
                        end
                    end

                    Config.Categories[num][category].OnItemSelect = function(menu, item, index)
                        
                        QBCore.Functions.TriggerCallback('lscustoms:can-purchase', function(bool)
                            if Config.AdminMode or bool then

                                if not Config.AdminMode then
                                    QBCore.Functions.Notify("Upgrade purchased", "success")
                                else
                                    QBCore.Functions.Notify("Upgrade applied", "success")
                                end
    
                                for key, value in pairs(menu.Items) do
                                    value:RightLabel('')
                                end
                                item:RightLabel('[X]')
    
                                if num == 53 then
                                    if category == 2 and item.Index ~= Config.Vehicle.Mods.pearlescentColor then
                                        Config.Vehicle.Mods.pearlescentColor = item.Index
    
                                        Config.Vehicle.ChangedMod = true
                                    elseif item.Index ~= Config.Vehicle.Mods.color1 then
                                        Config.Vehicle.Mods.color1 = item.Index
    
                                        Config.Vehicle.ChangedMod = true
                                    end
                                elseif num == 54 and item.Index ~= Config.Vehicle.Mods.color2 then
                                    Config.Vehicle.Mods.color2 = item.Index
    
                                    Config.Vehicle.ChangedMod = true
                                elseif num == 56 then
                                    if category == 6 and item.Index ~= Config.Vehicle.Mods.interiorColor then
                                        Config.Vehicle.Mods.interiorColor = item.Index
    
                                        Config.Vehicle.ChangedMod = true
                                    elseif category == 7 and item.Index ~= Config.Vehicle.Mods.dashboardColor then
                                        Config.Vehicle.Mods.dashboardColor = item.Index
    
                                        Config.Vehicle.ChangedMod = true
                                    end
                                elseif num == 57 and item.Index ~= Config.Vehicle.Mods.wheelColor then
                                    Config.Vehicle.Mods.wheelColor = item.Index
                                    
                                    Config.Vehicle.ChangedMod = true
                                end
                            end
                        end, item.Price)
                    end

                    Config.Categories[num][category].OnMenuChanged = function(menu, newmenu, forward)
                        if not forward and not Config.Vehicle.ChangedMod then
                            if num == 53 then
                                local primary, secondary = GetVehicleColours(Config.Vehicle.Vehicle)
                                local pearlescent, wheel = GetVehicleExtraColours(Config.Vehicle.Vehicle)

                                if menu.Category == 2 then
                                    SetVehicleExtraColours(Config.Vehicle.Vehicle, Config.Vehicle.Mods.pearlescentColor, wheel)
                                else
                                    SetVehicleColours(Config.Vehicle.Vehicle, Config.Vehicle.Mods.color1, secondary)
                                end
                            elseif num == 54 then
                                local primary, secondary = GetVehicleColours(Config.Vehicle.Vehicle)

                                SetVehicleColours(Config.Vehicle.Vehicle, primary, Config.Vehicle.Mods.color2)
                            elseif num == 56 then
                                if menu.Category == 6 then
                                    SetVehicleInteriorColor(Config.Vehicle.Vehicle, Config.Vehicle.Mods.interiorColor)
                                elseif menu.Category == 7 then
                                    SetVehicleDashboardColor(Config.Vehicle.Vehicle, Config.Vehicle.Mods.dashboardColor)
                                end
                            elseif num == 57 then
                                if menu.Category == 0 then
                                    local pearlescent, wheel = GetVehicleExtraColours(Config.Vehicle.Vehicle)
    
                                    SetVehicleExtraColours(Config.Vehicle.Vehicle, pearlescent, Config.Vehicle.Mods.wheelColor)
                                elseif menu.Category == 8 then
                                    SetVehicleTyreSmokeColor(Config.Vehicle.Vehicle, Config.Colors[6][index].index[1], Config.Colors[6][index].index[2], Config.Colors[6][index].index[3])
                                end 
                            end
                        end

                        Config.Vehicle.ChangedMod = nil
                    end
                end

                Config.Categories[num][category].Items = {}

                for _, color in pairs(colors) do
                    local item = NativeUI.CreateItem(color.label, '$'..Config.CommaValue(color.price).." "..color.label)
                    item.Price = color.price
                    item.Index = color.index

                    if num == 53 then
                        if category == 2 and color.index == Config.Vehicle.Mods.pearlescentColor then
                            item:RightLabel('[X]')
                        elseif color.index == Config.Vehicle.Mods.color1 and category ~= 2 then
                            item:RightLabel('[X]')
                        end
                    elseif num == 54 and color.index == Config.Vehicle.Mods.color2 then
                        item:RightLabel('[X]')
                    elseif num == 56 then
                        if category == 6 and color.index == Config.Vehicle.Mods.interiorColor then
                            item:RightLabel('[X]')
                        elseif category == 7 and color.index == Config.Vehicle.Mods.dashboardColor then
                            item:RightLabel('[X]')
                        end
                    elseif num == 57 and color.index == Config.Vehicle.Mods.wheelColor then
                        item:RightLabel('[X]')
                    end

                    Config.Categories[num][category]:AddItem(item)
                end
            end
        end
    end
end

function OpenWheelMenu(standalone)
    local includes = {23}

    if standalone then
        Config.Categories = {}

        Config.ModMenu = NativeUI.CreateMenu('LS Customs', 'Modify your wheels', 1400, 50, 'shopui_title_ie_modgarage','shopui_title_ie_modgarage') 
        Config.Menu:Add(Config.ModMenu)

        Config.ModMenu.OnIndexChange = function(sender, index)
            CheckDoorToggle()
        end

        Config.ModMenu.OnMenuChanged = function(menu, newmenu, forward)
            local category = newmenu.Category

            if forward and category and Config.TableHasValue(includes, category) then
                WheelMenuChanged(newmenu)
            end
        end
    else
        Config.WheelMenu = Config.Menu:AddSubMenu(Config.ModMenu, "Wheels", "Wheels", true, true, true)

        Config.WheelMenu.OnMenuChanged = function(menu, newmenu, forward)
            local category = newmenu.Category

            if forward and category and Config.TableHasValue(includes, category) then
                WheelMenuChanged(newmenu)
            end
        end 
    end

    for category, mods in Config.PairsByKeys(Config.Vehicle.Mods.modList) do
        if Config.TableHasValue(includes, category) and not Config.Categories[category] then
            if standalone then
                PopulateWheelCategories(Config.ModMenu, category, mods)
            else
                PopulateWheelCategories(Config.WheelMenu, category, mods)
            end
        end
    end
end

function WheelMenuChanged(newmenu)
    local category = newmenu.Category
    local wheelcategory = newmenu.WheelCategory

    newmenu.Items = {}

    for key,wheel in pairs(Config.Vehicle.Mods.modList[category][wheelcategory]) do
        local item = NativeUI.CreateItem(wheel.label, '$'..wheel.price.." "..wheel.label)
        if  (key == 1 and Config.Vehicle.Mods.currentMods[category] == -1) or (Config.Vehicle.Mods.wheels == wheelcategory and Config.Vehicle.Mods.currentMods[category] == wheel.index) then
            item:RightLabel('[X]')
        end

        newmenu:AddItem(item)
    end

    newmenu.OnIndexChange = function(sender, index)
        local wheel = Config.Vehicle.Mods.modList[category][Config.Categories[category].WheelCategory][index]

        SetVehicleWheelType(Config.Vehicle.Vehicle, wheelcategory)
        SetVehicleMod(Config.Vehicle.Vehicle, 23, wheel.index)
    end

    newmenu.OnItemSelect = function(menu, item, index)
        local wheel = Config.Vehicle.Mods.modList[category][Config.Categories[category].WheelCategory][index]

        if  GetVehicleWheelType(Config.Vehicle.Vehicle) ~= Config.Vehicle.Mods.wheels or wheel.index ~= Config.Vehicle.Mods.currentMods[category] then
            for key,value in pairs(menu.Items) do
                value:RightLabel('')
            end

            item:RightLabel('[X]')

            Config.Vehicle.Mods.currentMods[category] = wheel.index
            Config.Vehicle.Mods.wheels = wheelcategory

            Config.Vehicle.ChangedMod = true
        end
    end

    newmenu.OnMenuChanged = function(menu, newmenu, forward)
        if not forward then
            if not Config.Vehicle.ChangedMod then
                SetVehicleWheelType(Config.Vehicle.Vehicle, Config.Vehicle.Mods.wheels)
                SetVehicleMod(Config.Vehicle.Vehicle, category, Config.Vehicle.Mods.currentMods[category])
            end

            Config.Vehicle.CurrentType = nil
            Config.Vehicle.ChangedMod = nil
        end
    end

    SetVehicleMod(Config.Vehicle.Vehicle, category, -1)

    newmenu:RefreshIndex()
end

function PopulateWheelCategories(menu, category, mods)
    if not Config.Categories[category] then
        for wheelcategory, wheels in pairs(mods) do
            Config.Categories[category] = Config.Menu:AddSubMenu(menu, wheels[1].category, wheels[1].category, true, true, true)
            Config.Categories[category].Category = category
            Config.Categories[category].WheelCategory = wheelcategory
        end
    end
end

function OpenModMenu()
    local excluded = {23,53,54,56,57}

    Config.ModMenu = NativeUI.CreateMenu('LS Customs', 'Modify your vehicle', 1400, 50, 'shopui_title_ie_modgarage','shopui_title_ie_modgarage') 
    Config.Menu:Add(Config.ModMenu)

    Config.ModMenu.OnIndexChange = function(sender, index)
        CheckDoorToggle()
    end

    Config.ModMenu.OnMenuChanged = function(menu, newmenu, forward)
        local category = newmenu.Category

        if forward and category and not Config.TableHasValue(excluded, category) then
            newmenu.Items = {}

            for index,mod in pairs(Config.Vehicle.Mods.modList[category]) do
                if mod.label == "NULL" then
                    mod.label = "Stock"
                    mod.price = 0
                end

                local item = NativeUI.CreateItem(mod.label, "$"..Config.CommaValue(mod.price).." "..mod.label)

                if category == 22 and mod.index == -1 and not Config.Vehicle.Mods.currentMods[category] then
                    item:RightLabel('[X]')

                    UpdateMod(category, 1)
                elseif category == 51 then 
                    if 
                        (not mod.index[1] and mod.index[1] == Config.Vehicle.Mods.neonEnabled[1]) and 
                        (not mod.index[2] and mod.index[2] == Config.Vehicle.Mods.neonEnabled[2]) and 
                        (not mod.index[3] and mod.index[3] == Config.Vehicle.Mods.neonEnabled[3]) and 
                        (not mod.index[4] and mod.index[4] == Config.Vehicle.Mods.neonEnabled[4]) 
                    then
                        item:RightLabel('[X]')

                        UpdateMod(category, 1)
                    elseif 
                        (mod.index[1] == Config.Vehicle.Mods.neonEnabled[1]) and 
                        (mod.index[2] == Config.Vehicle.Mods.neonEnabled[2]) and 
                        (mod.index[3] == Config.Vehicle.Mods.neonEnabled[3]) and 
                        (mod.index[4] == Config.Vehicle.Mods.neonEnabled[4]) 
                    then
                        item:RightLabel('[X]')

                        UpdateMod(category, 1)
                    end
                elseif category == 52 and 
                    mod.index[1] == Config.Vehicle.Mods.neonColor[1] and 
                    mod.index[2] == Config.Vehicle.Mods.neonColor[2] and 
                    mod.index[3] == Config.Vehicle.Mods.neonColor[3] 
                then
                    item:RightLabel('[X]')

                    UpdateMod(category, 1)
                elseif category == 55 and mod.index == Config.Vehicle.Mods.windowTint then
                    item:RightLabel('[X]')

                    UpdateMod(category, 1)
                elseif mod.index == Config.Vehicle.Mods.currentMods[category] then
                    item:RightLabel('[X]')

                    UpdateMod(category, 1)
                end
                
                newmenu:AddItem(item)
            end

            newmenu.OnIndexChange = function(sender, index) 
                if category == 22 then
                    if index == 1 then
                        ToggleVehicleMod(Config.Vehicle.Vehicle, 22, false)
                    else
                        ToggleVehicleMod(Config.Vehicle.Vehicle, 22, true)
                        SetVehicleXenonLightsColour(Config.Vehicle.Vehicle, Config.Vehicle.Mods.modList[category][index].index)
                    end
                elseif category == 50 then
                    SetVehicleNumberPlateTextIndex(Config.Vehicle.Vehicle, Config.Vehicle.Mods.modList[category][index].index)
                elseif category == 51 then
                    local layout = Config.Mods.NeonLayout[index].index

                    for key, value in pairs(layout) do
                        SetVehicleNeonLightEnabled(Config.Vehicle.Vehicle, key-1, value)
                    end
                elseif category == 52 then
                    local color = Config.Mods.NeonColors[index].index

                    SetVehicleNeonLightsColour(Config.Vehicle.Vehicle, color[1], color[2], color[3])
                elseif category == 55 then                            
                    SetVehicleWindowTint(Config.Vehicle.Vehicle, Config.Vehicle.Mods.modList[category][index].index)
                else
                    if Config.Debug and Config.AdminMode then
                        print(Config.Vehicle.Mods.modelName.." "..category..": "..index-2, GetModTextLabel(Config.Vehicle.Vehicle, category, Config.Vehicle.Mods.modList[category][index].index), Config.VmtCategories[category])
                    end

                    if index == 1 then
                        SetVehicleMod(Config.Vehicle.Vehicle, category, -1)
                    else
                        SetVehicleMod(Config.Vehicle.Vehicle, category, Config.Vehicle.Mods.modList[category][index].index)
                    end
                end
        
                CheckDoorToggle(category)
            end

            newmenu.OnItemSelect = function(menu, item, index)
                for key,value in pairs(menu.Items) do
                    value:RightLabel('')
                end 
                item:RightLabel('[X]')

                QBCore.Functions.TriggerCallback('lscustoms:can-purchase', function(bool)
                    if category == 22 then 
                        if Config.Vehicle.Mods.currentMods[category] == IsToggleModOn(Config.Vehicle.Vehicle, category) then
                            if Config.Vehicle.Mods.xenonColor ~= GetVehicleXenonLightsColour(Config.Vehicle.Vehicle)then
                                if Config.AdminMode or bool then
                                    Config.Vehicle.Mods.xenonColor = GetVehicleXenonLightsColour(Config.Vehicle.Vehicle)
                                    Config.Vehicle.ChangedMod = true
                                
                                    UpdateMod(category, index)
    
                                    if not Config.AdminMode then
                                        QBCore.Functions.Notify("Upgrade purchased", "success")
                                    else
                                        QBCore.Functions.Notify("Upgrade applied", "success")
                                    end
                                else
                                    QBCore.Functions.Notify("Unable to make purchase", "error")
                                end
                            end
                        else
                            if Config.AdminMode or bool then
                                Config.Vehicle.Mods.currentMods[category] = IsToggleModOn(Config.Vehicle.Vehicle, category)
                                Config.Vehicle.ChangedMod = true
                                
                                UpdateMod(category, index)
    
                                if not Config.AdminMode then
                                    QBCore.Functions.Notify("Upgrade purchased", "success")
                                else
                                    QBCore.Functions.Notify("Upgrade applied", "success")
                                end
                            else
                                QBCore.Functions.Notify("Unable to make purchase", "error")
                            end
                        end 
                    elseif category == 50 then
                        if Config.AdminMode or bool then
                            if Config.Vehicle.Mods.plateIndex ~= GetVehicleNumberPlateTextIndex(Config.Vehicle.Vehicle) then
                                Config.Vehicle.Mods.plateIndex = GetVehicleNumberPlateTextIndex(Config.Vehicle.Vehicle)
                                Config.Vehicle.ChangedMod = true
                                
                                UpdateMod(category, index)
    
                                if not Config.AdminMode then
                                    QBCore.Functions.Notify("Upgrade purchased", "success")
                                else
                                    QBCore.Functions.Notify("Upgrade applied", "success")
                                end
                            else
                                QBCore.Functions.Notify("Unable to make purchase", "error")
                            end
                        end
                    elseif category == 51 then
                        if 
                            Config.Vehicle.Mods.neonEnabled[1] ~= IsVehicleNeonLightEnabled(Config.Vehicle.Vehicle, 0) and true or
                            Config.Vehicle.Mods.neonEnabled[2] ~= IsVehicleNeonLightEnabled(Config.Vehicle.Vehicle, 1) and true or
                            Config.Vehicle.Mods.neonEnabled[3] ~= IsVehicleNeonLightEnabled(Config.Vehicle.Vehicle, 2) and true or
                            Config.Vehicle.Mods.neonEnabled[4] ~= IsVehicleNeonLightEnabled(Config.Vehicle.Vehicle, 3) and true
                        then
                            if Config.AdminMode or bool then
                                Config.Vehicle.Mods.neonEnabled = {
                                    IsVehicleNeonLightEnabled(Config.Vehicle.Vehicle, 0) and true,
                                    IsVehicleNeonLightEnabled(Config.Vehicle.Vehicle, 1) and true,
                                    IsVehicleNeonLightEnabled(Config.Vehicle.Vehicle, 2) and true,
                                    IsVehicleNeonLightEnabled(Config.Vehicle.Vehicle, 3) and true
                                }
                                Config.Vehicle.ChangedMod = true
    
                                UpdateMod(category, index)
    
                                if not Config.AdminMode then
                                    QBCore.Functions.Notify("Upgrade purchased", "success")
                                else
                                    QBCore.Functions.Notify("Upgrade applied", "success")
                                end
                            else
                                QBCore.Functions.Notify("Unable to make purchase", "error")
                            end
                        end
                    elseif category == 52 then
                        if 
                            Config.Vehicle.Mods.neonColor[1] ~= table.pack(GetVehicleNeonLightsColour(Config.Vehicle.Vehicle))[1] or
                            Config.Vehicle.Mods.neonColor[2] ~= table.pack(GetVehicleNeonLightsColour(Config.Vehicle.Vehicle))[2] or
                            Config.Vehicle.Mods.neonColor[3] ~= table.pack(GetVehicleNeonLightsColour(Config.Vehicle.Vehicle))[3]
                        then
                            if Config.AdminMode or bool then
                                Config.Vehicle.Mods.neonColor = table.pack(GetVehicleNeonLightsColour(Config.Vehicle.Vehicle))
                                Config.Vehicle.ChangedMod = true
                                
                                UpdateMod(category, index)
    
                                if not Config.AdminMode then
                                    QBCore.Functions.Notify("Upgrade purchased", "success")
                                else
                                    QBCore.Functions.Notify("Upgrade applied", "success")
                                end
                            else
                                QBCore.Functions.Notify("Unable to make purchase", "error")
                            end
                        end
                    elseif category == 55 then
                        if Config.Vehicle.Mods.windowTint ~= GetVehicleWindowTint(Config.Vehicle.Vehicle) then
                            if Config.AdminMode or bool then
                                Config.Vehicle.Mods.windowTint = GetVehicleWindowTint(Config.Vehicle.Vehicle)
                                Config.Vehicle.ChangedMod = true
                                
                                UpdateMod(category, index)
    
                                if not Config.AdminMode then
                                    QBCore.Functions.Notify("Upgrade purchased", "success")
                                else
                                    QBCore.Functions.Notify("Upgrade applied", "success")
                                end
                            else
                                QBCore.Functions.Notify("Unable to make purchase", "error")
                            end
                        end
                    else
                        if Config.Vehicle.Mods.currentMods[category] ~= Config.Vehicle.Mods.modList[category][index].index then
                            if Config.AdminMode or bool then
                                Config.Vehicle.Mods.currentMods[category] = Config.Vehicle.Mods.modList[category][index].index
                                Config.Vehicle.ChangedMod = true
                                
                                UpdateMod(category, index)
    
                                if not Config.AdminMode then
                                    QBCore.Functions.Notify("Upgrade purchased", "success")
                                else
                                    QBCore.Functions.Notify("Upgrade applied", "success")
                                end
                            else
                                QBCore.Functions.Notify("Unable to make purchase", "error")
                            end
                        end
                    end
                end, Config.Vehicle.Mods.modList[category][index].price)
                
            end

            newmenu.OnMenuChanged = function(menu, newmenu, forward)
                if not Config.Vehicle.ChangedMod and not forward then
                    if category == 22 then 
                        ToggleVehicleMod(Config.Vehicle.Vehicle, 22, Config.Vehicle.Mods.currentMods[category])
                        SetVehicleXenonLightsColour(Config.Vehicle.Vehicle, Config.Vehicle.Mods.xenonColor)
                    elseif category == 50 then
                        SetVehicleNumberPlateTextIndex(Config.Vehicle.Vehicle, Config.Vehicle.Mods.plateIndex)
                    elseif category == 51 then
                        SetVehicleNeonLightEnabled(Config.Vehicle.Vehicle, 0, Config.Vehicle.Mods.neonEnabled[1] and true)
                        SetVehicleNeonLightEnabled(Config.Vehicle.Vehicle, 1, Config.Vehicle.Mods.neonEnabled[2] and true)
                        SetVehicleNeonLightEnabled(Config.Vehicle.Vehicle, 2, Config.Vehicle.Mods.neonEnabled[3] and true)
                        SetVehicleNeonLightEnabled(Config.Vehicle.Vehicle, 3, Config.Vehicle.Mods.neonEnabled[4] and true)
                    elseif category == 52 then
                        SetVehicleNeonLightsColour(Config.Vehicle.Vehicle, Config.Vehicle.Mods.neonColor[1], Config.Vehicle.Mods.neonColor[2], Config.Vehicle.Mods.neonColor[3])
                    elseif category == 55 then
                        SetVehicleWindowTint(Config.Vehicle.Vehicle, Config.Vehicle.Mods.windowTint)
                    else
                        SetVehicleMod(Config.Vehicle.Vehicle, category, Config.Vehicle.Mods.currentMods[category])
                    end
                end

                Config.Vehicle.CurrentType = nil
                Config.Vehicle.ChangedMod = nil
            end
        end
        
        newmenu:RefreshIndex()
    end

    for category, mods in Config.PairsByKeys(Config.Vehicle.Mods.modList) do
        if not Config.TableHasValue(excluded, category) then
            if not Config.Categories[category] then
                Config.Categories[category] = Config.Menu:AddSubMenu(Config.ModMenu, mods[1].category, mods[1].category, true, true, true)
                Config.Categories[category].Category = category
            end
        end
    end
end

function UpdateMod(category, index)
    Config.Vehicle.CurrentType = category

    if category == 22 then
        if index == 1 then
            ToggleVehicleMod(Config.Vehicle.Vehicle, 22, false)
        else
            ToggleVehicleMod(Config.Vehicle.Vehicle, 22, true)
            SetVehicleXenonLightsColour(Config.Vehicle.Vehicle, Config.Vehicle.Mods.modList[category][index].index)
        end
    elseif category == 50 then
        SetVehicleNumberPlateTextIndex(Config.Vehicle.Vehicle, Config.Vehicle.Mods.modList[category][index].index)
    elseif category == 51 then
        local layout = Config.Mods.NeonLayout[index].index

        for key, value in pairs(layout) do
            SetVehicleNeonLightEnabled(Config.Vehicle.Vehicle, key-1, value)
        end
    elseif category == 52 then
        local color = Config.Mods.NeonColors[index].index

        SetVehicleNeonLightsColour(Config.Vehicle.Vehicle, color[1], color[2], color[3])
    elseif category == 55 then                    
        SetVehicleWindowTint(Config.Vehicle.Vehicle, Config.Vehicle.Mods.modList[category][index].index)
    else
        if Config.Debug and Config.AdminMode then
            print(Config.Vehicle.Mods.modelName.." "..category..": "..index-2, GetModTextLabel(Config.Vehicle.Vehicle, category, Config.Vehicle.Mods.modList[category][index].index))
        end

        if index == 1 then
            SetVehicleMod(Config.Vehicle.Vehicle, category, -1)
        else
            SetVehicleMod(Config.Vehicle.Vehicle, category, Config.Vehicle.Mods.modList[category][index].index)
        end
    end

    CheckDoorToggle(category)
end

Citizen.CreateThread(function()
    while true do
        Wait(0)
		Config.Menu:ProcessMenus()

        if Config.ModMenu and not Config.ModMenu:Visible() and Config.InMenu then
            Config.InMenu = false

            CheckDoorToggle()
            FreezeEntityPosition(Config.Vehicle.Vehicle, false)
        end
    end
end)

function CheckDoorToggle(mod)
    if Config.DoorToggles[Config.Vehicle.Mods.modelName] and Config.DoorToggles[Config.Vehicle.Mods.modelName][mod] then
        if type(Config.Doors[Config.DoorToggles[Config.Vehicle.Mods.modelName][mod]]) == "table" then
            for key, value in pairs(Config.Doors[Config.DoorToggles[Config.Vehicle.Mods.modelName][mod]]) do
                SetVehicleDoorOpen(Config.Vehicle.Vehicle, value, false, false)
            end
        else
            SetVehicleDoorOpen(Config.Vehicle.Vehicle, Config.Doors[Config.DoorToggles[Config.Vehicle.Mods.modelName][mod]], false, false)
        end
    else
        for key,value in pairs(Config.Doors) do
            if type(value) ~= "table" then 
                if GetVehicleDoorAngleRatio(Config.Vehicle.Vehicle, value) > 0 then
                    SetVehicleDoorShut(Config.Vehicle.Vehicle, value, false)
                end
            end
        end
    end
end