ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\core.lvl")		-- TODO: this probably shouldn't be here tbh
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
	bIsModMap = true,
	gameMode = "conquest",
	mapSize = "lg",
	environmentType = "snow",
	
	-- In-game music
	musicVariation_SSVxGTH = "3_nov",
	musicVariation_SSVxCOL = "5",
	musicVariation_EVGxGTH = "9",
	musicVariation_EVGxCOL = "9",
	musicVariation_SSVxRPR = "8",
	
	-- Online matches
	onlineSideVar = "SSVxGTH",
	onlineHeroSSV = "shep_infiltrator",
	onlineHeroGTH = "gethprime_me2",
	onlineHeroCOL = "colgeneral",
	onlineHeroEVG = "gethprime_me3",
	
	-- AI hero spawns. CP name, CP spawn path name
	heroSupportCPs = {
				{"cp1", "cp1_spawn"},
				{"cp2", "cp2_spawn"},
				{"cp3", "cp3_spawn"},
				{"cp4", "cp4_spawn"},
				{"cp5", "cp5_spawn"},
				{"cp6", "cp6_spawn"},
				{"cp7", "cp7_spawn"},
				{"cp8", "cp8_spawn"},
	},
	-- Local ally spawns. CP name, CP spawn path name
	allySpawnCPs = {
				{"cp1", "cp1_spawn"},
				{"cp2", "cp2_spawn"},
				{"cp3", "cp3_spawn"},
				{"cp4", "cp4_spawn"},
				{"cp5", "cp5_spawn"},
				{"cp6", "cp6_spawn"},
				{"cp7", "cp7_spawn"},
				{"cp8", "cp8_spawn"},
	},
	
	-- Artillery strike path nodes. Path name, path node ID
	artilleryNodes = {
				{"cp1_spawn", 0},
				{"cp2_spawn", 0},
				{"cp3_spawn", 0},
				{"cp4_spawn", 0},
				{"cp5_spawn", 0},
				{"cp6_spawn", 0},
				{"cp7_spawn", 0},
				{"cp8_spawn", 0},
	},
	terrainType = "snow",
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

function ScriptPostLoad()
	
    --This defines the CPs.  These need to happen first 
    cp1 = CommandPost:New{name = "cp1"} 
    cp2 = CommandPost:New{name = "cp2"} 
    cp3 = CommandPost:New{name = "cp3"} 
    cp4 = CommandPost:New{name = "cp4"} 
    cp5 = CommandPost:New{name = "cp5"} 
    cp6 = CommandPost:New{name = "cp6"} 
    cp7 = CommandPost:New{name = "cp7"} 
    cp8 = CommandPost:New{name = "cp8"} 
	
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
    conquest:AddCommandPost(cp7)
    conquest:AddCommandPost(cp8)
	
    conquest:Start()
	
    EnableSPHeroRules()

	SetProperty("cp1", "HUDIndex", 7)	-- 7
	SetProperty("cp2", "HUDIndex", 1)	-- 1
	SetProperty("cp3", "HUDIndex", 5)	-- 4
	SetProperty("cp4", "HUDIndex", 3)	-- 6
	SetProperty("cp5", "HUDIndex", 6)	-- 5
	SetProperty("cp6", "HUDIndex", 2)	-- 2
	SetProperty("cp7", "HUDIndex", 8)	-- 8
	SetProperty("cp8", "HUDIndex", 4)	-- 3
	
	manager:Proc_ScriptPostLoad_End()
	
	AddDeathRegion("deathregion")
	
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

   --tell the game to load our loading image 
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\lzx.lvl")
	
	SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2399)
	SetMemoryPoolSize("ParticleTransformer::PositionTr", 1403)
	SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1547)
	
	manager:Proc_ScriptInit_Begin()
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\PFX_SSV_Veh.lvl;vehcommon")
	
    SetMaxFlyHeight(96)
    SetMaxPlayerFlyHeight(96)
	AISnipeSuitabilityDist(165)
	SetAttackerSnipeRange(130)
	SetDefenderSnipeRange(200)
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\me5tur.lvl",
					"tur_bldg_mturret",
					"tur_bldg_laser",
					"tur_bldg_hoth_dishturret")
	
	manager:Proc_ScriptInit_SideSetup()
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_LZX_Streaming.lvl")

    --  Level Stats 
    ClearWalkers()
    local weaponCnt = 1024 
	SetMemoryPoolSize("Aimer", 75) 
	SetMemoryPoolSize("AmmoCounter", weaponCnt) 
	SetMemoryPoolSize("BaseHint", 1024) 
	SetMemoryPoolSize("EnergyBar", weaponCnt) 
	SetMemoryPoolSize("EntityCloth", 0) 
	SetMemoryPoolSize("EntityFlyer", 0) 
	SetMemoryPoolSize("EntityHover", 32) 
	SetMemoryPoolSize("EntityLight", 200) 
    SetMemoryPoolSize("EntitySoundStatic", 43)
	SetMemoryPoolSize("Music", 99)
	SetMemoryPoolSize("Navigator", 128) 
	SetMemoryPoolSize("Obstacle", 1024) 
	SetMemoryPoolSize("RedOmniLight", 239) 
	SetMemoryPoolSize("PathNode", 1024) 
	SetMemoryPoolSize("SoldierAnimation", 382)
	SetMemoryPoolSize("SoundSpaceRegion", 64) 
	SetMemoryPoolSize("TreeGridStack", 1024) 
	SetMemoryPoolSize("UnitAgent", 128) 
	SetMemoryPoolSize("UnitController", 128) 
	SetMemoryPoolSize("Weapon", weaponCnt)
	manager:Proc_ScriptInit_MemoryPoolInit()
	
	SetSpawnDelay(10.0, 0.25)
	ReadDataFile("..\\..\\addon\\LZX\\data\\_LVL_PC\\LZX\\LZX.lvl", "LZX_conquest")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\LZX_AMB.lvl")	-- loads the soundstream region and the minimap
	SetDenseEnvironment("false")
	
	
	--  Sound Stats
	
	manager:Proc_ScriptInit_MusicSetup()
	
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_LZX_Streaming.lvl",  "LZX_ambiance")
	
	SoundFX()

	-- Camera Stats 
	AddCameraShot(-0.276930, -0.006705, -0.960585, 0.023256, 91.842682, 14.668467, 84.243149);
	AddCameraShot(0.811569, -0.051904, 0.580760, 0.037143, 130.966812, 14.082601, 34.935509);
	AddCameraShot(0.284131, -0.009807, -0.958165, -0.033073, -39.626015, 14.090186, 117.456718);
	AddCameraShot(0.661070, -0.102405, -0.734542, -0.113787, 96.750153, 23.179926, 146.376358);
	AddCameraShot(0.977186, -0.004879, -0.212328, -0.001060, -81.759819, 5.994357, 69.543793);
	
	manager:Proc_ScriptInit_End()
end 
