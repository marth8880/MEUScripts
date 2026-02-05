ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ME5_Master")
ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ME5_ObjectiveConquest")

-- Create a new MapManager object
manager = MapManager:New{
	-- Map-specific details
	gameMode = "conquest",
	mapSize = "lg",
	environmentType = "jungle",
	
	-- In-game music
	musicVariation_SSVxGTH = "1",
	musicVariation_SSVxCOL = "5",
	musicVariation_EVGxGTH = "9",
	musicVariation_EVGxCOL = "9",
	musicVariation_SSVxRPR = {"5_mahavid", "8"},
    musicVariation_SSVxCER = {"7_1", "7_2"},
	
	-- Online matches
	onlineSideVar = "SSVxCOL",
	onlineHeroSSV = "shep_infiltrator",
	onlineHeroGTH = "gethprime_me2",
	onlineHeroCOL = "colgeneral",
	onlineHeroEVG = "gethprime_me3",
	
	-- AI hero spawns. CP name, CP spawn path name
	heroSupportCPs = {
				{"cp1-1", "cp1spawn"},
				{"cp2-1", "cp2spawn"},
				{"cp3-1", "cp3spawn"},
				{"cp4-1", "cp4spawn"},
				{"cp5-1", "cp5spawn"},
				{"cp6-1", "cp6-1_spawn"},
	},
	-- Local ally spawns. CP name, CP spawn path name
	allySpawnCPs = {
				{"cp1-1", "cp1spawn"},
				{"cp2-1", "cp2spawn"},
				{"cp3-1", "cp3spawn"},
				{"cp4-1", "cp4spawn"},
				{"cp5-1", "cp5spawn"},
				{"cp6-1", "cp6-1_spawn"},
	},
	
	-- Artillery strike path nodes. Path name, path node ID
	artilleryNodes = {
				{"cp1spawn", 0},
				{"cp2spawn", 0},
				{"cp3spawn", 0},
				{"cp4spawn", 0},
				{"cp5spawn", 0},
				{"cp6-1_spawn", 0},
	},
	terrainType = "dirt",
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

HuskTeam = 3

ATT = 1
DEF = 2

---------------------------------------------------------------------------
-- FUNCTION:    ScriptInit
-- PURPOSE:     This function is only run once
-- INPUT:
-- OUTPUT:
-- NOTES:       The name, 'ScriptInit' is a chosen convention, and each
--              mission script must contain a version of this function, as
--              it is called from C to start the mission.
---------------------------------------------------------------------------

function ScriptPostLoad()
        --This defines the CPs.  These need to happen first
    cp1 = CommandPost:New{name = "cp1-1"}
    cp2 = CommandPost:New{name = "cp2-1"}
    cp3 = CommandPost:New{name = "cp3-1"}
    cp4 = CommandPost:New{name = "cp4-1"}
    cp5 = CommandPost:New{name = "cp5-1"}
    cp6 = CommandPost:New{name = "cp6-1"}

    
    --This sets up the actual objective.  This needs to happen after cp's are defined
    conquest = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, textATT = "game.modes.con", textDEF = "game.modes.con2", multiplayerRules = true}
    
    --This adds the CPs to the objective.  This needs to happen after the objective is set up
    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp2)
    conquest:AddCommandPost(cp3)
    conquest:AddCommandPost(cp4)
    conquest:AddCommandPost(cp5)
    conquest:AddCommandPost(cp6)

	conquest:Start()   
    EnableSPHeroRules()
    
	manager:Proc_ScriptPostLoad_End()
    
end

function ScriptInit()
	StealArtistHeap(132*1024)
    -- Designers, these two lines *MUST* be first.
    SetPS2ModelMemory(3200000)
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\load.lvl;fel1")
	
	SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2213)
	SetMemoryPoolSize("ParticleTransformer::PositionTr", 1318)
	SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1468)
	
	manager:Proc_ScriptInit_Begin()
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\PFX_SSV_Veh.lvl;vehcommon")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\PFX_SSV_Veh.lvl;vehnormal")

    SetMemoryPoolSize("Music", 99)


    SetMaxFlyHeight(53)
    SetMaxPlayerFlyHeight(53)
	AISnipeSuitabilityDist(55)
	SetAttackerSnipeRange(70)
	SetDefenderSnipeRange(100)
    
    SetAttackingTeam(ATT)
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\me5tur.lvl",
					"tur_bldg_mturret")
	
	manager:Proc_ScriptInit_SideSetup()
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_FEL_Streaming.lvl;fel1n")


    --  Level Stats 
    ClearWalkers()
    -- AddWalkerType(0, 8)
    --AddWalkerType(5, 2) -- 2 attes with 2 leg pairs each
    --AddWalkerType(3, 1) -- 3 acklays with 3 leg pairs each
    -- AddWalkerType(1, 2)
    -- AddWalkerType(0, 4)
    local weaponCnt = 260
    SetMemoryPoolSize("Aimer", 20)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 200)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntityHover", 3)
    SetMemoryPoolSize("EntityFlyer", 6)
    SetMemoryPoolSize("EntitySoundStream", 4)
    SetMemoryPoolSize("EntitySoundStatic", 0)
    SetMemoryPoolSize("EntityWalker", 5)		-- TODO: probably remove this tbh
    SetMemoryPoolSize("Obstacle", 400)
    SetMemoryPoolSize("PathNode", 512)
	SetMemoryPoolSize("SoldierAnimation", 371)
    SetMemoryPoolSize("TreeGridStack", 280)
    SetMemoryPoolSize("Weapon", weaponCnt)
	manager:Proc_ScriptInit_MemoryPoolInit()
    
    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\fel1.lvl", "fel1_conquest")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\minimap.lvl;fel1")
    SetDenseEnvironment("false")
    SetAIViewMultiplier(0.65)
    --AddDeathRegion("Sarlac01")

    --  Birdies
    SetNumBirdTypes(1)
    SetBirdType(0,1.0,"bird")
    

    --  Sound Stats
	
	manager:Proc_ScriptInit_MusicSetup()
	
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_FEL_Streaming.lvl",  "fel1")
	
	SoundFX()
	
	
    --  Camera Stats
    AddCameraShot(0.896307, -0.171348, -0.401716, -0.076796, -116.306931, 31.039505, 20.757469)
    AddCameraShot(0.909343, -0.201967, -0.355083, -0.078865, -116.306931, 31.039505, 20.757469)
    AddCameraShot(0.543199, 0.115521, -0.813428, 0.172990, -108.378189, 13.564240, -40.644150)
    AddCameraShot(0.970610, 0.135659, 0.196866, -0.027515, -3.214346, 11.924586, -44.687294)
    AddCameraShot(0.346130, 0.046311, -0.928766, 0.124267, 87.431061, 20.881388, 13.070729)
    AddCameraShot(0.468084, 0.095611, -0.860724, 0.175812, 18.063482, 19.360580, 18.178158)
	
	manager:Proc_ScriptInit_End()
end
