

Citizen.CreateThread(function()
if globalConfig.showBlipOnMap then
  for _, info in pairs(globalConfig.props) do
    info.blip = AddBlipForCoord(info.x, info.y, info.z)
    SetBlipSprite(info.blip, globalConfig.blip.id)
    SetBlipDisplay(info.blip, 4)
    SetBlipScale(info.blip, 1.0)
    SetBlipColour(info.blip, globalConfig.blip.colour)
    SetBlipAsShortRange(info.blip, true)
  BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(globalConfig.blip.title)
    EndTextCommandSetBlipName(info.blip)
  end
end
end)

local place = 0
local started = false
local grade = 0.5
local disabledControl = 0

Citizen.CreateThread(function()
	while true do
		Wait(5000)
    for i, modelConfig in pairs(globalConfig.props) do
      if Vdist(GetEntityCoords(PlayerPedId()), modelConfig.x, modelConfig.y, modelConfig.z) < 50 then
        thisTable = GetClosestObjectOfType(modelConfig.x, modelConfig.y, modelConfig.z, 1.5, GetHashKey(modelConfig.model), 0, 0, 0)
        if DoesEntityExist(thisTable) then
          SetEntityHeading(thisTable)
          PlaceObjectOnGroundProperly(thisTable)
        else
          thisTable = CreateObject(GetHashKey(modelConfig.model), modelConfig.x, modelConfig.y, modelConfig.z, false, false, false)
          SetEntityHeading(thisTable)
          PlaceObjectOnGroundProperly(thisTable)
        end
      elseif Vdist(GetEntityCoords(PlayerPedId()), modelConfig.x, modelConfig.y, modelConfig.z) >= 50 then
        thisTable = GetClosestObjectOfType(modelConfig.x, modelConfig.y, modelConfig.z, 1.5, GetHashKey(modelConfig.model), 0, 0, 0)
        if DoesEntityExist(thisTable) then
          DeleteEntity(thisTable)
        end
      end
    end		
	end
end)


Citizen.CreateThread(function()
  while true do
      Wait(0)

      if IsControlJustPressed(0, 38) and place == 0 then
        checkFunction()
      end

      if disabledControl == 1 then

          DisableControlAction(2, 71, true)
          DisableControlAction(2, 72, true)
          DisableControlAction(2, 63, true)
          DisableControlAction(2, 64, true)
          DisableControlAction(2, 75, true)
          DisableControlAction(2, 32, true)
          DisableControlAction(2, 33, true)
          DisableControlAction(2, 34, true)
          DisableControlAction(2, 35, true)
          DisableControlAction(2, 37, true)
          DisableControlAction(2, 23, true)
          DisableControlAction(2, 246, true)

      elseif disabledControl == 2 then

        DisableControlAction(2, 71, true)
        DisableControlAction(2, 72, true)
        DisableControlAction(2, 63, true)
        DisableControlAction(2, 64, true)
        DisableControlAction(2, 75, true)
        DisableControlAction(2, 73, true)
        DisableControlAction(2, 32, true)
        DisableControlAction(2, 33, true)
        DisableControlAction(2, 34, true)
        DisableControlAction(2, 35, true)
        DisableControlAction(2, 37, true)
        DisableControlAction(2, 23, true)
        DisableControlAction(2, 38, true)
        DisableControlAction(2, 246, true)

    end

  end
end)

function notify(msg)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(msg)
    DrawNotification(true,false)
end

