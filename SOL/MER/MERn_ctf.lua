--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\master.lvl")

ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\core.lvl")
ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\core.lvl")
-- load the gametype script
ScriptCB_DoFile("SOL_Master")
ScriptCB_DoFile("ME5_Master")
ScriptCB_DoFile("ME5_setup_teams")
Conquest = ScriptCB_DoFile("ME5_ObjectiveCTF")
ScriptCB_DoFile("Homer")

-- Create a new MapManager object
manager = MapManager:New{
	-- Map-specific details
	bIsModMap = true,					-- Whether or not this is a mod map (as opposed to a stock map).
	gameMode = "ctf",				-- The mission's game mode.
	mapSize = "sm",						-- Size of the map. Used for determining unit counts.
	environmentType = "urban",			-- Map's biome (essentially). Used for determining which camo textures to load. ("desert", "jungle", "snow", or "urban")
	factionIds = {REP = 2, CIS = 1},
	
	-- In-game music (you can also specify a table of values and one of them will be randomly selected at runtime, example: `musicVariation_SSVxGTH = {"1","3"}` )
	musicVariation_SSVxGTH = "4",		-- Music variation to use for SSVxGTH matches.
	musicVariation_SSVxCOL = "2",		-- Music variation to use for SSVxCOL matches.
	musicVariation_EVGxGTH = "9",		-- Music variation to use for EVGxGTH matches.
	musicVariation_EVGxCOL = "9",		-- Music variation to use for EVGxCOL matches.
	
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
	},
	-- Local ally spawns (required). CP name, CP spawn path name
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
    
    SetProperty("flag1", "GeometryName", "com_icon_republic_flag")
    SetProperty("flag1", "CarriedGeometryName", "com_icon_republic_flag_carried")
    SetProperty("flag2", "GeometryName", "com_icon_cis_flag")
    SetProperty("flag2", "CarriedGeometryName", "com_icon_cis_flag_carried")

                --This makes sure the flag is colorized when it has been dropped on the ground
    SetClassProperty("com_item_flag", "DroppedColorize", 1)

    --This is all the actual ctf objective setup
    ctf = ObjectiveCTF:New{teamATT = REP, teamDEF = CIS, captureLimit = 5, textATT = "game.modes.ctf", textDEF = "game.modes.ctf2", hideCPs = true, multiplayerRules = true}
    ctf:AddFlag{name = "flag1", homeRegion = "team1_capture", captureRegion = "team2_capture", regionDummyObject = "com_bldg_ctfbase",
                capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3.0, 
                icon = "", mapIcon = "flag_icon", mapIconScale = 3.0}
    ctf:AddFlag{name = "flag2", homeRegion = "team2_capture", captureRegion = "team1_capture", regionDummyObject = "com_bldg_ctfbase1",
                capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3.0, 
                icon = "", mapIcon = "flag_icon", mapIconScale = 3.0}
    
	ctf:Start()

	SoundEvent_SetupTeams( manager.factionIds.REP, 'rep', manager.factionIds.CIS, 'cis' )
	
    EnableSPHeroRules()

	SetClassProperty("sol_inf_astronaut", "HurtSound", "rep_inf_com_chatter_wound")
	SetClassProperty("sol_inf_astronaut", "DeathSound", "rep_inf_com_chatter_death")
	SetClassProperty("sol_inf_astronaut", "DamageRegionSound", "repmalechoke")
	SetClassProperty("sol_inf_astronaut", "FoleyFXClass", "rep_inf_trooper")

	SetObjectTeam("tur_bldg_chaingun_roof", CIS)
	SetObjectTeam("tur_bldg_chaingun_roof1", CIS)
	SetObjectTeam("tur_bldg_chaingun_roof2", REP)
	SetObjectTeam("tur_bldg_chaingun_roof3", REP)

	SetClassProperty("com_jedi_default", "MaxHealth", "800")

	AddDeathRegion("deathregion")
	AddDeathRegion("deathregion2")

	SetupHomer()

	SetObjectTeam("cp_nasa", 5)

    KillObject("ctf_cp2")
    KillObject("ctf_cp3")
	
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
    ReadDataFile("dc:Load\\mer_load_ctf.lvl")
	
	SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2172)
	SetMemoryPoolSize("ParticleTransformer::PositionTr", 1272)
	SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1433)
	
	-- Perform various pre-game operations
	manager:Proc_ScriptInit_Begin()

	AISnipeSuitabilityDist(30)
	SetAttackerSnipeRange(28)
	SetDefenderSnipeRange(40)
	
	SetMaxFlyHeight(50)
	SetMaxPlayerFlyHeight(50)
	
	ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\sound\\MER.lvl")
	ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\sound\\sol.lvl;sol_mern")
	
	-- Load and set up the sides
	manager:Proc_ScriptInit_SideSetup()

	ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\SIDE\\tur.lvl",
					"mer_bldg_powercluster",
					"tur_bldg_chaingun_roof")

    --  Level Stats
    --  ClearWalkers()
    AddWalkerType(0, 0) -- special -> droidekas
    AddWalkerType(1, 0) -- 1x2 (1 pair of legs)
    AddWalkerType(2, 0) -- 2x2 (2 pairs of legs)
    AddWalkerType(3, 0) -- 3x2 (3 pairs of legs)
    local weaponCnt = 1024
    SetMemoryPoolSize("Aimer", 75)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
	SetMemoryPoolSize("Asteroid", 100)
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
	SetMemoryPoolSize("RedOmniLight", 168)
    SetMemoryPoolSize("SoldierAnimation", 497)
    SetMemoryPoolSize("SoundSpaceRegion", 64)
    SetMemoryPoolSize("TreeGridStack", 1024)
	SetMemoryPoolSize("UnitAgent", 128)
	SetMemoryPoolSize("UnitController", 128)
	SetMemoryPoolSize("Weapon", weaponCnt)
	manager:Proc_ScriptInit_MemoryPoolInit()
    
    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\SOL\\MER.lvl", "MER_ctf")
    SetDenseEnvironment("true")


	--  Sound Stats
	
	OpenAudioStream("..\\..\\addon\\SOL\\data\\_LVL_PC\\sound\\sol.lvl", "SOLgcw_music")
	OpenMusicStreams(1)

	SetAmbientMusic(REP, 1.0, "MER_amb_earworm",  0,1)
	SetAmbientMusic(CIS, 1.0, "MER_amb_earworm",  0,1)
	
	SetVictoryMusic(REP, "ssv_amb_01_victory")
	SetDefeatMusic (REP, "ssv_amb_01_defeat")
	SetVictoryMusic(CIS, "ssv_amb_01_victory")
	SetDefeatMusic (CIS, "ssv_amb_01_defeat")
	
	OpenAudioStream("..\\..\\addon\\SOL\\data\\_LVL_PC\\sound\\MER.lvl",  "MER_ambiance")
	OpenAudioStream("..\\..\\addon\\SOL\\data\\_LVL_PC\\sound\\MER.lvl",  "MER_ambiance")
	
	SoundFX()
	
	ScaleSoundParameter("ambientenv",	"Gain", 1.0)

    -- Camera Stats
	AddCameraShot(-0.274886, 0.013827, -0.960164, -0.048297, -210.180695, 3.635276, 118.081535);	-- hangar
	AddCameraShot(0.496477, 0.008049, -0.867899, 0.014071, -215.348770, 0.987042, 188.249725);		-- mess hall
	AddCameraShot(0.453753, 0.001287, -0.891123, 0.002527, -187.783844, 1.628211, 87.657166);		-- power room
	AddCameraShot(-0.274609, 0.017051, -0.959557, -0.059580, -154.878372, 16.319477, 134.786194);	-- observatory
	AddCameraShot(0.514180, -0.033251, 0.855251, 0.055308, -100.511414, 2.989032, 132.859024);		-- command deck
	AddCameraShot(0.704096, -0.006660, -0.710042, -0.006716, -128.710251, 2.147865, 138.976120);	-- command deck towards sun
	
	-- Perform various post-load operations
	manager:Proc_ScriptInit_End()
end