ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\master.lvl")

isModMap = 1
isLowG = 1

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
	gameMode = "conquest",
	mapSize = "med",
	environmentType = "urban",
	factionIds = {REP = 1, CIS = 2, LocalTeam1 = 4, LocalTeam2 = 5},
	
	-- In-game music
	musicVariation_SSVxGTH = {"4","6"},
	musicVariation_SSVxCOL = "2",
	musicVariation_EVGxGTH = "9",
	musicVariation_EVGxCOL = "9",
	musicVariation_SSVxRPR = "8",
	musicVariation_SSVxCER = {"7_2", "7_3"},
	
	-- Online matches
	onlineSideVar = "SSVxRPR",
	onlineHeroSSV = "shep_engineer",
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
	},
	-- Local ally spawns. CP name, CP spawn path name
	allySpawnCPs = {
				{"cp1", "cp1_spawn"},
				{"cp2", "cp2_spawn"},
				{"cp3", "cp3_spawn"},
				{"cp4", "cp4_spawn"},
				{"cp5", "cp5_spawn"},
	},
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
    
    
    --This sets up the actual objective.  This needs to happen after cp's are defined
    conquest = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, 
                                     textATT = "game.modes.con", 
                                     textDEF = "game.modes.con2",
									 multiplayerRules = true,
	}
    
    --This adds the CPs to the objective.  This needs to happen after the objective is set up
    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp2)
    conquest:AddCommandPost(cp3)
    conquest:AddCommandPost(cp4)
    conquest:AddCommandPost(cp5)
    
    conquest:Start()

    EnableSPHeroRules()

    AddDeathRegion("deathregion1")
    AddDeathRegion("deathregion2")

	SetClassProperty("sol_inf_astronaut", "HurtSound", "rep_inf_com_chatter_wound")
	SetClassProperty("sol_inf_astronaut", "DeathSound", "rep_inf_com_chatter_death")
	SetClassProperty("sol_inf_astronaut", "DamageRegionSound", "repmalechoke")
	SetClassProperty("sol_inf_astronaut", "FoleyFXClass", "rep_inf_trooper")
	
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

    ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\Load\\tgb_load.lvl")
	
	-- Perform various pre-game operations
	manager:Proc_ScriptInit_Begin()

    SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2172)
    SetMemoryPoolSize("ParticleTransformer::PositionTr", 1272)
    SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1433)
    
   
    SetMaxFlyHeight(42)
	SetMaxPlayerFlyHeight(42)

	AISnipeSuitabilityDist(110)
	SetAttackerSnipeRange(100)
	SetDefenderSnipeRange(120)

    ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\sound\\tgb.lvl")
    ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\sound\\sol.lvl;sol_tgbn")
    
    SetMemoryPoolSize("Music", 99)

	ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\SIDE\\sol.lvl",
					"sol_inf_astronaut")
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\me5tur.lvl", 
					"tur_bldg_laser")
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\CON_LOWG.lvl")
	
	manager:Proc_ScriptInit_SideSetup()

	SetTeamName(3, "nasa")
	AddUnitClass(3, "sol_inf_astronaut", 7)
	SetUnitCount(3, 7)
	AddAIGoal(3, "Deathmatch", 100)
	
	SetTeamAsNeutral(ATT,3)
	SetTeamAsNeutral(3,ATT)
	SetTeamAsNeutral(DEF,3)
	SetTeamAsNeutral(3,DEF)
	SetTeamAsNeutral(manager.factionIds.LocalTeam1,3)
	SetTeamAsNeutral(manager.factionIds.LocalTeam2,3)
	SetTeamAsNeutral(3,manager.factionIds.LocalTeam1)
	SetTeamAsNeutral(3,manager.factionIds.LocalTeam2)
   
    --  Level Stats
	ClearWalkers()
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
    SetMemoryPoolSize("EntitySoundStream", 4)
    SetMemoryPoolSize("EntitySoundStatic", 32)
    SetMemoryPoolSize("MountedTurret", 32)
	SetMemoryPoolSize("Navigator", 128)
    SetMemoryPoolSize("Obstacle", 1024)
	SetMemoryPoolSize("PathNode", 1024)
    SetMemoryPoolSize("SoldierAnimation", 380)
    SetMemoryPoolSize("SoundSpaceRegion", 64)
    SetMemoryPoolSize("TreeGridStack", 1024)
	SetMemoryPoolSize("UnitAgent", 128)
	SetMemoryPoolSize("UnitController", 128)
	SetMemoryPoolSize("Weapon", weaponCnt)
	manager:Proc_ScriptInit_MemoryPoolInit()
    
    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\SOL\\TGB.lvl", "TGB_conquest")
    SetDenseEnvironment("false")




    --  Sound

	OpenAudioStream("..\\..\\addon\\SOL\\data\\_LVL_PC\\sound\\sol.lvl", "SOLgcw_music")
	OpenAudioStream("..\\..\\addon\\SOL\\data\\_LVL_PC\\sound\\sol.lvl", "sol_unit_vo_quick")
    OpenAudioStream("..\\..\\addon\\SOL\\data\\_LVL_PC\\sound\\tgb.lvl", "tgb")
    OpenAudioStream("..\\..\\addon\\SOL\\data\\_LVL_PC\\sound\\tgb.lvl", "tgb")
	OpenMusicStreams(1)
	
	SetAmbientMusic(REP, 1.0, "tgb_amb_earworm",  0,1)
	SetAmbientMusic(CIS, 1.0, "tgb_amb_earworm",  0,1)

	SetVictoryMusic(REP, "ssv_amb_01_victory")
	SetDefeatMusic (REP, "ssv_amb_01_defeat")
	SetVictoryMusic(CIS, "ssv_amb_01_victory")
	SetDefeatMusic (CIS, "ssv_amb_01_defeat")
	
	SoundFX()


--OpeningSateliteShot
	AddCameraShot(0.911245, 0.103724, -0.396033, 0.045079, -139.156097, 44.590298, 95.045326);
	AddCameraShot(0.397890, -0.074331, -0.898867, -0.167919, -184.298828, 50.598278, -56.799370);
	AddCameraShot(0.980279, 0.001899, 0.197610, -0.000383, 75.187302, 28.276314, 50.238789);
	AddCameraShot(0.812262, -0.003453, -0.583277, -0.002480, -173.689316, -9.784508, 153.920395);
	AddCameraShot(0.961733, -0.035697, 0.271467, 0.010076, -29.975756, 13.920562, 74.836327);
	AddCameraShot(0.878379, -0.061963, -0.472757, -0.033350, -98.627937, 15.251744, -93.360664);
	AddCameraShot(0.136804, 0.016430, -0.983395, 0.118106, -13.016040, 8.400755, -102.804359);
	
	-- Perform various post-load operations
	manager:Proc_ScriptInit_End()
end