function timer()


    PlaySoundFrontend(-1, "Out_Of_Area", "DLC_Lowrider_Relay_Race_Sounds", 0)
    local T = GetGameTimer()
    while GetGameTimer() - T < 1000 do
      Wait(0)
      Draw2DText(0.5, 0.4, ("~s~3"), 3.0)
    end
    PlaySoundFrontend(-1, "Out_Of_Area", "DLC_Lowrider_Relay_Race_Sounds", 0)
    local T = GetGameTimer()
    while GetGameTimer() - T < 1000 do
      Wait(0)
      Draw2DText(0.5, 0.4, ("~s~2"), 3.0)
    end
    PlaySoundFrontend(-1, "Out_Of_Area", "DLC_Lowrider_Relay_Race_Sounds", 0)
    local T = GetGameTimer()
    while GetGameTimer() - T < 1000 do
      Wait(0)
      Draw2DText(0.5, 0.4, ("~s~1"), 3.0)
    end
    PlaySoundFrontend(-1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", 0)
  
    local T = GetGameTimer()
    while GetGameTimer() - T < 1000 do
      Wait(0)
      Draw2DText(0.4, 0.4, ("~s~GO ~w~!"), 3.0)
    end
    

end


function checkFunction()
  for i, modelConfig in pairs(globalConfig.props) do
    local table = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 1.5, GetHashKey(modelConfig.model), 0, 0, 0)
    if DoesEntityExist(table) then
      local position = GetEntityCoords(PlayerPedId())
      TriggerServerEvent('evy_arm:check_sv', position)
      break
    end
  end
end

RegisterNetEvent('evy_arm:updategrade_cl')
AddEventHandler('evy_arm:updategrade_cl', function(gradeUpValue)

  grade = gradeUpValue

end)

RegisterNetEvent('evy_arm:start_cl')
AddEventHandler('evy_arm:start_cl', function()
  started = true
  if place == 1 then

    disabledControl = 2
    timer()

    PlayAnim(PlayerPedId(), "mini@arm_wrestling", "sweep_a", 1)
    SetEntityAnimSpeed(PlayerPedId(), "mini@arm_wrestling", "sweep_a", 0.0)
    SetEntityAnimCurrentTime(PlayerPedId(), "mini@arm_wrestling", "sweep_a", grade)
    PlayFacialAnim(PlayerPedId(), "electrocuted_1", "facials@gen_male@base")
    disabledControl = 1

    while grade >= 0.10 and grade <= 0.90 do
      Wait(0)
      PlayFacialAnim(PlayerPedId(), "electrocuted_1", "facials@gen_male@base")
      alert(text[globalConfig.language]['tuto'] .. "~INPUT_PICKUP~")
      SetEntityAnimSpeed(PlayerPedId(), "mini@arm_wrestling", "sweep_a", 0.0)
      SetEntityAnimCurrentTime(PlayerPedId(), "mini@arm_wrestling", "sweep_a", grade)
      if IsControlPressed(0, 38) then
        TriggerServerEvent('evy_arm:updategrade_sv', 0.015) 
        SetEntityAnimCurrentTime(PlayerPedId(), "mini@arm_wrestling", "sweep_a", grade)
        while IsControlPressed(0, 38) do
          Wait(0)
          alert(text[globalConfig.language]['tuto'] .. "~INPUT_PICKUP~")
          SetEntityAnimCurrentTime(PlayerPedId(), "mini@arm_wrestling", "sweep_a", grade)
        end
      end
    end
    if grade >= 0.90 then
      PlayAnim(PlayerPedId(), "mini@arm_wrestling", "win_a_ped_a", 2)
      notify("~g~" .. text[globalConfig.language]['win'])
    elseif grade <= 0.10 then
      PlayAnim(PlayerPedId(), "mini@arm_wrestling", "win_a_ped_b", 2)
      notify("~r~" .. text[globalConfig.language]['lose'])
    end
    Wait(4000)
    TriggerServerEvent('evy_arm:disband_sv', GetEntityCoords(PlayerPedId()))
    return

  elseif place == 2 then

    disabledControl = 2
    timer()

    PlayAnim(PlayerPedId(), "mini@arm_wrestling", "sweep_b", 1)
    SetEntityAnimSpeed(PlayerPedId(), "mini@arm_wrestling", "sweep_b", 0.0)
    SetEntityAnimCurrentTime(PlayerPedId(), "mini@arm_wrestling", "sweep_b", grade)
    PlayFacialAnim(PlayerPedId(), "electrocuted_1", "facials@gen_male@base")
    disabledControl = 1

    while grade >= 0.10 and grade <= 0.90 do
      Wait(0)
      PlayFacialAnim(PlayerPedId(), "electrocuted_1", "facials@gen_male@base")
      alert(text[globalConfig.language]['tuto'] .. "~INPUT_PICKUP~")
      SetEntityAnimSpeed(PlayerPedId(), "mini@arm_wrestling", "sweep_b", 0.0)
      SetEntityAnimCurrentTime(PlayerPedId(), "mini@arm_wrestling", "sweep_b", grade)
      if IsControlPressed(0, 38) then
        TriggerServerEvent('evy_arm:updategrade_sv', -0.015) 
        SetEntityAnimCurrentTime(PlayerPedId(), "mini@arm_wrestling", "sweep_b", grade)
        while IsControlPressed(0, 38) do
          Wait(0)
          alert(text[globalConfig.language]['tuto'] .. "~INPUT_PICKUP~")
          SetEntityAnimCurrentTime(PlayerPedId(), "mini@arm_wrestling", "sweep_b", grade)
        end
      end
    end

    if grade <= 0.10 then
      PlayAnim(PlayerPedId(), "mini@arm_wrestling", "win_a_ped_a", 2)
      notify("~g~" .. text[globalConfig.language]['win'])
    elseif grade >= 0.90 then
      PlayAnim(PlayerPedId(), "mini@arm_wrestling", "win_a_ped_b", 2)
      notify("~r~" .. text[globalConfig.language]['lose'])
    end
    Wait(4000)
    TriggerServerEvent('evy_arm:disband_sv', GetEntityCoords(PlayerPedId()))
    return

  end
end)

