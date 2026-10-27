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
ScriptCB_DoFile("Ambush")

-- Create a new MapManager object
manager = MapManager:New{
	-- Map-specific details
	bIsModMap = true,					-- Whether or not this is a mod map (as opposed to a stock map).
	gameMode = "ctf",				-- The mission's game mode.
	mapSize = "sm",						-- Size of the map. Used for determining unit counts.
	environmentType = "desert",			-- Map's biome (essentially). Used for determining which camo textures to load. ("desert", "jungle", "snow", or "urban")
	factionIds = {REP = 2, CIS = 1, LocalTeam1 = 5, LocalTeam2 = 6},
	
	-- In-game music (you can also specify a table of values and one of them will be randomly selected at runtime, example: `musicVariation_SSVxGTH = {"1","3"}` )
	musicVariation_SSVxGTH = "1",		-- Music variation to use for SSVxGTH matches.
	musicVariation_SSVxCOL = "5",		-- Music variation to use for SSVxCOL matches.
	musicVariation_EVGxGTH = "9",		-- Music variation to use for EVGxGTH matches.
	musicVariation_EVGxCOL = "9",		-- Music variation to use for EVGxCOL matches.
	
	-- Online matches
	onlineSideVar = "SSVxCER",			-- Faction combination to use in online matches.
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
	},
	-- Local ally spawns (required). CP name, CP spawn path name
	allySpawnCPs = {
				{"cp1", "cp1_spawn"},
				{"cp2", "cp2_spawn"},
				{"cp3", "cp3_spawn"},
				{"cp4", "cp4_spawn"},
				{"cp5", "cp5_spawn"},
				{"cp6", "cp6_spawn"},
	},
}
-- Initialize the MapManager
manager:Init()


function ScriptPostLoad()
	
	UnblockPlanningGraphArcs(1)
    
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
	
	SoundEvent_SetupTeams( manager.factionIds.REP, 'rep', manager.factionIds.CIS, 'cis' )
	
    EnableSPHeroRules()

	

