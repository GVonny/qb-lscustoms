Config.Doors = {
    ['driverfront'] = 0,
    ['driverrear'] = 2,
    ['passengerfront'] = 1,
    ['passengerrear'] = 3,
    ['hood'] = 4,
    ['trunk'] = 5,
    ['frontdoors'] = { 0, 1 },
    ['reardoors'] = { 2, 3 },
    ['hoodtrunk'] = { 4, 5 },
    ['alldoors'] = { 0, 1, 2, 3 },
    ['everything'] = { 0, 1, 2, 3, 4, 5 }
}

Config.DoorToggles = {
--DOMESTIC
    ['arias'] = {
        [8] = "trunk"
    },
    ['asterope2'] = {
        [31] = "alldoors",
        [39] = "hood",
        [40] = "hood",
        [41] = "hood"
    },
    ['banshee2'] = {
        [31] = "frontdoors",
        [39] = "hood",
        [41] = "hood"
    },
    ['brioso3'] = {
        [31] = "frontdoors",
        [39] = "hoodtrunk"
    },
    ['buccanee2'] = {
        [37] = "trunk",
        [38] = "trunk",
        [39] = "hood",
        [40] = "hood"
    },
    ['calico'] = {
        [31] = "frontdoors",
        [39] = "hood",
        [40] = "hood",
        [41] = "hood"
    },
    ['chino2'] = {
        [37] = "trunk",
        [38] = "trunk",
        [39] = "hood",
        [40] = "hood"
    },
    ['citi'] = {
        [39] = "hood",
        [40] = "trunk"
    },
    ['comet3'] = {
        [41] = "trunk"
    },
    ['comet42'] = {
        [31] = "frontdoors",
        [41] = "hood"
    },
    ['comet6'] = {
        [31] = "frontdoors"
    },
    ['coquette4c'] = {
        [31] = "frontdoors",
        [34] = "hood"
    },
    ['cypher'] = {
        [31] = "frontdoors",
        [39] = "hood",
        [41] = "hood"
    },
    ['cypherct'] = {
        [31] = "frontdoors",
        [39] = "hood",
        [40] = "hood",
        [41] = "hood"
    },
    ['dominator7'] = {
        [31] = "frontdoors",
        [39] = "hood",
        [40] = "hood",
        [41] = "hood",
        [47] = "hood"
    },
    ['elegy'] = {
        [31] = "frontdoors",
        [39] = "hood",
        [40] = "hood",
        [41] = "hood"
    },
    ['elegyrh7'] = {
        [36] = "hood",
        [39] = "hood",
        [41] = "hood"
    },
    ['euros'] = {
        [31] = "frontdoors",
        [39] = "hood",
        [40] = "hood",
        [41] = "hood"
    },
    ['faction2'] = {
        [37] = "trunk",
        [38] = "trunk",
        [39] = "hood",
        [40] = "hood"
    },
    ['faction3'] = {
        [37] = "trunk",
        [38] = "trunk",
        [39] = "hood",
        [40] = "hood"
    },
    ['ferocid'] = {
        [31] = "alldoors",
        [39] = "hood"
    },
    ['futo2'] = {
        [39] = "hood",
        [40] = "hood",
        [41] = "hood",
        [47] = "hood"
    },
    ['gauntlet5'] = {
        [31] = "frontdoors"
    },
    ['glendale2'] = {
        [37] = "trunk",
        [38] = "trunk",
        [39] = "hood",
        [40] = "hood"
    },
    ['greenwood'] = {
        [40] = "hood"
    },
    ['growler'] = {
        [41] = "trunk"
    },
    ['infernus2'] = {
        [8] = "hood"
    },
    ['italigtb2'] = {
        [31] = "frontdoors"
    },
    ['italigto'] = {
        [5] = "hood"
    },
    ['italigton'] = {
        [5] = "hood"
    },
    ['jackgpr'] = {
        [39] = "hood"
    },
    ['jester4'] = {
        [31] = "frontdoors",
        [39] = "hood",
        [40] = "hood",
        [41] = "hood"
    },
    ['jester5'] = {
        [31] = "frontdoors",
        [36] = "hood",
        [37] = "trunk",
        [39] = "hood",
        [41] = "hood"
    },
    ['jestgpr'] = {
        [31] = "frontdoors",
        [39] = "hood",
        [40] = "hood",
        [41] = "hood"
    },
    ['kanjosj'] = {
        [31] = "frontdoors",
        [39] = "hood",
        [40] = "hood",
        [41] = "hood"
    },
    ['kawaii'] = {
        [39] = "hood"
    },
    ['leo'] = {
        [36] = "hood"
    },
    ['manana2'] = {
        [37] = "trunk",
        [38] = "trunk",
        [39] = "hood",
        [40] = "hood"
    },
    ['minivan2'] = {
        [31] = "frontdoors",
        [37] = "trunk",
        [38] = "trunk",
        [39] = "hood",
        [40] = "hood"
    },
    ['moonbeam2'] = {
        [31] = "frontdoors",
        [37] = "trunk",
        [38] = "trunk",
        [39] = "hood",
        [40] = "hood"
    },
    ['n2futo'] = {
        [39] = "hood"
    },
    ['nero2'] = {
        [31] = "frontdoors"
    },
    ['nexus'] = {
        [31] = "frontdoors",
        [40] = "trunk"
    },
    ['oracxsle'] = {
        [41] = "hood"
    },
    ['postlude'] = {
        [31] = "frontdoors",
        [39] = "hood",
        [41] = "hood",
        [47] = "hood"
    },
    ['previon'] = {
        [31] = "frontdoors",
        [39] = "hood",
        [40] = "hood",
        [41] = "hood",
        [42] = "hood"
    },
    ['primo2'] = {
        [37] = "trunk",
        [38] = "trunk",
        [39] = "hood",
        [40] = "hood"
    },
    ['remus'] = {
        [26] = "hood",
        [31] = "frontdoors",
        [39] = "hood",
        [41] = "hood"
    },
    ['rt3000'] = {
        [31] = "frontdoors",
        [39] = "hood",
        [40] = "hood",
        [41] = "hood",
        [47] = "hood"
    },
    ['s230'] = {
        [39] = "hood",
        [40] = "hood",
        [41] = "hood"
    },
    ['sabregt2'] = {
        [37] = "trunk",
        [38] = "trunk",
        [39] = "hood",
        [40] = "hood"
    },
    ['sentinel4'] = {
        [31] = "frontdoors",
        [39] = "hood",
        [40] = "hood",
        [41] = "hood",
        [46] = "hood"
    },
    ['sentinel5'] = {
        [39] = "hood",
        [40] = "hood",
        [41] = "hood"
    },
    ['seraph3'] = {
        [40] = "trunk"
    },
    ['slamvan3'] = {
        [39] = "hood",
        [40] = "hood"
    },
    ['specter2'] = {
        [31] = "frontdoors"
    },
    ['sultan3'] = {
        [31] = "frontdoors",
        [39] = "hood",
        [40] = "hood",
        [41] = "hood",
        [46] = "hood"
    },
    ['sultanrs'] = {
        [31] = "frontdoors",
        [39] = "hood",
        [40] = "hood",
        [41] = "hood"
    },
    ['sunrise'] = {
        [36] = "trunk"
    },
    ['tailgater2'] = {
        [5] = "hood",
        [31] = "alldoors",
        [39] = "hood",
        [41] = "hood"
    },
    ['tenf2'] = {
        [31] = "frontdoors"
    },
    ['tornado5'] = {
        [37] = "trunk",
        [38] = "trunk",
        [39] = "hood",
        [40] = "hood"
    },
    ['vectre'] = {
        [31] = "frontdoors",
        [39] = "hood",
        [40] = "hood",
        [41] = "hood"
    },
    ['vigero3'] = {
        [5] = "hood",
        [39] = "hood",
        [41] = "hood",
        [42] = "hood",
        [43] = "hood",
        [44] = "hood"
    },
    ['virgo2'] = {
        [37] = "trunk",
        [38] = "trunk",
        [39] = "hood",
        [40] = "hood"
    },
    ['voodoo2'] = {
        [37] = "trunk",
        [38] = "trunk",
        [39] = "hood",
        [40] = "hood"
    },
    ['warrener2'] = {
        [31] = "frontdoors",
        [39] = "hood",
        [40] = "hood",
        [41] = "hood"
    },
    ['weevil2'] = {
        [47] = "frontdoors"
    },
    ['yosemite3'] = {
        [39] = "hood",
        [40] = "hood",
        [41] = "hood"
    },
    ['youga3'] = {
        [27] = "reardoors",
        [31] = "frontdoors",
        [37] = "reardoors",
        [39] = "hood"
    },
    ['z190'] = {
        [5] = "hood",
        [8] = "hood",
        [9] = "hood"
    },
    ['zion4'] = {
        [31] = "frontdoors",
        [39] = "hood"
    },
    ['zr350'] = {
        [31] = "frontdoors",
        [39] = "hood",
        [40] = "hood",
        [41] = "hood"
    },
    ['zr390'] = {
        [41] = "hood",
        [47] = "frontdoors"
    },
    ['zrgpr'] = {
        [31] = "frontdoors",
        [39] = "hood",
        [40] = "hood",
        [41] = "hood"
    },
}