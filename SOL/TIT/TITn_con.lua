ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\master.lvl")

isLowG = 1

ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\core.lvl")
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
	bIsModMap = true,					-- Whether or not this is a mod map (as opposed to a stock map).
	gameMode = "conquest",				-- The mission's game mode.
	mapSize = "lg",						-- Size of the map. Used for determining unit counts.
	environmentType = "desert",			-- Map's biome (essentially). Used for determining which camo textures to load. ("desert", "jungle", "snow", or "urban")
	factionIds = {REP = 1, CIS = 2, LocalTeam1 = 4, LocalTeam2 = 5},
	
	-- In-game music (you can also specify a table of values and one of them will be randomly selected at runtime, example: `musicVariation_SSVxGTH = {"1","3"}` )
	musicVariation_SSVxGTH = "1",		-- Music variation to use for SSVxGTH matches.
	musicVariation_SSVxCOL = "5",		-- Music variation to use for SSVxCOL matches.
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
				{"cp6", "cp6_spawn"},
				{"cp7", "cp7_spawn"},
				{"cp8", "cp8_spawn"},
	},
	-- Local ally spawns (required). CP name, CP spawn path name
	allySpawnCPs = {
				{"cp1", "cp1_spawn"},
				{"cp2", "cp2_spawn"},
				{"cp3", "cp3_spawn"},
				{"cp4", "cp4_spawn"},
				{"cp5", "cp5_spawn"},
				{"cp6", "cp6_spawn"},
				{"cp7", "cp7_spawn"},
				{"cp8", "cp8_spawn"},
	},
	
	-- Artillery strike path nodes (required only if artillery strikes are desired). Path name, path node ID
	artilleryNodes = {
				{"cp1_spawn", 0},
				{"cp2_spawn", 0},
				{"cp3_spawn", 0},
				{"cp4_spawn", 0},
				{"cp5_spawn", 0},
				{"cp6_spawn", 0},
				{"cp7_spawn", 0},
	},
	terrainType = "dirt",	-- Type of terrain in the map ("dirt, "sand", or "snow") (required if `artilleryNodes` is specified).
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
    cp6 = CommandPost:New{name = "cp6"}
    cp7 = CommandPost:New{name = "cp7"}
	cp8 = CommandPost:New{name = "cp8"}	
    
    
    --This sets up the actual objective.  This needs to happen after cp's are defined
    conquest = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, 
                                     textATT = "game.modes.con", 
                                     textDEF = "game.modes.con2",
                                     multiplayerRules = true}
    
    --This adds the CPs to the objective.  This needs to happen after the objective is set up
    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp2)
    conquest:AddCommandPost(cp3)
    conquest:AddCommandPost(cp4)
    conquest:AddCommandPost(cp5)
    conquest:AddCommandPost(cp6)
    conquest:AddCommandPost(cp7)
    conquest:AddCommandPost(cp8)
    
    conquest:Start()

    EnableSPHeroRules()
	
	-- Perform various post-load operations
	manager:Proc_ScriptPostLoad_End()
	
	SetClassProperty("com_inv_col_8_veh", "SoldierCollision", "none")
	SetClassProperty("com_inv_col_8_veh", "BuildingCollision", "none")
	SetProperty("com_inv_col_8_veh", "IsVisible", 0)
	SetProperty("com_inv_col_9_veh", "IsVisible", 0)
	SetProperty("com_inv_col_16", "IsVisible", 0)
	SetProperty("com_inv_col_32", "IsVisible", 0)
	SetProperty("com_inv_col_64", "IsVisible", 0)
	SetProperty("com_inv_col_65", "IsVisible", 0)
	SetProperty("com_inv_col_66", "IsVisible", 0)
	SetProperty("com_inv_col_67", "IsVisible", 0)
	SetProperty("com_inv_col_68", "IsVisible", 0)
	SetProperty("com_inv_col_69", "IsVisible", 0)
	SetProperty("com_inv_col_70", "IsVisible", 0)
	SetProperty("com_inv_col_71", "IsVisible", 0)
	SetProperty("com_inv_col_72", "IsVisible", 0)
	SetProperty("com_inv_col_73", "IsVisible", 0)
	SetProperty("com_inv_col_74", "IsVisible", 0)
	SetProperty("com_inv_col_75", "IsVisible", 0)
	SetProperty("com_inv_col_76", "IsVisible", 0)
	SetProperty("com_inv_col_77", "IsVisible", 0)
	SetProperty("com_inv_col_78", "IsVisible", 0)
	SetProperty("com_inv_col_79", "IsVisible", 0)
	SetProperty("com_inv_col_80", "IsVisible", 0)
	SetProperty("com_inv_col_81", "IsVisible", 0)
	SetProperty("com_inv_col_82", "IsVisible", 0)
	SetProperty("com_inv_col_83", "IsVisible", 0)
	SetProperty("com_inv_col_84", "IsVisible", 0)
	SetProperty("com_inv_col_85", "IsVisible", 0)
	SetProperty("com_inv_col_86", "IsVisible", 0)
	SetProperty("com_inv_col_87", "IsVisible", 0)
	SetProperty("com_inv_col_88", "IsVisible", 0)
	SetProperty("com_inv_col_89", "IsVisible", 0)
	SetProperty("com_inv_col_90", "IsVisible", 0)
	SetProperty("com_inv_col_91", "IsVisible", 0)
	SetProperty("com_inv_col_92", "IsVisible", 0)
	
	AddDeathRegion("chasmdeath")
	AddDeathRegion("deathregion_drill")

