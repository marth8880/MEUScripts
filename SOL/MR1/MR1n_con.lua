ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
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
	mapSize = "xs",						-- Size of the map. Used for determining unit counts.
	environmentType = "jungle",			-- Map's biome (essentially). Used for determining which camo textures to load. ("desert", "jungle", "snow", or "urban")
	
	-- In-game music (you can also specify a table of values and one of them will be randomly selected at runtime, example: `musicVariation_SSVxGTH = {"1","3"}` )
	musicVariation_SSVxGTH = "1",		-- Music variation to use for SSVxGTH matches.
	musicVariation_SSVxCOL = "5",		-- Music variation to use for SSVxCOL matches.
	musicVariation_EVGxGTH = "9",		-- Music variation to use for EVGxGTH matches.
	musicVariation_EVGxCOL = "9",		-- Music variation to use for EVGxCOL matches.
	
	-- Online matches
	onlineSideVar = "SSVxCOL",			-- Faction combination to use in online matches.
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
	
	BlockPlanningGraphArcs(1)
	
    -- This defines the CPs.  These need to happen first
    cp1 = CommandPost:New{name = "cp1"}
    cp2 = CommandPost:New{name = "cp2"}
    cp3 = CommandPost:New{name = "cp3"}
    cp4 = CommandPost:New{name = "cp4"}
    cp5 = CommandPost:New{name = "cp5"}
    cp6 = CommandPost:New{name = "cp6"}
    
    
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
    ReadDataFile("dc:Load\\mr1_load_me5.lvl")
	
	SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2172)
	SetMemoryPoolSize("ParticleTransformer::PositionTr", 1272)
	SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1433)
	--SetMemoryPoolSize("Music", 68)
	
	-- Perform various pre-game operations
	manager:Proc_ScriptInit_Begin()

	AISnipeSuitabilityDist(60)
	SetAttackerSnipeRange(60)
	SetDefenderSnipeRange(110)
	
	SetMaxFlyHeight(50)
	SetMaxPlayerFlyHeight(50)
	
	-- Load and set up the sides
	manager:Proc_ScriptInit_SideSetup()
	
	ReadDataFile("dc:sound\\MR1.lvl;MR1n")
    ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\sound\\sol.lvl;sol_mr1n")
   

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
	SetMemoryPoolSize("EntityCloth", 32)
	SetMemoryPoolSize("EntityFlyer", 32)
    SetMemoryPoolSize("EntityHover", 32)
    SetMemoryPoolSize("EntityLight", 200)
    SetMemoryPoolSize("EntitySoundStream", 64)
    SetMemoryPoolSize("EntitySoundStatic", 64)
    SetMemoryPoolSize("MountedTurret", 32)
	SetMemoryPoolSize("Navigator", 128)
    SetMemoryPoolSize("Obstacle", 1024)
	SetMemoryPoolSize("PathNode", 1024)
	SetMemoryPoolSize("SoldierAnimation", 465)
    SetMemoryPoolSize("SoundSpaceRegion", 64)
    SetMemoryPoolSize("TreeGridStack", 1024)
	SetMemoryPoolSize("UnitAgent", 128)
	SetMemoryPoolSize("UnitController", 128)
	SetMemoryPoolSize("Weapon", weaponCnt)
	manager:Proc_ScriptInit_MemoryPoolInit()
    
    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("dc:SOL\\MR1.lvl", "MR1_conquest")
    SetDenseEnvironment("false")
	
	ReadDataFile("dc:minimap.lvl;mr1")
	
	
	--  Sound Stats
	
	-- Set up music
	if ME5_SolMapMusic == 0 then
		OpenAudioStream("dc:sound\\sol.lvl", "soln_music")
		OpenMusicStreams(1)
	
		SetAmbientMusic(REP, 1.0, "mr1_amb_earworm_n",  0,1)
		SetAmbientMusic(CIS, 1.0, "mr1_amb_earworm_n",  0,1)
		
		SetVictoryMusic(REP, "ssv_amb_01_victory")
		SetDefeatMusic (REP, "ssv_amb_01_defeat")
		SetVictoryMusic(CIS, "ssv_amb_01_victory")
		SetDefeatMusic (CIS, "ssv_amb_01_defeat")
		
	elseif ME5_SolMapMusic == 1 then
		manager:Proc_ScriptInit_MusicSetup()
	end
	
	OpenAudioStream("dc:sound\\mr1.lvl",  "mr1_ambiance")
	OpenAudioStream("dc:sound\\mr1.lvl",  "mr1_ambiance")
	
	-- Set up common sound stuff
	SoundFX()
	
	
	-- Camera Stats
	AddCameraShot(0.860834, -0.066550, -0.503015, -0.038887, -156.444336, 26.008068, 375.989807);
	AddCameraShot(0.415989, -0.029820, -0.906554, -0.064987, -121.549095, 26.008068, 223.142822);
	AddCameraShot(-0.327677, 0.024227, -0.941908, -0.069639, 57.638302, 32.931034, 172.352127);
	AddCameraShot(0.771404, -0.020699, -0.635780, -0.017060, -86.801491, 13.656008, 306.767334);
	AddCameraShot(0.789378, -0.064580, 0.608469, 0.049779, 18.768763, 13.656008, 316.177277);
	
	-- Perform various post-load operations
	manager:Proc_ScriptInit_End()
end
