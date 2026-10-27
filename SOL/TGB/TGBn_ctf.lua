--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\master.lvl")

isModMap = 1
isLowG = 1

ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\core.lvl")
ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\core.lvl")
-- load the gametype script
ScriptCB_DoFile("SOL_Master")
ScriptCB_DoFile("ME5_Master")
ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ME5_ObjectiveCTF")

-- Create a new MapManager object
manager = MapManager:New{
	-- Map-specific details
	bIsModMap = true,					-- Whether or not this is a mod map (as opposed to a stock map).
	gameMode = "ctf",				-- The mission's game mode.
	mapSize = "med",						-- Size of the map. Used for determining unit counts.
	environmentType = "urban",			-- Map's biome (essentially). Used for determining which camo textures to load. ("desert", "jungle", "snow", or "urban")
	factionIds = {REP = 1, CIS = 2, LocalTeam1 = 4, LocalTeam2 = 5},
	
	-- In-game music (you can also specify a table of values and one of them will be randomly selected at runtime, example: `musicVariation_SSVxGTH = {"1","3"}` )
	musicVariation_SSVxGTH = "4",		-- Music variation to use for SSVxGTH matches.
	musicVariation_SSVxCOL = "2",		-- Music variation to use for SSVxCOL matches.
	musicVariation_EVGxGTH = "9",		-- Music variation to use for EVGxGTH matches.
	musicVariation_EVGxCOL = "9",		-- Music variation to use for EVGxCOL matches.
	
	-- Online matches
	onlineSideVar = "SSVxGTH",			-- Faction combination to use in online matches.
	onlineHeroSSV = "shep_sentinel",	-- SSV hero to use in online matches.
	onlineHeroGTH = "gethprime_me2",	-- GTH hero to use in online matches.
	onlineHeroCOL = "colgeneral",		-- COL hero to use in online matches.
	onlineHeroEVG = "gethprime_me3",	-- EVG hero to use in online matches.
	
	-- AI hero spawns (required). CP name, CP spawn path name
	heroSupportCPs = {},
	-- Local ally spawns (required). CP name, CP spawn path name
	allySpawnCPs = {},
}
-- Initialize the MapManager
manager:Init()


function ScriptPostLoad()
    
    SetProperty("flag1", "GeometryName", "com_icon_republic_flag")
    SetProperty("flag1", "CarriedGeometryName", "com_icon_republic_flag_carried")
    SetProperty("flag2", "GeometryName", "com_icon_cis_flag")
    SetProperty("flag2", "CarriedGeometryName", "com_icon_cis_flag_carried")

                --This makes sure the flag is colorized when it has been dropped on the ground
    SetClassProperty("com_item_flag", "DroppedColorize", 1)

    --This is all the actual ctf objective setup
    ctf = ObjectiveCTF:New{teamATT = REP, teamDEF = CIS, captureLimit = 5, textATT = "game.modes.ctf", textDEF = "game.modes.ctf2", hideCPs = true, multiplayerRules = true}
    ctf:AddFlag{name = "flag1", homeRegion = "team1_capture", captureRegion = "team2_capture",
                capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3.0, 
                icon = "", mapIcon = "flag_icon", mapIconScale = 3.0}
    ctf:AddFlag{name = "flag2", homeRegion = "team2_capture", captureRegion = "team1_capture",
                capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3.0, 
                icon = "", mapIcon = "flag_icon", mapIconScale = 3.0}
    
	ctf:Start()

	SoundEvent_SetupTeams( manager.factionIds.REP, 'rep', manager.factionIds.CIS, 'cis' )
	
    EnableSPHeroRules()

    AddDeathRegion("deathregion1")
    AddDeathRegion("deathregion2")

	SetClassProperty("sol_inf_astronaut", "HurtSound", "rep_inf_com_chatter_wound")
	SetClassProperty("sol_inf_astronaut", "DeathSound", "rep_inf_com_chatter_death")
	SetClassProperty("sol_inf_astronaut", "DamageRegionSound", "repmalechoke")
	SetClassProperty("sol_inf_astronaut", "FoleyFXClass", "rep_inf_trooper")

	-- Perform various post-load operations
	manager:Proc_ScriptPostLoad_End()

	KillObject("local_cp")
    
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

    ReadDataFile("dc:Load\\tgb_load.lvl")

    SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2172)
    SetMemoryPoolSize("ParticleTransformer::PositionTr", 1272)
    SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1433)
	
	-- Perform various pre-game operations
	manager:Proc_ScriptInit_Begin()
    
   
    SetMaxFlyHeight(42)
	SetMaxPlayerFlyHeight(42)
	
	AISnipeSuitabilityDist(110)
	SetAttackerSnipeRange(100)
	SetDefenderSnipeRange(120)

    ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\sound\\tgb.lvl")
    ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\sound\\sol.lvl;sol_tgbn")
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\me5tur.lvl", 
					"tur_bldg_laser")
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\CON_LOWG.lvl")
	
	-- Load and set up the sides
	manager:Proc_ScriptInit_SideSetup()

    --  Level Stats
    --  ClearWalkers()
    AddWalkerType(0, 4) -- special -> droidekas
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
    ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\SOL\\TGB.lvl", "TGB_ctf")
    SetDenseEnvironment("false")
	
	-- ReadDataFile("dc:minimap.lvl;ven")


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
	
	ScaleSoundParameter("ambientenv",	"Gain", 1.0)


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

