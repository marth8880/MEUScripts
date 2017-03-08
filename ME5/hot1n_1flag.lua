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
	environmentType = "snow",
	
	-- In-game music
	musicVariation_SSVxGTH = "3_nov",
	musicVariation_SSVxCOL = "5",
	musicVariation_EVGxGTH = "9",
	musicVariation_EVGxCOL = "9",
	
	-- Online matches
	onlineSideVar = "SSVxGTH",
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
	SoundEvent_SetupTeams( REP, 'rep', CIS, 'cis' )
	
	AddDeathRegion("fall")
    EnableSPHeroRules()
    
    
--CP SETUP for CONQUEST
    --SetObjectTeam("CP3", 1)
    
   KillObject("CP7OBJ")
   KillObject("shieldgen")
   KillObject("CP7OBJ")
   KillObject("hangarcp")
   KillObject("enemyspawn")
   KillObject("enemyspawn2")
   KillObject("echoback2")
   KillObject("echoback1")
   KillObject("shield")	
   DisableBarriers("conquestbar")
   DisableBarriers("bombbar")
   
  SetProperty("ship", "MaxHealth", 1e+37)
  SetProperty("ship", "CurHealth", 1e+37)
  SetProperty("ship2", "MaxHealth", 1e+37)
  SetProperty("ship2", "CurHealth", 1e+37)
  SetProperty("ship3", "MaxHealth", 1e+37)
  SetProperty("ship3", "CurHealth", 1e+37)
    
    

    ctf = ObjectiveOneFlagCTF:New{teamATT = 1, teamDEF = 2,
                           textATT = "game.modes.1flag", textDEF = "game.modes.1flag2", hideCPs = true, multiplayerRules = true, 
                           captureLimit = 5, flag = "flag", flagIcon = "flag_icon", 
                           flagIconScale = 3.0, homeRegion = "HomeRegion",
                           captureRegionATT = "Team2Capture", captureRegionDEF = "Team1Capture",
                           capRegionMarkerATT = "hud_objective_icon_circle", capRegionMarkerDEF = "hud_objective_icon_circle",
                           capRegionMarkerScaleATT = 3.0, capRegionMarkerScaleDEF = 3.0,
                           capRegionDummyObjectATT = "com_bldg_ctfbase", capRegionDummyObjectDEF = "com_bldg_ctfbase1",}
                           
    ctf:Start()
	
	manager:Proc_ScriptPostLoad_End()
	
end

function ScriptInit()
	StealArtistHeap(1280*1024)
    -- Designers, these two lines *MUST* be first.
    SetPS2ModelMemory(4000000)
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\load.lvl;hot1")
	
	SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2202)
	SetMemoryPoolSize("ParticleTransformer::PositionTr", 1305)
	SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1423)
	
	manager:Proc_ScriptInit_Begin()
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\PFX_SSV_Veh.lvl;vehcommon")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\PFX_SSV_Veh.lvl;vehnormal")


    SetMaxFlyHeight(70)
    SetMaxPlayerFlyHeight(70)
--    SetGroundFlyerMap(1);
	
	--[[ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\me5tur.lvl",
					"tur_bldg_mturret",
					"tur_bldg_hoth_dishturret",
					"tur_bldg_hoth_lasermortar")]]
	
	manager:Proc_ScriptInit_SideSetup()
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_HOT_Streaming.lvl;hot1n")
   
    --  Level Stats
    ClearWalkers()
    SetMemoryPoolSize("EntityWalker", 0)
    AddWalkerType(0, 0) -- 0 droidekas
    AddWalkerType(1, 0) -- 6 atsts with 1 leg pairs each
    AddWalkerType(2, 0) -- 2 atats with 2 leg pairs each
    
    local weaponCnt = 260
    SetMemoryPoolSize("Aimer", 50)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 300)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntityCloth", 44)
    SetMemoryPoolSize("EntityLight", 240)
    SetMemoryPoolSize("EntityFlyer", 6)
    SetMemoryPoolSize("EntitySoundStream", 12)
    SetMemoryPoolSize("EntitySoundStatic", 13)
    SetMemoryPoolSize("FLEffectObject::OffsetMatrix", 90)
    SetMemoryPoolSize("Music", 89)
    SetMemoryPoolSize("Navigator", 40)
    SetMemoryPoolSize("Obstacle", 400)
    SetMemoryPoolSize("PathNode", 180)
    SetMemoryPoolSize("RedOmniLight", 250)
    SetMemoryPoolSize("SoldierAnimation", 434)
    SetMemoryPoolSize("TreeGridStack", 350)
    SetMemoryPoolSize("UnitAgent", 46)
    SetMemoryPoolSize("UnitController", 46)
    SetMemoryPoolSize("Weapon", weaponCnt)
	manager:Proc_ScriptInit_MemoryPoolInit()

	ReadDataFile("HOT\\hot1.lvl", "hoth_ctf")	-- TODO: we should probably be loading MEU's hot1.lvl and not the stock one tbh
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\minimap.lvl;hot1")
    SetSpawnDelay(15.0, 0.25)
    SetDenseEnvironment("false")
    SetDefenderSnipeRange(170)
    AddDeathRegion("Death")


    --  Sound Stats
	
	manager:Proc_ScriptInit_MusicSetup()
	
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_HOT_Streaming.lvl",  "hot1")
	OpenAudioStream("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_s_HOT_Streaming.lvl",  "hot1")
	
	SoundFX()
	ScaleSoundParameter("ambientenv",	"Gain", 0.75)


    --  Camera Stats
    --Hoth
    --Hangar
    AddCameraShot(0.944210, 0.065541, 0.321983, -0.022350, -500.489838, 0.797472, -68.773849)
    --Shield Generator
    AddCameraShot(0.371197, 0.008190, -0.928292, 0.020482, -473.384155, -17.880533, 132.126801)
    --Battlefield
    AddCameraShot(0.927083, 0.020456, -0.374206, 0.008257, -333.221558, 0.676043, -14.027348)
	
	manager:Proc_ScriptInit_End()


end
