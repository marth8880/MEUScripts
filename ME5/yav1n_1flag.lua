ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ME5_Master")
ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ME5_ObjectiveOneFlagCTF")

-- Create a new MapManager object
manager = MapManager:New{
	-- Map-specific details
	gameMode = "1flag",
	mapSize = "lg",
	environmentType = "jungle",
	
	-- In-game music
	musicVariation_SSVxGTH = "1",
	musicVariation_SSVxCOL = "5",
	musicVariation_EVGxGTH = "9",
	musicVariation_EVGxCOL = "9",
	
	-- Online matches
	onlineSideVar = "SSVxCOL",
	onlineHeroSSV = "shep_soldier",
	onlineHeroGTH = "gethprime_me2",
	onlineHeroCOL = "colgeneral",
	onlineHeroEVG = "gethprime_me3",
	
	-- AI hero spawns. CP name, CP spawn path name
	heroSupportCPs = {},
	-- Local ally spawns. CP name, CP spawn path name
	allySpawnCPs = {},
}
-- Initialize the MapManager
manager:Init()

-- Randomize which team is ATT/DEF
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

---------------------------------------------------------------------------
-- FUNCTION:    ScriptInit
-- PURPOSE:     This function is only run once
-- INPUT:
-- OUTPUT:
-- NOTES:       The name, 'ScriptInit' is a chosen convention, and each
--              mission script must contain a version of this function, as
--              it is called from C to start the mission.
---------------------------------------------------------------------------

--PostLoad, this is all done after all loading, etc.
function ScriptPostLoad()

	SoundEvent_SetupTeams( CIS, 'cis', REP, 'rep' )
	
	
    DisableBarriers("StopTanks")
	KillObject ("TempleBlastDoor")

	    AddDeathRegion("death1")
	    AddDeathRegion("death2")
	    AddDeathRegion("death3")
	    AddDeathRegion("death4")
	    AddDeathRegion("death5")
	    AddDeathRegion("death6")
	    AddDeathRegion("death7")
	    AddDeathRegion("death8") 


    ctf = ObjectiveOneFlagCTF:New{teamATT = 1, teamDEF = 2,
                           textATT = "game.modes.1flag", textDEF = "game.modes.1flag2", 
                           captureLimit = 8, flag = "flag", flagIcon = "flag_icon", 
                           flagIconScale = 3.0, homeRegion = "HomeRegion",
                           captureRegionATT = "Team1Capture", captureRegionDEF = "Team2Capture",
                           capRegionMarkerATT = "hud_objective_icon_circle", capRegionMarkerDEF = "hud_objective_icon_circle",
                           capRegionMarkerScaleATT = 3.0, capRegionMarkerScaleDEF = 3.0, multiplayerRules = true,
                           capRegionDummyObjectATT = "Team1Capture", capRegionDummyObjectDEF = "Team2Capture",}

    ctf:Start()
	
    EnableSPHeroRules()
	
	manager:Proc_ScriptPostLoad_End()
	
end

