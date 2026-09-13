ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")

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

function ScriptPreInit()
	if not ScriptCB_InMultiplayer() then
		if solConfigSettings["cfg_VenTimeOfDay"] == 0 then
			SkyMode = math.random(1,2)
		else
			SkyMode = solConfigSettings["cfg_VenTimeOfDay"]
		end
	else
		SkyMode = 1
	end
end

function ScriptPostLoad()
	
	if SkyMode == 1 then
		ReadDataFile("dc:SOL\\sky.lvl", "daytime")
		ReadDataFile("dc:SOL\\VEN_env_day.lvl")
	elseif SkyMode == 2 then
		ReadDataFile("dc:SIDE\\mist.lvl", "myg1_sky_mist")
		ReadDataFile("dc:SOL\\sky.lvl", "nighttime")
		ReadDataFile("dc:SOL\\VEN_env_night.lvl")
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
                icon = "", mapIcon = "flag_icon", mapIconScale = 3.0, regionDummyObject = "com_bldg_ctfbase1"}
    ctf:AddFlag{name = "flag2", homeRegion = "team2_capture", captureRegion = "team1_capture",
                capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3.0, 
                icon = "", mapIcon = "flag_icon", mapIconScale = 3.0, regionDummyObject = "com_bldg_ctfbase"}
    
	ctf:Start()
	
    EnableSPHeroRules()

    AddDeathRegion("deathregion")

	SetClassProperty("ven_inf_astronaut", "HurtSound", "rep_inf_com_chatter_wound")
	SetClassProperty("ven_inf_astronaut", "DeathSound", "rep_inf_com_chatter_death")
	SetClassProperty("ven_inf_astronaut", "DamageRegionSound", "repmalechoke")
	SetClassProperty("ven_inf_astronaut", "FoleyFXClass", "rep_inf_trooper")

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
	
	-- Load and set up the sides
	manager:Proc_ScriptInit_SideSetup()
	
    ReadDataFile("dc:sound\\sol.lvl;sol_venn")
	ReadDataFile("dc:sound\\ven.lvl;venusn")

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
    ReadDataFile("dc:SOL\\VEN.lvl", "VEN_ctf")
    SetDenseEnvironment("false")
	
	ReadDataFile("dc:minimap.lvl;ven")
	

    --  Sound Stats
	
	-- Set up music
	if ME5_SolMapMusic == 0 then
		--ScriptCB_EnableHeroMusic(0)
		
		OpenAudioStream("dc:sound\\sol.lvl", "soln_music")
		--OpenAudioStream("dc:sound\\ven.lvl",  "venus_music")
		OpenMusicStreams(1)

		SetAmbientMusic(REP, 1.0, "ven_amb_earworm_n",  0,1)
		SetAmbientMusic(CIS, 1.0, "ven_amb_earworm_n",  0,1)
		
		SetVictoryMusic(REP, "ssv_amb_01_victory")
		SetDefeatMusic (REP, "ssv_amb_01_defeat")
		SetVictoryMusic(CIS, "ssv_amb_01_victory")
		SetDefeatMusic (CIS, "ssv_amb_01_defeat")
		
	elseif ME5_SolMapMusic == 1 then
		manager:Proc_ScriptInit_MusicSetup()
	end
	
    OpenAudioStream("dc:sound\\ven.lvl",  "ven")
    OpenAudioStream("dc:sound\\ven.lvl",  "ven")
	
	SoundFX()
	
	ScaleSoundParameter("ambientenv",	"Gain", 1.0)
	
    -- Camera Stats
	
	RandomCam = math.random(1,2)
	if not ScriptCB_InMultiplayer() then
		if RandomCam == 1 then
			AddCameraShot(0.833753, -0.041111, -0.549937, -0.027117, -59.834293, 7.632715, 26.208221);
			AddCameraShot(0.933529, -0.201821, 0.289606, 0.062610, 7.708241, 7.707424, 8.395696);
		elseif RandomCam == 2 then
			AddCameraShot(0.933529, -0.201821, 0.289606, 0.062610, 7.708241, 7.707424, 8.395696);
			AddCameraShot(0.833753, -0.041111, -0.549937, -0.027117, -59.834293, 7.632715, 26.208221);
		else
			AddCameraShot(0.833753, -0.041111, -0.549937, -0.027117, -59.834293, 7.632715, 26.208221);
			AddCameraShot(0.933529, -0.201821, 0.289606, 0.062610, 7.708241, 7.707424, 8.395696);
		end
	else
		AddCameraShot(0.833753, -0.041111, -0.549937, -0.027117, -59.834293, 7.632715, 26.208221);
		AddCameraShot(0.933529, -0.201821, 0.289606, 0.062610, 7.708241, 7.707424, 8.395696);
	end
	AddCameraShot(-0.247927, 0.000648, -0.968775, -0.002532, 14.313373, 3.652352, 33.439255);
	AddCameraShot(0.270304, -0.020588, -0.959775, -0.073104, -95.084686, 7.707424, -108.813805);
	AddCameraShot(-0.229996, 0.023490, -0.967873, -0.098852, 94.367546, 7.707424, -112.500244);
	AddCameraShot(-0.334930, 0.048097, -0.931459, -0.133760, 2.688356, 2.464442, -13.071471);
	
	-- Perform various post-load operations
	manager:Proc_ScriptInit_End()
	
end
