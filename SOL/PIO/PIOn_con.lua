ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
WeatherMode = math.random(1,5)

isModMap = 1

ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\core.lvl")
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("SOL_Master")
ScriptCB_DoFile("ME5_Master")
ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ME5_ObjectiveConquest")

-- Create a new MapManager object
manager = MapManager:New{
	-- Map-specific details
	bIsModMap = true,					-- Whether or not this is a mod map (as opposed to a stock map).
	gameMode = "conquest",				-- The mission's game mode.
	mapSize = "med",						-- Size of the map. Used for determining unit counts.
	environmentType = "jungle",			-- Map's biome (essentially). Used for determining which camo textures to load. ("desert", "jungle", "snow", or "urban")
	
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
	artilleryNodes = {
				{"cp1_spawn", 0},
				{"cp2_spawn", 0},
				{"cp3_spawn", 0},
				{"cp4_spawn", 0},
				{"cp5_spawn", 0},
				{"cp6_spawn", 0},
				{"cp7_spawn", 0},
	},
	terrainType = "dirt",	-- Type of terrain in the map ("dirt, "sand", or "snow") (required if `artilleryNodes` is specified).
}
-- Initialize the MapManager
manager:Init()
	
if not ScriptCB_InMultiplayer() then
	CIS = math.random(1,2)
	REP = (3 - CIS)
else
	REP = 2
	CIS = 1
end

HuskTeam = 3

ATT = 1
DEF = 2


function ScriptPostLoad()	   
    
    
    -- This defines the CPs.  These need to happen first
    cp1 = CommandPost:New{name = "cp1"}
    cp2 = CommandPost:New{name = "cp2"}
    cp3 = CommandPost:New{name = "cp3"}
    cp4 = CommandPost:New{name = "cp4"}
    cp5 = CommandPost:New{name = "cp5"}
    cp6 = CommandPost:New{name = "cp6"}
    cp7 = CommandPost:New{name = "cp7"}
    
    
    -- This sets up the actual objective.  This needs to happen after cp's are defined
    conquest = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, 
                                     textATT = "game.modes.con", textDEF = "game.modes.con2", 
                                     
                                     multiplayerRules = true}
    
    -- This adds the CPs to the objective.  This needs to happen after the objective is set up
    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp2)
    conquest:AddCommandPost(cp3)
    conquest:AddCommandPost(cp4)
    conquest:AddCommandPost(cp5)
    conquest:AddCommandPost(cp6)
    conquest:AddCommandPost(cp7)    
    
    conquest:Start()

    EnableSPHeroRules()
	
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
	StealArtistHeap(2048*2048)
	
	if not ScriptCB_InMultiplayer() then
		if WeatherMode == 1 then
			ReadDataFile("dc:Load\\pio_load_sun_me5.lvl")
		elseif WeatherMode == 2 then 
			ReadDataFile("dc:Load\\pio_load_rain_me5.lvl")
		elseif WeatherMode == 3 then 
			ReadDataFile("dc:Load\\pio_load_storm_me5.lvl")
		elseif WeatherMode == 4 then 
			ReadDataFile("dc:Load\\pio_load_clouds_me5.lvl")
		elseif WeatherMode == 5 then 
			ReadDataFile("dc:Load\\pio_load_fog_me5.lvl")
		else end
	else
		ReadDataFile("dc:Load\\pio_load_sun_me5.lvl")
	end
	
	SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2559)
	SetMemoryPoolSize("ParticleTransformer::PositionTr", 1513)
	SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1699)
	
	-- Perform various pre-game operations
	manager:Proc_ScriptInit_Begin()
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\PFX_SSV_Veh.lvl;vehcommon")
    
   
    SetMaxFlyHeight(40)
    SetMaxPlayerFlyHeight(40)
    
	--  Side Definitions
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\me5tur.lvl",
					"tur_bldg_laser",
					"tur_bldg_mturret")
	
	-- Load and set up the sides
	manager:Proc_ScriptInit_SideSetup()
	
	ReadDataFile("dc:sound\\pio.lvl;pion")
   
	--  Memory Pools
    --  Level Stats
    --  ClearWalkers()
	--SetMemoryPoolSize("EntityWalker", -1)
    AddWalkerType(0, 0) -- special -> droidekas
    AddWalkerType(1, 0) -- 6 oneman AT-STs with 1 leg pair each
    AddWalkerType(2, 0) -- 2x2 (2 pairs of legs)
    AddWalkerType(3, 0) -- 3x2 (3 pairs of legs)
	
    local weaponCnt = 1024
    SetMemoryPoolSize("Aimer", 75)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 1024)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
	SetMemoryPoolSize("EntityCloth", 32)
	SetMemoryPoolSize("EntityFlyer", 32)
    SetMemoryPoolSize("EntityHover", 32)
    SetMemoryPoolSize("EntityLight", 200)
    SetMemoryPoolSize("EntitySoundStream", 64)
    SetMemoryPoolSize("EntitySoundStatic", 43)
	--SetMemoryPoolSize("Music", 108)
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
	ReadDataFile("dc:SOL\\PIO_skyobj.lvl")
	
	-- This tells our random weather which sky to load
	if not ScriptCB_InMultiplayer() then
		if WeatherMode == 1 then
			ReadDataFile("dc:SOL\\sunfx.lvl")
			ReadDataFile("dc:SOL\\PIO_sky.lvl", "sun")
			ReadDataFile("dc:SOL\\PIO.lvl", "PIO_conquest", "PIO_sun")
			SetDenseEnvironment("false")
			
			-- Birdies
			SetNumBirdTypes(1)
			SetBirdType(0, 1.0, "bird")
			
			AISnipeSuitabilityDist(170)
			SetAttackerSnipeRange(145)
			SetDefenderSnipeRange(200)
			
		elseif WeatherMode == 2 then 
			ReadDataFile("dc:SOL\\PIO.lvl", "PIO_conquest", "PIO_rain")
			ReadDataFile("dc:SOL\\PIO_sky.lvl", "rain")
			SetDenseEnvironment("true")
			SetAIViewMultiplier(0.83)
			
			AISnipeSuitabilityDist(150)
			SetAttackerSnipeRange(135)
			SetDefenderSnipeRange(170)
			
		elseif WeatherMode == 3 then 
			ReadDataFile("dc:SOL\\PIO.lvl", "PIO_conquest", "PIO_rain")
			ReadDataFile("dc:SOL\\PIO_sky.lvl", "storm")
			SetDenseEnvironment("true")
			SetAIViewMultiplier(0.77)
			
			AISnipeSuitabilityDist(145)
			SetAttackerSnipeRange(125)
			SetDefenderSnipeRange(160)
			
		elseif WeatherMode == 4 then
			ReadDataFile("dc:SOL\\sunfx.lvl")
			ReadDataFile("dc:SOL\\PIO.lvl", "PIO_conquest", "PIO_clouds")
			ReadDataFile("dc:SOL\\PIO_sky.lvl", "clouds")
			SetDenseEnvironment("false")
			
			-- Birdies
			SetNumBirdTypes(1)
			SetBirdType(0, 1.0, "bird")
			
			AISnipeSuitabilityDist(170)
			SetAttackerSnipeRange(145)
			SetDefenderSnipeRange(200)
			
		elseif WeatherMode == 5 then
			ReadDataFile("dc:SOL\\PIO.lvl", "PIO_conquest", "PIO_fog")
			ReadDataFile("dc:SOL\\PIO_sky.lvl", "fog")
			SetDenseEnvironment("true")
			
			AISnipeSuitabilityDist(110)
			SetAttackerSnipeRange(100)
			SetDefenderSnipeRange(120)
			
		end
	else
		ReadDataFile("dc:SOL\\sunfx.lvl")
		ReadDataFile("dc:SOL\\PIO.lvl", "PIO_conquest", "PIO_sun")
		ReadDataFile("dc:SOL\\PIO_sky.lvl", "sun")
		SetDenseEnvironment("false")
		
		-- Birdies
		SetNumBirdTypes(1)
		SetBirdType(0, 1.0, "bird")
		
		AISnipeSuitabilityDist(170)
		SetAttackerSnipeRange(145)
		SetDefenderSnipeRange(200)
	end
	
	ReadDataFile("dc:minimap.lvl;pio")
	
	-- Fishies
	SetNumFishTypes(1)
	SetFishType(0,0.8,"fish")


	--  Sound Stats
	
	-- Set up music
	manager:Proc_ScriptInit_MusicSetup()
	
	OpenAudioStream("dc:sound\\pio.lvl",  "pio")
	OpenAudioStream("dc:sound\\pio.lvl",  "pio_ambiance")	-- because battlefront's a poop :p
	
	SoundFX()
	
	if not ScriptCB_InMultiplayer() then
		if WeatherMode == 1 then
			ScaleSoundParameter("ambientenv",	"Gain", 1.0)
		elseif WeatherMode == 2 then
			ScaleSoundParameter("ambientenv",	"Gain", 0.85)
		elseif WeatherMode == 3 then
			ScaleSoundParameter("ambientenv",	"Gain", 1.0)
		elseif WeatherMode == 4 then
			ScaleSoundParameter("ambientenv",	"Gain", 1.0)
		elseif WeatherMode == 5 then
			ScaleSoundParameter("ambientenv",	"Gain", 1.0)
		end
	else
		ScaleSoundParameter("ambientenv",	"Gain", 1.0)
	end
	
	
	-- Camera Stats
    AddCameraShot(0.931925, -0.108715, 0.343641, 0.040088, -5.782282, 13.685349, 221.953949);
	AddCameraShot(0.358358, -0.010894, -0.933090, -0.028365, -44.763466, 2.160791, 153.530457);
	AddCameraShot(0.755659, -0.094642, 0.643067, 0.080541, 162.549301, 19.342003, 249.039520);
	AddCameraShot(0.558064, -0.040028, -0.826708, -0.059298, -197.403259, 8.593826, 157.532486);
	AddCameraShot(0.995680, -0.092814, 0.002568, 0.000239, -51.045925, 19.905941, 308.196655);
	
	-- Perform various post-load operations
	manager:Proc_ScriptInit_End()
	
end