---------- BEGIN SECRET AREA STUFF ----------

	SetProperty("cis_fedcruiser_door1", "IsLocked", 1)
	BlockPlanningGraphArcs("Connection186")
	SetProperty("spa_veh_turret_chair", "DisableTime", 1e+37)
    	AllowAISpawn(5, false)

	CubeCheck = false

	get_cube = OnFlagPickUp(
		function(flag, character)
			if GetEntityName(flag) ~= "companion_cube" then return end
			if not IsCharacterHuman(character) then return end				
			CubeCheck = true
		end,
		"companion_cube"
	)

	drop_cube = OnFlagDrop(
		function(flag, carrier)
			if GetEntityName(flag) ~= "companion_cube" then return end
			CubeCheck = false
		end,
		"companion_cube"
	)

	cube_button = OnEnterRegion(
		function(regIn, character)
			if not IsCharacterHuman(character) then return end
			if CubeCheck == true then
				KillObject("companion_cube")
				ReleaseFlagPickUp(get_cube)
				ReleaseFlagDrop(drop_cube)
				ReleaseEnterRegion(cube_button)
				DeactivateRegion("cube_button_capture")

				KillObject("companion_cube_button")
				KillObject("tit_sign_door")
				SetProperty("cis_fedcruiser_door1", "IsLocked", 0)
				UnblockPlanningGraphArcs("Connection186")
				SetProperty("spa_veh_turret_chair", "DisableTime", 0)
				DisableBarriers("BarrierDoor")
    				AllowAISpawn(3, true)
			end
		end,
		"cube_button_capture"
	)
	ActivateRegion("cube_button_capture") 