---------- BEGIN SECRET AREA STUFF ----------

        alienVehicleSpawns = {
            "com_item_vehicle_spawn",
            "com_item_vehicle_spawn1",
            "com_item_vehicle_spawn2",
			"com_item_vehicle_spawn_saucer",
        }
        
        numAlienVehicleSlots = table.getn(alienVehicleSpawns)
        alienVehicleUnitCounter = 1
        alienVehicleUnitCounterMax = 1
        alienVehicleSpawnIndex = 1

        function GetAlienVehicleSpawn()
            local vehSpawn = alienVehicleSpawns[alienVehicleSpawnIndex]

            assert(vehSpawn ~= nil, "Error: Valid alien vehicle spawn not found for index "..alienVehicleSpawnIndex)

            alienVehicleSpawnIndex = alienVehicleSpawnIndex + 1
            if alienVehicleSpawnIndex > numAlienVehicleSlots then
                alienVehicleSpawnIndex = 1
            end

            print("Choosing alien vehicle spawn "..vehSpawn)

            return vehSpawn
        end

        alienTeamForceIntoVehicleHandler = OnCharacterSpawnTeam(
            function(player)
                if not IsCharacterHuman(player) then
                    if alienVehicleUnitCounter == 1 then
                        EnterVehicle(player, GetAlienVehicleSpawn())
                    end

                    alienVehicleUnitCounter = alienVehicleUnitCounter + 1
                    if alienVehicleUnitCounter > alienVehicleUnitCounterMax then
                        alienVehicleUnitCounter = 1
                    end
                end
            end,
        4
        )

    	AllowAISpawn(4, false)

	alienArtifact = OnObjectKillName(
   	   	function(object, killer)
    			SetProperty("mr1_prop_energy_regulator", "MaxHealth", 1e+37)
			KillObject("mr1_prop_alien_artifact")
			SetProperty("alien_cp", "Team", 4)
			ShowMessageText("level.MR1.obj.alien_alert_1")
			ReleaseObjectKill(alienArtifact)

			alienSpawnTimer = CreateTimer("alienSpawnTimer")
			SetTimerValue(alienSpawnTimer, 45)
			StartTimer(alienSpawnTimer)
			alienSpawnTimerElapse = OnTimerElapse(
				function(timer)
					ReleaseTimerElapse(alienSpawnTimerElapse)
					DestroyTimer(alienSpawnTimer)
    				
					AllowAISpawn(4, true)
					Ambush("alien_spawn", 30, 4)
					ShowMessageText("level.MR1.obj.alien_alert_2")
    				ScriptCB_EnableHeroMusic(0)
					ScriptCB_PlayInGameMusic("mr1_amb_aliens")

					CreateTimer("alienSpawnRepeatTimer")
					SetTimerValue("alienSpawnRepeatTimer", 45)
					StartTimer("alienSpawnRepeatTimer")
					OnTimerElapse(
					function(timer)
						Ambush("alien_spawn", 30, 4)
						SetTimerValue("alienSpawnRepeatTimer", 45)
						StartTimer("alienSpawnRepeatTimer")
					end,
					"alienSpawnRepeatTimer"
				)
				end,
				alienSpawnTimer
			)

		end,
		"mr1_prop_energy_regulator"
	)
	
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
	
	ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\sound\\MR1.lvl;MR1n")
    ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\sound\\sol.lvl;sol_mr1n")
	
	-- Load and set up the sides
	manager:Proc_ScriptInit_SideSetup()
	
	ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\SIDE\\sol.lvl",
					"sol_inf_astronaut")
	
    ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\SIDE\\cer.lvl",
		"mr1_fly_saucer",
		"sol_walk_alien",
		"sol_inf_alien_invader")

	SetTeamName(3, "nasa")
	AddUnitClass(3, "sol_inf_astronaut", 7)
	SetUnitCount(3, 7)
	AddAIGoal(3, "Deathmatch", 100)

	SetTeamName(4, "alien")
	AddUnitClass(4, "sol_inf_alien_invader", 30)
	SetUnitCount(4, 30)
	AddAIGoal(4, "Deathmatch", 100)
	
	SetTeamAsNeutral(ATT,3)
	SetTeamAsNeutral(3,ATT)
	SetTeamAsNeutral(DEF,3)
	SetTeamAsNeutral(3,DEF)
	SetTeamAsNeutral(manager.factionIds.LocalTeam1,3)
	SetTeamAsNeutral(manager.factionIds.LocalTeam2,3)
	SetTeamAsNeutral(3,manager.factionIds.LocalTeam1)
	SetTeamAsNeutral(3,manager.factionIds.LocalTeam2)

	SetTeamAsEnemy(ATT,4)
	SetTeamAsEnemy(4,ATT)
	SetTeamAsEnemy(DEF,4)
	SetTeamAsEnemy(4,DEF)
	SetTeamAsEnemy(manager.factionIds.LocalTeam1,4)
	SetTeamAsEnemy(manager.factionIds.LocalTeam2,4)
	SetTeamAsEnemy(4,manager.factionIds.LocalTeam1)
	SetTeamAsEnemy(4,manager.factionIds.LocalTeam2)
	SetTeamAsEnemy(3,4)
	SetTeamAsEnemy(4,3)
	
    --  Level Stats
    --  ClearWalkers()
    AddWalkerType(0, 0) -- special -> droidekas
    AddWalkerType(1, 0) -- 1x2 (1 pair of legs)
    AddWalkerType(2, 3) -- 2x2 (2 pairs of legs)
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
	ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\SOL\\MR1.lvl", "MR1_2flag")
	SetDenseEnvironment("false")
	
	ReadDataFile("dc:minimap.lvl;mr1")
	
	
	--  Sound Stats
	
	OpenAudioStream("..\\..\\addon\\SOL\\data\\_LVL_PC\\sound\\sol.lvl", "solgcw_music")
	OpenMusicStreams(1)

	SetAmbientMusic(REP, 1.0, "mr1_amb_earworm_cw",  0,1)
	SetAmbientMusic(CIS, 1.0, "mr1_amb_earworm_cw",  0,1)
	
	SetVictoryMusic(REP, "ssv_amb_01_victory")
	SetDefeatMusic (REP, "ssv_amb_01_defeat")
	SetVictoryMusic(CIS, "ssv_amb_01_victory")
	SetDefeatMusic (CIS, "ssv_amb_01_defeat")
	
	OpenAudioStream("..\\..\\addon\\SOL\\data\\_LVL_PC\\sound\\mr1.lvl",  "mr1_ambiance")
	OpenAudioStream("..\\..\\addon\\SOL\\data\\_LVL_PC\\sound\\mr1.lvl",  "mr1_ambiance")
	
	-- Set up common sound stuff
	SoundFX()
	
	
	-- Camera Stats
	AddCameraShot(0.8227257, 0.07549034, -0.5610467, 0.051479615, -140.26575, 1.8257815, 346.4143);
	AddCameraShot(0.6227781, -0.0028024006, -0.7823855, -0.0035206086, -79.65998, 2.568664, 314.9821);
	AddCameraShot(0.9724822, 0.010211547, -0.23274042, 0.00244389, -55.654736, 1.811145, 266.7097);
	AddCameraShot(0.8934442, 0.03754682, 0.44720748, -0.018793808, -18.215828, 2.9851952, 314.34924);
	AddCameraShot(0.85873276, -0.024480637, -0.5116308, -0.0145855015, -34.985847, 2.1041138, 347.6967);
	AddCameraShot(0.37048256, 0.0011113799, 0.92883456, -0.0027863337, 10.705422, 1.6729876, 281.3408);
	AddCameraShot(0.47978666, -0.050563663, 0.87110287, 0.0918036, 28.258001, 20.217344, 275.8831);
	AddCameraShot(0.47941083, -0.23424816, 0.75989014, 0.37129503, -55.377033, 39.838455, 293.56424);
	AddCameraShot(0.9954685, 0.011946581, 0.0943316, -0.0011320701, 5.2994504, 5.3513618, 367.79092);
	
	-- Perform various post-load operations
	manager:Proc_ScriptInit_End()
end
