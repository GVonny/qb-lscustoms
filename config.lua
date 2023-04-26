Config.CommaValue = function(amount)
    local formatted = amount
    while true do  
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if (k==0) then
            break
        end
    end
    return formatted
end

Config.Trim = function(value)
    if not value then return nil end
    return (string.gsub(value, '^%s*(.-)%s*$', '%1'))
end

Config.PairsByKeys = function(t, f)
    local a = {}
    for n in pairs(t) do table.insert(a, n) end
    table.sort(a, f)
    local i = 0
    local iter = function ()
        i = i + 1
        if a[i] == nil then return nil
        else return a[i], t[a[i]]
        end
    end
    return iter
end

Config.TableLength = function(table)
    local count = 0
        for _ in pairs(table) do count = count + 1 end
    return count
end

Config.TableHasValue = function(table, val)
    for index, value in ipairs(table) do
        if value == val then
            return true
        end
    end

    return false
end

Config.GetVehicleProperties = function(vehicle)
    if DoesEntityExist(vehicle) then
    --properties
	    SetVehicleModKit(vehicle, 0)

        local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)

        local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
        if GetIsVehiclePrimaryColourCustom(vehicle) then
            local r, g, b = GetVehicleCustomPrimaryColour(vehicle)
            colorPrimary = {r, g, b}
        end

        if GetIsVehicleSecondaryColourCustom(vehicle) then
            local r, g, b = GetVehicleCustomSecondaryColour(vehicle)
            colorSecondary = {r, g, b}
        end

        local extras = {}
        for extraId = 0, 12 do
            if DoesExtraExist(vehicle, extraId) then
                local state = IsVehicleExtraTurnedOn(vehicle, extraId) == 1
                extras[tostring(extraId)] = state
            end
        end

        local modLivery = GetVehicleMod(vehicle, 48)

        local tireHealth = {}
        for i = 0, 3 do
            tireHealth[i] = GetVehicleWheelHealth(vehicle, i)
        end

        local tireBurstState = {}
        for i = 0, 5 do
           tireBurstState[i] = IsVehicleTyreBurst(vehicle, i, false)
        end

        local tireBurstCompletely = {}
        for i = 0, 5 do
            tireBurstCompletely[i] = IsVehicleTyreBurst(vehicle, i, true)
        end

        local windowStatus = {}
        for i = 0, 7 do
            windowStatus[i] = IsVehicleWindowIntact(vehicle, i) == 1
        end

        local doorStatus = {}
        for i = 0, 5 do
            doorStatus[i] = IsVehicleDoorDamaged(vehicle, i) == 1
        end

        local currentMods = {}
        for x=0,50 do
            if x == 22 then
                currentMods[x] = IsToggleModOn(vehicle, x)
            elseif x == 50 then
                currentMods[x] = GetVehicleNumberPlateTextIndex(vehicle)
            else
                currentMods[x] = GetVehicleMod(vehicle, x)
            end
        end

        local windowTint = GetVehicleWindowTint(vehicle)
        if windowTint == -1 then
            windowTint = 0
        end

        local modelName = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)):lower()
    --customs
        local modList = {}
        local excluded = {16,21}
        for x=0,57 do
            if not Config.TableHasValue(excluded, x) and (Config.AllowBlacklisted or not Config.BlacklistAll(modelName, x)) then
                local category = Config.GetModCategoryName(vehicle, modelName, x)

                if x == 11 then
                    modList[x] = Config.Mods.Engines
                elseif x == 12 then
                    modList[x] = Config.Mods.Brakes
                elseif x == 13 then
                    modList[x] = Config.Mods.Transmissions
                elseif x == 14 then
                    modList[x] = Config.Mods.Horns
                elseif x == 15 then
                    modList[x] = Config.Mods.Suspension
                elseif x == 22 then
                    modList[x] = Config.Mods.Headlights
                elseif x == 23 then
                    modList[x] = Config.Mods.Wheels
                elseif x == 24 and GetVehicleNumberOfWheels(Config.Vehicle.vehicle) == 2 then
                    modList[x] = Config.Mods.Wheels
                elseif x == 50 then
                    modList[x] = Config.Mods.Plates
                elseif x == 51 then
                    modList[x] = Config.Mods.NeonLayout
                elseif x == 52 then
                    modList[x] = Config.Mods.NeonColors
                elseif x == 53 then
                    modList[x] = Config.SetModType(Config.Mods.Primary, x)
                elseif x == 54 then
                    modList[x] = Config.SetModType(Config.Mods.Secondary, x)
                elseif x == 55 then
                    modList[x] = Config.Mods.WindowTint
                elseif x == 56 then
                    modList[x] = Config.SetModType(Config.Mods.Interior, x)
                elseif x == 57 then
                    modList[x] = Config.SetModType(Config.Mods.WheelColor, x)
                else
                    if GetNumVehicleMods(vehicle, x) > 0 then
                        modList[x] = {}

                        for y=-1, GetNumVehicleMods(vehicle, x)-1 do
                            if Config.AllowBlacklisted or not Config.BlacklistMod(modelName, x, y) then
                                local label = Config.GetModLabelName(vehicle, modelName, x, y)
                                
                                if y > -1 and label == "NULL" then
                                    if Config.CustomExceptionLabels[modelName] and Config.CustomExceptionLabels[modelName][x] and Config.CustomExceptionLabels[modelName][x][y] then
                                        label = Config.CustomExceptionLabels[modelName][x][y]
                                    end
                                end

                                table.insert(modList[x], Config.CreateMod(x, y, label, category, modelName))
                            end
                        end
                    end
                end
            end
        end

        return {
            currentMods = currentMods,
            model = GetEntityModel(vehicle),
            modelName = modelName,
            plate = string.gsub(GetVehicleNumberPlateText(vehicle), '^%s*(.-)%s*$', '%1'),
            plateIndex = GetVehicleNumberPlateTextIndex(vehicle),
            bodyHealth = GetVehicleBodyHealth(vehicle),
            engineHealth = GetVehicleEngineHealth(vehicle),
            tankHealth = GetVehiclePetrolTankHealth(vehicle),
            fuelLevel = GetVehicleFuelLevel(vehicle),
            dirtLevel = GetVehicleDirtLevel(vehicle),
            oilLevel = GetVehicleOilLevel(vehicle),
            color1 = colorPrimary,
            color2 = colorSecondary,
            pearlescentColor = pearlescentColor,
            dashboardColor = GetVehicleDashboardColour(vehicle),
            wheelColor = wheelColor,
            wheels = GetVehicleWheelType(vehicle),
            wheelSize = GetVehicleWheelSize(vehicle),
            wheelWidth = GetVehicleWheelWidth(vehicle),
            tireHealth = tireHealth,
            tireBurstState = tireBurstState,
            tireBurstCompletely = tireBurstCompletely,
            windowTint = windowTint,
            windowStatus = windowStatus,
            doorStatus = doorStatus,
            xenonColor = GetVehicleXenonLightsColour(vehicle),
            neonEnabled = {
                IsVehicleNeonLightEnabled(vehicle, 0) and true,
                IsVehicleNeonLightEnabled(vehicle, 1) and true,
                IsVehicleNeonLightEnabled(vehicle, 2) and true,
                IsVehicleNeonLightEnabled(vehicle, 3) and true
            },
            neonColor = table.pack(GetVehicleNeonLightsColour(vehicle)),
            headlightColor = GetVehicleHeadlightsColour(vehicle),
            interiorColor = GetVehicleInteriorColour(vehicle),
            extras = extras,
            tyreSmokeColor = table.pack(GetVehicleTyreSmokeColor(vehicle)),
            modSpoilers = GetVehicleMod(vehicle, 0),
            modFrontBumper = GetVehicleMod(vehicle, 1),
            modRearBumper = GetVehicleMod(vehicle, 2),
            modSideSkirt = GetVehicleMod(vehicle, 3),
            modExhaust = GetVehicleMod(vehicle, 4),
            modFrame = GetVehicleMod(vehicle, 5),
            modGrille = GetVehicleMod(vehicle, 6),
            modHood = GetVehicleMod(vehicle, 7),
            modFender = GetVehicleMod(vehicle, 8),
            modRightFender = GetVehicleMod(vehicle, 9),
            modRoof = GetVehicleMod(vehicle, 10),
            modEngine = GetVehicleMod(vehicle, 11),
            modBrakes = GetVehicleMod(vehicle, 12),
            modTransmission = GetVehicleMod(vehicle, 13),
            modHorns = GetVehicleMod(vehicle, 14),
            modSuspension = GetVehicleMod(vehicle, 15),
            modArmor = GetVehicleMod(vehicle, 16),
            modKit17 = GetVehicleMod(vehicle, 17),
            modTurbo = IsToggleModOn(vehicle, 18),
            modKit19 = GetVehicleMod(vehicle, 19),
            modSmokeEnabled = IsToggleModOn(vehicle, 20),
            modKit21 = GetVehicleMod(vehicle, 21),
            modXenon = IsToggleModOn(vehicle, 22),
            modFrontWheels = GetVehicleMod(vehicle, 23),
            modBackWheels = GetVehicleMod(vehicle, 24),
            modCustomTiresF = GetVehicleModVariation(vehicle, 23),
            modCustomTiresR = GetVehicleModVariation(vehicle, 24),
            modPlateHolder = GetVehicleMod(vehicle, 25),
            modVanityPlate = GetVehicleMod(vehicle, 26),
            modTrimA = GetVehicleMod(vehicle, 27),
            modOrnaments = GetVehicleMod(vehicle, 28),
            modDashboard = GetVehicleMod(vehicle, 29),
            modDial = GetVehicleMod(vehicle, 30),
            modDoorSpeaker = GetVehicleMod(vehicle, 31),
            modSeats = GetVehicleMod(vehicle, 32),
            modSteeringWheel = GetVehicleMod(vehicle, 33),
            modShifterLeavers = GetVehicleMod(vehicle, 34),
            modAPlate = GetVehicleMod(vehicle, 35),
            modSpeakers = GetVehicleMod(vehicle, 36),
            modTrunk = GetVehicleMod(vehicle, 37),
            modHydrolic = GetVehicleMod(vehicle, 38),
            modEngineBlock = GetVehicleMod(vehicle, 39),
            modAirFilter = GetVehicleMod(vehicle, 40),
            modStruts = GetVehicleMod(vehicle, 41),
            modArchCover = GetVehicleMod(vehicle, 42),
            modMirror = GetVehicleMod(vehicle, 43),
            modTrimB = GetVehicleMod(vehicle, 44),
            modTank = GetVehicleMod(vehicle, 45),
            modWindows = GetVehicleMod(vehicle, 46),
            modKit47 = GetVehicleMod(vehicle, 47),
            modLivery = modLivery,
            modKit49 = GetVehicleMod(vehicle, 49),
            liveryRoof = GetVehicleRoofLivery(vehicle),
            modCount = modCount,
            modList = modList
        }
    else
        return
    end
end

