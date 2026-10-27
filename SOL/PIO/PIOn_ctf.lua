--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\master.lvl")

isModMap = 1

ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\core.lvl")
ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\core.lvl")

-- load the gametype script
ScriptCB_DoFile("SOL_Master")
ScriptCB_DoFile("ME5_Master")
ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ObjectiveCTF")
	
-- Create a new MapManager object
manager = MapManager:New{
	-- Map-specific details
	bIsModMap = true,					-- Whether or not this is a mod map (as opposed to a stock map).
	gameMode = "ctf",				-- The mission's game mode.
	mapSize = "med",						-- Size of the map. Used for determining unit counts.
	environmentType = "jungle",			-- Map's biome (essentially). Used for determining which camo textures to load. ("desert", "jungle", "snow", or "urban")
	factionIds = {REP = 2, CIS = 1},
	
	-- In-game music (you can also specify a table of values and one of them will be randomly selected at runtime, example: `musicVariation_SSVxGTH = {"1","3"}` )
	musicVariation_SSVxGTH = "1",		-- Music variation to use for SSVxGTH matches.
	musicVariation_SSVxCOL = "5",		-- Music variation to use for SSVxCOL matches.
	musicVariation_EVGxGTH = "9",		-- Music variation to use for EVGxGTH matches.
	musicVariation_EVGxCOL = "9",		-- Music variation to use for EVGxCOL matches.
	
	-- Online matches
	onlineSideVar = "SSVxGTH",			-- Faction combination to use in online matches.
	onlineHeroSSV = "shep_infiltrator",	-- SSV hero to use in online matches.
	onlineHeroGTH = "gethprime_me2",	-- GTH hero to use in online matches.
	onlineHeroCOL = "colgeneral",		-- COL hero to use in online matches.
	onlineHeroEVG = "gethprime_me3",	-- EVG hero to use in online matches.
	
	-- AI hero spawns (required). CP name, CP spawn path name
	heroSupportCPs = {
				{"cp1", "cp1_spawn"},
				{"cp2", "cp2_spawn"},
				{"cp3", "cp3_spawn"},
				{"cp4", "cp4_spawn"},
				{"cp5", "cp5_spawn"},
				{"cp6", "cp6_spawn"},
				{"cp7", "cp7_spawn"},
	},
	-- Local ally spawns (required). CP name, CP spawn path name
	allySpawnCPs = {
				{"cp1", "cp1_spawn"},
				{"cp2", "cp2_spawn"},
				{"cp3", "cp3_spawn"},
				{"cp4", "cp4_spawn"},
				{"cp5", "cp5_spawn"},
				{"cp6", "cp6_spawn"},
				{"cp7", "cp7_spawn"},
	},
	
	-- Artillery strike path nodes (required only if artillery strikes are desired). Path name, path node ID
	-- artilleryNodes = {
	-- 			{"cp1_spawn", 0},
	-- 			{"cp2_spawn", 0},
	-- 			{"cp3_spawn", 0},
	-- 			{"cp4_spawn", 0},
	-- 			{"cp5_spawn", 0},
	-- 			{"cp6_spawn", 0},
	-- 			{"cp7_spawn", 0},
	-- },
	terrainType = "dirt",	-- Type of terrain in the map ("dirt, "sand", or "snow") (required if `artilleryNodes` is specified).
}
-- Initialize the MapManager
manager:Init()

function ScriptPostLoad()
    
    SetProperty("flag2", "GeometryName", "com_icon_republic_flag")
    SetProperty("flag2", "CarriedGeometryName", "com_icon_republic_flag_carried")
    SetProperty("flag1", "GeometryName", "com_icon_cis_flag")
    SetProperty("flag1", "CarriedGeometryName", "com_icon_cis_flag_carried")

                --This makes sure the flag is colorized when it has been dropped on the ground
    SetClassProperty("com_item_flag", "DroppedColorize", 1)

    --This is all the actual ctf objective setup
    ctf = ObjectiveCTF:New{teamATT = REP, teamDEF = CIS, captureLimit = 5, textATT = "game.modes.ctf", textDEF = "game.modes.ctf2", hideCPs = true, multiplayerRules = true}
    ctf:AddFlag{name = "flag1", homeRegion = "team1_capture", captureRegion = "team2_capture",
				capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3.0, 
				icon = "", mapIcon = "flag_icon", mapIconScale = 3.0}
    ctf:AddFlag{name = "flag2", homeRegion = "team2_capture", captureRegion = "team1_capture",
				capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3.0, 
				icon = "", mapIcon = "flag_icon", mapIconScale = 3.0}
	
	ctf:Start()
	
	SoundEvent_SetupTeams( manager.factionIds.REP, 'rep', manager.factionIds.CIS, 'cis' )
	
    EnableSPHeroRules()
	
	SetClassProperty("com_bldg_controlzone_ctf", "VehicleCollision", "none")

    SetClassProperty("tur_bldg_laser", "RespawnTime", "30")

	turretList = {
		"ctf_turret_1",
		"ctf_turret_2",
		"ctf_turret_3",
		"ctf_turret_4",
		"ctf_turret_5",
		"ctf_turret_6",
		"tur_bldg_laser",
		"tur_bldg_laser1",
		"tur_bldg_laser6",
		"tur_bldg_laser8",
	}
    
    respawnTurretsTimer = CreateTimer("respawnTurretsTimer")
    SetTimerValue(respawnTurretsTimer, 1)

    respawnTurretsTimerElapse = OnTimerElapse(
        function(timer)
            for _, turret in ipairs(turretList) do
				SetProperty(turret, "MaxHealth", 1600)
				SetProperty(turret, "CurHealth", 1600)
			end

            ReleaseTimerElapse(respawnTurretsTimerElapse)
            DestroyTimer(timer)
        end,
        respawnTurretsTimer
    )

    StartTimer(respawnTurretsTimer)
	
	-- Perform various post-load operations
	manager:Proc_ScriptPostLoad_End()
	
end


---------------------------------------------------------------------------
-- FUNCTION:    ScriptInit
-- PURPOSE:     This function is only run once
-- INPUT:
-- OUTPUT:
-- NOTES:       The name, 'ScriptInit' is a chosen convention, and each
--              mission script must contain a version of this function, as
--              it is called from C to start the mission.
---------------------------------------------------------------------------
function ScriptInit()

	if not ScriptCB_InMultiplayer() then
		if solConfigSettings["cfg_PioWeather"] == 0 then
			WeatherMode = math.random(1,5)
		else
			WeatherMode = solConfigSettings["cfg_PioWeather"]
		end
	else
		WeatherMode = 5
	end
	
	StealArtistHeap(2048*2048)
	--SetWorldExtents(512.0)
	
	if WeatherMode == 1 then
		ReadDataFile("dc:Load\\pio_load_sun.lvl")
	elseif WeatherMode == 2 then 
		ReadDataFile("dc:Load\\pio_load_rain.lvl")
	elseif WeatherMode == 3 then 
		ReadDataFile("dc:Load\\pio_load_storm.lvl")
	elseif WeatherMode == 4 then 
		ReadDataFile("dc:Load\\pio_load_clouds.lvl")
	elseif WeatherMode == 5 then 
		ReadDataFile("dc:Load\\pio_load_fog.lvl")
	end
	
	SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2183)
	SetMemoryPoolSize("ParticleTransformer::PositionTr", 1272)
	SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1406)
    SetMemoryPoolSize("ParticleEmitterObject", 3800)
	--SetMemoryPoolSize("Music", 108)
    
   
    SetMaxFlyHeight(30)
    SetMaxPlayerFlyHeight(30)
	
	--  Side Definitions
	ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\sound\\pio.lvl;pion")
    ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\sound\\sol.lvl;sol_pion")
    
	--  Side Definitions
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\me5tur.lvl",
					"tur_bldg_laser",
					"tur_bldg_mturret")
	
	ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\SIDE\\tur.lvl",
					"pio_waterdrops")
	
	-- Perform various pre-game operations
	manager:Proc_ScriptInit_Begin()
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\PFX_SSV_Veh.lvl;vehcommon")
	
	--  Memory Pools
    --  Level Stats
    --  ClearWalkers()
	SetMemoryPoolSize("EntityWalker", -1)
    AddWalkerType(0, 0) -- special -> droidekas
    AddWalkerType(1, 0) -- 6 oneman AT-STs with 1 leg pair each
    AddWalkerType(2, 0) -- 2x2 (2 pairs of legs)
    AddWalkerType(3, 0) -- 3x2 (3 pairs of legs)
    local weaponCnt = 1024
    SetMemoryPoolSize("Aimer", 75)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 1024)
	SetMemoryPoolSize("CommandWalker", 0)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
	SetMemoryPoolSize("EntityCloth", 32)
	SetMemoryPoolSize("EntityFlyer", 32)
    SetMemoryPoolSize("EntityHover", 32)
    SetMemoryPoolSize("EntityLight", 200)
    SetMemoryPoolSize("EntitySoundStream", 64)
    SetMemoryPoolSize("EntitySoundStatic", 43)
	SetMemoryPoolSize("FLEffectObject::OffsetMatrix", 90)
    SetMemoryPoolSize("MountedTurret", 32)
	SetMemoryPoolSize("Navigator", 128)
    SetMemoryPoolSize("Obstacle", 1024)
	SetMemoryPoolSize("PathNode", 1024)
    SetMemoryPoolSize("SoldierAnimation", 1000)
    SetMemoryPoolSize("SoundSpaceRegion", 64)
    SetMemoryPoolSize("TreeGridStack", 2048)
	SetMemoryPoolSize("UnitAgent", 128)
	SetMemoryPoolSize("UnitController", 128)
	SetMemoryPoolSize("Weapon", weaponCnt)
	manager:Proc_ScriptInit_MemoryPoolInit()
    
    SetSpawnDelay(10.0, 0.25)

	ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\SOL\\PIO_skyobj.lvl")
	canUseFoleyFx = false
	if GameExt.TestVersion then
		canUseFoleyFx = GameExt.TestVersion(1, 1, 0)
	end
	if WeatherMode == 1 then
		ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\SOL\\sunfx.lvl")
		ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\SOL\\PIO.lvl", "PIO_ctf", "PIO_sun", "PIO_NoRain")
		ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\SOL\\PIO_sky.lvl", "sun")
		SetDenseEnvironment("false")
		
		-- Birdies
		SetNumBirdTypes(1)
		SetBirdType(0, 1.0, "bird")
		SetBirdFlockMinHeight(91.0)
		
		AISnipeSuitabilityDist(170)
		SetAttackerSnipeRange(145)
		SetDefenderSnipeRange(200)
	elseif WeatherMode == 2 then 
		if canUseFoleyFx == true then
			ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\SOL\\PIO.lvl", "PIO_ctf", "PIO_rain", "PIO_RainExtras", "PIO_RainFoleyFx")
		else
			ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\SOL\\PIO.lvl", "PIO_ctf", "PIO_rain", "PIO_RainExtras")
		end
		ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\SOL\\PIO_sky.lvl", "rain")
		ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\SOL\\PIO_rain.lvl")
		SetDenseEnvironment("true")
		SetAIViewMultiplier(0.83)
		
		AISnipeSuitabilityDist(150)
		SetAttackerSnipeRange(135)
		SetDefenderSnipeRange(170)
	elseif WeatherMode == 3 then 
		if canUseFoleyFx == true then
			ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\SOL\\PIO.lvl", "PIO_ctf", "PIO_rain", "PIO_RainExtras", "PIO_RainFoleyFx")
		else
			ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\SOL\\PIO.lvl", "PIO_ctf", "PIO_rain", "PIO_RainExtras")
		end
		ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\SOL\\PIO_sky.lvl", "storm")
		ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\SOL\\PIO_stormy.lvl")
		SetDenseEnvironment("true")
		SetAIViewMultiplier(0.77)
		
		AISnipeSuitabilityDist(145)
		SetAttackerSnipeRange(125)
		SetDefenderSnipeRange(160)
	elseif WeatherMode == 4 then
		ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\SOL\\sunfx.lvl")
		ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\SOL\\PIO.lvl", "PIO_ctf", "PIO_clouds", "PIO_NoRain")
		ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\SOL\\PIO_sky.lvl", "clouds")
		SetDenseEnvironment("false")
		
		-- Birdies
		SetNumBirdTypes(1)
		SetBirdType(0, 1.0, "bird")
		SetBirdFlockMinHeight(91.0)
		
		AISnipeSuitabilityDist(170)
		SetAttackerSnipeRange(145)
		SetDefenderSnipeRange(200)
	elseif WeatherMode == 5 then
		ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\SOL\\PIO.lvl", "PIO_ctf", "PIO_fog", "PIO_NoRain")
		ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\SOL\\PIO_sky.lvl", "fog")
		SetDenseEnvironment("true")
		
		-- Birdies
		SetNumBirdTypes(1)
		SetBirdType(0, 1.0, "bird")
		SetBirdFlockMinHeight(91.0)
		
		AISnipeSuitabilityDist(110)
		SetAttackerSnipeRange(100)
		SetDefenderSnipeRange(120)
	end
	
	-- Fishies
	SetNumFishTypes(1)
	SetFishType(0,0.8,"fish")
	
	
    --  Sound Stats
    
	OpenAudioStream("..\\..\\addon\\SOL\\data\\_LVL_PC\\sound\\sol.lvl",  "sol_unit_vo_quick")
	OpenAudioStream("..\\..\\addon\\SOL\\data\\_LVL_PC\\sound\\pio.lvl",  "pio")
	OpenAudioStream("..\\..\\addon\\SOL\\data\\_LVL_PC\\sound\\pio.lvl",  "pio")
	OpenAudioStream("..\\..\\addon\\SOL\\data\\_LVL_PC\\sound\\pio.lvl",  "pio_ambiance")
	
	OpenMusicStreams(1)

	SetVictoryMusic(REP, "ssv_amb_01_victory")
	SetDefeatMusic (REP, "ssv_amb_01_defeat")
	SetVictoryMusic(CIS, "ssv_amb_01_victory")
	SetDefeatMusic (CIS, "ssv_amb_01_defeat")

	SoundFX()
	
	if WeatherMode == 1 then
		ScaleSoundParameter("ambientenv",	"Gain", 1.0)
	elseif WeatherMode == 2 then 
		ScaleSoundParameter("ambientenv",	"Gain", 0.45)
	elseif WeatherMode == 3 then 
		ScaleSoundParameter("ambientenv",	"Gain", 1.0)
	elseif WeatherMode == 4 then 
		ScaleSoundParameter("ambientenv",	"Gain", 1.0)
	elseif WeatherMode == 5 then 
		ScaleSoundParameter("ambientenv",	"Gain", 1.0)
	end


