ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\master.lvl")

isLowG = 1

ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\core.lvl")
ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\core.lvl")
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("SOL_Master")
ScriptCB_DoFile("ME5_Master")
ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ME5_ObjectiveConquest")
ScriptCB_DoFile("SOL_teleport")

-- Create a new MapManager object
manager = MapManager:New{
	-- Map-specific details
	bIsModMap = true,					-- Whether or not this is a mod map (as opposed to a stock map).
	gameMode = "conquest",				-- The mission's game mode.
	mapSize = "lg",						-- Size of the map. Used for determining unit counts.
	environmentType = "desert",			-- Map's biome (essentially). Used for determining which camo textures to load. ("desert", "jungle", "snow", or "urban")
	factionIds = {REP = 2, CIS = 1, LocalTeam1 = 4, LocalTeam2 = 5},
	
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
	},
	-- Local ally spawns (required). CP name, CP spawn path name
	allySpawnCPs = {
				{"cp1", "cp1_spawn"},
				{"cp2", "cp2_spawn"},
				{"cp3", "cp3_spawn"},
				{"cp4", "cp4_spawn"},
				{"cp5", "cp5_spawn"},
				{"cp6", "cp6_spawn"},
	},
	
	-- Artillery strike path nodes (required only if artillery strikes are desired). Path name, path node ID
	-- artilleryNodes = {
	-- 			{"cp1_spawn", 0},
	-- 			{"cp2_spawn", 0},
	-- 			{"cp3_spawn", 0},
	-- 			{"cp4_spawn", 0},
	-- 			{"cp5_spawn", 0},
	-- 			{"cp6_spawn", 0},
	-- },
	terrainType = "dirt",	-- Type of terrain in the map ("dirt, "sand", or "snow") (required if `artilleryNodes` is specified).
}
-- Initialize the MapManager
manager:Init()

