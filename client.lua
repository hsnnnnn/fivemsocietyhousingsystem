ESX = nil
PlayerData = {}
local myhouse = nil
bought = {}
Citizen.CreateThread(function()
    while ESX == nil do
        ESX = exports['es_extended']:getSharedObject()
        Citizen.Wait(1)
    end
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(1)
    end
    PlayerData = ESX.GetPlayerData()
    markerscheck()
end)

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
	DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
	ClearDrawOrigin()
end

Citizen.CreateThread(function()
    while true do
        local wait = 1000
        for k,v in pairs(Config.BuyHouse) do
           local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),v.x,v.y,v.z)
           if distance <= 5.0 then
            wait = 1
              if myhouse == nil then
                text = 'Ev Satın Al'
              else
                text = 'Ev Etkilesimleri'
              end
              if distance <= 1.0 then
                text = 'E - '..text
                if IsControlJustPressed(1,38) then
                    if myhouse == nil then
                        BuyHouse()
                    else
                        HouseMenu()
                    end
                end
              end
              DrawText3Ds(v.x,v.y,v.z,text)
           end
        end
        Citizen.Wait(wait)
    end
end)



HouseMenu = function()
    for k,v in pairs(Config.Houses) do
        for i,j in pairs(v.Ent) do
            if v.houseid == myhouse then
                elements = {
                    {label = 'Evden Ayrıl',value = 'evdenayril'},
                }
                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'xdxddxdx', {
                    title    = v.houseid.." - Ev Menüsü",
                    align    = 'top-left',
                    elements = elements
                }, function(data, menu)
                    if data.current.value == 'evdenayril' then
                        myhouse = nil
                        bought[v.houseid] = false
                        TriggerServerEvent("fivemsociety:evdenayril",v.houseid)
                        menu.close()
                    end
                end, function(data, menu)
                    menu.close()
                end)
            end
        end
    end
end
RegisterCommand("fix",function()
    ESX.UI.Menu.CloseAll()
end)

BuyHouse = function()
    elements = {}
    for k,v in pairs(Config.Houses) do
       --for km,vm in ipairs(v.Ent) do
        if bought[v.houseid] ~= true then
            table.insert(elements,{label = k..' | '..v.price.. '$',value = v})
        end
    end
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fsociety', {
        title    = "Ev Satın Al",
        align    = 'top-left',
        elements = elements
    }, function(data, menu)
        if data.current.value then
            TriggerServerEvent("fivemsociety:houserent",data.current.value.price,data.current.value.houseid)
            menu.close()
        end
    end, function(data, menu)
        menu.close()
    end)
end

RegisterNetEvent("fivemsociety:reload:client")
AddEventHandler("fivemsociety:reload:client",function()
    TriggerServerEvent("fivemsociety:reload:server")
end)

blips = {} 

CreateBlip = function(x,y, sprite, colour, scale, text)
    local blip = AddBlipForCoord(x,y)
    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, colour)
    SetBlipAsShortRange(blip, true)
    SetBlipScale(blip, scale)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)
    table.insert(blips, blip)
end

RegisterNetEvent("fivemsociety:sethouse:client")
AddEventHandler("fivemsociety:sethouse:client",function(houseid,boughthouses)
    if boughthouses ~= nil then
        bought[boughthouses] = true
    end
    for k, v in pairs(blips) do
        RemoveBlip(v)
    end
    if houseid ~= nil then
        myhouse = houseid
        for k,v in pairs(Config.Houses) do
            for i,j in pairs(v.Ent) do
                if v.houseid == houseid then
                    CreateBlip(j.door.x,j.door.y, 40, 3, 0.75, k)
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
	for k,v in pairs(Config.BuyHouse) do
		
		local blip = AddBlipForCoord(v.x,v.y,v.z)

		SetBlipSprite (blip, 475)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 0.9)
		SetBlipColour (blip, 0)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('Ev Satın Al')
		EndTextCommandSetBlipName(blip)
	end
end)