function ScriptInit()
    StealArtistHeap(1350*1024)
    -- Designers, these two lines *MUST* be first!
    SetPS2ModelMemory(2400000)
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\load.lvl;yav1")
	
	SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2202)
	SetMemoryPoolSize("ParticleTransformer::PositionTr", 1298)
	SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1416)
	
	manager:Proc_ScriptInit_Begin()
	
    SetMaxFlyHeight(14)
    SetMaxPlayerFlyHeight(14)
	AISnipeSuitabilityDist(130)
	SetAttackerSnipeRange(150)
	SetDefenderSnipeRange(185)
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\me5tur.lvl", 
					"tur_bldg_laser",
					"tur_bldg_tower")
	
	manager:Proc_ScriptInit_SideSetup()
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_YAV_Streaming.lvl;yav1n")
	
	
    --  Level Stats
    --  ClearWalkers()
    AddWalkerType(0, 0) -- special -> droidekas
    AddWalkerType(1, 0) -- 1x2 (1 pair of legs)
    AddWalkerType(2, 0) -- 2x2 (2 pairs of legs)
    AddWalkerType(3, 0) -- 3x2 (3 pairs of legs)
    local weaponCnt = 230
    SetMemoryPoolSize("Aimer", 24)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 1000)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntityLight", 40)
    SetMemoryPoolSize("EntitySoundStream", 4)
    SetMemoryPoolSize("EntitySoundStatic", 20)
    SetMemoryPoolSize("Navigator", 47)
    SetMemoryPoolSize("Obstacle", 750)
    SetMemoryPoolSize("PathFollower", 47)
    SetMemoryPoolSize("PathNode", 256)
    SetMemoryPoolSize("SoundSpaceRegion", 48)
    SetMemoryPoolSize("TentacleSimulator", 0)
    SetMemoryPoolSize("TreeGridStack", 500)
    SetMemoryPoolSize("UnitAgent", 47)
    SetMemoryPoolSize("UnitController", 47)
    SetMemoryPoolSize("Weapon", weaponCnt)
	SetMemoryPoolSize("EntityFlyer", 6)   
    SetMemoryPoolSize("EntityHover",2)
	manager:Proc_ScriptInit_MemoryPoolInit()

    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\yav1.lvl","Yavin1_CTF_CenterFlag")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\minimap.lvl;yav1")
    SetDenseEnvironment("false")

    --  Birdies
    SetNumBirdTypes(2)
    SetBirdType(0,1.0,"bird")
    SetBirdType(1,1.5,"bird2")

    --  Fishies
    SetNumFishTypes(1)
    SetFishType(0,0.8,"fish")

    --  Sound
	
	manager:Proc_ScriptInit_MusicSetup()
	
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_YAV_Streaming.lvl",	"yav1")
	
	SoundFX()
	
    SetAttackingTeam(ATT)
    --Yav 1 - Temple
    --Fountain
	AddCameraShot(0.660400, -0.059877, -0.745465, -0.067590, 143.734436, -55.725388, 7.761997);
	AddCameraShot(0.830733, -0.144385, 0.529679, 0.092061, 111.796799, -42.959831, 75.199142);
	AddCameraShot(0.475676, -0.064657, -0.869247, -0.118154, 13.451733, -47.769894, 13.242496);
	AddCameraShot(-0.168833, 0.020623, -0.978158, -0.119483, 58.080200, -50.858742, -62.208008);
	AddCameraShot(0.880961, -0.440820, -0.153824, -0.076971, 101.777763, -46.775646, -29.683767);
	AddCameraShot(0.893823, -0.183838, 0.400618, 0.082398, 130.714828, -60.244068, -27.587791);
	AddCameraShot(0.999534, 0.004060, 0.030244, -0.000123, 222.209137, -61.220325, -18.061192);
	AddCameraShot(0.912637, -0.057866, 0.403844, 0.025606, 236.693344, -49.829277, -116.150986);
	AddCameraShot(0.430732, -0.016398, -0.901678, -0.034328, 180.692062, -54.148796, -159.856644);
	AddCameraShot(0.832119, -0.063785, 0.549306, 0.042107, 160.699402, -54.148796, -130.990692);
	AddCameraShot(0.404200, -0.037992, -0.909871, -0.085520, 68.815331, -54.148796, -160.837585);
	AddCameraShot(-0.438845, 0.053442, -0.890394, -0.108431, 116.562241, -52.504406, -197.686005);
	AddCameraShot(0.389349, -0.113400, -0.877617, -0.255609, 29.177610, -23.974962, -288.061676);
	AddCameraShot(0.499938, -0.081056, -0.851146, -0.137998, 90.326912, -28.060659, -283.329376);
	AddCameraShot(-0.217006, 0.015116, -0.973694, -0.067827, 202.056778, -37.476913, -181.445663);
	AddCameraShot(0.990640, -0.082509, 0.108367, 0.009026, 206.266953, -37.476913, -225.158249);
	AddCameraShot(-0.386589, 0.126400, -0.868314, -0.283907, 224.942032, -17.820135, -269.532227);
	AddCameraShot(0.967493, 0.054298, 0.246611, -0.013840, 155.984451, -30.781782, -324.836975);
	AddCameraShot(-0.453147, 0.140485, -0.840816, -0.260672, 164.648956, -0.002431, -378.487061);
	AddCameraShot(0.592731, -0.182571, -0.749678, -0.230913, 99.326836, -13.029744, -414.846191);
	AddCameraShot(0.865750, -0.184352, 0.455084, 0.096905, 137.221359, -19.694859, -436.057556);
	AddCameraShot(0.026915, -0.002609, -0.994969, -0.096461, 128.397949, -30.249140, -428.447418);
	
	manager:Proc_ScriptInit_End()

end

