ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")	-- Load MEU's pre-packaged scripts (required)
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ScriptCB_DoFile("ME5_Master")				-- MEU's master include file (required)
ScriptCB_DoFile("ME5_setup_teams")			-- MEU's version of setup_teams.lua (required)
ScriptCB_DoFile("ME5_ObjectiveConquest")	-- MEU's ObjectiveConquest script (required for Conquest matches)

-- Create a new MapManager object
manager = MapManager:New{
	-- Map-specific details
	bIsModMap = true,					-- Whether or not this is a mod map (as opposed to a stock map).
	gameMode = "conquest",				-- The mission's game mode.
	mapSize = "med",						-- Size of the map. Used for determining unit counts.
	environmentType = "jungle",			-- Map's biome (essentially). Used for determining which camo textures to load. ("desert", "jungle", "snow", or "urban")
	
	-- In-game music (you can also specify a table of values and one of them will be randomly selected at runtime, example: `musicVariation_SSVxGTH = {"1","3"}` )
	musicVariation_SSVxGTH = "3_vrm",		-- Music variation to use for SSVxGTH matches.
	musicVariation_SSVxCOL = "5",		-- Music variation to use for SSVxCOL matches.
	musicVariation_EVGxGTH = "9",		-- Music variation to use for EVGxGTH matches.
	musicVariation_EVGxCOL = "9",		-- Music variation to use for EVGxCOL matches.
	musicVariation_SSVxRPR = "5_mahavid",		-- Music variation to use for SSVxRPR matches.
	musicVariation_SSVxCER = {"7_1", "7_2"},
	
	-- Online matches
	onlineSideVar = "SSVxGTH",			-- Faction combination to use in online matches.
	onlineHeroSSV = "shep_engineer",	-- SSV hero to use in online matches.
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
	artilleryNodes = {
				{"cp1_spawn", 0},
				{"cp2_spawn", 0},
				{"cp3_spawn", 0},
				--{"cp4_spawn", 0},
				{"cp5_spawn", 0},
				{"cp6_spawn", 0},
	},
	terrainType = "dirt",	-- Type of terrain in the map ("dirt, "sand", or "snow") (required if `artilleryNodes` is specified).
}
-- Initialize the MapManager
manager:Init()

-- Randomize which team is ATT/DEF
if not ScriptCB_InMultiplayer() then
	CIS = math.random(1,2)
	REP = (3 - CIS)
else
	REP = 1
	CIS = 2
end

HuskTeam = 3	-- The husk team (required, name cannot be changed)

ATT = 1
DEF = 2


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
	
	-- Perform various post-load operations
	manager:Proc_ScriptPostLoad_End()

    --BlockPlanningGraphArcs("ConnectionCave")
    DisableBarriers("BarrierCave")
	
end


---------------------------------------------------------------------------
-- FUNCTION:	ScriptInit
-- PURPOSE:	 This function is only run once
-- INPUT:
-- OUTPUT:
-- NOTES:	   The name, 'ScriptInit' is a chosen convention, and each
--			  mission script must contain a version of this function, as
--			  it is called from C to start the mission.
---------------------------------------------------------------------------
function ScriptInit()
	-- Load our loadscreen
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\AEI.lvl")
	
	SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2367)
	SetMemoryPoolSize("ParticleTransformer::PositionTr", 1380)
	SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1533)
	
	-- Perform various pre-game operations
	manager:Proc_ScriptInit_Begin()
	
	SetMaxFlyHeight(45)
	SetMaxPlayerFlyHeight(45)
	
	AISnipeSuitabilityDist(60)
	SetAttackerSnipeRange(90)
	SetDefenderSnipeRange(150)
	
	-- Load the turrets
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\me5tur.lvl",
					"tur_bldg_mturret",
					"tur_bldg_laser")
	
	-- Load and set up the sides
	manager:Proc_ScriptInit_SideSetup()
	
	-- Load our map-specific sound lvl
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Sound\\SFL_AEI_Streaming.lvl")
	
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
	SetMemoryPoolSize("EntityCloth", 0)
	SetMemoryPoolSize("EntityFlyer", 32)
	SetMemoryPoolSize("EntityHover", 32)
	SetMemoryPoolSize("EntityLight", 200)
	SetMemoryPoolSize("EntitySoundStream", 4)
	SetMemoryPoolSize("EntitySoundStatic", 32)
	SetMemoryPoolSize("Navigator", 128)
	SetMemoryPoolSize("Obstacle", 1024)
	SetMemoryPoolSize("PathNode", 1024)
	SetMemoryPoolSize("SoldierAnimation", 417)
	SetMemoryPoolSize("SoundSpaceRegion", 24)
	SetMemoryPoolSize("TreeGridStack", 1024)
	SetMemoryPoolSize("UnitAgent", 128)
	SetMemoryPoolSize("UnitController", 128)
	SetMemoryPoolSize("Weapon", weaponCnt)
	manager:Proc_ScriptInit_MemoryPoolInit()
	
	SetSpawnDelay(10.0, 0.25)
    ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\AEI.lvl", "AEI_conquest")
	SetDenseEnvironment("true")
	
	--  Birdies
	SetNumBirdTypes(1)
	SetBirdType(0, 0.7, "bird")
	SetBirdFlockMinHeight(60)
	
	--  Fishies
	SetNumFishTypes(1)
	SetFishType(0, 0.88, "fish")
	
	
	--  Sound Stats
	
	-- Open our map-specific ambient sound streams
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\Sound\\SFL_AEI_Streaming.lvl",  "AEI_ambiance")
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\Sound\\SFL_AEI_Streaming.lvl",  "AEI_ambiance")

	-- Set up music
	manager:Proc_ScriptInit_MusicSetup()
	
	-- Set up common sound stuff
	SoundFX()
	
	-- Camera Stats
	AddCameraShot(0.588003, -0.024096, -0.807822, -0.033104, -295.404785, 31.805162, -189.417618);	-- Island Wide Angle
	AddCameraShot(0.913883, 0.034342, -0.404237, 0.015190, -133.944977, 13.277077, 72.781090);		-- Beach
	AddCameraShot(0.134694, 0.005500, -0.990047, 0.040425, 106.765259, 31.005287, -192.390869);		-- Caves
	AddCameraShot(-0.454844, 0.063869, -0.879648, -0.123520, -161.709030, 47.911930, -241.780487);	-- Crag
	AddCameraShot(0.990507, -0.137447, -0.002231, -0.000310, -185.309265, 24.109367, -32.575871);	-- Dunes
	AddCameraShot(0.983676, -0.153915, -0.092113, -0.014413, -87.806061, 24.917538, -50.486591);	-- Gorge
	AddCameraShot(0.597136, 0.018231, -0.801560, 0.024472, -77.412819, 23.308689, -214.238998);		-- Ravine
	
	-- Perform various post-load operations
	manager:Proc_ScriptInit_End()
end