function ScriptPostLoad()
    
    
    --This defines the CPs.  These need to happen first
    cp1 = CommandPost:New{name = "cp1"}
    cp2 = CommandPost:New{name = "cp2"}
	cp3 = CommandPost:New{name = "cp3"}
	cp4 = CommandPost:New{name = "cp4"}
	cp5 = CommandPost:New{name = "cp5"}
	cp6 = CommandPost:New{name = "cp6"}
	
    
    
    
    --This sets up the actual objective.  This needs to happen after cp's are defined
    conquest = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, 
                                     textATT = "game.modes.con", 
                                     textDEF = "game.modes.con2",
                                     multiplayerRules = true}
    
    --This adds the CPs to the objective.  This needs to happen after the objective is set up
    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp2)
	conquest:AddCommandPost(cp3)
	conquest:AddCommandPost(cp4)
	conquest:AddCommandPost(cp5)
	conquest:AddCommandPost(cp6)
    
    conquest:Start()

    EnableSPHeroRules()
	
	-- Teleport 1
	-- Start: "The Tunnels" command post
	-- End: South entrance to the tunnels
	local region = GetRegionLocation( "teleport1" )
	local destination = GetPathNodeDestination( "teleport1_spawn", 0 )
	SetupEnterRegionTeleport( region, destination, 0, 0 )
	ActivateRegion( "teleport1" )
	
	-- Teleport 2
	-- Start: South entrance to the tunnels
	-- End: "The Tunnels" command post
	local region = GetRegionLocation( "teleport2" )
	local destination = GetPathNodeDestination( "teleport2_spawn", 0 )
	SetupEnterRegionTeleport( region, destination, 0, 0 )
	ActivateRegion( "teleport2" )
	
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
	
	SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2558)
	SetMemoryPoolSize("ParticleTransformer::PositionTr", 1502)
	SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1654)
    
	ReadDataFile("dc:Load\\lun_load_me5.lvl")
	
	-- Perform various pre-game operations
	manager:Proc_ScriptInit_Begin()
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\PFX_SSV_Veh.lvl;vehcommon")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\PFX_SSV_Veh.lvl;vehnormal")
	
	-- These modify the AI marksman
	AISnipeSuitabilityDist(150)
	SetAttackerSnipeRange(120)
	SetDefenderSnipeRange(200)
    
   
    SetMinFlyHeight(-500)
    SetMaxFlyHeight(1000)
    --SetMaxPlayerFlyHeight (50)
	--SetGroundFlyerMap(1);
	
	ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\sound\\LUN.lvl;LUNn")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\me5tur.lvl",
					"tur_bldg_laser",
					"tur_bldg_recoilless_lg",
					"tur_bldg_mturret")
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\CON_LOWG.lvl")
	
	-- Load and set up the sides
	manager:Proc_ScriptInit_SideSetup()
	
    --  Level Stats
    --  ClearWalkers()
    AddWalkerType(0, 0) -- special -> droidekas
    AddWalkerType(1, 0) -- 1x2 (1 pair of legs)
    AddWalkerType(2, 0) -- 2x2 (2 pairs of legs)
    AddWalkerType(3, 0) -- 3x2 (3 pairs of legs)
    local weaponCnt = 1024
    SetMemoryPoolSize("Aimer", 75)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 1024)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
	SetMemoryPoolSize("EntityFlyer", 36)
    SetMemoryPoolSize("EntityHover", 32)
    SetMemoryPoolSize("EntityLight", 200)
	SetMemoryPoolSize("EntityPortableTurret", 64)
    SetMemoryPoolSize("EntitySoundStream", 64)
    SetMemoryPoolSize("EntitySoundStatic", 43)
    SetMemoryPoolSize("MountedTurret", 32)
	SetMemoryPoolSize("Navigator", 128)
    SetMemoryPoolSize("Obstacle", 1024)
	SetMemoryPoolSize("PathNode", 1024)
	SetMemoryPoolSize("SoldierAnimation", 437)
    SetMemoryPoolSize("SoundSpaceRegion", 64)
    SetMemoryPoolSize("TreeGridStack", 1024)
	SetMemoryPoolSize("UnitAgent", 128)
	SetMemoryPoolSize("UnitController", 128)
	SetMemoryPoolSize("Weapon", weaponCnt)
	manager:Proc_ScriptInit_MemoryPoolInit()
    
    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\SOL\\LUN.lvl", "LUN_conquest")
    SetDenseEnvironment("false")
	
	ReadDataFile("dc:minimap.lvl;lun")
	
	
    --  Sound
	
	OpenMusicStreams(1)
	
	SetVictoryMusic(REP, "ssv_amb_01_victory")
	SetDefeatMusic (REP, "ssv_amb_01_defeat")
	SetVictoryMusic(CIS, "ssv_amb_01_victory")
	SetDefeatMusic (CIS, "ssv_amb_01_defeat")
	
	OpenAudioStream("..\\..\\addon\\SOL\\data\\_LVL_PC\\sound\\lun.lvl",  "lun_ambiance")
	OpenAudioStream("..\\..\\addon\\SOL\\data\\_LVL_PC\\sound\\lun.lvl",  "lun_ambiance")
	
	SoundFX()
	
	ScaleSoundParameter("ambientenv",	"Gain", 1.0)


	-- Camera Stats
	AddCameraShot(0.914811, -0.054627, 0.399460, 0.023853, 186.374527, 41.910858, 230.153229);
	AddCameraShot(0.42879942, 0.029634291, 0.900765, -0.062251795, 94.304184, 3.1068244, 60.714558);
	AddCameraShot(-0.30707565, -0.010137247, 0.951113, -0.03139835, 113.88304, -1.8544445, 94.82649);
	AddCameraShot(0.8871262, 0.022626923, 0.46082205, -0.011753666, 153.2498, 3.7333364, 77.53909);
	AddCameraShot(0.12190397, -0.011001026, 0.9884641, 0.089202344, 68.87806, 15.825792, -21.693985);
	AddCameraShot(0.59346724, 0.005341597, -0.80480784, 0.007243802, -143.12001, 8.210795, 162.646);
	
	-- Perform various post-load operations
	manager:Proc_ScriptInit_End()
end