Config.SetVehicleProperties = function(vehicle, props)
    if DoesEntityExist(vehicle) then
        if props.extras then
            for id, enabled in pairs(props.extras) do
                if enabled then
                    SetVehicleExtra(vehicle, tonumber(id), 0)
                else
                    SetVehicleExtra(vehicle, tonumber(id), 1)
                end
            end
        end

        local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
        local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
        SetVehicleModKit(vehicle, 0)
        if props.plate then
            SetVehicleNumberPlateText(vehicle, props.plate)
        end
        if props.plateIndex then
            SetVehicleNumberPlateTextIndex(vehicle, props.plateIndex)
        end
        if props.bodyHealth then
            SetVehicleBodyHealth(vehicle, props.bodyHealth + 0.0)
        end
        if props.engineHealth then
            SetVehicleEngineHealth(vehicle, props.engineHealth + 0.0)
        end
        if props.tankHealth then
            SetVehiclePetrolTankHealth(vehicle, props.tankHealth)
        end
        if props.fuelLevel then
            SetVehicleFuelLevel(vehicle, props.fuelLevel + 0.0)
        end
        if props.dirtLevel then
            SetVehicleDirtLevel(vehicle, props.dirtLevel + 0.0)
        end
        if props.oilLevel then
            SetVehicleOilLevel(vehicle, props.oilLevel)
        end
        if props.color1 then
            if type(props.color1) == "number" then
                SetVehicleColours(vehicle, props.color1, colorSecondary)
            else
                SetVehicleCustomPrimaryColour(vehicle, props.color1[1], props.color1[2], props.color1[3])
            end
        end
        if props.color2 then
            if type(props.color2) == "number" then
                SetVehicleColours(vehicle, props.color1 or colorPrimary, props.color2)
            else
                SetVehicleCustomSecondaryColour(vehicle, props.color2[1], props.color2[2], props.color2[3])
            end
        end
        if props.pearlescentColor then
            SetVehicleExtraColours(vehicle, props.pearlescentColor, wheelColor)
        end
        if props.interiorColor then
            SetVehicleInteriorColor(vehicle, props.interiorColor)
        end
        if props.dashboardColor then
            SetVehicleDashboardColour(vehicle, props.dashboardColor)
        end
        if props.wheelColor then
            SetVehicleExtraColours(vehicle, props.pearlescentColor or pearlescentColor, props.wheelColor)
        end
        if props.wheels then
            SetVehicleWheelType(vehicle, props.wheels)
        end
        if props.tireHealth then
            for wheelIndex, health in pairs(props.tireHealth) do
                SetVehicleWheelHealth(vehicle, wheelIndex, health)
            end
        end
        if props.tireBurstState then
            for wheelIndex, burstState in pairs(props.tireBurstState) do
                if burstState then
                    SetVehicleTyreBurst(vehicle, tonumber(wheelIndex), false, 1000.0)
                end
            end
        end
        if props.tireBurstCompletely then
            for wheelIndex, burstState in pairs(props.tireBurstCompletely) do
                if burstState then
                    SetVehicleTyreBurst(vehicle, tonumber(wheelIndex), true, 1000.0)
                end
            end
        end
        if props.windowTint then
            SetVehicleWindowTint(vehicle, props.windowTint)
        end
        if props.windowStatus then
            for windowIndex, smashWindow in pairs(props.windowStatus) do
                if not smashWindow then SmashVehicleWindow(vehicle, windowIndex) end
            end
        end
        if props.doorStatus then
            for doorIndex, breakDoor in pairs(props.doorStatus) do
                if breakDoor then
                    SetVehicleDoorBroken(vehicle, tonumber(doorIndex), true)
                end
            end
        end
        if props.neonEnabled then
            SetVehicleNeonLightEnabled(vehicle, 0, props.neonEnabled[1])
            SetVehicleNeonLightEnabled(vehicle, 1, props.neonEnabled[2])
            SetVehicleNeonLightEnabled(vehicle, 2, props.neonEnabled[3])
            SetVehicleNeonLightEnabled(vehicle, 3, props.neonEnabled[4])
        end
        if props.neonColor then
            SetVehicleNeonLightsColour(vehicle, props.neonColor[1], props.neonColor[2], props.neonColor[3])
        end
        if props.headlightColor then
            SetVehicleHeadlightsColour(vehicle, props.headlightColor)
        end
        if props.interiorColor then
            SetVehicleInteriorColour(vehicle, props.interiorColor)
        end
        if props.wheelSize then
            SetVehicleWheelSize(vehicle, props.wheelSize)
        end
        if props.wheelWidth then
            SetVehicleWheelWidth(vehicle, props.wheelWidth)
        end
        if props.tyreSmokeColor then
            SetVehicleTyreSmokeColor(vehicle, props.tyreSmokeColor[1], props.tyreSmokeColor[2], props.tyreSmokeColor[3])
        end
        if props.modSpoilers then
            SetVehicleMod(vehicle, 0, props.modSpoilers, false)
        end
        if props.modFrontBumper then
            SetVehicleMod(vehicle, 1, props.modFrontBumper, false)
        end
        if props.modRearBumper then
            SetVehicleMod(vehicle, 2, props.modRearBumper, false)
        end
        if props.modSideSkirt then
            SetVehicleMod(vehicle, 3, props.modSideSkirt, false)
        end
        if props.modExhaust then
            SetVehicleMod(vehicle, 4, props.modExhaust, false)
        end
        if props.modFrame then
            SetVehicleMod(vehicle, 5, props.modFrame, false)
        end
        if props.modGrille then
            SetVehicleMod(vehicle, 6, props.modGrille, false)
        end
        if props.modHood then
            SetVehicleMod(vehicle, 7, props.modHood, false)
        end
        if props.modFender then
            SetVehicleMod(vehicle, 8, props.modFender, false)
        end
        if props.modRightFender then
            SetVehicleMod(vehicle, 9, props.modRightFender, false)
        end
        if props.modRoof then
            SetVehicleMod(vehicle, 10, props.modRoof, false)
        end
        if props.modEngine then
            SetVehicleMod(vehicle, 11, props.modEngine, false)
        end
        if props.modBrakes then
            SetVehicleMod(vehicle, 12, props.modBrakes, false)
        end
        if props.modTransmission then
            SetVehicleMod(vehicle, 13, props.modTransmission, false)
        end
        if props.modHorns then
            SetVehicleMod(vehicle, 14, props.modHorns, false)
        end
        if props.modSuspension then
            SetVehicleMod(vehicle, 15, props.modSuspension, false)
        end
        if props.modArmor then
            SetVehicleMod(vehicle, 16, props.modArmor, false)
        end
        if props.modKit17 then
            SetVehicleMod(vehicle, 17, props.modKit17, false)
        end
        if props.modTurbo then
            ToggleVehicleMod(vehicle, 18, props.modTurbo)
        end
        if props.modKit19 then
            SetVehicleMod(vehicle, 19, props.modKit19, false)
        end
        if props.modSmokeEnabled then
            ToggleVehicleMod(vehicle, 20, props.modSmokeEnabled)
        end
        if props.modKit21 then
            SetVehicleMod(vehicle, 21, props.modKit21, false)
        end
        if props.modXenon then
            ToggleVehicleMod(vehicle, 22, props.modXenon)
        end
        if props.xenonColor then
            SetVehicleXenonLightsColor(vehicle, props.xenonColor)
        end
        if props.modFrontWheels then
            SetVehicleMod(vehicle, 23, props.modFrontWheels, false)
        end
        if props.modBackWheels then
            SetVehicleMod(vehicle, 24, props.modBackWheels, false)
        end
        if props.modCustomTiresF then
            SetVehicleMod(vehicle, 23, props.modFrontWheels, props.modCustomTiresF)
        end
        if props.modCustomTiresR then
            SetVehicleMod(vehicle, 24, props.modBackWheels, props.modCustomTiresR)
        end
        if props.modPlateHolder then
            SetVehicleMod(vehicle, 25, props.modPlateHolder, false)
        end
        if props.modVanityPlate then
            SetVehicleMod(vehicle, 26, props.modVanityPlate, false)
        end
        if props.modTrimA then
            SetVehicleMod(vehicle, 27, props.modTrimA, false)
        end
        if props.modOrnaments then
            SetVehicleMod(vehicle, 28, props.modOrnaments, false)
        end
        if props.modDashboard then
            SetVehicleMod(vehicle, 29, props.modDashboard, false)
        end
        if props.modDial then
            SetVehicleMod(vehicle, 30, props.modDial, false)
        end
        if props.modDoorSpeaker then
            SetVehicleMod(vehicle, 31, props.modDoorSpeaker, false)
        end
        if props.modSeats then
            SetVehicleMod(vehicle, 32, props.modSeats, false)
        end
        if props.modSteeringWheel then
            SetVehicleMod(vehicle, 33, props.modSteeringWheel, false)
        end
        if props.modShifterLeavers then
            SetVehicleMod(vehicle, 34, props.modShifterLeavers, false)
        end
        if props.modAPlate then
            SetVehicleMod(vehicle, 35, props.modAPlate, false)
        end
        if props.modSpeakers then
            SetVehicleMod(vehicle, 36, props.modSpeakers, false)
        end
        if props.modTrunk then
            SetVehicleMod(vehicle, 37, props.modTrunk, false)
        end
        if props.modHydrolic then
            SetVehicleMod(vehicle, 38, props.modHydrolic, false)
        end
        if props.modEngineBlock then
            SetVehicleMod(vehicle, 39, props.modEngineBlock, false)
        end
        if props.modAirFilter then
            SetVehicleMod(vehicle, 40, props.modAirFilter, false)
        end
        if props.modStruts then
            SetVehicleMod(vehicle, 41, props.modStruts, false)
        end
        if props.modArchCover then
            SetVehicleMod(vehicle, 42, props.modArchCover, false)
        end
        if props.modmirror then
            SetVehicleMod(vehicle, 43, props.modmirror, false)
        end
        if props.modTrimB then
            SetVehicleMod(vehicle, 44, props.modTrimB, false)
        end
        if props.modTank then
            SetVehicleMod(vehicle, 45, props.modTank, false)
        end
        if props.modWindows then
            SetVehicleMod(vehicle, 46, props.modWindows, false)
        end
        if props.modKit47 then
            SetVehicleMod(vehicle, 47, props.modKit47, false)
        end
        if props.modLivery then
            SetVehicleMod(vehicle, 48, props.modLivery, false)
            SetVehicleLivery(vehicle, props.modLivery)
        end
        if props.modKit49 then
            SetVehicleMod(vehicle, 49, props.modKit49, false)
        end
        if props.liveryRoof then
            SetVehicleRoofLivery(vehicle, props.liveryRoof)
        end
    end
end

Config.SetModType = function(table, type)
    for key,category in pairs(table) do
        for _, mod in pairs(category) do
            mod.type = type
        end
    end

    return table
end

Config.CreateMod = function(type, index, label, category, model)
    if not category and Config.DefaultCategories[type] then
        category = Config.DefaultCategories[type]
    end

    local price = Config.Prices[type] or Config.DefaultPrice
    if model and Config.CustomPrices[model] and Config.CustomPrices[model][type] then
        price = Config.CustomPrices[model][type]
    end

    return { 
        type = type,
        index = index,
        label = label,
        category = category,
        price = price
    }
end

Config.GetModLabelName = function(vehicle, model, type, index)
    local label = GetModTextLabel(vehicle, type, index)

    if Config.CustomLabels[model] and Config.CustomLabels[model][label] then
        label = Config.Trim(Config.CustomLabels[model][label])
    else
        label = GetLabelText(GetModTextLabel(vehicle, type, index))
    end

    return label
end

Config.GetModCategoryName = function(vehicle, model, slot)
    local category = GetModSlotName(vehicle, slot)

    if Config.CustomCategories[model] and Config.CustomCategories[model][slot] then
        category = Config.CustomCategories[model][slot]
    elseif Config.DefaultCategories[slot] then
        category = Config.DefaultCategories[slot]
    end

    return category
end

Config.BlacklistMod = function(model, x, y)
    return Config.BlacklistedMods[model] and Config.BlacklistedMods[model][x] and (Config.TableLength(Config.BlacklistedMods[model][x]) == 0 or Config.TableHasValue(Config.BlacklistedMods[model][x], y))
end

Config.BlacklistAll = function(model, x)
    return Config.BlacklistedMods[model] and Config.BlacklistedMods[model][x] and Config.TableLength(Config.BlacklistedMods[model][x]) == 0
end

Config.CanPurchase = function(price)
    QBCore.Functions.TriggerCallback('lscustoms:can-purchase', function(bool)
        return bool
    end, price)
end

