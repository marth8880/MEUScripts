ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--
ScriptCB_DoFile("ME5_Master")
ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ME5_ObjectiveBFConquest")

-- Create a new MapManager object
manager = MapManager:New{
	-- Map-specific details
	gameMode = "siege",
	mapSize = "lg",
	environmentType = "desert",
	
	-- In-game music
	musicVariation_SSVxGTH = "1",
	musicVariation_SSVxCOL = "5",
	musicVariation_EVGxGTH = "9",
	musicVariation_EVGxCOL = "9",
	
	-- Online matches
	onlineSideVar = "SSVxCOL",
	onlineHeroSSV = "shep_adept",
	onlineHeroGTH = "gethprime_me2",
	onlineHeroCOL = "colgeneral",
	onlineHeroEVG = "gethprime_me3",
	
	-- AI hero spawns. CP name, CP spawn path name
	heroSupportCPs = {
				{"team1_permacp", "CP1_SpawnPath"},
				{"team2_permacp", "CP6_SpawnPath"},
				{"cp2", "CP2_SpawnPath"},
				{"cp3", "CP3_SpawnPath"},
				{"cp7", "CP7SpawnPath"},
				{"cp8", "CP8SpawnPath"},
				{"cp10", "cp10_spawn"},
	},
	-- Local ally spawns. CP name, CP spawn path name
	allySpawnCPs = {
				{"team1_permacp", "CP1_SpawnPath"},
				{"team2_permacp", "CP6_SpawnPath"},
				{"cp2", "CP2_SpawnPath"},
				{"cp3", "CP3_SpawnPath"},
				{"cp7", "CP7SpawnPath"},
				{"cp8", "CP8SpawnPath"},
				{"cp10", "cp10_spawn"},
	},
	
	-- Artillery strike path nodes. Path name, path node ID
	artilleryNodes = {
				{"CP1_SpawnPath", 0},
				{"CP2_SpawnPath", 0},
				--{"CP3_SpawnPath", 0},
				{"CP6_SpawnPath", 0},
				{"CP9SpawnPath", 0},
				{"CP8SpawnPath", 0},	-- TODO: look into adding node for cp10
	},
	terrainType = "sand",
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
	SetObjectTeam("CP2", 0)
	SetObjectTeam("CP3", 0)
	SetObjectTeam("CP7", 0)
	SetObjectTeam("CP8", 0)
	SetObjectTeam("CP10", 0)
	KillObject("CP1")	-- team 1
	KillObject("CP6")	-- team 2
	
	SetProperty("CP2", "CaptureRegion", "CP2_Capture_siege")
	SetProperty("CP7", "CaptureRegion", "CP9Capture_siege")
	
	EnableBarriers("CP10_crates1")
	EnableBarriers("CP10_crates2")
	EnableBarriers("CP10_crates3")
	EnableBarriers("CP10_crates4")
	EnableBarriers("CP10_evaporator")
	DisableBarriers("CP10_tubes")
	
        --This defines the CPs.  These need to happen first
    --cp1 = CommandPost:New{name = "cp1"}
    cp2 = CommandPost:New{name = "cp2"}
    cp3 = CommandPost:New{name = "cp3"}

	--cp6 = CommandPost:New{name = "cp6"}
	cp7 = CommandPost:New{name = "cp7"}
	cp8 = CommandPost:New{name = "cp8"}
	cp10 = CommandPost:New{name = "cp10"}

    
    --This sets up the actual objective.  This needs to happen after cp's are defined
    conquest = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, textATT = "game.modes.siege", textDEF = "game.modes.siege2", multiplayerRules = true}
    
    --This adds the CPs to the objective.  This needs to happen after the objective is set up
	--conquest:AddCommandPost(cp1)
	conquest:AddCommandPost(cp2)
	conquest:AddCommandPost(cp3)

	--conquest:AddCommandPost(cp6)
	conquest:AddCommandPost(cp7)
	conquest:AddCommandPost(cp8)
	conquest:AddCommandPost(cp10)
	
	conquest:Start()
	
	EnableSPHeroRules()
	
	manager:Proc_ScriptPostLoad_End()
	
	KillObject("jawa_cp")
	
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
    -- Designers, these two lines *MUST* be first!
    StealArtistHeap(256*1024)
    SetPS2ModelMemory(2097152 + 65536 * 10)
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\load.lvl;tat2")
	
	SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2541)
	SetMemoryPoolSize("ParticleTransformer::PositionTr", 1494)
	SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1645)
	
	manager:Proc_ScriptInit_Begin()
	
    SetMaxFlyHeight(40)
	SetMaxPlayerFlyHeight(40)
	AISnipeSuitabilityDist(80)
	SetAttackerSnipeRange(100)
	SetDefenderSnipeRange(140)
	
	SetAIVehicleNotifyRadius(7)
    
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\me5tur.lvl",
					"tur_bldg_laser",
					"tur_bldg_mturret",
					"tur_bldg_tat_barge")
	
	manager:Proc_ScriptInit_SideSetup()
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_TAT2_Streaming.lvl")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_TAT_Streaming.lvl;tat2n")

    --  Level Stats
    ClearWalkers()
    AddWalkerType(0, 0) -- special -> droidekas
    AddWalkerType(1, 0) -- 1x2 (1 pair of legs)
    AddWalkerType(2, 0) -- 2x2 (2 pairs of legs)
    AddWalkerType(3, 0) -- 3x2 (3 pairs of legs)
    
    local weaponCnt = 230
    SetMemoryPoolSize("Aimer", 32)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 379)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntityCloth", 19)
	SetMemoryPoolSize("EntityFlyer", 6) -- to account for rocket upgrade
    SetMemoryPoolSize("EntityHover", 1)
    SetMemoryPoolSize("EntitySoundStream", 12)
    SetMemoryPoolSize("EntitySoundStatic", 43)
	SetMemoryPoolSize("FlagItem", 512)
    SetMemoryPoolSize("MountedTurret", 20)
    SetMemoryPoolSize("Navigator", 50)
    SetMemoryPoolSize("Obstacle", 788)
    SetMemoryPoolSize("PathFollower", 50)
    SetMemoryPoolSize("PathNode", 256)
	SetMemoryPoolSize("SoldierAnimation", 382)
    SetMemoryPoolSize("TreeGridStack", 325)
    SetMemoryPoolSize("UnitAgent", 50)
    SetMemoryPoolSize("UnitController", 50)
    SetMemoryPoolSize("Weapon", weaponCnt)

    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\tat2.lvl", "tat2_siege")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\minimap.lvl;tat2")
    SetDenseEnvironment("false")


    --  Sound Stats
    
    OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\Sound\\SFL_TAT2_Streaming.lvl",  "TAT_ambiance")	-- TODO: merge this with SFL_s_TAT_Streaming.lvl!

	manager:Proc_ScriptInit_MusicSetup()
	
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_TAT_Streaming.lvl",  "tat2")
	
	SoundFX()


    SetAttackingTeam(ATT)

    --  Camera Stats
    --Tat2 Mos Eisley
	AddCameraShot(0.974338, -0.222180, 0.035172, 0.008020, -82.664650, 23.668301, 43.955681);
	AddCameraShot(0.390197, -0.089729, -0.893040, -0.205362, 23.563562, 12.914885, -101.465561);
	AddCameraShot(0.169759, 0.002225, -0.985398, 0.012916, 126.972809, 4.039628, -22.020613);
	AddCameraShot(0.677453, -0.041535, 0.733016, 0.044942, 97.517807, 4.039628, 36.853477);
	AddCameraShot(0.866029, -0.156506, 0.467299, 0.084449, 7.685640, 7.130688, -10.895234);
	
	manager:Proc_ScriptInit_End()
end