Citizen.CreateThread(function()
    while true do
        local player = PlayerPedId()
        local sleepthreat = 750
        local entity = GetEntityCoords(player)
        for k,v in pairs(Config.Houses) do
            for km,vm in pairs(v.Ent) do
                if v.houseid == myhouse then
                    local distance = GetDistanceBetweenCoords(entity,vm.door.x,vm.door.y,vm.door.z,false)
                    if distance <= 5.0 then
                        sleepthreat = 1
                        txt = 'Kapı'
                        if distance <= 1.0 then
                            if vm.doorlocked then
                                txt = 'E - Kapıyı Ac'
                            else
                                txt = 'E - Kapıyı Kilitle'
                            end
                            if IsControlJustPressed(1,38) then
                                ToggleDoor(k)
                            end
                        end
                        DrawText3Ds(vm.door.x,vm.door.y,vm.door.z,txt)
                    end
                    local distance2 = GetDistanceBetweenCoords(entity,vm.dolap.x,vm.dolap.y,vm.dolap.z,false)
                    if distance2 <= 5.0 then
                        sleepthreat = 1
                        text = 'Dolap'
                        if distance2 <= 1.0 then
                            text = 'E - Dolap'
                            if IsControlJustPressed(1,38) then
                                OpenStash(k)
                            end
                        end
                        DrawText3Ds(vm.dolap.x,vm.dolap.y,vm.dolap.z,text)
                    end 
                    local distance3 = GetDistanceBetweenCoords(entity,vm.kiyafet.x,vm.kiyafet.y,vm.kiyafet.z,false)
                    if distance3 <= 5.0 then
                        sleepthreat = 1
                        msg = 'Kıyafet Dolabı'
                        if distance3 <= 1.0 then
                            msg = 'E - Kıyafet Dolabı'
                            if IsControlJustPressed(1,38) then
                                OpenClotheMenu()
                            end
                        end
                        DrawText3Ds(vm.kiyafet.x,vm.kiyafet.y,vm.kiyafet.z,msg)
                    end
                end
            end
        end
        Citizen.Wait(sleepthreat)
    end
end)

OpenClotheMenu = function()
    ESX.TriggerServerCallback('fivemsociety:housing:getplayerdressing', function(dressing)
        local elements = {}
            for i= 1, #dressing, 1 do
                table.insert(elements, {
                label = dressing[i],
                value = i
                })
            end      
                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'clothing', {
                  title    = "Kıyafetlerini Değiştir",
                  align    = 'top-left',
                  elements = elements
                }, function(data2, menu2)
                    TriggerEvent('skinchanger:getSkin', function(skin)
                        ESX.TriggerServerCallback('fivemsociety:housing:getplayeroutfit', function(clothes)
                            TriggerEvent('skinchanger:loadClothes', skin, clothes)
                            TriggerEvent('esx_skin:setLastSkin', skin)
        
                            TriggerEvent('skinchanger:getSkin', function(skin)
                            TriggerServerEvent('esx_skin:save', skin)
                            end)
                        end, data2.current.value)
                    end)
                    TriggerEvent("notification",'Kıyafetinizi değiştirdiniz',2)
                end, function(data2, menu2)
                  menu2.close()
                end)
            end)
end

 
OpenStash = function(house)
    if Config.StashType == 'disc' then
        TriggerEvent('disc-inventoryhud:openInventory', {
        type = 'fivemsocietyhousing',
        slots = 100,
        owner = ""..house.."", 
        })
    elseif Config.StashType == 'm3' then
        TriggerEvent('m3:inventoryhud:client:openCustomStash', ''..house..'')
    elseif Config.StashType == 'npinv' then
        TriggerEvent("server-inventory-open", "1", ''..house..'');
    elseif Config.StashType == 'custom' then
        TriggerServerEvent("inventory:server:OpenInventory", "stash", ""..house)
        TriggerEvent("inventory:client:SetCurrentStash",""..house)
    end
end




RegisterNetEvent("fivemsociety:doorsync:client")
AddEventHandler("fivemsociety:doorsync:client",function(house,state)
    for k,v in pairs(Config.Houses) do
        for i,j in pairs(v.Ent) do
            if k == house then
                j.doorlocked = state
            end
        end
    end
end)

ToggleDoor = function(house)
    for k,v in pairs(Config.Houses) do
        for i,j in pairs(v.Ent) do
            if k == house then
                if j.doorlocked then
                    j.doorlocked = false
                else
                    j.doorlocked = true
                end
                TriggerServerEvent("fivemsociety:doorsync:server",k,j.doorlocked)
            end
        end
    end
end


function markerscheck()
    Citizen.CreateThread(function()
        while true do
            local wait = 750
            for k,v in pairs(Config.Houses) do
                for i,j in pairs(v.Ent) do
                local playercoords = GetEntityCoords(PlayerPedId())
                    if GetDistanceBetweenCoords(playercoords, j.door.x,j.door.y,j.door.z, false) <= 60.0 then
					wait = 5
                        if j.obj == nil or not DoesEntityExist(j.obj) then
                            j.obj = GetClosestObjectOfType(j.door.x,j.door.y,j.door.z, 1.4, v.hash, false, false, false)
                            FreezeEntityPosition(j.obj, j.doorlocked)
						else
                            FreezeEntityPosition(j.obj, j.doorlocked)
                            if j.doorlocked then
								SetEntityHeading(j.obj, j.heading)
                            end
                        end
                    end
				end
                Citizen.Wait(100)
            end
            Citizen.Wait(wait)
        end
    end)
end