--OpeningSatelliteShot
	if WeatherMode == 1 then
		AddCameraShot(0.78239214, 0.048178133, 0.6197459, -0.0381627, 20.473604, -1.757833, 236.0353);
		AddCameraShot(0.321062, 0.007418, -0.946776, 0.021876, -191.791428, 1.474755, 153.650238);
		AddCameraShot(0.6870821, 0.0030921237, 0.7265658, -0.003269815, 163.77206, 9.248371, 112.79863);
		AddCameraShot(0.36380637, 0.01911758, 0.92999524, -0.048870113, 9.35362, 0.2784728, 147.9558);
		AddCameraShot(0.45681807, 0.02537953, 0.8878289, -0.049325284, 45.225582, 0.59574914, 237.8672);
	elseif WeatherMode == 2 then
		AddCameraShot(0.321062, 0.007418, -0.946776, 0.021876, -191.791428, 1.474755, 153.650238);
		AddCameraShot(0.78239214, 0.048178133, 0.6197459, -0.0381627, 20.473604, -1.757833, 236.0353);
		AddCameraShot(0.6870821, 0.0030921237, 0.7265658, -0.003269815, 163.77206, 9.248371, 112.79863);
		AddCameraShot(0.36380637, 0.01911758, 0.92999524, -0.048870113, 9.35362, 0.2784728, 147.9558);
		AddCameraShot(0.45681807, 0.02537953, 0.8878289, -0.049325284, 45.225582, 0.59574914, 237.8672);
	elseif WeatherMode == 3 then
		AddCameraShot(0.6870821, 0.0030921237, 0.7265658, -0.003269815, 163.77206, 9.248371, 112.79863);
		AddCameraShot(0.78239214, 0.048178133, 0.6197459, -0.0381627, 20.473604, -1.757833, 236.0353);
		AddCameraShot(0.321062, 0.007418, -0.946776, 0.021876, -191.791428, 1.474755, 153.650238);
		AddCameraShot(0.36380637, 0.01911758, 0.92999524, -0.048870113, 9.35362, 0.2784728, 147.9558);
		AddCameraShot(0.45681807, 0.02537953, 0.8878289, -0.049325284, 45.225582, 0.59574914, 237.8672);
	elseif WeatherMode == 4 then
		AddCameraShot(0.36380637, 0.01911758, 0.92999524, -0.048870113, 9.35362, 0.2784728, 147.9558);
		AddCameraShot(0.78239214, 0.048178133, 0.6197459, -0.0381627, 20.473604, -1.757833, 236.0353);
		AddCameraShot(0.321062, 0.007418, -0.946776, 0.021876, -191.791428, 1.474755, 153.650238);
		AddCameraShot(0.6870821, 0.0030921237, 0.7265658, -0.003269815, 163.77206, 9.248371, 112.79863);
		AddCameraShot(0.45681807, 0.02537953, 0.8878289, -0.049325284, 45.225582, 0.59574914, 237.8672);
	elseif WeatherMode == 5 then
		AddCameraShot(0.45681807, 0.02537953, 0.8878289, -0.049325284, 45.225582, 0.59574914, 237.8672);
		AddCameraShot(0.78239214, 0.048178133, 0.6197459, -0.0381627, 20.473604, -1.757833, 236.0353);
		AddCameraShot(0.321062, 0.007418, -0.946776, 0.021876, -191.791428, 1.474755, 153.650238);
		AddCameraShot(0.6870821, 0.0030921237, 0.7265658, -0.003269815, 163.77206, 9.248371, 112.79863);
		AddCameraShot(0.36380637, 0.01911758, 0.92999524, -0.048870113, 9.35362, 0.2784728, 147.9558);
	end
	AddCameraShot(0.9712917, -0.07591473, -0.22476804, -0.017567536, 6.6314235, 11.444863, 317.3819);
	AddCameraShot(-0.23325159, -0.012958795, 0.97083294, -0.053936716, -45.294662, -0.3002582, 167.09244);
	AddCameraShot(0.67033625, 0.007038841, 0.7419832, -0.007791168, -190.95717, 1.7646347, 166.28362);
	AddCameraShot(-0.3353011, -0.015098751, 0.9410364, -0.042375274, 121.87659, 8.596119, 135.9086);
	AddCameraShot(0.82748014, -0.0099301785, 0.56136674, 0.0067366837, 155.13936, 12.231754, 257.96085);
	AddCameraShot(0.93805367, 0.035193536, -0.34445572, 0.012923157, -93.28247, 7.2759905, 345.1387);
	AddCameraShot(0.8872635, -0.001330881, -0.4612606, -0.00069188356, -129.10677, 3.1064968, 271.71475);
	AddCameraShot(0.527645, -0.0071236347, -0.8493577, -0.011467017, -191.0782, 2.580083, 161.12482);
	AddCameraShot(0.9563252, -0.057448473, 0.2860883, 0.017185926, 99.960106, 20.792898, 338.19553);
	
	-- Perform various post-load operations
	manager:Proc_ScriptInit_End()
end