ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
SkyMode = math.random(1,2)

ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\core.lvl")
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--
-- load the gametype script
ScriptCB_DoFile("SOL_Master")
ScriptCB_DoFile("ME5_Master")
ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ME5_ObjectiveCTF")

-- Create a new MapManager object
manager = MapManager:New{
	-- Map-specific details
	bIsModMap = true,
	gameMode = "ctf",
	mapSize = "xs",
	environmentType = "jungle",
	
	-- In-game music
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
	heroSupportCPs = {},
	-- Local ally spawns (required). CP name, CP spawn path name
	allySpawnCPs = {},
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
	
	UnblockPlanningGraphArcs(1)
	
	SoundEvent_SetupTeams( REP, 'rep', CIS, 'cis' )
    
    SetProperty("flag1", "GeometryName", "com_icon_republic_flag")
    SetProperty("flag1", "CarriedGeometryName", "com_icon_republic_flag_carried")
    SetProperty("flag2", "GeometryName", "com_icon_cis_flag")
    SetProperty("flag2", "CarriedGeometryName", "com_icon_cis_flag_carried")

                --This makes sure the flag is colorized when it has been dropped on the ground
    SetClassProperty("com_item_flag", "DroppedColorize", 1)

    --This is all the actual ctf objective setup
    ctf = ObjectiveCTF:New{teamATT = REP, teamDEF = CIS, captureLimit = 5, 
    			textATT = "game.modes.ctf", textDEF = "game.modes.ctf2", 
    			hideCPs = true, multiplayerRules = true}
    ctf:AddFlag{name = "flag1", homeRegion = "team1_capture", captureRegion = "team2_capture",
				capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3.0, 
				icon = "", mapIcon = "flag_icon", mapIconScale = 3.0, regionDummyObject = "team2_capture"}
    ctf:AddFlag{name = "flag2", homeRegion = "team2_capture", captureRegion = "team1_capture",
				capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3.0, 
				icon = "", mapIcon = "flag_icon", mapIconScale = 3.0, regionDummyObject = "team1_capture"}
	
	ctf:Start()
	
    EnableSPHeroRules()
	
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
	
	manager:Proc_ScriptInit_Begin()
	
	AISnipeSuitabilityDist(60)
	SetAttackerSnipeRange(60)
	SetDefenderSnipeRange(110)
	
	SetMaxFlyHeight(50)
	SetMaxPlayerFlyHeight(50)
    
    SetMemoryPoolSize("ClothData", 20)
	
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
    SetMemoryPoolSize("RedOmniLight", 193)
    SetMemoryPoolSize("SoldierAnimation", 410)
    SetMemoryPoolSize("SoundSpaceRegion", 64)
    SetMemoryPoolSize("TreeGridStack", 1024)
	SetMemoryPoolSize("UnitAgent", 128)
	SetMemoryPoolSize("UnitController", 128)
	SetMemoryPoolSize("Weapon", weaponCnt)
	manager:Proc_ScriptInit_MemoryPoolInit()
	
	SetSpawnDelay(10.0, 0.25)
	ReadDataFile("dc:SOL\\MR1.lvl", "MR1_2flag")
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
