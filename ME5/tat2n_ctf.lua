ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ScriptCB_DoFile("ME5_Master")
ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ME5_ObjectiveCTF")

-- Create a new MapManager object
manager = MapManager:New{
	-- Map-specific details
	gameMode = "1flag",
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

--PostLoad, this is all done after all loading, etc.
function ScriptPostLoad()
	--Switch the flag appearance(s) for CW vs GCW
    SetProperty("ctf_flag1", "GeometryName", "com_icon_cis_flag")
    SetProperty("ctf_flag1", "CarriedGeometryName", "com_icon_cis_flag_carried")

    SetProperty("ctf_flag2", "GeometryName", "com_icon_republic_flag")
    SetProperty("ctf_flag2", "CarriedGeometryName", "com_icon_republic_flag_carried")
	
	--Set up all the CTF objective stuff 
	ctf = ObjectiveCTF:New{teamATT = ATT, teamDEF = DEF, captureLimit = 5,	textATT = "game.modes.ctf", textDEF = "game.modes.ctf2", multiplayerRules = true, hideCPs = true}
	ctf:AddFlag{name = "ctf_flag1", homeRegion = "flag1_home", captureRegion = "flag2_home",
			capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3.0, 
			icon = "", mapIcon = "flag_icon", mapIconScale = 3.0}
	ctf:AddFlag{name = "ctf_flag2", homeRegion = "flag2_home", captureRegion = "flag1_home",
			capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3.0, 
			icon = "", mapIcon = "flag_icon", mapIconScale = 3.0}

	SoundEvent_SetupTeams( CIS, 'cis', REP, 'rep' )

	ctf:Start()
	
	KillObject("CP1")
	KillObject("CP2")
	KillObject("CP3")
	KillObject("CP4")
	KillObject("CP5")
	KillObject("CP6")
	KillObject("CP7")
	KillObject("CP8")
	
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
    StealArtistHeap(2048*1024)
    SetPS2ModelMemory(2097152 + 65536 * 6)
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
	
	-- Jawas --------------------------
	--[[SetTeamName (3, "locals")
	AddUnitClass (3, "tat_inf_jawa", 7)
	SetUnitCount (3, 7)
	SetTeamAsFriend(3,ATT)
	SetTeamAsFriend(3,DEF)
	SetTeamAsFriend(ATT,3)
	SetTeamAsFriend(DEF,3)]]
	-----------------------------------

    --  Level Stats
    ClearWalkers()
    AddWalkerType(0, 0) -- special -> droidekas
    AddWalkerType(1, 0) -- 1x2 (1 pair of legs)
    AddWalkerType(2, 0) -- 2x2 (2 pairs of legs)
    AddWalkerType(3, 0) -- 3x2 (3 pairs of legs)
    local weaponCnt = 230
    SetMemoryPoolSize("Aimer", 30)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 379)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntityCloth", 0)
    SetMemoryPoolSize("EntitySoundStream", 64)
    SetMemoryPoolSize("EntitySoundStatic", 43)
    SetMemoryPoolSize("Navigator", 50)
    SetMemoryPoolSize("Obstacle", 788)
    SetMemoryPoolSize("PathFollower", 50)
    SetMemoryPoolSize("PathNode", 256)
    SetMemoryPoolSize("SoldierAnimation", 405)
    SetMemoryPoolSize("TentacleSimulator", 0)
    SetMemoryPoolSize("TreeGridStack", 325)
    SetMemoryPoolSize("Weapon", weaponCnt)
	manager:Proc_ScriptInit_MemoryPoolInit()

    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\tat2.lvl", "tat2_ctf")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\minimap.lvl;tat2")
    SetDenseEnvironment("false")


    --  Sound Stats
	
	manager:Proc_ScriptInit_MusicSetup()
	
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_TAT_Streaming.lvl",  "tat2")
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