RegisterNetEvent('evy_arm:check_cl')
AddEventHandler('evy_arm:check_cl', function(args)
  local table = 0
  if args == 'place1' then
    place = 1

    for i, modelConfig in pairs(globalConfig.props) do
      table = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 1.5, GetHashKey(modelConfig.model), 0, 0, 0)
      if DoesEntityExist(table) then
        break
      end
    end
    disabledControl = 2

    SetEntityNoCollisionEntity(PlayerPedId(), table, false)
    --SetEntityHeading(table, 0.0)
    SetEntityHeading(PlayerPedId(), GetEntityHeading(table))
    Wait(100)
    SetEntityCoords(PlayerPedId(), GetOffsetFromEntityInWorldCoords(table, -0.20, 0.0, 0.0).x, GetOffsetFromEntityInWorldCoords(table, 0.0, -0.65, 0.0).y, GetEntityCoords(PlayerPedId()).z-1)
    FreezeEntityPosition(PlayerPedId(), true)
    PlayAnim(PlayerPedId(), "mini@arm_wrestling","aw_ig_intro_alt1_a", 2)
    while ( GetEntityAnimCurrentTime(PlayerPedId(), "mini@arm_wrestling", "aw_ig_intro_alt1_a") < 0.95 ) do
      Wait(0)
    end
    PlayAnim(PlayerPedId(), "mini@arm_wrestling", "nuetral_idle_a", 1)
    disabledControl = 1

    while not started do

      Wait(0)
      
      alert(text[globalConfig.language]['wait'])
      
      if IsControlPressed(2, 73) or IsPedRagdoll(PlayerPedId()) or IsControlPressed(2, 200) or IsControlPressed(2, 214) then
        SetEntityNoCollisionEntity(PlayerPedId(), table, true)
        TriggerServerEvent('evy_arm:disband_sv', GetEntityCoords(PlayerPedId()))
        return
      end

    end
  elseif args == 'place2' then

    place = 2
    for i, modelConfig in pairs(globalConfig.props) do
      table = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 1.5, GetHashKey(modelConfig.model), 0, 0, 0)
      if DoesEntityExist(table) then
        break
      end
    end
    disabledControl = 2

    SetEntityNoCollisionEntity(PlayerPedId(), table, false)
    --SetEntityHeading(table, 0.0)
    SetEntityHeading(PlayerPedId(), GetEntityHeading(table)-180)
    Wait(100)
    SetEntityCoords(PlayerPedId(), GetOffsetFromEntityInWorldCoords(table, 0.0, 0.0, 0.0).x, GetOffsetFromEntityInWorldCoords(table, 0.0, 0.50, 0.0).y, GetEntityCoords(PlayerPedId()).z-1)
    
    FreezeEntityPosition(PlayerPedId(), true)
    PlayAnim(PlayerPedId(), "mini@arm_wrestling","aw_ig_intro_alt1_b", 2)
    while ( GetEntityAnimCurrentTime(PlayerPedId(), "mini@arm_wrestling", "aw_ig_intro_alt1_b") < 0.95 ) do
      Wait(0)
    end
    PlayAnim(PlayerPedId(), "mini@arm_wrestling", "nuetral_idle_b", 1)
    disabledControl = 1
    
    while not started do
      
      Wait(0)
      alert(text[globalConfig.language]['wait'])
          
      if IsControlPressed(2, 73) or IsPedRagdoll(PlayerPedId()) or IsControlPressed(2, 200) or IsControlPressed(2, 214) then
        SetEntityNoCollisionEntity(PlayerPedId(), table, true)
        TriggerServerEvent('evy_arm:disband_sv', GetEntityCoords(PlayerPedId()))
        return
      end

    end

  elseif args == 'noplace' then

    notify('~r~' ..text[globalConfig.language]['full'])

  end