---------- END SECRET AREA STUFF ----------
	
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
    ReadDataFile("dc:Load\\tit_load_me5.lvl")
	
	SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2220)
	SetMemoryPoolSize("ParticleTransformer::PositionTr", 1298)
	SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1461)
	
	-- Perform various pre-game operations
	manager:Proc_ScriptInit_Begin()
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\PFX_SSV_Veh.lvl;vehcommon")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\PFX_SSV_Veh.lvl;vehnormal")
   
    SetMaxFlyHeight(75)
    SetMaxPlayerFlyHeight(75)
	AISnipeSuitabilityDist(100)
	SetAttackerSnipeRange(120)
	SetDefenderSnipeRange(200)

	ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\sound\\TIT.lvl")
    ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\sound\\sol.lvl;sol_titn")
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\me5tur.lvl",
					"tur_bldg_laser",
					"tur_bldg_mturret")
    
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\CON_LOWG.lvl")
	
	-- Load and set up the sides
	manager:Proc_ScriptInit_SideSetup()
	ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\SIDE\\sol.lvl",
					"sol_inf_astronaut")
    
	ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\SIDE\\tit.lvl",
					"sol_fly_titanhawk")

	SetTeamName(3, "nasa")
	AddUnitClass(3, "sol_inf_astronaut", 4,4)
	SetUnitCount(3, 4)
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
    SetMemoryPoolSize("EntityRemoteTerminal", 1)
	SetMemoryPoolSize("EntitySoundStatic", 45)
    SetMemoryPoolSize("MountedTurret", 32)
	SetMemoryPoolSize("Navigator", 128)
	SetMemoryPoolSize("SoldierAnimation", 678)
    SetMemoryPoolSize("Obstacle", 1024)
	SetMemoryPoolSize("PathNode", 1024)
    SetMemoryPoolSize("SoundSpaceRegion", 64)
    SetMemoryPoolSize("TreeGridStack", 1024)
	SetMemoryPoolSize("UnitAgent", 128)
	SetMemoryPoolSize("UnitController", 128)
	SetMemoryPoolSize("Weapon", weaponCnt)
	manager:Proc_ScriptInit_MemoryPoolInit()
    
    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\SOL\\TIT.lvl", "TIT_conquest")
    SetDenseEnvironment("false")
	
	ReadDataFile("dc:minimap.lvl;tit")
	
	
    --  Sound
	
	-- Set up music
	OpenAudioStream("..\\..\\addon\\SOL\\data\\_LVL_PC\\sound\\sol.lvl", "sol_unit_vo_quick")
	OpenAudioStream("..\\..\\addon\\SOL\\data\\_LVL_PC\\sound\\sol.lvl", "solgcw_music")
	OpenAudioStream("..\\..\\addon\\SOL\\data\\_LVL_PC\\sound\\tit.lvl",  "tit_ambiance")
	OpenAudioStream("..\\..\\addon\\SOL\\data\\_LVL_PC\\sound\\tit.lvl",  "tit_ambiance")
	OpenMusicStreams(1)
	
	SetVictoryMusic(REP, "ssv_amb_01_victory")
	SetDefeatMusic (REP, "ssv_amb_01_defeat")
	SetVictoryMusic(CIS, "ssv_amb_01_victory")
	SetDefeatMusic (CIS, "ssv_amb_01_defeat")
	
	SoundFX()
	
	ScaleSoundParameter("ambientenv",	"Gain", 1.0)

	-- Camera Stats
	--AddCameraShot(0.968782, 0.198703, -0.145230, 0.029787, -47.800732, 15.215631, 83.858757);
	RandomCam = math.random(1,2)
	if not ScriptCB_InMultiplayer() then
		if RandomCam == 1 then
			AddCameraShot(0.389738, -0.018265, -0.919735, -0.043104, -73.200005, 3.981526, -82.745537);
			AddCameraShot(0.952109, -0.018313, 0.305153, 0.005869, -41.345215, 7.416323, 168.862106);
		elseif RandomCam == 2 then
			AddCameraShot(0.952109, -0.018313, 0.305153, 0.005869, -41.345215, 7.416323, 168.862106);
			AddCameraShot(0.389738, -0.018265, -0.919735, -0.043104, -73.200005, 3.981526, -82.745537);
		else
			AddCameraShot(0.389738, -0.018265, -0.919735, -0.043104, -73.200005, 3.981526, -82.745537);
			AddCameraShot(0.952109, -0.018313, 0.305153, 0.005869, -41.345215, 7.416323, 168.862106);
		end
	else
		AddCameraShot(0.389738, -0.018265, -0.919735, -0.043104, -73.200005, 3.981526, -82.745537);
		AddCameraShot(0.952109, -0.018313, 0.305153, 0.005869, -41.345215, 7.416323, 168.862106);
	end
	AddCameraShot(0.952871, -0.139226, 0.266711, 0.038970, -98.611649, 15.215631, 82.076218);
	AddCameraShot(0.355997, 0.004551, -0.934400, 0.011946, -17.224558, 4.794593, -81.837601);
	AddCameraShot(0.777703, -0.003223, -0.628618, -0.002605, 63.268856, 5.437579, 76.909973);
	AddCameraShot(0.659072, 0.034651, 0.750245, -0.039444, 164.185898, 7.416323, 200.864777);
	AddCameraShot(0.741443, 0.031598, -0.669663, 0.028539, -138.970978, 7.416323, 90.806053);
	AddCameraShot(0.964213, 0.135263, -0.225819, 0.031679, -95.374229, 4.976299, 129.912308);
	AddCameraShot(0.99106175, 0.008919773, 0.13309991, -0.0011979284, 249.89085, 3.575956, 170.78441);
	
	-- Perform various post-load operations
	manager:Proc_ScriptInit_End()
end
