ESX = nil
TriggerEvent("esx:getSharedObject",function(adsfadfsdgsdg)
    ESX = adsfadfsdgsdg
end)


RegisterServerEvent("fivemsociety:houserent")
AddEventHandler("fivemsociety:houserent",function(price,houseid)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if Config.MoneyCheck == 'cash' then
        if xPlayer.getMoney() >= price then
	    xPlayer.removeMoney(price)
            MySQL.Async.execute('INSERT INTO fivemsociety_housing (identifier, houseid) VALUES (@identifier, @houseid)',{
            ['@identifier'] = xPlayer.identifier, ['@houseid'] = houseid })
            TriggerClientEvent("notification",src,'Ev satın alındı',3)
            TriggerClientEvent("fivemsociety:reload:client",-1)
        else
            TriggerClientEvent("notification",src,'Yeterli paranız bulunmuyor',2)
            --print("yeterli parası yok")
        end
    elseif Config.MoneyCheck == 'bank' then
        if xPlayer.getAccount('bank').money >= price then
	    xPlayer.removeAccountMoney("bank", price)
            MySQL.Async.execute('INSERT INTO fivemsociety_housing (identifier, houseid) VALUES (@identifier, @houseid)',{
            ['@identifier'] = xPlayer.identifier, ['@houseid'] = houseid })
            TriggerClietEvent("notification",src,'Ev satın alındı',3)
            TriggerClientEvent("fivemsociety:reload:client",-1)
        else
            TriggerClietEvent("notification",src,'Yeterli paranız bulunmuyor',2)
        end
    end
end)

AddEventHandler("esx:playerLoaded",function(id,xPlayer)
    local Player = ESX.GetPlayerFromId(id)
    houseid = nil
    local boughthouses = nil
    MySQL.Async.fetchAll('SELECT * FROM fivemsociety_housing WHERE identifier = @identifier', {
        ['@identifier'] = Player.identifier,
    }, function(result)
        if result[1] ~= nil then
            houseid = json.decode(result[1].houseid) -- ?
        end
        MySQL.Async.fetchAll("SELECT * FROM fivemsociety_housing", {}, function(result2)
            if result2[1] ~= nil then
                for i = 1, #result2 do
                    boughthouses = json.decode(result2[i].houseid) -- ?
                end
            end
            TriggerClientEvent("fivemsociety:sethouse:client",Player.source,houseid,boughthouses)
        end)
    end)      
end)

RegisterServerEvent("fivemsociety:reload:server")
AddEventHandler("fivemsociety:reload:server",function()
    local Player = ESX.GetPlayerFromId(source)
    houseid = nil
    local boughthouses = nil
    MySQL.Async.fetchAll('SELECT * FROM fivemsociety_housing WHERE identifier = @identifier', {
        ['@identifier'] = Player.identifier,
    }, function(result)
        if result[1] ~= nil then
            houseid = json.decode(result[1].houseid) -- ?
        end
        MySQL.Async.fetchAll("SELECT * FROM fivemsociety_housing", {}, function(result2)
            if result2[1] ~= nil then
                for i = 1, #result2 do
                    boughthouses = json.decode(result2[i].houseid) -- ?
                end
            end
            TriggerClientEvent("fivemsociety:sethouse:client",Player.source,houseid,boughthouses)
        end)
    end)  
end)

RegisterServerEvent("fivemsociety:doorsync:server")
AddEventHandler("fivemsociety:doorsync:server",function(house,locked)
    TriggerClientEvent("fivemsociety:doorsync:client",-1,house,locked)
end)

RegisterServerEvent("fivemsociety:evdenayril")
AddEventHandler("fivemsociety:evdenayril",function(houseid)
    local src = source
    local player = ESX.GetPlayerFromId(src)
    MySQL.Async.execute('DELETE FROM fivemsociety_housing WHERE identifier = (@identifier)',{['@identifier'] = player.identifier})
    TriggerClientEvent("fivemsociety:reload:client",-1)
end)

ESX.RegisterServerCallback('fivemsociety:housing:getplayerdressing', function(source, cb)
	local xPlayer  = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		local count  = store.count('dressing')
		local labels = {}

		for i=1, count, 1 do
			local entry = store.get('dressing', i)
			table.insert(labels, entry.label)
		end

		cb(labels)
	end)
end)

ESX.RegisterServerCallback('fivemsociety:housing:getplayeroutfit', function(source, cb, num)
	local xPlayer  = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		local outfit = store.get('dressing', num)
		cb(outfit.skin)
	end)
end)