end)

RegisterNetEvent('evy_arm:reset_cl')
AddEventHandler('evy_arm:reset_cl', function()
  for i, modelConfig in pairs(globalConfig.props) do
    local tableId = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 1.5, GetHashKey(modelConfig.model), 0, 0, 0)
    if DoesEntityExist(tableId) then
      SetEntityNoCollisionEntity(PlayerPedId(), tableId, true)
      break
    end
  end
  ClearPedTasks(PlayerPedId())
  place = 0
  started = false
  grade = 0.5
  disabledControl = 0
  FreezeEntityPosition(PlayerPedId(), false)
  
end)

--============================================================================================--
--=====================              EXTERNAL FUNCTION              ==========================--
--============================================================================================--

function PlayAnim(ped, dict, name, flag)
  RequestAnimDict(dict)
  while not HasAnimDictLoaded(dict) do
    Citizen.Wait(0)
  end
  TaskPlayAnim(ped, dict, name, 1.5, 1.5, -1, flag, 0.0, false, false, false)
end

function alert(msg)
  SetTextComponentFormat("STRING")
  AddTextComponentString(msg)
  DisplayHelpTextFromStringLabel(0,0,1,-1)
end	

function Draw2DText(x, y, text, scale)
  -- Draw text on screen
  SetTextFont(4)
  SetTextProportional(7)
  SetTextScale(scale, scale)
  SetTextColour( 198, 25, 66, 255)
  SetTextDropShadow(0, 0, 0, 0,255)
  SetTextDropShadow()
  SetTextEdge(4, 0, 0, 0, 255)
  SetTextOutline()
  SetTextEntry("STRING")
  AddTextComponentString(text)
  DrawText(x, y)
end

function DrawAdvancedNativeText(x,y,w,h,sc, text, r,g,b,a,font,jus)
  SetTextFont(font)
  SetTextScale(sc, sc)
N_0x4e096588b13ffeca(jus)
  SetTextColour(254, 254, 254, 255)
  SetTextEntry("STRING")
  AddTextComponentString(text)
DrawText(x - 0.1+w, y - 0.02+h)
end