Config.Colors = {
    [5] = {
        Config.CreateMod(-1, 120, "Chrome", "Chrome"),
    },
    [1] = {
        Config.CreateMod(-1, 0, "Black", "Metallic"),
        Config.CreateMod(-1, 147, "Carbon Black", "Metallic"),
        Config.CreateMod(-1, 1, "Graphite", "Metallic"),
        Config.CreateMod(-1, 11, "Anhracite Black", "Metallic"),
        Config.CreateMod(-1, 2, "Black Steel", "Metallic"),
        Config.CreateMod(-1, 3, "Dark Steel", "Metallic"),
        Config.CreateMod(-1, 4, "Silver", "Metallic"),
        Config.CreateMod(-1, 5, "Bluish Silver", "Metallic"),
        Config.CreateMod(-1, 6, "Rolled Steel", "Metallic"),
        Config.CreateMod(-1, 7, "Shadow Silver", "Metallic"),
        Config.CreateMod(-1, 8, "Stone Silver", "Metallic"),
        Config.CreateMod(-1, 9, "Midnight Silver", "Metallic"),
        Config.CreateMod(-1, 10, "Cast Iron Silver", "Metallic"),
        Config.CreateMod(-1, 27, "Red", "Metallic"),
        Config.CreateMod(-1, 28, "Torino Red", "Metallic"),
        Config.CreateMod(-1, 29, "Formula Red", "Metallic"),
        Config.CreateMod(-1, 150, "Lava Red", "Metallic"),
        Config.CreateMod(-1, 30, "Blaze Red", "Metallic"),
        Config.CreateMod(-1, 31, "Grace Red", "Metallic"),
        Config.CreateMod(-1, 32, "Garnet Red", "Metallic"),
        Config.CreateMod(-1, 33, "Sunset Red", "Metallic"),
        Config.CreateMod(-1, 34, "Cabernet Red", "Metallic"),
        Config.CreateMod(-1, 143, "Wine Red", "Metallic"),
        Config.CreateMod(-1, 35, "Candy Red", "Metallic"),
        Config.CreateMod(-1, 135, "Hot Pink", "Metallic"),
        Config.CreateMod(-1, 137, "Pfsiter Pink", "Metallic"),
        Config.CreateMod(-1, 136, "Salmon Pink", "Metallic"),
        Config.CreateMod(-1, 36, "Sunrise Orange", "Metallic"),
        Config.CreateMod(-1, 38, "Orange", "Metallic"),
        Config.CreateMod(-1, 138, "Bright Orange", "Metallic"),
        Config.CreateMod(-1, 99, "Gold", "Metallic"),
        Config.CreateMod(-1, 90, "Bronze", "Metallic"),
        Config.CreateMod(-1, 88, "Yellow", "Metallic"),
        Config.CreateMod(-1, 89, "Race Yellow", "Metallic"),
        Config.CreateMod(-1, 91, "Dew Yellow", "Metallic"),
        Config.CreateMod(-1, 49, "Dark Green", "Metallic"),
        Config.CreateMod(-1, 50, "Racing Green", "Metallic"),
        Config.CreateMod(-1, 51, "Sea Green", "Metallic"),
        Config.CreateMod(-1, 52, "Olive Green", "Metallic"),
        Config.CreateMod(-1, 53, "Bright Green", "Metallic"),
        Config.CreateMod(-1, 54, "Gasoline Green", "Metallic"),
        Config.CreateMod(-1, 92, "Lime Green", "Metallic"),
        Config.CreateMod(-1, 141, "Midnight Blue", "Metallic"),
        Config.CreateMod(-1, 61, "Galaxy Blue", "Metallic"),
        Config.CreateMod(-1, 62, "Dark Blue", "Metallic"),
        Config.CreateMod(-1, 63, "Saxon Blue", "Metallic"),
        Config.CreateMod(-1, 64, "Blue", "Metallic"),
        Config.CreateMod(-1, 65, "Mariner Blue", "Metallic"),
        Config.CreateMod(-1, 66, "Harbor Blue", "Metallic"),
        Config.CreateMod(-1, 67, "Diamond Blue", "Metallic"),
        Config.CreateMod(-1, 68, "Surf Blue", "Metallic"),
        Config.CreateMod(-1, 69, "Nautical Blue", "Metallic"),
        Config.CreateMod(-1, 73, "Racing Blue", "Metallic"),
        Config.CreateMod(-1, 70, "Ultra Blue", "Metallic"),
        Config.CreateMod(-1, 74, "Light Blue", "Metallic"),
        Config.CreateMod(-1, 96, "Chocolate Brown", "Metallic"),
        Config.CreateMod(-1, 101, "Bison Brown", "Metallic"),
        Config.CreateMod(-1, 95, "Creeen Brown", "Metallic"),
        Config.CreateMod(-1, 94, "Feltzer Brown", "Metallic"),
        Config.CreateMod(-1, 97, "Maple Brown", "Metallic"),
        Config.CreateMod(-1, 103, "Beechwood Brown", "Metallic"),
        Config.CreateMod(-1, 104, "Sienna Brown", "Metallic"),
        Config.CreateMod(-1, 98, "Saddle Brown", "Metallic"),
        Config.CreateMod(-1, 100, "Moss Brown", "Metallic"),
        Config.CreateMod(-1, 102, "Woodbeech Brown", "Metallic"),
        Config.CreateMod(-1, 99, "Straw Brown", "Metallic"),
        Config.CreateMod(-1, 105, "Sandy Brown", "Metallic"),
        Config.CreateMod(-1, 106, "Bleached Brown", "Metallic"),
        Config.CreateMod(-1, 71, "Schafter Purple", "Metallic"),
        Config.CreateMod(-1, 72, "Spinnaker Purple", "Metallic"),
        Config.CreateMod(-1, 142, "Midnight Purple", "Metallic"),
        Config.CreateMod(-1, 145, "Bright Purple", "Metallic"),
        Config.CreateMod(-1, 107, "Cream", "Metallic"),
        Config.CreateMod(-1, 111, "Ice White", "Metallic"),
        Config.CreateMod(-1, 112, "Frost White", "Metallic")
    },
    [4] = {
        Config.CreateMod(-1, 117, "Brushed Steel", "Metals"),
        Config.CreateMod(-1, 118, "Brushed Black Steel", "Metals"),
        Config.CreateMod(-1, 119, "Brushed Aluminum", "Metals"),
        Config.CreateMod(-1, 158, "Pure Gold", "Metals"),
        Config.CreateMod(-1, 159, "Brushed Gold", "Metals"),
    },
    [3] = {
        Config.CreateMod(-1, 12, "Black", "Matte"),
        Config.CreateMod(-1, 13, "Gray", "Matte"),
        Config.CreateMod(-1, 14, "Light Gray", "Matte"),
        Config.CreateMod(-1, 131, "Ice White", "Matte"),
        Config.CreateMod(-1, 83, "Blue", "Matte"),
        Config.CreateMod(-1, 82, "Dark Blue", "Matte"),
        Config.CreateMod(-1, 84, "Midnight Blue", "Matte"),
        Config.CreateMod(-1, 149, "Midnight Purple", "Matte"),
        Config.CreateMod(-1, 148, "Schafter Purple", "Matte"),
        Config.CreateMod(-1, 39, "Red", "Matte"),
        Config.CreateMod(-1, 40, "Dark Red", "Matte"),
        Config.CreateMod(-1, 41, "Orange", "Matte"),
        Config.CreateMod(-1, 42, "Yellow", "Matte"),
        Config.CreateMod(-1, 55, "Lime Green", "Matte"),
        Config.CreateMod(-1, 128, "Green", "Matte"),
        Config.CreateMod(-1, 151, "Frost Green", "Matte"),
        Config.CreateMod(-1, 155, "Foliage Green", "Matte"),
        Config.CreateMod(-1, 152, "Olive Darb", "Matte"),
        Config.CreateMod(-1, 153, "Dark Earth", "Matte"),
        Config.CreateMod(-1, 154, "Desert Tan", "Matte"),
    },
    [6] = {
        Config.CreateMod(-1, {254,254,254}, "White", "Tire Smoke"),
        Config.CreateMod(-1, {1,1,1}, "Black", "Tire Smoke"),
        Config.CreateMod(-1, {0,150,255}, "Blue", "Tire Smoke"),
        Config.CreateMod(-1, {255,255,50}, "Yellow", "Tire Smoke"),
        Config.CreateMod(-1, {255,153,51}, "Orange", "Tire Smoke"),
        Config.CreateMod(-1, {255,10,10}, "Red", "Tire Smoke"),
        Config.CreateMod(-1, {10,255,10}, "Green", "Tire Smoke"),
        Config.CreateMod(-1, {153,10,153}, "Purple", "Tire Smoke"),
        Config.CreateMod(-1, {255,102,178}, "Pink", "Tire Smoke"),
        Config.CreateMod(-1, {128,128,128}, "Grey", "Tire Smoke"),
    },
    [9] = {
        Config.CreateMod(-1, 161, "Anodized Red Pearl", "Chameleon"),
        Config.CreateMod(-1, 162, "Anodized Wine Pearl", "Chameleon"),
        Config.CreateMod(-1, 163, "Anodized Purple Pearl", "Chameleon"),
        Config.CreateMod(-1, 164, "Anodized Blue Pearl", "Chameleon"),
        Config.CreateMod(-1, 165, "Anodized Green Pearl", "Chameleon"),
        Config.CreateMod(-1, 166, "Anodized Lime Pearl", "Chameleon"),
        Config.CreateMod(-1, 167, "Anodized Copper Pearl", "Chameleon"),
        Config.CreateMod(-1, 168, "Anodized Bronze Pearl", "Chameleon"),
        Config.CreateMod(-1, 169, "Anodized Champagne Pearl", "Chameleon"),
        Config.CreateMod(-1, 170, "Anodized Gold Pearl", "Chameleon"),
        Config.CreateMod(-1, 171, "Green/Blue Flip", "Chameleon"),
        Config.CreateMod(-1, 172, "Green/Red Flip", "Chameleon"),
        Config.CreateMod(-1, 173, "Green/Brown Flip", "Chameleon"),
        Config.CreateMod(-1, 174, "Green/Turquoise Flip", "Chameleon"),
        Config.CreateMod(-1, 175, "Green/Purple Flip", "Chameleon"),
        Config.CreateMod(-1, 176, "Teal/Purple Flip", "Chameleon"),
        Config.CreateMod(-1, 177, "Turquoise/Red Flip", "Chameleon"),
        Config.CreateMod(-1, 178, "Turquoise/Purple Flip", "Chameleon"),
        Config.CreateMod(-1, 179, "Cyan/Purple Flip", "Chameleon"),
        Config.CreateMod(-1, 180, "Blue/Pink Flip", "Chameleon"),
        Config.CreateMod(-1, 181, "Blue/Green Flip", "Chameleon"),
        Config.CreateMod(-1, 182, "Purple/Red Flip", "Chameleon"),
        Config.CreateMod(-1, 183, "Purple/Green Flip", "Chameleon"),
        Config.CreateMod(-1, 184, "Magenta/Green Flip", "Chameleon"),
        Config.CreateMod(-1, 185, "Magenta/Yellow Flip", "Chameleon"),
        Config.CreateMod(-1, 186, "Burgundy/Green Flip", "Chameleon"),
        Config.CreateMod(-1, 187, "Magenta/Cyan Flip", "Chameleon"),
        Config.CreateMod(-1, 188, "Copper/Purple Flip", "Chameleon"),
        Config.CreateMod(-1, 189, "Magenta/Orange Flip", "Chameleon"),
        Config.CreateMod(-1, 190, "Red/Orange Flip", "Chameleon"),
        Config.CreateMod(-1, 191, "Orange/Purple Flip", "Chameleon"),
        Config.CreateMod(-1, 192, "Orange/Blue Flip", "Chameleon"),
        Config.CreateMod(-1, 193, "White/Purple Flip", "Chameleon"),
        Config.CreateMod(-1, 194, "Red/Rainbow Flip", "Chameleon"),
        Config.CreateMod(-1, 195, "Blue/Rainbow Flip", "Chameleon"),
        Config.CreateMod(-1, 196, "Dark Green Pearl", "Chameleon"),
        Config.CreateMod(-1, 197, "Dark Teal Pearl", "Chameleon"),
        Config.CreateMod(-1, 198, "Dark Blue Pearl", "Chameleon"),
        Config.CreateMod(-1, 199, "Dark Purple Pearl", "Chameleon"),
        Config.CreateMod(-1, 200, "Oil Slick Pearl", "Chameleon"),
        Config.CreateMod(-1, 201, "Light Green Pearl", "Chameleon"),
        Config.CreateMod(-1, 202, "Light Blue Pearl", "Chameleon"),
        Config.CreateMod(-1, 203, "Light Purple Pearl", "Chameleon"),
        Config.CreateMod(-1, 204, "Light Pink Pearl", "Chameleon"),
        Config.CreateMod(-1, 205, "Off White Pearl", "Chameleon"),
        Config.CreateMod(-1, 206, "Cute Pink Pearl", "Chameleon"),
        Config.CreateMod(-1, 207, "Baby Yellow Pearl", "Chameleon"),
        Config.CreateMod(-1, 208, "Baby Green Pearl", "Chameleon"),
        Config.CreateMod(-1, 209, "Baby Blue Pearl", "Chameleon"),
        Config.CreateMod(-1, 210, "Cream Pearl", "Chameleon"),
        Config.CreateMod(-1, 211, "White Prismatic Pearl", "Chameleon"),
        Config.CreateMod(-1, 212, "Graphite Prismatic Pearl", "Chameleon"),
        Config.CreateMod(-1, 213, "Blue Prismatic Pearl", "Chameleon"),
        Config.CreateMod(-1, 214, "Purple Prismatic Pearl", "Chameleon"),
        Config.CreateMod(-1, 215, "Hot Pink Prismatic Pearl", "Chameleon"),
        Config.CreateMod(-1, 216, "Red Prismatic Pearl", "Chameleon"),
        Config.CreateMod(-1, 217, "Green Prismatic Pearl", "Chameleon"),
        Config.CreateMod(-1, 218, "Black Prismatic Pearl", "Chameleon"),
        Config.CreateMod(-1, 219, "Oil Spill Prismatic Pearl", "Chameleon"),
        Config.CreateMod(-1, 220, "Rainbow Prismatic Pearl", "Chameleon"),
        Config.CreateMod(-1, 221, "Black Holographic Pearl", "Chameleon"),
        Config.CreateMod(-1, 222, "White Holographic Pearl", "Chameleon"),
        Config.CreateMod(-1, 223, "Fubuki-jo Specials: Monochrome", "Chameleon"),
        Config.CreateMod(-1, 224, "Fubuki-jo Specials: Night & Day", "Chameleon"),
        Config.CreateMod(-1, 225, "Fubuki-jo Specials: The Verlierer", "Chameleon"),
        Config.CreateMod(-1, 226, "Fubuki-jo Specials: Sprunk Extreme", "Chameleon"),
        Config.CreateMod(-1, 227, "Fubuki-jo Specials: Vice City", "Chameleon"),
        Config.CreateMod(-1, 228, "Fubuki-jo Specials: Synthwave Night", "Chameleon"),
        Config.CreateMod(-1, 229, "Fubuki-jo Specials: Four Seasons", "Chameleon"),
        Config.CreateMod(-1, 230, "Fubuki-jo Specials: M9 Throwback", "Chameleon"),
        Config.CreateMod(-1, 231, "Fubuki-jo Specials: Bubblegum", "Chameleon"),
        Config.CreateMod(-1, 232, "Fubuki-jo Specials: Full Rainbow", "Chameleon"),
        Config.CreateMod(-1, 233, "Fubuki-jo Specials: Sunset", "Chameleon"),
        Config.CreateMod(-1, 234, "Fubuki-jo Specials: The Seven", "Chameleon"),
        Config.CreateMod(-1, 235, "Fubuki-jo Specials: Kamen Rider", "Chameleon"),
        Config.CreateMod(-1, 236, "Fubuki-jo Specials: Chromatic", "Chameleon"),
        Config.CreateMod(-1, 237, "Fubuki-jo Specials: It's Christmas!", "Chameleon"),
        Config.CreateMod(-1, 238, "Fubuki-jo Specials: Temperature", "Chameleon"),
        Config.CreateMod(-1, 239, "Fubuki-jo Specials: HSW Badge", "Chameleon"),
        Config.CreateMod(-1, 240, "Fubuki-jo Specials: Anod. Lightning", "Chameleon"),
        Config.CreateMod(-1, 241, "Fubuki-jo Specials: Emeralds", "Chameleon"),
        Config.CreateMod(-1, 242, "Fubuki-jo Specials: Fubuki Castle", "Chameleon"),
    }
}

