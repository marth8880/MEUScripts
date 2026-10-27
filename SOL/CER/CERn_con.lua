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
ScriptCB_DoFile("ME5_ObjectiveConquest")
ScriptCB_DoFile("Ambush")
ScriptCB_DoFile("SOL_teleport")

-- Create a new MapManager object
manager = MapManager:New{
	-- Map-specific details
	gameMode = "conquest",
	mapSize = "med",
	environmentType = "urban",
	factionIds = {REP = 1, CIS = 2, LocalTeam1 = 5, LocalTeam2 = 6},
	
	-- In-game music
	musicVariation_SSVxGTH = {"4","6"},
	musicVariation_SSVxCOL = "2",
	musicVariation_EVGxGTH = "9",
	musicVariation_EVGxCOL = "9",
	musicVariation_SSVxRPR = "8",
	musicVariation_SSVxCER = {"7_2", "7_3"},
	
	-- Online matches
	onlineSideVar = "SSVxRPR",
	onlineHeroSSV = "shep_engineer",
	onlineHeroGTH = "gethprime_me2",
	onlineHeroCOL = "colgeneral",
	onlineHeroEVG = "gethprime_me3",
	
	-- AI hero spawns. CP name, CP spawn path name
	heroSupportCPs = {
				{"cp1", "cp1_spawn"},
				{"cp2", "cp2_spawn"},
				{"cp3", "cp3_spawn"},
				{"cp4", "cp4_spawn"},
				{"cp5", "cp5_spawn"},
	},
	-- Local ally spawns. CP name, CP spawn path name
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
    
    
    --This defines the CPs.  These need to happen first
    cp1 = CommandPost:New{name = "cp1"}
    cp2 = CommandPost:New{name = "cp2"}
    cp3 = CommandPost:New{name = "cp3"}
    cp4 = CommandPost:New{name = "cp4"}
    cp5 = CommandPost:New{name = "cp5"}
    cp6 = CommandPost:New{name = "cp6"}
    cp7 = CommandPost:New{name = "cp7"}
    cp8 = CommandPost:New{name = "cp8"}
    cp9 = CommandPost:New{name = "cp9"}
    
    --This sets up the actual objective.  This needs to happen after cp's are defined
    conquest = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, 
                                     textATT = "game.modes.con", 
                                     textDEF = "game.modes.con2",
                                     multiplayerRules = true,
	}
    
    --This adds the CPs to the objective.  This needs to happen after the objective is set up
    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp2)
    conquest:AddCommandPost(cp3)
    conquest:AddCommandPost(cp4)
    conquest:AddCommandPost(cp5)
    conquest:AddCommandPost(cp6)
    conquest:AddCommandPost(cp7)
    conquest:AddCommandPost(cp8)     
    conquest:AddCommandPost(cp9)

    conquest:Start()

    EnableSPHeroRules()

    AddDeathRegion("deathregion0")
    AddDeathRegion("deathregion1")
    AddDeathRegion("deathregion2")

	DisableBarriers("BarrierHuntDoors")
	DisableBarriers("BarrierHunt1")
	DisableBarriers("BarrierHunt2")
	DisableBarriers("BarrierHunt3")

	SetClassProperty("sol_inf_astronaut", "HurtSound", "rep_inf_com_chatter_wound")
	SetClassProperty("sol_inf_astronaut", "DeathSound", "rep_inf_com_chatter_death")
	SetClassProperty("sol_inf_astronaut", "DamageRegionSound", "repmalechoke")
	SetClassProperty("sol_inf_astronaut", "FoleyFXClass", "rep_inf_trooper")
	SetClassProperty("sol_inf_astronaut", "NoEnterVehicles", 1)
	SetClassProperty("sol_inf_astronaut", "NoEnterBuildings", 1)

	SetClassProperty("sol_inf_alien_invader", "DamageRegionSound", "repmalechoke")
	SetClassProperty("sol_inf_alien_invader", "FoleyFXClass", "rep_inf_trooper")

	KillObject("wormhole_console_ceres")
	KillObject("cer_prop_wormhole_sphere")

	-- Teleport 1
	-- Start: Ceres Artifact
	-- End: Phaeton Cave
	local region = GetRegionLocation( "teleport1" )
	local destination = GetPathNodeDestination( "teleport1_spawn", 0 )
	SetupEnterRegionTeleport( region, destination, 0, 0 )

		collectorDestroyed = 0

		local collectorCount = 5

		collectorKillHandler = OnObjectKillClass(
			function(object, killer)				
				collectorDestroyed = collectorDestroyed + 1
				
				ShowMessageText("level.CER.obj.collector_"..collectorDestroyed)

				if collectorDestroyed == collectorCount then
					ReleaseObjectKill(collectorKillHandler)
					collectorKillHandler = nil
					
					RespawnObject("wormhole_console_ceres")
					RespawnObject("cer_prop_wormhole_sphere")
					ActivateRegion( "teleport1" )
				end
			end,
			"sol_bldg_aliendevice"
		)
	
	-- Teleport 2
	-- Start: Phaeton Cave
	-- End: Ceres Landing Platform
	local region = GetRegionLocation( "teleport2" )
	local destination = GetPathNodeDestination( "teleport2_spawn", 0 )
	SetupEnterRegionTeleport( region, destination, 0, 0 )
	ActivateRegion( "teleport2" )

	Ambush("alien_cp_spawn", 18, 4)
	--SetProperty("alien_cp", "Team", 0)
    	--KillObject("alien_cp")

        alienVehicleSpawns = {
            "com_item_vehicle_spawn3",
            "com_item_vehicle_spawn4",
            "com_item_vehicle_spawn5",
            "com_item_vehicle_spawn6",
            "com_item_vehicle_spawn7",
            "com_item_vehicle_spawn8",
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
        6
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

    ReadDataFile("dc:Load\\cer_load.lvl")

	-- Perform various pre-game operations
	manager:Proc_ScriptInit_Begin()

	StealArtistHeap(2048*1024)
	
	SetMemoryPoolSize("ParticleTransformer::ColorTrans", 2519)
	SetMemoryPoolSize("ParticleTransformer::PositionTr", 1495)
	SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1630)
	SetMemoryPoolSize("FLEffectObject::OffsetMatrix", 129)
    SetMemoryPoolSize("ParticleEmitterObject",3800)
    
   
    SetMaxFlyHeight(100)
    SetMaxPlayerFlyHeight(100)
    SetGroundFlyerMap(1);
    
	ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\sound\\CER.lvl")
    ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\sound\\sol.lvl;sol_cern")
	ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\SIDE\\sol.lvl",
					"sol_inf_astronaut")

    ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\SIDE\\cer.lvl",
                "sol_fly_victoryviper",
		"sol_walk_alien_lowg",
		-- "sol_inf_alien_invader",
		"sol_bldg_AAA_turret")
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\CON_LOWG.lvl")
	
	manager:Proc_ScriptInit_SideSetup()

	SetTeamName(3, "nasa")
	AddUnitClass(3, "sol_inf_astronaut", 7)
	SetUnitCount(3, 7)
	AddAIGoal(3, "Deathmatch", 100)

	SetTeamName(4, "aliens")
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
    AddWalkerType(2, 6) -- 2x2 (2 pairs of legs)
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
    SetMemoryPoolSize("EntitySoundStream", 12)
    SetMemoryPoolSize("EntitySoundStatic", 32)
    SetMemoryPoolSize("MountedTurret", 32)
    SetMemoryPoolSize("Music", 68)
	SetMemoryPoolSize("Navigator", 128)
    SetMemoryPoolSize("Obstacle", 1024)
	SetMemoryPoolSize("PathNode", 1024)
	SetMemoryPoolSize("RedOmniLight", 269)
    SetMemoryPoolSize("SoldierAnimation", 502)
    SetMemoryPoolSize("SoundSpaceRegion", 64)
    SetMemoryPoolSize("TreeGridStack", 1024)
	SetMemoryPoolSize("UnitAgent", 128)
	SetMemoryPoolSize("UnitController", 128)
	SetMemoryPoolSize("Weapon", weaponCnt)
	manager:Proc_ScriptInit_MemoryPoolInit()
    
    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("..\\..\\addon\\SOL\\data\\_LVL_PC\\SOL\\CER.lvl", "CER_conquest")
    SetDenseEnvironment("false")




    --  Sound
    
	solVoiceQuick = OpenAudioStream("..\\..\\addon\\SOL\\data\\_LVL_PC\\sound\\sol.lvl",  "sol_unit_vo_quick")
    AudioStreamAppendSegments("..\\..\\addon\\SOL\\data\\_LVL_PC\\sound\\sol.lvl", "cer_unit_vo_quick", solVoiceQuick)
	OpenAudioStream("..\\..\\addon\\SOL\\data\\_LVL_PC\\sound\\sol.lvl", "SOLgcw_music")
    OpenAudioStream("..\\..\\addon\\SOL\\data\\_LVL_PC\\sound\\cer.lvl",  "cer_ambiance")
    OpenAudioStream("..\\..\\addon\\SOL\\data\\_LVL_PC\\sound\\cer.lvl",  "cer_ambiance")

	OpenMusicStreams(1)

    SetAmbientMusic(REP, 1.0, "cer_amb_earworm", 0,1)
    SetAmbientMusic(CIS, 1.0, "cer_amb_earworm", 0,1)

	SetVictoryMusic(REP, "ssv_amb_01_victory")
	SetDefeatMusic (REP, "ssv_amb_01_defeat")
	SetVictoryMusic(CIS, "ssv_amb_01_victory")
	SetDefeatMusic (CIS, "ssv_amb_01_defeat")
	
	SoundFX()
	
	ScaleSoundParameter("ambientenv",	"Gain", 1.0)


--OpeningSateliteShot
	AddCameraShot(0.844049, 0.010520, 0.536121, -0.006682, 34.275692, 22.109158, -240.666397);
	AddCameraShot(0.603384, 0.010681, 0.797255, -0.014113, -64.703590, 30.946028, -24.305109);
	AddCameraShot(0.628540, 0.050432, -0.773654, 0.062076, 29.690235, 30.946028, 8.675513);
	AddCameraShot(0.870744, 0.008779, 0.491633, -0.004957, -86.289017, 22.109158, -114.169350);
	AddCameraShot(0.170466, -0.036734, -0.962583, -0.207427, 121.701324, 7.232048, -102.043007);
	AddCameraShot(0.867474, -0.231071, -0.425718, -0.113400, 163.432098, 11.001021, -131.852936);
	AddCameraShot(0.946178, -0.100748, 0.305837, 0.032565, 238.087524, 7.944492, -136.450500);
	AddCameraShot(0.902639, -0.172581, -0.387266, -0.074044, 256.218781, 18.799791, -47.954979);
	AddCameraShot(-0.377596, 0.042753, -0.919110, -0.104066, 24.116261, 5.660319, -38.783955);
end

