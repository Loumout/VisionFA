Citizen.CreateThread(function()
    -- LOCAL OPTIMIZATION
    local Wait = Wait
    local GetVehiclePedIsUsing = GetVehiclePedIsUsing
    local PlayerPedId = PlayerPedId
    local IsVehicleSirenOn = IsVehicleSirenOn
    local DisableControlAction = DisableControlAction
    local IsDisabledControlJustPressed = IsDisabledControlJustPressed
    local DecorExistOn = DecorExistOn
    local DecorGetBool = DecorGetBool
    local DecorSetBool = DecorSetBool
    local PlaySoundFrontend = PlaySoundFrontend
    -- END LOCAL OPTIMIZATIO

    DecorRegister("esc_siren_enabled", 2)
    while true do
        local veh = GetVehiclePedIsUsing(PlayerPedId())
        local wait = false
        if veh then
            if GetPedInVehicleSeat(veh, -1) == GetPlayerPed(-1) then
                wait = true
                if IsVehicleSirenOn(veh) then
                    DisableControlAction(0, 113, true)
                    if DecorExistOn(veh, "esc_siren_enabled") and DecorGetBool(veh, "esc_siren_enabled") then
                        if IsDisabledControlJustPressed(0, 113) then
                            DecorSetBool(veh, "esc_siren_enabled", false)
                            PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
                        end
                    else
                        if not DecorExistOn(veh, "esc_siren_enabled") then
                            DecorSetBool(veh, "esc_siren_enabled", false)
                        end
                        if IsDisabledControlJustPressed(0, 113) then
                            DecorSetBool(veh, "esc_siren_enabled", true)
                            PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
                        end
                    end
                end
            end
        end

        if wait then
            Wait(1)
        else
            Wait(1000)
        end
    end
end)
Citizen.CreateThread(function()
    -- LOCAL OPTIMIZATION
    local EnumerateVehicles = EnumerateVehicles
    local DecorExistOn = DecorExistOn
    local DecorGetBool = DecorGetBool
    local DisableVehicleImpactExplosionActivation = DisableVehicleImpactExplosionActivation
    local Wait = Wait
    -- END LOCAL OPTIMIZATION
    while true do
        Wait(150)
        local _c = 0
        for veh in EnumerateVehicles() do
            if DecorExistOn(veh, "esc_siren_enabled") and DecorGetBool(veh, "esc_siren_enabled") then
                DisableVehicleImpactExplosionActivation(veh, false)
            else
                DisableVehicleImpactExplosionActivation(veh, true)
            end
            _c = (_c + 1) % 10
            if _c == 0 then
                Wait(0)
            end
        end
    end
end)