Config.Mods = {
    Engines = {
        Config.CreateMod(11, -1, "Stock"),
        Config.CreateMod(11, -0, "Stage 2"),
        Config.CreateMod(11, 1, "Stage 3"),
        Config.CreateMod(11, 2, "Stage 4"),
        Config.CreateMod(11, 3, "Stage 5"),
    },
    Brakes = {
        Config.CreateMod(12, -1, "Stock"),
        Config.CreateMod(12, -0, "Stage 2"),
        Config.CreateMod(12, 1, "Stage 3"),
        Config.CreateMod(12, 2, "Stage 4"),
    },
    Transmissions = {
        Config.CreateMod(13, -1, "Stock"),
        Config.CreateMod(13, -0, "Stage 2"),
        Config.CreateMod(13, 1, "Stage 3"),
        Config.CreateMod(13, 2, "Stage 4"),
    },
    Suspension = {
        Config.CreateMod(15, -1, "Stock"),
        Config.CreateMod(15, -0, "Stage 2"),
        Config.CreateMod(15, 1, "Stage 3"),
        Config.CreateMod(15, 2, "Stage 4"),
        Config.CreateMod(15, 3, "Stage 5"),
    },
    Headlights = {
        Config.CreateMod(22, -1, "Stock"),
        Config.CreateMod(22, 0, "White Xenon"),
        Config.CreateMod(22, 1, "Darkblue Xenon"),
        Config.CreateMod(22, 2, "Lightblue Xenon"),
        Config.CreateMod(22, 3, "Turquoise Xenon"),
        Config.CreateMod(22, 4, "Green Xenon"),
        Config.CreateMod(22, 5, "Yellow Xenon"),
        Config.CreateMod(22, 6, "Gold Xenon"),
        Config.CreateMod(22, 7, "Orange Xenon"),
        Config.CreateMod(22, 8, "Red Xenon"),
        Config.CreateMod(22, 9, "Pink Xenon"),
        Config.CreateMod(22, 10, "Violet Xenon"),
        Config.CreateMod(22, 11, "Purple Xenon"),
        Config.CreateMod(22, 12, "Ultraviolet Xenon"),
    },
    Horns = {
        Config.CreateMod(14, -1, "Stock"),
        Config.CreateMod(14, 0, "Truck Horn"),
        Config.CreateMod(14, 1, "Police Horn"),
        Config.CreateMod(14, 2, "Clown Horn"),
        Config.CreateMod(14, 3, "Musical Horn 1"),
        Config.CreateMod(14, 4, "Musical Horn 2"),
        Config.CreateMod(14, 5, "Musical Horn 3"),
        Config.CreateMod(14, 6, "Musical Horn 4"),
        Config.CreateMod(14, 7, "Musical Horn 5"),
        Config.CreateMod(14, 8, "Sadtrombone Horn"),
        Config.CreateMod(14, 9, "Classical Horn 1"),
        Config.CreateMod(14, 10, "Classical Horn 2"),
        Config.CreateMod(14, 11, "Classical Horn 3"),
        Config.CreateMod(14, 12, "Classical Horn 4"),
        Config.CreateMod(14, 13, "Classical Horn 5"),
        Config.CreateMod(14, 14, "Classical Horn 6"),
        Config.CreateMod(14, 15, "Classical Horn 7"),
        Config.CreateMod(14, 16, "Scaledo Horn"),
        Config.CreateMod(14, 17, "Scalere Horn"),
        Config.CreateMod(14, 18, "Scalemi Horn"),
        Config.CreateMod(14, 19, "Scalefa Horn"),
        Config.CreateMod(14, 20, "Scalesol Horn"),
        Config.CreateMod(14, 21, "Scalela Horn"),
        Config.CreateMod(14, 22, "Scaleti Horn"),
        Config.CreateMod(14, 23, "Scaledo Horn"),
        Config.CreateMod(14, 25, "Jazz Horn 1"),
        Config.CreateMod(14, 26, "Jazz Horn 2"),
        Config.CreateMod(14, 27, "Jazz Horn 2"),
        Config.CreateMod(14, 28, "Jazzloop Horn"),
        Config.CreateMod(14, 29, "Starspangban Horn 1"),
        Config.CreateMod(14, 30, "Starspangban Horn 2"),
        Config.CreateMod(14, 31, "Starspangban Horn 3"),
        Config.CreateMod(14, 32, "Starspangban Horn 4"),
        Config.CreateMod(14, 33, "Classical loop Horn 1"),
        Config.CreateMod(14, 34, "Classical loop Horn 2"),
        Config.CreateMod(14, 35, "Classical loop Horn 3"),
    },
    NeonColors = {
        Config.CreateMod(52, {255,255,255}, "White"),
        Config.CreateMod(52, {0,0,255}, "Blue"),
        Config.CreateMod(52, {0,150,255}, "Electric Blue"),
        Config.CreateMod(52, {50,255,155}, "Mint Green"),
        Config.CreateMod(52, {0,255,0}, "Lime Green"),
        Config.CreateMod(52, {255,255,0}, "Yellow"),
        Config.CreateMod(52, {204,204,0}, "Golden Shower"),
        Config.CreateMod(52, {255,128,0}, "Orange"),
        Config.CreateMod(52, {255,0,0}, "Red"),
        Config.CreateMod(52, {255,102,255}, "Pony Pink"),
        Config.CreateMod(52, {255,0,255}, "Hot Pink"),
        Config.CreateMod(52, {153,0,153}, "Purple"),
        Config.CreateMod(52, {139,69,19}, "Brown"),
    },
    NeonLayout = {
        Config.CreateMod(51, { false, false, false, false }, "NULL"),
        Config.CreateMod(51, { false, false, true, false }, "Front Only"),
        Config.CreateMod(51, { false, false, false, true }, "Rear Only"),
        Config.CreateMod(51, { true, true, false, false }, "Sides Only"),
        Config.CreateMod(51, { true, true, true, false }, "Front & Sides"),
        Config.CreateMod(51, { true, true, false, true }, "Rear & Sides"),
        Config.CreateMod(51, { false, false, true, true }, "Front & Rear"),
        Config.CreateMod(51, { true, true, true, true }, "All Sides"),
    },
    Primary = {
        [1] = Config.Colors[1],
        [2] = Config.Colors[1],
        [3] = Config.Colors[3],
        [4] = Config.Colors[4],
        [5] = Config.Colors[5],
        [9] = Config.Colors[9],
    },
    Secondary = {
        [0] = Config.Colors[0],
        [1] = Config.Colors[1],
        [2] = Config.Colors[2],
        [3] = Config.Colors[3],
        [4] = Config.Colors[4],
        [5] = Config.Colors[5],
        [9] = Config.Colors[9],
    },
    Interior = {
        [6] = Config.Colors[1],
        [7] = Config.Colors[1]
    },
    WheelColor = {
        [0] = Config.Colors[1],
        [8] = Config.Colors[6]
    },
    Plates = {
        Config.CreateMod(50, 0, "Stock"),
        Config.CreateMod(50, 1, "Yellow on Black"),
        Config.CreateMod(50, 2, "Yellow on Blue"),
        Config.CreateMod(50, 3, "Blue on White"),
        Config.CreateMod(50, 4, "White Exempt"),
    },
    Wheels = {
        [0] = {
            Config.CreateMod(23, -1, "Stock", "Sport Wheels"),

            Config.CreateMod(23, 0, "Inferno"),
            Config.CreateMod(23, 1, "Deep Five"),
            Config.CreateMod(23, 2, "Lozspeed Mk.V"),
            Config.CreateMod(23, 3, "Diamond Cut"),
            Config.CreateMod(23, 4, "Chrono"),
            Config.CreateMod(23, 5, "Ferocci RR"),
            Config.CreateMod(23, 6, "Fifty Nine"),
            Config.CreateMod(23, 7, "Mercie"),
            Config.CreateMod(23, 8, "Synthetic Z"),
            Config.CreateMod(23, 9, "Organic Type 0"),
            Config.CreateMod(23, 10, "Endo v.1"),
            Config.CreateMod(23, 11, "GT One"),
            Config.CreateMod(23, 12, "Duper 7"),
            Config.CreateMod(23, 13, "Uzer"),
            Config.CreateMod(23, 14, "Ground Ride"),
            Config.CreateMod(23, 15, "S Racer"),
            Config.CreateMod(23, 16, "Venum"),
            Config.CreateMod(23, 17, "Cosmo"),
            Config.CreateMod(23, 18, "Dash VIP"),
            Config.CreateMod(23, 19, "Ice Kid"),
            Config.CreateMod(23, 20, "Ruff Weld"),
            Config.CreateMod(23, 21, "Wangan Master"),
            Config.CreateMod(23, 22, "Super Five"),
            Config.CreateMod(23, 23, "Endo v.2"),
            Config.CreateMod(23, 24, "Split Six"),

            Config.CreateMod(23, 25, "Inferno"),
            Config.CreateMod(23, 26, "Deep Five"),
            Config.CreateMod(23, 27, "Lozspeed Mk.V"),
            Config.CreateMod(23, 28, "Diamond Cut"),
            Config.CreateMod(23, 29, "Chrono"),
            Config.CreateMod(23, 30, "Ferocci RR"),
            Config.CreateMod(23, 31, "Fifty Nine"),
            Config.CreateMod(23, 32, "Mercie"),
            Config.CreateMod(23, 33, "Synthetic Z"),
            Config.CreateMod(23, 34, "Organic Type 0"),
            Config.CreateMod(23, 35, "Endo v.1"),
            Config.CreateMod(23, 36, "GT One"),
            Config.CreateMod(23, 37, "Duper 7"),
            Config.CreateMod(23, 38, "Uzer"),
            Config.CreateMod(23, 39, "Ground Ride"),
            Config.CreateMod(23, 40, "S Racer"),
            Config.CreateMod(23, 41, "Venum"),
            Config.CreateMod(23, 42, "Cosmo"),
            Config.CreateMod(23, 43, "Dash VIP"),
            Config.CreateMod(23, 44, "Ice Kid"),
            Config.CreateMod(23, 45, "Ruff Weld"),
            Config.CreateMod(23, 46, "Wangan Master"),
            Config.CreateMod(23, 47, "Super Five"),
            Config.CreateMod(23, 48, "Endo v.2"),
            Config.CreateMod(23, 49, "Split Six"),

            Config.CreateMod(23, 50, "Aftermarket"),
            Config.CreateMod(23, 51, "Aftermarket"),
            Config.CreateMod(23, 52, "Aftermarket"),
            Config.CreateMod(23, 53, "Aftermarket"),
            Config.CreateMod(23, 54, "Aftermarket"),
            Config.CreateMod(23, 55, "Aftermarket"),
            Config.CreateMod(23, 56, "Aftermarket"),
            Config.CreateMod(23, 57, "Aftermarket"),
            Config.CreateMod(23, 58, "Aftermarket"),
            Config.CreateMod(23, 59, "Aftermarket"),

            Config.CreateMod(23, 60, "Aftermarket"),
            Config.CreateMod(23, 61, "Aftermarket"),
            Config.CreateMod(23, 62, "Aftermarket"),
            Config.CreateMod(23, 63, "Aftermarket"),
            Config.CreateMod(23, 64, "Aftermarket"),
            Config.CreateMod(23, 65, "Aftermarket"),
            Config.CreateMod(23, 66, "Aftermarket"),
            Config.CreateMod(23, 67, "Aftermarket"),
            Config.CreateMod(23, 68, "Aftermarket"),
            Config.CreateMod(23, 69, "Aftermarket"),

            Config.CreateMod(23, 70, "Aftermarket"),
            Config.CreateMod(23, 71, "Aftermarket"),
            Config.CreateMod(23, 72, "Aftermarket"),
            Config.CreateMod(23, 73, "Aftermarket"),
            Config.CreateMod(23, 74, "Aftermarket"),
            Config.CreateMod(23, 75, "Aftermarket"),
            Config.CreateMod(23, 76, "Aftermarket"),
            Config.CreateMod(23, 77, "Aftermarket"),
            Config.CreateMod(23, 78, "Aftermarket"),
            Config.CreateMod(23, 79, "Aftermarket"),

            Config.CreateMod(23, 80, "Aftermarket"),
            Config.CreateMod(23, 81, "Aftermarket"),
            Config.CreateMod(23, 82, "Aftermarket"),
            Config.CreateMod(23, 83, "Aftermarket"),
            Config.CreateMod(23, 84, "Aftermarket"),
            Config.CreateMod(23, 85, "Aftermarket"),
            Config.CreateMod(23, 86, "Aftermarket"),
            Config.CreateMod(23, 87, "Aftermarket"),
            Config.CreateMod(23, 88, "Aftermarket"),
            Config.CreateMod(23, 89, "Aftermarket"),

            Config.CreateMod(23, 90, "Aftermarket"),
            Config.CreateMod(23, 91, "Aftermarket"),
            Config.CreateMod(23, 92, "Aftermarket"),
            Config.CreateMod(23, 93, "Aftermarket"),
            Config.CreateMod(23, 94, "Aftermarket"),
            Config.CreateMod(23, 95, "Aftermarket"),
            Config.CreateMod(23, 96, "Aftermarket"),
            Config.CreateMod(23, 97, "Aftermarket"),
            Config.CreateMod(23, 98, "Aftermarket"),
            Config.CreateMod(23, 99, "Aftermarket"),

            Config.CreateMod(23, 100, "Aftermarket"),
            Config.CreateMod(23, 101, "Aftermarket"),
            Config.CreateMod(23, 102, "Aftermarket"),
            Config.CreateMod(23, 103, "Aftermarket"),
            Config.CreateMod(23, 104, "Aftermarket"),
            Config.CreateMod(23, 105, "Aftermarket"),
            Config.CreateMod(23, 106, "Aftermarket"),
            Config.CreateMod(23, 107, "Aftermarket"),
            Config.CreateMod(23, 108, "Aftermarket"),
            Config.CreateMod(23, 109, "Aftermarket"),

            Config.CreateMod(23, 110, "Aftermarket"),
            Config.CreateMod(23, 111, "Aftermarket"),
            Config.CreateMod(23, 112, "Aftermarket"),
            Config.CreateMod(23, 113, "Aftermarket"),
            Config.CreateMod(23, 114, "Aftermarket"),
            Config.CreateMod(23, 115, "Aftermarket"),
            Config.CreateMod(23, 116, "Aftermarket"),
            Config.CreateMod(23, 117, "Aftermarket"),
            Config.CreateMod(23, 118, "Aftermarket"),
            Config.CreateMod(23, 119, "Aftermarket"),

            Config.CreateMod(23, 120, "Aftermarket"),
            Config.CreateMod(23, 121, "Aftermarket"),
            Config.CreateMod(23, 122, "Aftermarket"),
            Config.CreateMod(23, 123, "Aftermarket"),
            Config.CreateMod(23, 124, "Aftermarket"),
            Config.CreateMod(23, 125, "Aftermarket"),
            Config.CreateMod(23, 126, "Aftermarket"),
            Config.CreateMod(23, 127, "Aftermarket"),
            Config.CreateMod(23, 128, "Aftermarket"),
            Config.CreateMod(23, 129, "Aftermarket"),

            Config.CreateMod(23, 130, "Aftermarket"),
            Config.CreateMod(23, 131, "Aftermarket"),
            Config.CreateMod(23, 132, "Aftermarket"),
            Config.CreateMod(23, 133, "Aftermarket"),
            Config.CreateMod(23, 134, "Aftermarket"),
            Config.CreateMod(23, 135, "Aftermarket"),
            Config.CreateMod(23, 136, "Aftermarket"),
            Config.CreateMod(23, 137, "Aftermarket"),
            Config.CreateMod(23, 138, "Aftermarket"),
            Config.CreateMod(23, 139, "Aftermarket"),

            Config.CreateMod(23, 140, "Aftermarket"),
            Config.CreateMod(23, 141, "Aftermarket"),
            Config.CreateMod(23, 142, "Aftermarket"),
            Config.CreateMod(23, 143, "Aftermarket"),
            Config.CreateMod(23, 144, "Aftermarket"),
            Config.CreateMod(23, 145, "Aftermarket"),
            Config.CreateMod(23, 146, "Aftermarket"),
            Config.CreateMod(23, 147, "Aftermarket"),
            Config.CreateMod(23, 148, "Aftermarket"),
            Config.CreateMod(23, 149, "Aftermarket"),

            Config.CreateMod(23, 150, "Aftermarket"),
            Config.CreateMod(23, 151, "Aftermarket"),
            Config.CreateMod(23, 152, "Aftermarket"),
            Config.CreateMod(23, 153, "Aftermarket"),
            Config.CreateMod(23, 154, "Aftermarket"),
            Config.CreateMod(23, 155, "Aftermarket"),
            Config.CreateMod(23, 156, "Aftermarket"),
            Config.CreateMod(23, 157, "Aftermarket"),
            Config.CreateMod(23, 158, "Aftermarket"),
            Config.CreateMod(23, 159, "Aftermarket"),

            Config.CreateMod(23, 160, "Aftermarket"),
            Config.CreateMod(23, 161, "Aftermarket"),
            Config.CreateMod(23, 162, "Aftermarket"),
            Config.CreateMod(23, 163, "Aftermarket"),
            Config.CreateMod(23, 164, "Aftermarket"),
            Config.CreateMod(23, 165, "Aftermarket"),
            Config.CreateMod(23, 166, "Aftermarket"),
            Config.CreateMod(23, 167, "Aftermarket"),
            Config.CreateMod(23, 168, "Aftermarket"),
            Config.CreateMod(23, 169, "Aftermarket"),

            Config.CreateMod(23, 170, "Aftermarket"),
            Config.CreateMod(23, 171, "Aftermarket"),
            Config.CreateMod(23, 172, "Aftermarket"),
            Config.CreateMod(23, 173, "Aftermarket"),
            Config.CreateMod(23, 174, "Aftermarket"),
            Config.CreateMod(23, 175, "Aftermarket"),
            Config.CreateMod(23, 176, "Aftermarket"),
            Config.CreateMod(23, 177, "Aftermarket"),
            Config.CreateMod(23, 178, "Aftermarket"),
            Config.CreateMod(23, 179, "Aftermarket"),

            Config.CreateMod(23, 180, "Aftermarket"),
            Config.CreateMod(23, 181, "Aftermarket"),
            Config.CreateMod(23, 182, "Aftermarket"),
            Config.CreateMod(23, 183, "Aftermarket"),
            Config.CreateMod(23, 184, "Aftermarket"),
            Config.CreateMod(23, 185, "Aftermarket"),
            Config.CreateMod(23, 186, "Aftermarket"),
            Config.CreateMod(23, 187, "Aftermarket"),
            Config.CreateMod(23, 188, "Aftermarket"),
            Config.CreateMod(23, 189, "Aftermarket"),

            Config.CreateMod(23, 190, "Aftermarket"),
            Config.CreateMod(23, 191, "Aftermarket"),
            Config.CreateMod(23, 192, "Aftermarket"),
            Config.CreateMod(23, 193, "Aftermarket"),
            Config.CreateMod(23, 194, "Aftermarket"),
            Config.CreateMod(23, 195, "Aftermarket"),
            Config.CreateMod(23, 196, "Aftermarket"),
            Config.CreateMod(23, 197, "Aftermarket"),
            Config.CreateMod(23, 198, "Aftermarket"),
            Config.CreateMod(23, 199, "Aftermarket"),

            Config.CreateMod(23, 200, "Aftermarket"),
            Config.CreateMod(23, 201, "Aftermarket"),
        },
        [1] = {
            Config.CreateMod(23, -1, "Stock", "Muscle Wheels"),

            Config.CreateMod(23, 0, "Classic Five"),
            Config.CreateMod(23, 1, "Dukes"),
            Config.CreateMod(23, 2, "Muscle Freak"),
            Config.CreateMod(23, 3, "Kracka"),
            Config.CreateMod(23, 4, "Azreal"),
            Config.CreateMod(23, 5, "Mecha"),
            Config.CreateMod(23, 6, "Black Top"),
            Config.CreateMod(23, 7, "Drag SPL"),
            Config.CreateMod(23, 8, "Revolver"),
            Config.CreateMod(23, 9, "Classic Rod"),
            Config.CreateMod(23, 10, "Fairlie"),
            Config.CreateMod(23, 11, "Spooner"),
            Config.CreateMod(23, 12, "Five Star"),
            Config.CreateMod(23, 13, "Old School"),
            Config.CreateMod(23, 14, "El Jefe"),
            Config.CreateMod(23, 15, "Dodman"),
            Config.CreateMod(23, 16, "Six Gun"),
            Config.CreateMod(23, 17, "Mercenary"),
            
            Config.CreateMod(23, 18, "Classic Five"),
            Config.CreateMod(23, 19, "Dukes"),
            Config.CreateMod(23, 20, "Muscle Freak"),
            Config.CreateMod(23, 21, "Kracka"),
            Config.CreateMod(23, 22, "Azreal"),
            Config.CreateMod(23, 23, "Mecha"),
            Config.CreateMod(23, 24, "Black Top"),
            Config.CreateMod(23, 25, "Drag SPL"),
            Config.CreateMod(23, 26, "Revolver"),
            Config.CreateMod(23, 27, "Classic Rod"),
            Config.CreateMod(23, 28, "Fairlie"),
            Config.CreateMod(23, 29, "Spooner"),
            Config.CreateMod(23, 30, "Five Star"),
            Config.CreateMod(23, 31, "Old School"),
            Config.CreateMod(23, 32, "El Jefe"),
            Config.CreateMod(23, 33, "Dodman"),
            Config.CreateMod(23, 34, "Six Gun"),
            Config.CreateMod(23, 35, "Mercenary"),

            Config.CreateMod(23, 36, "Aftermarket"),
            Config.CreateMod(23, 37, "Aftermarket"),
            Config.CreateMod(23, 38, "Aftermarket"),
            Config.CreateMod(23, 39, "Aftermarket"),
            Config.CreateMod(23, 40, "Aftermarket"),
            Config.CreateMod(23, 41, "Aftermarket"),
            Config.CreateMod(23, 42, "Aftermarket"),
            Config.CreateMod(23, 43, "Aftermarket"),
            Config.CreateMod(23, 44, "Aftermarket"),
            Config.CreateMod(23, 45, "Aftermarket"),

            Config.CreateMod(23, 46, "Aftermarket"),
            Config.CreateMod(23, 47, "Aftermarket"),
            Config.CreateMod(23, 48, "Aftermarket"),
            Config.CreateMod(23, 49, "Aftermarket"),
            Config.CreateMod(23, 50, "Aftermarket"),
            Config.CreateMod(23, 51, "Aftermarket"),
            Config.CreateMod(23, 52, "Aftermarket"),
            Config.CreateMod(23, 53, "Aftermarket"),
            Config.CreateMod(23, 54, "Aftermarket"),
            Config.CreateMod(23, 55, "Aftermarket"),

            Config.CreateMod(23, 66, "Aftermarket"),
            Config.CreateMod(23, 67, "Aftermarket"),
            Config.CreateMod(23, 68, "Aftermarket"),
            Config.CreateMod(23, 69, "Aftermarket"),
            Config.CreateMod(23, 70, "Aftermarket"),
            Config.CreateMod(23, 71, "Aftermarket"),
            Config.CreateMod(23, 72, "Aftermarket"),
        },
        [2] = {
            Config.CreateMod(23, -1, "Stock", "Lowrider Wheels"),

            Config.CreateMod(23, 0, "Flare"),
            Config.CreateMod(23, 1, "Wired"),
            Config.CreateMod(23, 2, "Triple Golds"),
            Config.CreateMod(23, 3, "Big Worm"),
            Config.CreateMod(23, 4, "Seven Fives"),
            Config.CreateMod(23, 5, "Split Six"),
            Config.CreateMod(23, 6, "Fresh Mesh"),
            Config.CreateMod(23, 7, "Lead Sled"),
            Config.CreateMod(23, 8, "Turbine"),
            Config.CreateMod(23, 9, "Super Fin"),
            Config.CreateMod(23, 10, "Classic Rod"),
            Config.CreateMod(23, 11, "Dollar"),
            Config.CreateMod(23, 12, "Dukes"),
            Config.CreateMod(23, 13, "Low Five"),
            Config.CreateMod(23, 14, "Gooch"),
            
            Config.CreateMod(23, 15, "Flare"),
            Config.CreateMod(23, 16, "Wired"),
            Config.CreateMod(23, 17, "Triple Golds"),
            Config.CreateMod(23, 18, "Big Worm"),
            Config.CreateMod(23, 19, "Seven Fives"),
            Config.CreateMod(23, 20, "Split Six"),
            Config.CreateMod(23, 21, "Fresh Mesh"),
            Config.CreateMod(23, 22, "Lead Sled"),
            Config.CreateMod(23, 23, "Turbine"),
            Config.CreateMod(23, 24, "Super Fin"),
            Config.CreateMod(23, 25, "Classic Rod"),
            Config.CreateMod(23, 26, "Dollar"),
            Config.CreateMod(23, 27, "Dukes"),
            Config.CreateMod(23, 28, "Low Five"),
            Config.CreateMod(23, 29, "Gooch"),

            Config.CreateMod(23, 30, "Aftermarket"),
            Config.CreateMod(23, 31, "Aftermarket"),
            Config.CreateMod(23, 32, "Aftermarket"),
            Config.CreateMod(23, 33, "Aftermarket"),
            Config.CreateMod(23, 34, "Aftermarket"),
            Config.CreateMod(23, 35, "Aftermarket"),
            Config.CreateMod(23, 36, "Aftermarket"),
            Config.CreateMod(23, 37, "Aftermarket"),
            Config.CreateMod(23, 38, "Aftermarket"),
            Config.CreateMod(23, 39, "Aftermarket"),

            Config.CreateMod(23, 40, "Aftermarket"),
            Config.CreateMod(23, 41, "Aftermarket"),
        },
        [3] = {
            Config.CreateMod(23, -1, "Stock", "SUV Wheels"),

            Config.CreateMod(23, 0, "VIP"),
            Config.CreateMod(23, 0, "Benefactor"),
            Config.CreateMod(23, 0, "Cosmo"),
            Config.CreateMod(23, 0, "Bippu"),
            Config.CreateMod(23, 0, "Royal Six"),
            Config.CreateMod(23, 0, "Fagorme"),
            Config.CreateMod(23, 0, "Deluxe"),
            Config.CreateMod(23, 0, "Iced Out"),
            Config.CreateMod(23, 0, "Cognscenti"),
            Config.CreateMod(23, 0, "LozSpeed Ten"),
            Config.CreateMod(23, 0, "Supernova"),
            Config.CreateMod(23, 0, "Obey RS"),
            Config.CreateMod(23, 0, "LozSpeed Baller"),
            Config.CreateMod(23, 0, "Extravaganzo"),
            Config.CreateMod(23, 0, "Split Six"),
            Config.CreateMod(23, 0, "Empowered"),
            Config.CreateMod(23, 0, "Sunrise"),
            Config.CreateMod(23, 0, "Dash VIP"),
            Config.CreateMod(23, 0, "Cutter"),
        },
        [4] = {
            Config.CreateMod(23, -1, "Stock", "Offroad Wheels"),
            
            Config.CreateMod(23, 0, "Raider"),
            Config.CreateMod(23, 1, "Mudslinger"),
            Config.CreateMod(23, 2, "Nevis"),
            Config.CreateMod(23, 3, "Cairngorm"),
            Config.CreateMod(23, 4, "Amazon"),
            Config.CreateMod(23, 5, "Challenger"),
            Config.CreateMod(23, 6, "Dune Basher"),
            Config.CreateMod(23, 7, "Five Star"),
            Config.CreateMod(23, 8, "Rock Crawler"),
            Config.CreateMod(23, 9, "Mil Spec Seelie"),
            
            Config.CreateMod(23, 10, "Raider"),
            Config.CreateMod(23, 11, "Mudslinger"),
            Config.CreateMod(23, 12, "Nevis"),
            Config.CreateMod(23, 13, "Cairngorm"),
            Config.CreateMod(23, 14, "Amazon"),
            Config.CreateMod(23, 15, "Challenger"),
            Config.CreateMod(23, 16, "Dune Basher"),
            Config.CreateMod(23, 17, "Five Star"),
            Config.CreateMod(23, 18, "Rock Crawler"),
            Config.CreateMod(23, 19, "Mil Spec Seelie"),
            
            Config.CreateMod(23, 20, "Retro Steelie"),
            Config.CreateMod(23, 21, "Heavy Duty Steelie"),
            Config.CreateMod(23, 22, "Concave Steelie"),
            Config.CreateMod(23, 23, "Police Issue Steelie"),
            Config.CreateMod(23, 24, "Lightweight Steelie"),
            Config.CreateMod(23, 25, "Dukes"),
            Config.CreateMod(23, 26, "Avalanche"),
            Config.CreateMod(23, 27, "Mountain Man"),
            Config.CreateMod(23, 28, "Rigde Climber"),
            Config.CreateMod(23, 29, "Concave 5"),
            Config.CreateMod(23, 30, "Flat Six"),
            Config.CreateMod(23, 31, "All Terrain Monster"),
            Config.CreateMod(23, 32, "Drag SPL"),
            Config.CreateMod(23, 33, "Concave Rally Master"),
            Config.CreateMod(23, 34, "Rugged Snowflake"),

            Config.CreateMod(23, 35, "Aftermarket"),
            Config.CreateMod(23, 36, "Aftermarket"),
            Config.CreateMod(23, 37, "Aftermarket"),
            Config.CreateMod(23, 38, "Aftermarket"),
            Config.CreateMod(23, 39, "Aftermarket"),
            Config.CreateMod(23, 40, "Aftermarket"),
            Config.CreateMod(23, 41, "Aftermarket"),
            Config.CreateMod(23, 42, "Aftermarket"),
            Config.CreateMod(23, 43, "Aftermarket"),
            Config.CreateMod(23, 44, "Aftermarket"),
            Config.CreateMod(23, 45, "Aftermarket"),
            Config.CreateMod(23, 46, "Aftermarket"),
            Config.CreateMod(23, 47, "Aftermarket"),
            Config.CreateMod(23, 48, "Aftermarket"),
        },
        [5] = {
            Config.CreateMod(23, -1, "Stock", "Tuner Wheels"),
            
            Config.CreateMod(23, 0, "Cosmo"),
            Config.CreateMod(23, 1, "Super Mesh"),
            Config.CreateMod(23, 2, "Outsider"),
            Config.CreateMod(23, 3, "Rollas"),
            Config.CreateMod(23, 4, "Driftmeister"),
            Config.CreateMod(23, 5, "Slicer"),
            Config.CreateMod(23, 6, "Elquatro"),
            Config.CreateMod(23, 7, "Dubbed"),
            Config.CreateMod(23, 8, "Five Star"),
            Config.CreateMod(23, 9, "Slideways"),
            Config.CreateMod(23, 10, "Apex"),
            Config.CreateMod(23, 11, "Stanced EG"),
            Config.CreateMod(23, 12, "Countersteer"),
            Config.CreateMod(23, 13, "Endo v.1"),
            Config.CreateMod(23, 14, "Endo v.2 dish"),
            Config.CreateMod(23, 15, "Guppe Z"),
            Config.CreateMod(23, 16, "Choku-Dori"),
            Config.CreateMod(23, 17, "Chicane"),
            Config.CreateMod(23, 18, "Saisoku"),
            Config.CreateMod(23, 19, "Dished Eight"),
            Config.CreateMod(23, 20, "Fujiwara"),
            Config.CreateMod(23, 21, "Zokusha"),
            Config.CreateMod(23, 22, "Battle Vill"),
            Config.CreateMod(23, 23, "Rally Master"),
            
            Config.CreateMod(23, 24, "Cosmo"),
            Config.CreateMod(23, 25, "Super Mesh"),
            Config.CreateMod(23, 26, "Outsider"),
            Config.CreateMod(23, 27, "Rollas"),
            Config.CreateMod(23, 28, "Driftmeister"),
            Config.CreateMod(23, 29, "Slicer"),
            Config.CreateMod(23, 30, "Elquatro"),
            Config.CreateMod(23, 31, "Dubbed"),
            Config.CreateMod(23, 32, "Five Star"),
            Config.CreateMod(23, 33, "Slideways"),
            Config.CreateMod(23, 34, "Apex"),
            Config.CreateMod(23, 35, "Stanced EG"),
            Config.CreateMod(23, 36, "Countersteer"),
            Config.CreateMod(23, 37, "Endo v.1"),
            Config.CreateMod(23, 38, "Endo v.2 dish"),
            Config.CreateMod(23, 39, "Guppe Z"),
            Config.CreateMod(23, 40, "Choku-Dori"),
            Config.CreateMod(23, 41, "Chicane"),
            Config.CreateMod(23, 42, "Saisoku"),
            Config.CreateMod(23, 43, "Dished Eight"),
            Config.CreateMod(23, 44, "Fujiwara"),
            Config.CreateMod(23, 45, "Zokusha"),
            Config.CreateMod(23, 46, "Battle Vill"),
            Config.CreateMod(23, 47, "Rally Master"),
        },
        [7] = {
            Config.CreateMod(23, -1, "Stock", "Highend Wheels"),
            
            Config.CreateMod(23, 0, "Shadow"),
            Config.CreateMod(23, 1, "Hyper"),
            Config.CreateMod(23, 2, "Blade"),
            Config.CreateMod(23, 3, "Diamond"),
            Config.CreateMod(23, 4, "Supa Gee"),
            Config.CreateMod(23, 5, "Chromatic Z"),
            Config.CreateMod(23, 6, "Mercie"),
            Config.CreateMod(23, 7, "Obey RS"),
            Config.CreateMod(23, 8, "GT Chrome"),
            Config.CreateMod(23, 9, "Cheetah R"),
            Config.CreateMod(23, 10, "Solar"),
            Config.CreateMod(23, 11, "Split Ten"),
            Config.CreateMod(23, 12, "Dash VIP"),
            Config.CreateMod(23, 13, "LozSpeed Ten"),
            Config.CreateMod(23, 14, "Carbon Inferno"),
            Config.CreateMod(23, 15, "Carbon Shadow"),
            Config.CreateMod(23, 16, "Carbonic Z"),
            Config.CreateMod(23, 17, "Carbon Solar"),
            Config.CreateMod(23, 18, "Carbon Cheetahr"),
            Config.CreateMod(23, 19, "Carbon S Racer"),
            
            Config.CreateMod(23, 20, "Shadow"),
            Config.CreateMod(23, 21, "Hyper"),
            Config.CreateMod(23, 22, "Blade"),
            Config.CreateMod(23, 23, "Diamond"),
            Config.CreateMod(23, 24, "Supa Gee"),
            Config.CreateMod(23, 25, "Chromatic Z"),
            Config.CreateMod(23, 26, "Mercie"),
            Config.CreateMod(23, 27, "Obey RS"),
            Config.CreateMod(23, 28, "GT Chrome"),
            Config.CreateMod(23, 29, "Cheetah R"),
            Config.CreateMod(23, 30, "Solar"),
            Config.CreateMod(23, 31, "Split Ten"),
            Config.CreateMod(23, 32, "Dash VIP"),
            Config.CreateMod(23, 33, "LozSpeed Ten"),
            Config.CreateMod(23, 34, "Carbon Inferno"),
            Config.CreateMod(23, 35, "Carbon Shadow"),
            Config.CreateMod(23, 36, "Carbonic Z"),
            Config.CreateMod(23, 37, "Carbon Solar"),
            Config.CreateMod(23, 38, "Carbon Cheetahr"),
            Config.CreateMod(23, 39, "Carbon S Racer"),
            
            Config.CreateMod(23, 40, "Aftermarket"),
            Config.CreateMod(23, 41, "Aftermarket"),
            Config.CreateMod(23, 42, "Aftermarket"),
            Config.CreateMod(23, 43, "Aftermarket"),
            Config.CreateMod(23, 44, "Aftermarket"),
            Config.CreateMod(23, 45, "Aftermarket"),
            Config.CreateMod(23, 46, "Aftermarket"),
            Config.CreateMod(23, 47, "Aftermarket"),
            Config.CreateMod(23, 48, "Aftermarket"),
            Config.CreateMod(23, 49, "Aftermarket"),
            Config.CreateMod(23, 50, "Aftermarket"),
            Config.CreateMod(23, 51, "Aftermarket"),
            Config.CreateMod(23, 52, "Aftermarket"),
            Config.CreateMod(23, 53, "Aftermarket"),
            Config.CreateMod(23, 54, "Aftermarket"),
            Config.CreateMod(23, 55, "Aftermarket"),
            Config.CreateMod(23, 56, "Aftermarket"),
            Config.CreateMod(23, 57, "Aftermarket"),
            Config.CreateMod(23, 58, "Aftermarket"),
            Config.CreateMod(23, 59, "Aftermarket"),
        },
        [10] = {
            Config.CreateMod(23, -1, "Stock", "Open Wheels"),
            
            Config.CreateMod(23, 0, "Classic 5"),
            Config.CreateMod(23, 1, "Classic 5 Striped"),
            Config.CreateMod(23, 2, "Retro Star"),
            Config.CreateMod(23, 3, "Retro Star Striped"),
            Config.CreateMod(23, 4, "Triplex"),
            Config.CreateMod(23, 5, "Triplex Striped"),
            Config.CreateMod(23, 6, "70s Spec"),
            Config.CreateMod(23, 7, "70s Spec Striped"),
            Config.CreateMod(23, 8, "Super 5 R"),
            Config.CreateMod(23, 9, "Super 5 R Striped"),
            Config.CreateMod(23, 0, "Speedster"),
            Config.CreateMod(23, 11, "Speedster Striped"),
            Config.CreateMod(23, 12, "GP-90"),
            Config.CreateMod(23, 13, "GP-90 Striped"),
            Config.CreateMod(23, 14, "Superspoke"),
            Config.CreateMod(23, 15, "Superspoke Striped"),
            Config.CreateMod(23, 16, "Gridline"),
            Config.CreateMod(23, 17, "Gridline Striped"),
            Config.CreateMod(23, 18, "Snowflake"),
            Config.CreateMod(23, 19, "Snowflake Striped"),
            
            Config.CreateMod(23, 20, "Classic 5"),
            Config.CreateMod(23, 21, "Classic 5 Striped"),
            Config.CreateMod(23, 22, "Retro Star"),
            Config.CreateMod(23, 23, "Retro Star Striped"),
            Config.CreateMod(23, 24, "Triplex"),
            Config.CreateMod(23, 25, "Triplex Striped"),
            Config.CreateMod(23, 26, "70s Spec"),
            Config.CreateMod(23, 27, "70s Spec Striped"),
            Config.CreateMod(23, 28, "Super 5 R"),
            Config.CreateMod(23, 29, "Super 5 R Striped"),
            Config.CreateMod(23, 30, "Speedster"),
            Config.CreateMod(23, 31, "Speedster Striped"),
            Config.CreateMod(23, 32, "GP-90"),
            Config.CreateMod(23, 33, "GP-90 Striped"),
            Config.CreateMod(23, 34, "Superspoke"),
            Config.CreateMod(23, 35, "Superspoke Striped"),
            Config.CreateMod(23, 36, "Gridline"),
            Config.CreateMod(23, 37, "Gridline Striped"),
            Config.CreateMod(23, 38, "Snowflake"),
            Config.CreateMod(23, 39, "Snowflake Striped"),
            
            Config.CreateMod(23, 40, "Classic 5"),
            Config.CreateMod(23, 41, "Classic 5 Striped"),
            Config.CreateMod(23, 42, "Retro Star"),
            Config.CreateMod(23, 43, "Retro Star Striped"),
            Config.CreateMod(23, 44, "Triplex"),
            Config.CreateMod(23, 45, "Triplex Striped"),
            Config.CreateMod(23, 46, "70s Spec"),
            Config.CreateMod(23, 47, "70s Spec Striped"),
            Config.CreateMod(23, 48, "Super 5 R"),
            Config.CreateMod(23, 49, "Super 5 R Striped"),
            Config.CreateMod(23, 50, "Speedster"),
            Config.CreateMod(23, 51, "Speedster Striped"),
            Config.CreateMod(23, 52, "GP-90"),
            Config.CreateMod(23, 53, "GP-90 Striped"),
            Config.CreateMod(23, 54, "Superspoke"),
            Config.CreateMod(23, 55, "Superspoke Striped"),
            Config.CreateMod(23, 56, "Gridline"),
            Config.CreateMod(23, 57, "Gridline Striped"),
            Config.CreateMod(23, 58, "Snowflake"),
            Config.CreateMod(23, 59, "Snowflake Striped"),
            
            Config.CreateMod(23, 60, "Classic 5"),
            Config.CreateMod(23, 61, "Classic 5 Striped"),
            Config.CreateMod(23, 62, "Retro Star"),
            Config.CreateMod(23, 63, "Retro Star Striped"),
            Config.CreateMod(23, 64, "Triplex"),
            Config.CreateMod(23, 65, "Triplex Striped"),
            Config.CreateMod(23, 66, "70s Spec"),
            Config.CreateMod(23, 67, "70s Spec Striped"),
            Config.CreateMod(23, 68, "Super 5 R"),
            Config.CreateMod(23, 69, "Super 5 R Striped"),
            Config.CreateMod(23, 70, "Speedster"),
            Config.CreateMod(23, 71, "Speedster Striped"),
            Config.CreateMod(23, 72, "GP-90"),
            Config.CreateMod(23, 73, "GP-90 Striped"),
            Config.CreateMod(23, 74, "Superspoke"),
            Config.CreateMod(23, 75, "Superspoke Striped"),
            Config.CreateMod(23, 76, "Gridline"),
            Config.CreateMod(23, 77, "Gridline Striped"),
            Config.CreateMod(23, 78, "Snowflake"),
            Config.CreateMod(23, 79, "Snowflake Striped"),
            
            Config.CreateMod(23, 80, "Classic 5"),
            Config.CreateMod(23, 81, "Classic 5 Striped"),
            Config.CreateMod(23, 82, "Retro Star"),
            Config.CreateMod(23, 83, "Retro Star Striped"),
            Config.CreateMod(23, 84, "Triplex"),
            Config.CreateMod(23, 85, "Triplex Striped"),
            Config.CreateMod(23, 86, "70s Spec"),
            Config.CreateMod(23, 87, "70s Spec Striped"),
            Config.CreateMod(23, 88, "Super 5 R"),
            Config.CreateMod(23, 89, "Super 5 R Striped"),
            Config.CreateMod(23, 90, "Speedster"),
            Config.CreateMod(23, 91, "Speedster Striped"),
            Config.CreateMod(23, 92, "GP-90"),
            Config.CreateMod(23, 93, "GP-90 Striped"),
            Config.CreateMod(23, 94, "Superspoke"),
            Config.CreateMod(23, 95, "Superspoke Striped"),
            Config.CreateMod(23, 96, "Gridline"),
            Config.CreateMod(23, 97, "Gridline Striped"),
            Config.CreateMod(23, 98, "Snowflake"),
            Config.CreateMod(23, 99, "Snowflake Striped"),
            
            Config.CreateMod(23, 100, "Classic 5"),
            Config.CreateMod(23, 101, "Classic 5 Striped"),
            Config.CreateMod(23, 102, "Retro Star"),
            Config.CreateMod(23, 103, "Retro Star Striped"),
            Config.CreateMod(23, 104, "Triplex"),
            Config.CreateMod(23, 105, "Triplex Striped"),
            Config.CreateMod(23, 106, "70s Spec"),
            Config.CreateMod(23, 107, "70s Spec Striped"),
            Config.CreateMod(23, 108, "Super 5 R"),
            Config.CreateMod(23, 109, "Super 5 R Striped"),
            Config.CreateMod(23, 110, "Speedster"),
            Config.CreateMod(23, 111, "Speedster Striped"),
            Config.CreateMod(23, 112, "GP-90"),
            Config.CreateMod(23, 113, "GP-90 Striped"),
            Config.CreateMod(23, 114, "Superspoke"),
            Config.CreateMod(23, 115, "Superspoke Striped"),
            Config.CreateMod(23, 116, "Gridline"),
            Config.CreateMod(23, 117, "Gridline Striped"),
            Config.CreateMod(23, 118, "Snowflake"),
            Config.CreateMod(23, 119, "Snowflake Striped"),
            
            Config.CreateMod(23, 120, "Classic 5"),
            Config.CreateMod(23, 121, "Classic 5 Striped"),
            Config.CreateMod(23, 122, "Retro Star"),
            Config.CreateMod(23, 123, "Retro Star Striped"),
            Config.CreateMod(23, 124, "Triplex"),
            Config.CreateMod(23, 125, "Triplex Striped"),
            Config.CreateMod(23, 126, "70s Spec"),
            Config.CreateMod(23, 127, "70s Spec Striped"),
            Config.CreateMod(23, 128, "Super 5 R"),
            Config.CreateMod(23, 129, "Super 5 R Striped"),
            Config.CreateMod(23, 130, "Speedster"),
            Config.CreateMod(23, 131, "Speedster Striped"),
            Config.CreateMod(23, 132, "GP-90"),
            Config.CreateMod(23, 133, "GP-90 Striped"),
            Config.CreateMod(23, 134, "Superspoke"),
            Config.CreateMod(23, 135, "Superspoke Striped"),
            Config.CreateMod(23, 136, "Gridline"),
            Config.CreateMod(23, 137, "Gridline Striped"),
            Config.CreateMod(23, 138, "Snowflake"),
            Config.CreateMod(23, 139, "Snowflake Striped"),
        },
        [11] = {
            Config.CreateMod(23, -1, "Stock", "Street Wheels"),

            Config.CreateMod(23, 0, "Retro Steelie"),
            Config.CreateMod(23, 1, "Poverty Spec Steelie"),
            Config.CreateMod(23, 2, "Concave Steelie"),
            Config.CreateMod(23, 3, "Nebula"),
            Config.CreateMod(23, 4, "Hotring Steelie"),
            Config.CreateMod(23, 5, "Cup Champion"),
            Config.CreateMod(23, 6, "Stanced EG Custom"),
            Config.CreateMod(23, 7, "Kracka Custom"),
            Config.CreateMod(23, 8, "Dukes Custom"),
            Config.CreateMod(23, 9, "Endo v.3 Custom"),
            Config.CreateMod(23, 10, "V8 Killer"),
            Config.CreateMod(23, 11, "Fujiwara Custom"),
            Config.CreateMod(23, 12, "Cosmo MKII"),
            Config.CreateMod(23, 13, "Aero Star"),
            Config.CreateMod(23, 14, "Hype Five"),
            Config.CreateMod(23, 15, "Ruff Weld Mega Deep"),
            Config.CreateMod(23, 16, "Mercie Concave"),
            Config.CreateMod(23, 17, "Sugoi Concave"),
            Config.CreateMod(23, 18, "Synthetic Concave"),
            Config.CreateMod(23, 19, "Endo v.4 Dished"),
            Config.CreateMod(23, 20, "Hyperfresh"),
            Config.CreateMod(23, 21, "Truffade Concave"),
            Config.CreateMod(23, 22, "Organic Type II"),
            Config.CreateMod(23, 23, "Big Mamba"),
            Config.CreateMod(23, 24, "Deep Flake"),
            Config.CreateMod(23, 25, "Cosmo MKIII"),
            Config.CreateMod(23, 26, "Concave Racer"),
            Config.CreateMod(23, 27, "Deep Flake Reverse"),
            Config.CreateMod(23, 28, "Wild Wagon"),
            Config.CreateMod(23, 29, "Concave Mega Mesh"),

            Config.CreateMod(23, 30, "Retro Steelie"),
            Config.CreateMod(23, 31, "Poverty Spec Steelie"),
            Config.CreateMod(23, 32, "Concave Steelie"),
            Config.CreateMod(23, 33, "Nebula"),
            Config.CreateMod(23, 34, "Hotring Steelie"),
            Config.CreateMod(23, 35, "Cup Champion"),
            Config.CreateMod(23, 36, "Stanced EG Custom"),
            Config.CreateMod(23, 37, "Kracka Custom"),
            Config.CreateMod(23, 38, "Dukes Custom"),
            Config.CreateMod(23, 39, "Endo v.3 Custom"),
            Config.CreateMod(23, 40, "V8 Killer"),
            Config.CreateMod(23, 41, "Fujiwara Custom"),
            Config.CreateMod(23, 42, "Cosmo MKII"),
            Config.CreateMod(23, 43, "Aero Star"),
            Config.CreateMod(23, 44, "Hype Five"),
            Config.CreateMod(23, 45, "Ruff Weld Mega Deep"),
            Config.CreateMod(23, 46, "Mercie Concave"),
            Config.CreateMod(23, 47, "Sugoi Concave"),
            Config.CreateMod(23, 48, "Synthetic Concave"),
            Config.CreateMod(23, 49, "Endo v.4 Dished"),
            Config.CreateMod(23, 50, "Hyperfresh"),
            Config.CreateMod(23, 51, "Truffade Concave"),
            Config.CreateMod(23, 52, "Organic Type II"),
            Config.CreateMod(23, 53, "Big Mamba"),
            Config.CreateMod(23, 54, "Deep Flake"),
            Config.CreateMod(23, 55, "Cosmo MKIII"),
            Config.CreateMod(23, 56, "Concave Racer"),
            Config.CreateMod(23, 57, "Deep Flake Reverse"),
            Config.CreateMod(23, 58, "Wild Wagon"),
            Config.CreateMod(23, 59, "Concave Mega Mesh"),

            Config.CreateMod(23, 60, "Retro Steelie"),
            Config.CreateMod(23, 61, "Poverty Spec Steelie"),
            Config.CreateMod(23, 62, "Concave Steelie"),
            Config.CreateMod(23, 63, "Nebula"),
            Config.CreateMod(23, 64, "Hotring Steelie"),
            Config.CreateMod(23, 65, "Cup Champion"),
            Config.CreateMod(23, 66, "Stanced EG Custom"),
            Config.CreateMod(23, 67, "Kracka Custom"),
            Config.CreateMod(23, 68, "Dukes Custom"),
            Config.CreateMod(23, 69, "Endo v.3 Custom"),
            Config.CreateMod(23, 70, "V8 Killer"),
            Config.CreateMod(23, 71, "Fujiwara Custom"),
            Config.CreateMod(23, 72, "Cosmo MKII"),
            Config.CreateMod(23, 73, "Aero Star"),
            Config.CreateMod(23, 74, "Hype Five"),
            Config.CreateMod(23, 75, "Ruff Weld Mega Deep"),
            Config.CreateMod(23, 76, "Mercie Concave"),
            Config.CreateMod(23, 77, "Sugoi Concave"),
            Config.CreateMod(23, 78, "Synthetic Concave"),
            Config.CreateMod(23, 79, "Endo v.4 Dished"),
            Config.CreateMod(23, 80, "Hyperfresh"),
            Config.CreateMod(23, 81, "Truffade Concave"),
            Config.CreateMod(23, 82, "Organic Type II"),
            Config.CreateMod(23, 83, "Big Mamba"),
            Config.CreateMod(23, 84, "Deep Flake"),
            Config.CreateMod(23, 85, "Cosmo MKIII"),
            Config.CreateMod(23, 86, "Concave Racer"),
            Config.CreateMod(23, 87, "Deep Flake Reverse"),
            Config.CreateMod(23, 88, "Wild Wagon"),
            Config.CreateMod(23, 89, "Concave Mega Mesh"),

            Config.CreateMod(23, 90, "Retro Steelie"),
            Config.CreateMod(23, 91, "Poverty Spec Steelie"),
            Config.CreateMod(23, 92, "Concave Steelie"),
            Config.CreateMod(23, 93, "Nebula"),
            Config.CreateMod(23, 94, "Hotring Steelie"),
            Config.CreateMod(23, 95, "Cup Champion"),
            Config.CreateMod(23, 96, "Stanced EG Custom"),
            Config.CreateMod(23, 97, "Kracka Custom"),
            Config.CreateMod(23, 98, "Dukes Custom"),
            Config.CreateMod(23, 99, "Endo v.3 Custom"),
            Config.CreateMod(23, 100, "V8 Killer"),
            Config.CreateMod(23, 101, "Fujiwara Custom"),
            Config.CreateMod(23, 102, "Cosmo MKII"),
            Config.CreateMod(23, 103, "Aero Star"),
            Config.CreateMod(23, 104, "Hype Five"),
            Config.CreateMod(23, 105, "Ruff Weld Mega Deep"),
            Config.CreateMod(23, 106, "Mercie Concave"),
            Config.CreateMod(23, 107, "Sugoi Concave"),
            Config.CreateMod(23, 108, "Synthetic Concave"),
            Config.CreateMod(23, 109, "Endo v.4 Dished"),
            Config.CreateMod(23, 110, "Hyperfresh"),
            Config.CreateMod(23, 111, "Truffade Concave"),
            Config.CreateMod(23, 112, "Organic Type II"),
            Config.CreateMod(23, 113, "Big Mamba"),
            Config.CreateMod(23, 114, "Deep Flake"),
            Config.CreateMod(23, 115, "Cosmo MKIII"),
            Config.CreateMod(23, 116, "Concave Racer"),
            Config.CreateMod(23, 117, "Deep Flake Reverse"),
            Config.CreateMod(23, 118, "Wild Wagon"),
            Config.CreateMod(23, 119, "Concave Mega Mesh"),

            Config.CreateMod(23, 120, "Retro Steelie"),
            Config.CreateMod(23, 121, "Poverty Spec Steelie"),
            Config.CreateMod(23, 122, "Concave Steelie"),
            Config.CreateMod(23, 123, "Nebula"),
            Config.CreateMod(23, 124, "Hotring Steelie"),
            Config.CreateMod(23, 125, "Cup Champion"),
            Config.CreateMod(23, 126, "Stanced EG Custom"),
            Config.CreateMod(23, 127, "Kracka Custom"),
            Config.CreateMod(23, 128, "Dukes Custom"),
            Config.CreateMod(23, 129, "Endo v.3 Custom"),
            Config.CreateMod(23, 130, "V8 Killer"),
            Config.CreateMod(23, 131, "Fujiwara Custom"),
            Config.CreateMod(23, 132, "Cosmo MKII"),
            Config.CreateMod(23, 133, "Aero Star"),
            Config.CreateMod(23, 134, "Hype Five"),
            Config.CreateMod(23, 135, "Ruff Weld Mega Deep"),
            Config.CreateMod(23, 136, "Mercie Concave"),
            Config.CreateMod(23, 137, "Sugoi Concave"),
            Config.CreateMod(23, 138, "Synthetic Concave"),
            Config.CreateMod(23, 139, "Endo v.4 Dished"),
            Config.CreateMod(23, 140, "Hyperfresh"),
            Config.CreateMod(23, 141, "Truffade Concave"),
            Config.CreateMod(23, 142, "Organic Type II"),
            Config.CreateMod(23, 143, "Big Mamba"),
            Config.CreateMod(23, 144, "Deep Flake"),
            Config.CreateMod(23, 145, "Cosmo MKIII"),
            Config.CreateMod(23, 146, "Concave Racer"),
            Config.CreateMod(23, 147, "Deep Flake Reverse"),
            Config.CreateMod(23, 148, "Wild Wagon"),
            Config.CreateMod(23, 149, "Concave Mega Mesh"),

            Config.CreateMod(23, 150, "Retro Steelie"),
            Config.CreateMod(23, 151, "Poverty Spec Steelie"),
            Config.CreateMod(23, 152, "Concave Steelie"),
            Config.CreateMod(23, 153, "Nebula"),
            Config.CreateMod(23, 154, "Hotring Steelie"),
            Config.CreateMod(23, 155, "Cup Champion"),
            Config.CreateMod(23, 156, "Stanced EG Custom"),
            Config.CreateMod(23, 157, "Kracka Custom"),
            Config.CreateMod(23, 158, "Dukes Custom"),
            Config.CreateMod(23, 159, "Endo v.3 Custom"),
            Config.CreateMod(23, 160, "V8 Killer"),
            Config.CreateMod(23, 161, "Fujiwara Custom"),
            Config.CreateMod(23, 162, "Cosmo MKII"),
            Config.CreateMod(23, 163, "Aero Star"),
            Config.CreateMod(23, 164, "Hype Five"),
            Config.CreateMod(23, 165, "Ruff Weld Mega Deep"),
            Config.CreateMod(23, 166, "Mercie Concave"),
            Config.CreateMod(23, 167, "Sugoi Concave"),
            Config.CreateMod(23, 168, "Synthetic Concave"),
            Config.CreateMod(23, 169, "Endo v.4 Dished"),
            Config.CreateMod(23, 170, "Hyperfresh"),
            Config.CreateMod(23, 171, "Truffade Concave"),
            Config.CreateMod(23, 172, "Organic Type II"),
            Config.CreateMod(23, 173, "Big Mamba"),
            Config.CreateMod(23, 174, "Deep Flake"),
            Config.CreateMod(23, 175, "Cosmo MKIII"),
            Config.CreateMod(23, 176, "Concave Racer"),
            Config.CreateMod(23, 177, "Deep Flake Reverse"),
            Config.CreateMod(23, 178, "Wild Wagon"),
            Config.CreateMod(23, 179, "Concave Mega Mesh"),

            Config.CreateMod(23, 180, "Retro Steelie"),
            Config.CreateMod(23, 181, "Poverty Spec Steelie"),
            Config.CreateMod(23, 182, "Concave Steelie"),
            Config.CreateMod(23, 183, "Nebula"),
            Config.CreateMod(23, 184, "Hotring Steelie"),
            Config.CreateMod(23, 185, "Cup Champion"),
            Config.CreateMod(23, 186, "Stanced EG Custom"),
            Config.CreateMod(23, 187, "Kracka Custom"),
            Config.CreateMod(23, 188, "Dukes Custom"),
            Config.CreateMod(23, 189, "Endo v.3 Custom"),
            Config.CreateMod(23, 190, "V8 Killer"),
            Config.CreateMod(23, 191, "Fujiwara Custom"),
            Config.CreateMod(23, 192, "Cosmo MKII"),
            Config.CreateMod(23, 193, "Aero Star"),
            Config.CreateMod(23, 194, "Hype Five"),
            Config.CreateMod(23, 195, "Ruff Weld Mega Deep"),
            Config.CreateMod(23, 196, "Mercie Concave"),
            Config.CreateMod(23, 197, "Sugoi Concave"),
            Config.CreateMod(23, 198, "Synthetic Concave"),
            Config.CreateMod(23, 199, "Endo v.4 Dished"),
            Config.CreateMod(23, 200, "Hyperfresh"),
            Config.CreateMod(23, 201, "Truffade Concave"),
            Config.CreateMod(23, 202, "Organic Type II"),
            Config.CreateMod(23, 203, "Big Mamba"),
            Config.CreateMod(23, 204, "Deep Flake"),
            Config.CreateMod(23, 205, "Cosmo MKIII"),
            Config.CreateMod(23, 206, "Concave Racer"),
            Config.CreateMod(23, 207, "Deep Flake Reverse"),
            Config.CreateMod(23, 208, "Wild Wagon"),
            Config.CreateMod(23, 209, "Concave Mega Mesh"),
        },
        [12] = {
            Config.CreateMod(23, -1, "Stock", "Track Wheels"),

            Config.CreateMod(23, 0, "Rally Throwback"),
            Config.CreateMod(23, 1, "Gravel Trap"),
            Config.CreateMod(23, 2, "Stove Top"),
            Config.CreateMod(23, 3, "Stove Top Mesh"),
            Config.CreateMod(23, 4, "Retro 3 Piece"),
            Config.CreateMod(23, 5, "Rally Monoblock"),
            Config.CreateMod(23, 6, "Forged 5"),
            Config.CreateMod(23, 7, "Split Star"),
            Config.CreateMod(23, 8, "Speed Boy"),
            Config.CreateMod(23, 9, "90s Running"),
            Config.CreateMod(23, 10, "Tropos"),
            Config.CreateMod(23, 11, "Exos"),
            Config.CreateMod(23, 12, "High Five"),
            Config.CreateMod(23, 13, "Super Luxe"),
            Config.CreateMod(23, 14, "Pure Business"),
            Config.CreateMod(23, 15, "Pepper Pot"),
            Config.CreateMod(23, 16, "Blacktop Blender"),
            Config.CreateMod(23, 17, "Throwback"),
            Config.CreateMod(23, 18, "Expressway"),
            Config.CreateMod(23, 19, "Hidden Six"),
            Config.CreateMod(23, 20, "Dinka SPL"),
            Config.CreateMod(23, 21, "Retro Turbofan"),
            Config.CreateMod(23, 22, "Conical Turbofan"),
            Config.CreateMod(23, 23, "Ice Storm"),
            Config.CreateMod(23, 24, "Super Turbine"),
            Config.CreateMod(23, 25, "Modern Mesh"),
            Config.CreateMod(23, 26, "Forged Star"),
            Config.CreateMod(23, 27, "Snowflake"),
            Config.CreateMod(23, 28, "Giga Mesh"),
            Config.CreateMod(23, 29, "Mesh Meister"),

            Config.CreateMod(23, 30, "Rally Throwback"),
            Config.CreateMod(23, 31, "Gravel Trap"),
            Config.CreateMod(23, 32, "Stove Top"),
            Config.CreateMod(23, 33, "Stove Top Mesh"),
            Config.CreateMod(23, 34, "Retro 3 Piece"),
            Config.CreateMod(23, 35, "Rally Monoblock"),
            Config.CreateMod(23, 36, "Forged 5"),
            Config.CreateMod(23, 37, "Split Star"),
            Config.CreateMod(23, 38, "Speed Boy"),
            Config.CreateMod(23, 39, "90s Running"),
            Config.CreateMod(23, 40, "Tropos"),
            Config.CreateMod(23, 41, "Exos"),
            Config.CreateMod(23, 42, "High Five"),
            Config.CreateMod(23, 43, "Super Luxe"),
            Config.CreateMod(23, 44, "Pure Business"),
            Config.CreateMod(23, 45, "Pepper Pot"),
            Config.CreateMod(23, 46, "Blacktop Blender"),
            Config.CreateMod(23, 47, "Throwback"),
            Config.CreateMod(23, 48, "Expressway"),
            Config.CreateMod(23, 49, "Hidden Six"),
            Config.CreateMod(23, 50, "Dinka SPL"),
            Config.CreateMod(23, 51, "Retro Turbofan"),
            Config.CreateMod(23, 52, "Conical Turbofan"),
            Config.CreateMod(23, 53, "Ice Storm"),
            Config.CreateMod(23, 54, "Super Turbine"),
            Config.CreateMod(23, 55, "Modern Mesh"),
            Config.CreateMod(23, 56, "Forged Star"),
            Config.CreateMod(23, 57, "Snowflake"),
            Config.CreateMod(23, 58, "Giga Mesh"),
            Config.CreateMod(23, 59, "Mesh Meister"),

            Config.CreateMod(23, 60, "Rally Throwback"),
            Config.CreateMod(23, 61, "Gravel Trap"),
            Config.CreateMod(23, 62, "Stove Top"),
            Config.CreateMod(23, 63, "Stove Top Mesh"),
            Config.CreateMod(23, 64, "Retro 3 Piece"),
            Config.CreateMod(23, 65, "Rally Monoblock"),
            Config.CreateMod(23, 66, "Forged 5"),
            Config.CreateMod(23, 67, "Split Star"),
            Config.CreateMod(23, 68, "Speed Boy"),
            Config.CreateMod(23, 69, "90s Running"),
            Config.CreateMod(23, 70, "Tropos"),
            Config.CreateMod(23, 71, "Exos"),
            Config.CreateMod(23, 72, "High Five"),
            Config.CreateMod(23, 73, "Super Luxe"),
            Config.CreateMod(23, 74, "Pure Business"),
            Config.CreateMod(23, 75, "Pepper Pot"),
            Config.CreateMod(23, 76, "Blacktop Blender"),
            Config.CreateMod(23, 77, "Throwback"),
            Config.CreateMod(23, 78, "Expressway"),
            Config.CreateMod(23, 79, "Hidden Six"),
            Config.CreateMod(23, 80, "Dinka SPL"),
            Config.CreateMod(23, 81, "Retro Turbofan"),
            Config.CreateMod(23, 82, "Conical Turbofan"),
            Config.CreateMod(23, 83, "Ice Storm"),
            Config.CreateMod(23, 84, "Super Turbine"),
            Config.CreateMod(23, 85, "Modern Mesh"),
            Config.CreateMod(23, 86, "Forged Star"),
            Config.CreateMod(23, 87, "Snowflake"),
            Config.CreateMod(23, 88, "Giga Mesh"),
            Config.CreateMod(23, 89, "Mesh Meister"),

            Config.CreateMod(23, 90, "Rally Throwback"),
            Config.CreateMod(23, 91, "Gravel Trap"),
            Config.CreateMod(23, 92, "Stove Top"),
            Config.CreateMod(23, 93, "Stove Top Mesh"),
            Config.CreateMod(23, 94, "Retro 3 Piece"),
            Config.CreateMod(23, 95, "Rally Monoblock"),
            Config.CreateMod(23, 96, "Forged 5"),
            Config.CreateMod(23, 97, "Split Star"),
            Config.CreateMod(23, 98, "Speed Boy"),
            Config.CreateMod(23, 99, "90s Running"),
            Config.CreateMod(23, 100, "Tropos"),
            Config.CreateMod(23, 101, "Exos"),
            Config.CreateMod(23, 102, "High Five"),
            Config.CreateMod(23, 103, "Super Luxe"),
            Config.CreateMod(23, 104, "Pure Business"),
            Config.CreateMod(23, 105, "Pepper Pot"),
            Config.CreateMod(23, 106, "Blacktop Blender"),
            Config.CreateMod(23, 107, "Throwback"),
            Config.CreateMod(23, 108, "Expressway"),
            Config.CreateMod(23, 109, "Hidden Six"),
            Config.CreateMod(23, 110, "Dinka SPL"),
            Config.CreateMod(23, 111, "Retro Turbofan"),
            Config.CreateMod(23, 112, "Conical Turbofan"),
            Config.CreateMod(23, 113, "Ice Storm"),
            Config.CreateMod(23, 114, "Super Turbine"),
            Config.CreateMod(23, 115, "Modern Mesh"),
            Config.CreateMod(23, 116, "Forged Star"),
            Config.CreateMod(23, 117, "Snowflake"),
            Config.CreateMod(23, 118, "Giga Mesh"),
            Config.CreateMod(23, 119, "Mesh Meister"),

            Config.CreateMod(23, 120, "Rally Throwback"),
            Config.CreateMod(23, 121, "Gravel Trap"),
            Config.CreateMod(23, 122, "Stove Top"),
            Config.CreateMod(23, 123, "Stove Top Mesh"),
            Config.CreateMod(23, 124, "Retro 3 Piece"),
            Config.CreateMod(23, 125, "Rally Monoblock"),
            Config.CreateMod(23, 126, "Forged 5"),
            Config.CreateMod(23, 127, "Split Star"),
            Config.CreateMod(23, 128, "Speed Boy"),
            Config.CreateMod(23, 129, "90s Running"),
            Config.CreateMod(23, 130, "Tropos"),
            Config.CreateMod(23, 131, "Exos"),
            Config.CreateMod(23, 132, "High Five"),
            Config.CreateMod(23, 133, "Super Luxe"),
            Config.CreateMod(23, 134, "Pure Business"),
            Config.CreateMod(23, 135, "Pepper Pot"),
            Config.CreateMod(23, 136, "Blacktop Blender"),
            Config.CreateMod(23, 137, "Throwback"),
            Config.CreateMod(23, 138, "Expressway"),
            Config.CreateMod(23, 139, "Hidden Six"),
            Config.CreateMod(23, 140, "Dinka SPL"),
            Config.CreateMod(23, 141, "Retro Turbofan"),
            Config.CreateMod(23, 142, "Conical Turbofan"),
            Config.CreateMod(23, 143, "Ice Storm"),
            Config.CreateMod(23, 144, "Super Turbine"),
            Config.CreateMod(23, 145, "Modern Mesh"),
            Config.CreateMod(23, 146, "Forged Star"),
            Config.CreateMod(23, 147, "Snowflake"),
            Config.CreateMod(23, 148, "Giga Mesh"),
            Config.CreateMod(23, 149, "Mesh Meister"),

            Config.CreateMod(23, 150, "Rally Throwback"),
            Config.CreateMod(23, 151, "Gravel Trap"),
            Config.CreateMod(23, 152, "Stove Top"),
            Config.CreateMod(23, 153, "Stove Top Mesh"),
            Config.CreateMod(23, 154, "Retro 3 Piece"),
            Config.CreateMod(23, 155, "Rally Monoblock"),
            Config.CreateMod(23, 156, "Forged 5"),
            Config.CreateMod(23, 157, "Split Star"),
            Config.CreateMod(23, 158, "Speed Boy"),
            Config.CreateMod(23, 159, "90s Running"),
            Config.CreateMod(23, 160, "Tropos"),
            Config.CreateMod(23, 161, "Exos"),
            Config.CreateMod(23, 162, "High Five"),
            Config.CreateMod(23, 163, "Super Luxe"),
            Config.CreateMod(23, 164, "Pure Business"),
            Config.CreateMod(23, 165, "Pepper Pot"),
            Config.CreateMod(23, 166, "Blacktop Blender"),
            Config.CreateMod(23, 167, "Throwback"),
            Config.CreateMod(23, 168, "Expressway"),
            Config.CreateMod(23, 169, "Hidden Six"),
            Config.CreateMod(23, 170, "Dinka SPL"),
            Config.CreateMod(23, 171, "Retro Turbofan"),
            Config.CreateMod(23, 172, "Conical Turbofan"),
            Config.CreateMod(23, 173, "Ice Storm"),
            Config.CreateMod(23, 174, "Super Turbine"),
            Config.CreateMod(23, 175, "Modern Mesh"),
            Config.CreateMod(23, 176, "Forged Star"),
            Config.CreateMod(23, 177, "Snowflake"),
            Config.CreateMod(23, 178, "Giga Mesh"),
            Config.CreateMod(23, 179, "Mesh Meister"),

            Config.CreateMod(23, 180, "Rally Throwback"),
            Config.CreateMod(23, 181, "Gravel Trap"),
            Config.CreateMod(23, 182, "Stove Top"),
            Config.CreateMod(23, 183, "Stove Top Mesh"),
            Config.CreateMod(23, 184, "Retro 3 Piece"),
            Config.CreateMod(23, 185, "Rally Monoblock"),
            Config.CreateMod(23, 186, "Forged 5"),
            Config.CreateMod(23, 187, "Split Star"),
            Config.CreateMod(23, 188, "Speed Boy"),
            Config.CreateMod(23, 189, "90s Running"),
            Config.CreateMod(23, 190, "Tropos"),
            Config.CreateMod(23, 191, "Exos"),
            Config.CreateMod(23, 192, "High Five"),
            Config.CreateMod(23, 193, "Super Luxe"),
            Config.CreateMod(23, 194, "Pure Business"),
            Config.CreateMod(23, 195, "Pepper Pot"),
            Config.CreateMod(23, 196, "Blacktop Blender"),
            Config.CreateMod(23, 197, "Throwback"),
            Config.CreateMod(23, 198, "Expressway"),
            Config.CreateMod(23, 199, "Hidden Six"),
            Config.CreateMod(23, 200, "Dinka SPL"),
            Config.CreateMod(23, 201, "Retro Turbofan"),
            Config.CreateMod(23, 202, "Conical Turbofan"),
            Config.CreateMod(23, 203, "Ice Storm"),
            Config.CreateMod(23, 204, "Super Turbine"),
            Config.CreateMod(23, 205, "Modern Mesh"),
            Config.CreateMod(23, 206, "Forged Star"),
            Config.CreateMod(23, 207, "Snowflake"),
            Config.CreateMod(23, 208, "Giga Mesh"),
            Config.CreateMod(23, 209, "Mesh Meister"),
        }
    },
    WindowTint = {
        Config.CreateMod(55, 0, "Stock"),
        Config.CreateMod(55, 3, "Light Smoke"),
        Config.CreateMod(55, 2, "Dark Smoke"),
        Config.CreateMod(55, 1, "Pure Black"),
    }
}