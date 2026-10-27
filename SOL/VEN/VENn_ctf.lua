ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\master.lvl")

ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\core.lvl")
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
	
	if SkyMode == 1 then
		ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\SOL\\sky.lvl", "daytime")
		ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\SOL\\VEN_env_day.lvl")
	elseif SkyMode == 2 then
		ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\SIDE\\mist.lvl", "myg1_sky_mist")
		ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\SOL\\sky.lvl", "nighttime")
		ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\SOL\\VEN_env_night.lvl")
	end

	CreateTimer("globalhawk1_timer")
	SetTimerValue("globalhawk1_timer", 27)
	StartTimer("globalhawk1_timer")
	OnTimerElapse(
		function(timer)
			ScriptCB_SndPlaySound("globalhawk_flyby")
			DestroyTimer("globalhawk1_timer")
			
			CreateTimer("globalhawk2_timer")
			SetTimerValue("globalhawk2_timer", 60)
			StartTimer("globalhawk2_timer")
			OnTimerElapse(
			function(timer)
				ScriptCB_SndPlaySound("globalhawk_flyby")
				SetTimerValue("globalhawk2_timer", 60)
				StartTimer("globalhawk2_timer")
			end,
			"globalhawk2_timer"
		)
		end,
	"globalhawk1_timer"
	)
    
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
                icon = "", mapIcon = "flag_icon", mapIconScale = 3.0, regionDummyObject = "com_bldg_ctfbase1"}
    ctf:AddFlag{name = "flag2", homeRegion = "team2_capture", captureRegion = "team1_capture",
                capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3.0, 
                icon = "", mapIcon = "flag_icon", mapIconScale = 3.0, regionDummyObject = "com_bldg_ctfbase"}
    
	ctf:Start()

	SoundEvent_SetupTeams( manager.factionIds.REP, 'rep', manager.factionIds.CIS, 'cis' )
	
    EnableSPHeroRules()

    AddDeathRegion("deathregion")

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
	if not ScriptCB_InMultiplayer() then
		if solConfigSettings["cfg_VenTimeOfDay"] == 0 then
			SkyMode = math.random(1,2)
		else
			SkyMode = solConfigSettings["cfg_VenTimeOfDay"]
		end
	else
		SkyMode = 1
	end

	StealArtistHeap(2048*2048)
	
	if SkyMode == 1 then
		ReadDataFile("dc:Load\\ven_load_day_me5.lvl")
	elseif SkyMode == 2 then
		ReadDataFile("dc:Load\\ven_load_night_me5.lvl")
	end
	
	SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2563)
	SetMemoryPoolSize("ParticleTransformer::PositionTr", 1509)
	SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1658)
	
	-- Perform various pre-game operations
	manager:Proc_ScriptInit_Begin()
	
    SetMaxFlyHeight(60)
    SetMaxPlayerFlyHeight(60)
	
    ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\sound\\sol.lvl;sol_venn")
	ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\sound\\ven.lvl;venusn")
	
	-- Load and set up the sides
	manager:Proc_ScriptInit_SideSetup()

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
	SetMemoryPoolSize("EntityFlyer", 32)
    SetMemoryPoolSize("EntityHover", 32)
    SetMemoryPoolSize("EntityLight", 200)
    SetMemoryPoolSize("EntitySoundStream", 64)
    SetMemoryPoolSize("EntitySoundStatic", 64)
    SetMemoryPoolSize("MountedTurret", 32)
	SetMemoryPoolSize("Navigator", 128)
    SetMemoryPoolSize("Obstacle", 1024)
	SetMemoryPoolSize("PathNode", 1024)
    SetMemoryPoolSize("SoldierAnimation", 410)
    SetMemoryPoolSize("SoundSpaceRegion", 64)
    SetMemoryPoolSize("TreeGridStack", 1024)
	SetMemoryPoolSize("UnitAgent", 128)
	SetMemoryPoolSize("UnitController", 128)
	SetMemoryPoolSize("Weapon", weaponCnt)
	manager:Proc_ScriptInit_MemoryPoolInit()
    
    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\SOL\\VEN.lvl", "VEN_ctf")
    SetDenseEnvironment("false")
	
	ReadDataFile("dc:minimap.lvl;ven")
	

    --  Sound Stats
	
	OpenAudioStream("..\\..\\addon\\SOL\\data\\_LVL_PC\\sound\\sol.lvl", "solgcw_music")
	OpenAudioStream("..\\..\\addon\\SOL\\data\\_LVL_PC\\sound\\ven.lvl",  "ven")
	OpenAudioStream("..\\..\\addon\\SOL\\data\\_LVL_PC\\sound\\ven.lvl",  "ven")
	OpenMusicStreams(1)

	SetAmbientMusic(REP, 1.0, "ven_amb_earworm_cw",  0,1)
	SetAmbientMusic(CIS, 1.0, "ven_amb_earworm_cw",  0,1)
	
	SetVictoryMusic(REP, "ssv_amb_01_victory")
	SetDefeatMusic (REP, "ssv_amb_01_defeat")
	SetVictoryMusic(CIS, "ssv_amb_01_victory")
	SetDefeatMusic (CIS, "ssv_amb_01_defeat")
	
	SoundFX()
	
	ScaleSoundParameter("ambientenv",	"Gain", 1.0)
	
    -- Camera Stats
	AddCameraShot(0.79059, -0.022537941, -0.6116825, -0.017437689, -110.67704, 4.485702, 93.36073);
	AddCameraShot(0.07222806, -0.0008667819, 0.99731594, 0.011968416, 90.45041, 3.6745024, -110.50886);
	AddCameraShot(0.92603636, 0.004167157, 0.37740752, -0.0016983316, 51.947643, 6.736896, 50.649803);
	AddCameraShot(0.8545839, -0.006409529, -0.5192592, -0.003894535, -58.650284, 1.9489465, 3.612307);
	AddCameraShot(0.67634284, 0.0030435282, -0.7365732, 0.0033145633, -68.053665, 1.8203292, -57.926434);
	AddCameraShot(-0.41427866, 0.0062146685, 0.9100265, 0.013651472, -11.129101, 1.6246367, -4.01956);
	AddCameraShot(0.13783737, 0.0024813851, 0.9902913, -0.017827494, 1.6406196, 1.4287041, -8.253273);
	AddCameraShot(0.8543938, 0.019227374, 0.51913875, -0.011682757, 6.532426, 1.003527, 21.393188);
	AddCameraShot(0.98420566, -0.0044286465, -0.17697157, -0.0007963219, 78.19751, 2.568953, 105.87319);
	AddCameraShot(0.92222, 0.040142465, 0.38421237, -0.016724026, -63.393074, 2.5041702, -62.350685);
	AddCameraShot(0.7688, -0.2659123, 0.5496331, 0.19010688, 24.084211, 66.66496, 13.23911);
	AddCameraShot(0.0012905692, -0.0012539304, 0.7172131, 0.6968516, -12.769728, 2.3128731, -2.363696);
	
	-- Perform various post-load operations
	manager:Proc_ScriptInit_End()
	
end
