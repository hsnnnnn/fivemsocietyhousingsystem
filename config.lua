Config = {}
Config.BuyHouse = { --Ev satın alma koordinatı
    vector3(-266.623, -960.859, 31.223)
}

Config.MoneyCheck = 'cash' -- veya 'bank' 
Config.StashType = 'custom'  --'esx' - 'disc' - 'np' - 'm3' 'custom' == "qb" 
Config.Houses = {
    ['Franklin House'] = {
        hash = 520341586,
        price = 1500,
        houseid = 1,
        Ent = {
            [1] = {door = vector3(-14.0542, -1441.55, 31.102),heading = -180.0,obj = nil,dolap = vector3(-16.9750, -1440.83, 31.101),kiyafet = vector3(-19.1700, -1432.55, 31.101),doorlocked = true}
        },
    },
    ['Fraklin House 2'] = {
        hash = 308207762,
        price = 2500,
        houseid = 2,
        Ent = {
            [1] = {door = vector3(8.478948, 539.4733, 176.02),heading = 150.0,obj = nil,dolap = vector3(-2.16523, 525.5687, 170.63),kiyafet = vector3(9.750511, 528.5465, 170.61),doorlocked = true}
        },
    },
    ['Lester House'] = {
        hash = 1145337974,
        price = 3500,
        houseid = 3,
        Ent = {
            [1] = {door = vector3(1274.560, -1720.67, 54.685),heading = 25.0,obj = nil,dolap = vector3(1268.246, -1709.85, 54.771),kiyafet = vector3(1275.777, -1713.55, 54.771),doorlocked = true}
        },
    },
    ['XX House'] = {
        hash = 486670049,
        price = 4500,
        houseid = 4,
        Ent = {
            [1] = {door = vector3(-106.891, -8.25868, 70.524),heading = 70.0,obj = nil,dolap = vector3(-112.189, -7.87149, 70.519),kiyafet = vector3(-110.679, -14.7323, 70.519),doorlocked = true}
        },
    }
}