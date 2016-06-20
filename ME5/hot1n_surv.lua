ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\master.lvl")
--RandomSide = math.random(1,3)
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ME5_Master")
ScriptCB_DoFile("ME5_setup_teams")
ScriptCB_DoFile("ME5_ObjectiveSurvival")

    --  Empire Attacking (attacker is always #1)
    REP = 1
    CIS = 2
    --  These variables do not change
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
	
	ScriptCB_SetGameRules("campaign")
	--ForceHumansOntoTeam1();
	
	AddDeathRegion("fall")
	DisableBarriers("atat")
	DisableBarriers("bombbar")

    --CP SETUP for CONQUEST
--    SetProperty("shield", "MaxHealth", 222600.0)
--  	SetProperty("shield", "CurHealth", 222600.0)
    SetObjectTeam("CP3", 1)
    SetObjectTeam("CP6", 1)
    KillObject("CP7")
 
    --EnableSPHeroRules()
    
    cp1 = CommandPost:New{name = "CP3"}
    cp2 = CommandPost:New{name = "CP4"}
    --cp3 = CommandPost:New{name = "CP5"}
    cp3 = CommandPost:New{name = "CP6"}
    
	survival = ObjectiveSurvival:New{teamATT = ATT, teamDEF = DEF, 
									 textATT = "game.modes.surv", 
									 textDEF = "game.modes.surv2", 
									 multiplayerRules = true}
    
	survival:AddCommandPost(cp1)
	survival:AddCommandPost(cp2)
	--survival:AddCommandPost(cp3)
	survival:AddCommandPost(cp3)
    
    survival:Start()
	
	SetUberMode(1);
	
	
	ShieldGenNode = GetPathPoint("CP2_SpawnPath", 3) --gets the path point
	CP3Node = GetPathPoint("CP3_SpawnPath", 6)
	CP4Node = GetPathPoint("CP4_SpawnPath", 0)
	CP5Node = GetPathPoint("CP5_SpawnPath", 1)
	--CP5Node = GetPathPoint("Path 13", 0)
	CP6Node = GetPathPoint("CP6_SpawnPath", 3)
	
	CreateTimer("artGameTimer")
	SetTimerValue("artGameTimer", 720)
	StartTimer("artGameTimer")
	OnTimerElapse(
		function(timer)
			local team1pts = GetReinforcementCount(1)
			if team1pts >= 100 then
				artMatrices = { ShieldGenNode, CP3Node, CP4Node, CP5Node, CP6Node }
				goingthroughturrets = 0			
				
				artInitTimer = CreateTimer("artInitTimer")
				SetTimerValue("artInitTimer", 20.0)
				StartTimer("artInitTimer")
				ShowTimer("artInitTimer")
				OnTimerElapse(
					function(timer)
						goingthroughturrets = goingthroughturrets + 1
						if goingthroughturrets == 6 then
							goingthroughturrets = 1
						end
						
						SetEntityMatrix( "artillery1", artMatrices[goingthroughturrets])
						ShowMessageText("level.common.events.surv.artillery.msg"..goingthroughturrets)
							print("hot1n_surv: Artillery transitioning to matrix: "..goingthroughturrets)					
						SetTimerValue("artInitTimer", 20.0)
						StartTimer("artInitTimer")
					end,
				"artInitTimer"
				)
			else
			end
			
			DestroyTimer(Timer)
		end,
	"artGameTimer"
	)
	
	
	SetObjectTeam("CP3", 1)
	SetObjectTeam("CP4", 1)
	SetObjectTeam("CP6", 1)
	KillObject("shield")
	SetProperty("CP5", "CaptureRegion", "")
	
	SetProperty("CP3", "VO_Rep_RepCapture", "ssv_adm_com_report_captured_commandpost")
	SetProperty("CP4", "VO_Rep_RepCapture", "ssv_adm_com_report_captured_commandpost")
	SetProperty("CP5", "VO_Rep_RepCapture", "ssv_adm_com_report_captured_commandpost")
	SetProperty("CP6", "VO_Rep_RepCapture", "ssv_adm_com_report_captured_commandpost")
	SetProperty("CP3", "VO_Rep_RepLost", "ssv_adm_com_report_lost_commandpost")
	SetProperty("CP4", "VO_Rep_RepLost", "ssv_adm_com_report_lost_commandpost")
	SetProperty("CP5", "VO_Rep_RepLost", "ssv_adm_com_report_lost_commandpost")
	SetProperty("CP6", "VO_Rep_RepLost", "ssv_adm_com_report_lost_commandpost")
	
			SetProperty("CP3", "VO_Rep_CisCapture", "ssv_adm_com_report_gthCaptured_commandpost")
			SetProperty("CP4", "VO_Rep_CisCapture", "ssv_adm_com_report_gthCaptured_commandpost")
			SetProperty("CP5", "VO_Rep_CisCapture", "ssv_adm_com_report_gthCaptured_commandpost")
			SetProperty("CP6", "VO_Rep_CisCapture", "ssv_adm_com_report_gthCaptured_commandpost")
			SetProperty("CP3", "VO_Rep_CisLost", "ssv_adm_com_report_gthLost_commandpost")
			SetProperty("CP4", "VO_Rep_CisLost", "ssv_adm_com_report_gthLost_commandpost")
			SetProperty("CP5", "VO_Rep_CisLost", "ssv_adm_com_report_gthLost_commandpost")
			SetProperty("CP6", "VO_Rep_CisLost", "ssv_adm_com_report_gthLost_commandpost")
			
			SetProperty("CP3", "VO_Cis_CisCapture", "gth_ann_com_report_captured_commandpost")
			SetProperty("CP4", "VO_Cis_CisCapture", "gth_ann_com_report_captured_commandpost")
			SetProperty("CP5", "VO_Cis_CisCapture", "gth_ann_com_report_captured_commandpost")
			SetProperty("CP6", "VO_Cis_CisCapture", "gth_ann_com_report_captured_commandpost")
			SetProperty("CP3", "VO_Cis_CisLost", "gth_ann_com_report_lost_commandpost")
			SetProperty("CP4", "VO_Cis_CisLost", "gth_ann_com_report_lost_commandpost")
			SetProperty("CP5", "VO_Cis_CisLost", "gth_ann_com_report_lost_commandpost")
			SetProperty("CP6", "VO_Cis_CisLost", "gth_ann_com_report_lost_commandpost")
			SetProperty("CP3", "VO_Cis_RepCapture", "gth_ann_com_report_ssvCaptured_commandpost")
			SetProperty("CP4", "VO_Cis_RepCapture", "gth_ann_com_report_ssvCaptured_commandpost")
			SetProperty("CP5", "VO_Cis_RepCapture", "gth_ann_com_report_ssvCaptured_commandpost")
			SetProperty("CP6", "VO_Cis_RepCapture", "gth_ann_com_report_ssvCaptured_commandpost")
			SetProperty("CP3", "VO_Cis_RepLost", "gth_ann_com_report_ssvLost_commandpost")
			SetProperty("CP4", "VO_Cis_RepLost", "gth_ann_com_report_ssvLost_commandpost")
			SetProperty("CP5", "VO_Cis_RepLost", "gth_ann_com_report_ssvLost_commandpost")
			SetProperty("CP6", "VO_Cis_RepLost", "gth_ann_com_report_ssvLost_commandpost")
	
	SetProperty("VehicleSpawn_8", "ClassCisATK", "ssv_tread_mako")
	SetProperty("VehicleSpawn_8", "ClassCisDEF", "ssv_tread_mako")
	SetProperty("VehicleSpawn_8", "ClassRepATK", "ssv_tread_mako")
	SetProperty("VehicleSpawn_8", "ClassRepDEF", "ssv_tread_mako")
	SetProperty("VehicleSpawn_8", "SpawnTime", "20.0")
	SetProperty("VehicleSpawn_9", "ClassCisATK", "ssv_tread_mako")
	SetProperty("VehicleSpawn_9", "ClassCisDEF", "ssv_tread_mako")
	SetProperty("VehicleSpawn_9", "ClassRepATK", "ssv_tread_mako")
	SetProperty("VehicleSpawn_9", "ClassRepDEF", "ssv_tread_mako")
	SetProperty("VehicleSpawn_9", "SpawnTime", "20.0")
    
--    KillObject("shield");
    
end

function StartArtilleryTimers()
	
	--[[StartTimer("artInitTimer")
	ShowTimer("artInitTimer")
	OnTimerElapse(
		function(timer)
			CreateEntity("com_bldg_artillery1", ShieldGenNode, "artillery1") --spawns the artillery dummy
			
			DestroyTimer("artInitTimer")
			
			artDoneTimer = CreateTimer("artDoneTimer")
			SetTimerValue("artDoneTimer", 6.0)
			StartTimer("artDoneTimer")
			ShowTimer("artDoneTimer")
		end,
	"artInitTimer"
	)
	
	
	OnTimerElapse(
		function(timer)
			DeleteEntity("com_bldg_artillery1", ShieldGenNode, "artillery1") --kills the artillery dummy
			KillObject("artillery1") --kills the artillery dummy
			
			DestroyTimer("artDoneTimer")
			
			artInitTimer = CreateTimer("artInitTimer")
			SetTimerValue("artInitTimer", 4.0)
			StartTimer("artInitTimer")
			ShowTimer("artInitTimer")
		end,
	"artDoneTimer"
	)]]
	
end

--[[function ArtilleryInit()
		print("ArtilleryInit(): Entered")
	
	ShieldGenNode = GetPathPoint("CP2_SpawnPath", 3) --gets the path point
	CP3Node = GetPathPoint("CP3_SpawnPath", 6)
	CP4Node = GetPathPoint("CP4_SpawnPath", 0)
	CP5Node = GetPathPoint("CP5_SpawnPath", 1)
	CP6Node = GetPathPoint("CP6_SpawnPath", 3)
	
	
	artInitTimer = CreateTimer("artInitTimer")
	SetTimerValue("artInitTimer", 4.0)
	StartTimer("artInitTimer")
	ShowTimer("artInitTimer")
	OnTimerElapse(
		function(timer)
			DecideArtilleryMatrix()
				print("hot1n_surv: Deciding artillery matrix...")
			
			SetTimerValue("artInitTimer", 15.0)
			StartTimer("artInitTimer")
		end,
	"artInitTimer"
	)
	
		print("ArtilleryInit(): Exited")
end]]

function DecideArtilleryMatrix()
		print("DecideArtilleryMatrix(): Entered")
	
	DecideMatrix = math.random(1,5)
	
	if DecideMatrix == 1 then
		SetEntityMatrix( "artillery1", ShieldGenNode )
		ShowMessageText("level.common.events.surv.artillery.msg1")
	elseif DecideMatrix == 2 then
		SetEntityMatrix( "artillery1", CP3Node )
		ShowMessageText("level.common.events.surv.artillery.msg2")
	elseif DecideMatrix == 3 then
		SetEntityMatrix( "artillery1", CP4Node )
		ShowMessageText("level.common.events.surv.artillery.msg3")
	elseif DecideMatrix == 4 then
		SetEntityMatrix( "artillery1", CP5Node )
		ShowMessageText("level.common.events.surv.artillery.msg4")
	elseif DecideMatrix == 5 then
		SetEntityMatrix( "artillery1", CP6Node )
		ShowMessageText("level.common.events.surv.artillery.msg5")
	end
	
	
	artMatrices = { ShieldGenNode, CP3Node, CP4Node, CP5Node, CP6Node }
	for i, artMatrix in ipairs(artMatrices) do
		
	end
	
		print("DecideArtilleryMatrix(): Exited")
end

function ScriptInit()
	if(ScriptCB_GetPlatform() == "PS2") then
        StealArtistHeap(1024*1024)	-- steal 1MB from art heap
    end
    
    -- Designers, these two lines *MUST* be first.
    --SetPS2ModelMemory(4500000)
    SetPS2ModelMemory(3300000)
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\Load\\load.lvl;hot1")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamessv.lvl")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ingamegth.lvl")
	PreLoadStuff()


    SetMaxFlyHeight(70)
    SetMaxPlayerFlyHeight(70)
    SetGroundFlyerMap(1);
	
    --SFL_Turrets()
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\me5tur.lvl",
					"tur_bldg_mturret",
					"tur_bldg_hoth_dishturret",
					"tur_bldg_hoth_lasermortar")
	
		print("ME5_RandomSides: Setup_SSVxGTH_lg()")
	--Setup_SSVxGTH_lg = 1
	
	SetAIDifficulty(-3, 3)
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_SSV_NonStreaming.lvl")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\ssv.lvl",
				"ssv_inf_soldier",
				"ssv_inf_infiltrator",
				"ssv_inf_adept",
				"ssv_inf_engineer",
				"ssv_inf_sentinel",
				"ssv_inf_vanguard",
				"ssv_hero_shepard",
				"ssv_hero_shepard_soldier",
				"ssv_hero_shepard_infiltrator",
				"ssv_hero_shepard_engineer",
				"ssv_hero_shepard_adept",
				"ssv_hero_shepard_sentinel",
				"ssv_hero_shepard_vanguard"
				--"ssv_tread_mako"
				)
				
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\coressv.lvl")
	
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\sound\\SFL_GTH_NonStreaming.lvl")
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\SIDE\\gth.lvl",
				"gth_hero_prime",
				"gth_inf_trooper",
				"gth_inf_rocketeer",
				"gth_inf_sniper",
				"gth_inf_machinist",
				"gth_inf_hunter",
				"gth_inf_shock",
				"gth_inf_shock_online",
				"gth_inf_destroyer",
				"gth_inf_juggernaut")
				
	ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\coregth.lvl")
	SetupTeams{
	rep = {
		team = REP,
		units = 36,
		reinforcements = 200,
		soldier  = { "ssv_inf_soldier",6, 6},
		sniper  = { "ssv_inf_infiltrator",6, 6},
		adept = { "ssv_inf_adept",6, 6},
		engineer   = { "ssv_inf_engineer",6, 6},
		sentinel = { "ssv_inf_sentinel",6, 6},
		vanguard = { "ssv_inf_vanguard",6, 6},	
	},
	
	cis = {
		team = CIS,
		units = 72,
		reinforcements = -1,
		soldier  = { "gth_inf_trooper",23, 23},
		assault  = { "gth_inf_rocketeer",8, 8},
		sniper = { "gth_inf_sniper",9, 9},
	}
	}
	
	if not ScriptCB_InMultiplayer() then
		DecideSSVHeroClass()
	else
		SetHeroClass(REP, "ssv_hero_shepard_adept")
	end
	
	SetHeroClass(CIS, "gth_hero_prime")
	
	team2ticketstring = "level.common.events.con.ticketboost.gth"
	team1ticketstring = "level.common.events.con.ticketboost.ssv"
	
	ReadDataFile("sound\\hot.lvl;hot1gcw")
	SFL_SSV_vf()
	SFL_SSV_vt()
	
	
	--  Level Stats
    ClearWalkers()
    AddWalkerType(0, 0) -- 0 droidekas
    AddWalkerType(1, 0) -- 6 atsts with 1 leg pairs each
    AddWalkerType(2, 2) -- 2 atats with 2 leg pairs each

	local weaponCnt = 250
    SetMemoryPoolSize("Aimer", 80)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 175)
    SetMemoryPoolSize("CommandWalker", 0)
    SetMemoryPoolSize("ConnectivityGraphFollower", 56)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
	SetMemoryPoolSize("EntityCloth", 41)
	SetMemoryPoolSize("EntityHover", 15) --11
    SetMemoryPoolSize("EntityFlyer", 10)
    SetMemoryPoolSize("EntityLight", 110)
    SetMemoryPoolSize("EntitySoundStatic", 32)
    SetMemoryPoolSize("EntitySoundStream", 12)
	SetMemoryPoolSize("FLEffectObject::OffsetMatrix", 54)
    SetMemoryPoolSize("MountedTurret", 38)
    SetMemoryPoolSize("Music", 78)
    SetMemoryPoolSize("Navigator", 63)
    SetMemoryPoolSize("Obstacle", 400)
	--SetMemoryPoolSize("OrdnanceTowCable", 40) -- !!!! need +4 extra for wrapped/fallen cables !!!!
    SetMemoryPoolSize("PathFollower", 63)
	SetMemoryPoolSize("PathNode", 128)
	SetMemoryPoolSize("ShieldEffect", 0)
	SetMemoryPoolSize("SoldierAnimation", 308)
    SetMemoryPoolSize("TreeGridStack", 300)
    SetMemoryPoolSize("UnitController", 63)
    SetMemoryPoolSize("UnitAgent", 63)
    SetMemoryPoolSize("Weapon", weaponCnt)

    ReadDataFile("..\\..\\addon\\ME5\\data\\_LVL_PC\\ME5\\hot1.lvl", "hoth_Survival")
    --ReadDataFile("tan\\tan1.lvl", "tan1_obj")
    SetSpawnDelay(10.0, 0.25)
    SetDenseEnvironment("false")
    SetDefenderSnipeRange(170)
    AddDeathRegion("Death")
	
	PostInitStuff()


    --  Sound Stats
	
	Music04()
	
	SSVWorldVO()
	GTHWorldVO()
	
	OpenAudioStream("sound\\hot.lvl",  "hot1gcw")
	
	SoundFX()


    --  Camera Stats
    --Hoth
    --Hangar
    AddCameraShot(0.944210, 0.065541, 0.321983, -0.022350, -500.489838, 0.797472, -68.773849)
    --Shield Generator
    AddCameraShot(0.371197, 0.008190, -0.928292, 0.020482, -473.384155, -17.880533, 132.126801)
    --Battlefield
    AddCameraShot(0.927083, 0.020456, -0.374206, 0.008257, -333.221558, 0.676043, -14.027348)


end
